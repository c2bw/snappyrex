testdata_path = Path.expand("../testdata", __DIR__)
benchmark_time = String.to_float(System.get_env("BENCHMARK_TIME", "3.0"))
benchmark_warmup = String.to_float(System.get_env("BENCHMARK_WARMUP", "1.0"))

inputs =
  testdata_path
  |> Path.join("**/*")
  |> Path.wildcard()
  |> Enum.filter(&File.regular?/1)
  |> Enum.map(&File.read!/1)

if inputs == [] do
  raise "no benchmark inputs found in #{testdata_path}"
end

raw_compressed =
  Enum.map(inputs, fn data ->
    {:ok, compressed} = Snappyrex.compress(data, format: :raw)
    compressed
  end)

frame_compressed =
  Enum.map(inputs, fn data ->
    {:ok, compressed} = Snappyrex.compress(data, format: :frame)
    compressed
  end)

Benchee.run(
  %{
    "compress/raw" => fn ->
      Enum.map(inputs, &Snappyrex.compress(&1, format: :raw))
    end,
    "compress/frame" => fn ->
      Enum.map(inputs, &Snappyrex.compress(&1, format: :frame))
    end,
    "decompress/raw" => fn ->
      Enum.map(raw_compressed, &Snappyrex.decompress(&1, format: :raw))
    end,
    "decompress/frame" => fn ->
      Enum.map(frame_compressed, &Snappyrex.decompress(&1, format: :frame))
    end
  },
  time: benchmark_time,
  warmup: benchmark_warmup
)
