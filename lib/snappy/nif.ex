defmodule Snappy.Nif do
  use Rustler, otp_app: :snappyrex, crate: "snappy_nif"
  @moduledoc false

  @doc """
   Compress a binary in the Snappy _frame_ format.
  """
  @spec frame_compress(binary) :: binary | :compression_failed
  def frame_compress(data) when is_binary(data), do: error()

  @doc """
    Decompress a binary in the Snappy _frame_ format.
  """
  @spec frame_decompress(binary) :: binary | :decompression_failed
  def frame_decompress(data) when is_binary(data), do: error()

  @doc """
    Compress a binary in the Snappy _raw_ format.
  """
  @spec raw_compress(binary) :: binary | :compression_failed
  def raw_compress(data) when is_binary(data), do: error()

  @doc """
    Decompress a binary in the Snappy _raw_ format.
  """
  @spec raw_decompress(binary) :: binary | :decompression_failed
  def raw_decompress(data) when is_binary(data), do: error()

  defp error(), do: :erlang.nif_error(:nif_not_loaded)
end
