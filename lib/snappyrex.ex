defmodule Snappyrex do
  @moduledoc """
  Snappyrex is a Rustler wrapper leveraging the 'snap' package as a NIF for fast Snappy compression/decompression in Elixir.

  ### Usage

  ```elixir
  iex> Snappyrex.compress("hello")
  {:ok, <<5, 16, 104, 101, 108, 108, 111>>}
  iex> Snappyrex.decompress(<<5, 16, 104, 101, 108, 108, 111>>)
  {:ok, "hello"}
  iex> Snappyrex.compress("hello", format: :frame)
  {:ok, <<255, 6, 0, 0, 115, 78, 97, 80, 112, 89, 1, 9, 0, 0, 187, 31, 28, 25, 104, 101, 108, 108, 111>>}
  iex> Snappyrex.decompress(<<255, 6, 0, 0, 115, 78, 97, 80, 112, 89, 1, 9, 0, 0, 187, 31, 28, 25, 104, 101, 108, 108, 111>>, format: :frame)
  {:ok, "hello"}
  ```


  ### Credits

  [rusterlium/rustler](https://github.com/rusterlium/rustler)

  [Rust `snap` package](https://github.com/BurntSushi/rust-snappy)
  """
  import Snappy.Nif

  @doc """
  Compress a binary.

  ## Options
  - `:format` - `:frame` or `:raw` (default: `:raw`)
  """
  @spec compress(binary, keyword()) ::
          {:ok, binary} | {:error, :invalid_format | :compression_failed}
  def compress(data, opts \\ []) when is_binary(data) do
    Keyword.get(opts, :format, :raw)
    |> case do
      :raw -> raw_compress(data)
      :frame -> frame_compress(data)
      _ -> :invalid_format
    end
    |> case do
      :compression_failed -> {:error, :compression_failed}
      :invalid_format -> {:error, :invalid_format}
      data -> {:ok, data}
    end
  end

  @doc """
  Decompress a binary.

  Setting `detect` to true will attempt to detect the format of the compressed data.
  It will first try to decompress with the format specified, only use the detected format if the decompression fails and the detected format is different from the specified format.

  ## Options
  - `:format` - `:frame` or `:raw` (default: `:raw`)
  - `:detect` - `true` or `false` (default: `false`)
  """
  @spec decompress(binary, keyword()) ::
          {:ok, binary} | {:error, :invalid_format | :decompression_failed}
  def decompress(data, opts \\ []) when is_binary(data) do
    expected_format = Keyword.get(opts, :format, :raw)

    detected =
      Keyword.get(opts, :detect, false)
      |> case do
        false -> nil
        true -> Snappy.Helper.detect_compressed_format(data)
      end
      |> case do
        nil -> nil
        ^expected_format -> nil
        detected -> detected
      end

    expected_format
    |> case do
      :raw -> raw_decompress(data)
      :frame -> frame_decompress(data)
      _ -> :invalid_format
    end
    |> case do
      :decompression_failed when is_nil(detected) -> {:error, :decompression_failed}
      :decompression_failed -> decompress(data, format: detected, detect: false)
      :invalid_format -> {:error, :invalid_format}
      data -> {:ok, data}
    end
  end
end
