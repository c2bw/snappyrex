# Snappyrex [![Hex Version](https://img.shields.io/hexpm/v/snappyrex.svg)](https://hex.pm/packages/snappyrex) [![Hex Docs](https://img.shields.io/badge/docs-hexpm-blue.svg)](https://hexdocs.pm/snappyrex/)

Fast Snappy compression/decompression in Elixir.

Uses the [`snap`](https://docs.rs/snap) package as a NIF, created with [`Rustler`](https://github.com/rusterlium/rustler).

## Installation

The package can be installed by adding `snappyrex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:snappyrex, "~> 0.1.1"}
  ]
end
```

***Note: Rust toolchain is required to compile the library.***

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

[github.com/rusterlium/rustler](https://github.com/rusterlium/rustler)

[Rust `snap` package](https://github.com/BurntSushi/rust-snappy)


### Performance

Tested using [`benchee`](https://github.com/bencheeorg/benchee) against [`snappyer`](https://github.com/zmstone/snappyer):

```
Name                ips        average  deviation         median         99th %
snappyrex        161.32        6.20 ms     ±2.13%        6.17 ms        6.73 ms
snappyer          32.05       31.20 ms     ±0.52%       31.17 ms       31.75 ms

Comparison:
snappyrex        161.32
snappyer          32.05 - 5.03x slower +25.00 ms
```

Input is [`testdata`](https://github.com/google/snappy/tree/49087d4e1463707da50f9a53da80d5af932418ce/testdata) from the official `google/snappy` repository