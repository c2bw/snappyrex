# Snappyrex

  Snappyrex is a [`Rustler`](https://github.com/rusterlium/rustler) wrapper leveraging the [`snap`](https://docs.rs/snap) package as a NIF for fast Snappy compression/decompression in Elixir.

## Installation

The package can be installed by adding `snappyrex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:snappyrex, "~> 0.1.0"}
  ]
end
```

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
