defmodule SnappyrexTest do
  use ExUnit.Case
  doctest Snappyrex

  describe "compress/2" do
    test "compresses data in raw format by default" do
      expected = <<5, 16, 104, 101, 108, 108, 111>>
      assert {:ok, ^expected} = Snappyrex.compress("hello")
    end

    test "compresses data in frame format" do
      expected = <<255, 6, 0, 0, 115, 78, 97, 80, 112, 89, 1, 9, 0, 0, 187, 31, 28, 25, 104, 101, 108, 108, 111>>
      assert {:ok, ^expected} = Snappyrex.compress("hello", format: :frame)
    end

    test "returns error for invalid format" do
      assert {:error, :invalid_format} = Snappyrex.compress("hello", format: :invalid)
    end
  end

  describe "decompress/2" do
    test "decompresses raw format by default" do
      compressed = <<5, 16, 104, 101, 108, 108, 111>>
      assert {:ok, "hello"} = Snappyrex.decompress(compressed)
    end

    test "decompresses frame format" do
      compressed = <<255, 6, 0, 0, 115, 78, 97, 80, 112, 89, 1, 9, 0, 0, 187, 31, 28, 25, 104, 101, 108, 108, 111>>
      assert {:ok, "hello"} = Snappyrex.decompress(compressed, format: :frame)
    end

    test "returns error for invalid format" do
      assert {:error, :invalid_format} = Snappyrex.decompress("data", format: :invalid)
    end

    test "auto-detects format when detect: true" do
      frame_data = <<255, 6, 0, 0, 115, 78, 97, 80, 112, 89, 1, 9, 0, 0, 187, 31, 28, 25, 104, 101, 108, 108, 111>>
      assert {:ok, "hello"} = Snappyrex.decompress(frame_data, format: :raw, detect: true)
      frame_data = <<5, 16, 104, 101, 108, 108, 111>>
      assert {:ok, "hello"} = Snappyrex.decompress(frame_data, format: :frame, detect: true)
    end

    test "returns error for corrupted data" do
      data = <<1, 16, 104, 101, 108, 108, 111>>
      assert {:error, :decompression_failed} = Snappyrex.decompress(data, format: :raw)
      data = <<255, 0, 0, 0, 115, 78, 97, 80, 112, 89, 1, 9, 0, 0, 187, 31, 28, 25, 104, 101, 108, 108, 111>>
      assert {:error, :decompression_failed} = Snappyrex.decompress(data, format: :frame)
      assert {:error, :decompression_failed} = Snappyrex.decompress(data, format: :raw, detect: true)
    end
  end

  describe "compression/decompression" do
    test "round-trip" do
      data = """
      Alice was beginning to get very tired of sitting by her sister
      on the bank, and of having nothing to do:  once or twice she had
      peeped into the book her sister was reading, but it had no
      pictures or conversations in it, `and what is the use of a book,'
      thought Alice `without pictures or conversation?'
      """

      {:ok, compressed} = Snappyrex.compress(data)
      {:ok, decompressed} = Snappyrex.decompress(compressed)
      assert data == decompressed
      {:ok, compressed} = Snappyrex.compress(data, format: :frame)
      {:ok, decompressed} = Snappyrex.decompress(compressed, format: :frame)
      assert data == decompressed
    end
  end
end
