use rustler::{Binary, Error, OwnedBinary};
use std::io::{Read, Write};
use snap;

// Frame format

#[rustler::nif]
fn frame_compress<'a>(env: rustler::Env<'a>, data: Binary<'a>) -> Result<Binary<'a>, Error> {
    let mut encoder = snap::write::FrameEncoder::new(Vec::new());
    encoder
        .write_all(&data)
        .map_err(|_| Error::Atom("compression_failed"))?;
    let compressed = encoder
        .into_inner()
        .map_err(|_| Error::Atom("compression_failed"))?;
    Ok(vec_to_binary(compressed, env))
}

#[rustler::nif]
fn frame_decompress<'a>(env: rustler::Env<'a>, data: Binary<'a>) -> Result<Binary<'a>, Error> {
    let mut decoder = snap::read::FrameDecoder::new(&data[..]);
    let mut buf = Vec::new();
    decoder
        .read_to_end(&mut buf)
        .map_err(|_| Error::Atom("decompression_failed"))?;
    Ok(vec_to_binary(buf, env))
}

// Raw Format

#[rustler::nif]
fn raw_compress<'a>(env: rustler::Env<'a>, data: Binary<'a>) -> Result<Binary<'a>, Error> {
    let compressed = snap::raw::Encoder::new()
        .compress_vec(&data)
        .map_err(|_| Error::Atom("compression_failed"))?;
    Ok(vec_to_binary(compressed, env))
}

#[rustler::nif]
fn raw_decompress<'a>(env: rustler::Env<'a>, data: Binary<'a>) -> Result<Binary<'a>, Error> {
    let decompressed = snap::raw::Decoder::new()
        .decompress_vec(&data)
        .map_err(|_| Error::Atom("decompression_failed"))?;
    Ok(vec_to_binary(decompressed, env))
}

// Helper
fn vec_to_binary<'a>(data: Vec<u8>, env: rustler::Env<'a>) -> Binary<'a> {
    let mut binary = OwnedBinary::new(data.len()).unwrap();
    binary.as_mut_slice().copy_from_slice(&data);
    binary.release(env)
}

rustler::init!("Elixir.Snappy.Nif");
