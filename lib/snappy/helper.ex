defmodule Snappy.Helper do
  @snappy_stream_identifier <<0xFF, 0x06, 0x00, 0x00, 0x73, 0x4E, 0x61, 0x50, 0x70, 0x59>>
  def detect_compressed_format(<<@snappy_stream_identifier::binary, _rest::binary>>), do: :frame
  def detect_compressed_format(_), do: :raw
end
