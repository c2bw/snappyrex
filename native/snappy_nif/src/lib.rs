use rustler::{Binary, Error, OwnedBinary};
use std::io::{Read, Write};

// Frame format

const SNAPPY_STREAM_IDENTIFIER: &[u8] = b"\xff\x06\x00\x00sNaPpY";

#[rustler::nif(schedule = "DirtyCpu")]
fn frame_compress<'a>(env: rustler::Env<'a>, data: Binary<'a>) -> Result<Binary<'a>, Error> {
    if data.is_empty() {
        return vec_to_binary(SNAPPY_STREAM_IDENTIFIER.to_vec(), env)
            .ok_or(Error::Atom("compression_failed"));
    }

    let mut encoder = snap::write::FrameEncoder::new(Vec::new());
    encoder
        .write_all(&data)
        .map_err(|_| Error::Atom("compression_failed"))?;
    let compressed = encoder
        .into_inner()
        .map_err(|_| Error::Atom("compression_failed"))?;
    vec_to_binary(compressed, env).ok_or(Error::Atom("compression_failed"))
}

#[rustler::nif(schedule = "DirtyCpu")]
fn frame_decompress<'a>(env: rustler::Env<'a>, data: Binary<'a>) -> Result<Binary<'a>, Error> {
    if data.is_empty() {
        return Err(Error::Atom("decompression_failed"));
    }

    let mut decoder = snap::read::FrameDecoder::new(&data[..]);
    let mut buf = Vec::new();
    decoder
        .read_to_end(&mut buf)
        .map_err(|_| Error::Atom("decompression_failed"))?;
    vec_to_binary(buf, env).ok_or(Error::Atom("decompression_failed"))
}

// Raw Format

#[rustler::nif(schedule = "DirtyCpu")]
fn raw_compress<'a>(env: rustler::Env<'a>, data: Binary<'a>) -> Result<Binary<'a>, Error> {
    let compressed = snap::raw::Encoder::new()
        .compress_vec(&data)
        .map_err(|_| Error::Atom("compression_failed"))?;
    vec_to_binary(compressed, env).ok_or(Error::Atom("compression_failed"))
}

#[rustler::nif(schedule = "DirtyCpu")]
fn raw_decompress<'a>(env: rustler::Env<'a>, data: Binary<'a>) -> Result<Binary<'a>, Error> {
    let decompressed = snap::raw::Decoder::new()
        .decompress_vec(&data)
        .map_err(|_| Error::Atom("decompression_failed"))?;
    vec_to_binary(decompressed, env).ok_or(Error::Atom("decompression_failed"))
}

// Helper

fn vec_to_binary<'a>(data: Vec<u8>, env: rustler::Env<'a>) -> Option<Binary<'a>> {
    let mut binary = OwnedBinary::new(data.len())?;
    binary.as_mut_slice().copy_from_slice(&data);
    Some(binary.release(env))
}

rustler::init!("Elixir.Snappy.Nif");
