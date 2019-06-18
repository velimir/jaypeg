#include "erl_nif.h"

#include <jpeglib.h>

ERL_NIF_TERM decode_properties(ErlNifEnv *env, int width, int height,
                               int channels) {
  ERL_NIF_TERM width_term;
  width_term = enif_make_tuple2(env, enif_make_atom(env, "width"),
                                enif_make_int(env, width));

  ERL_NIF_TERM height_term;
  height_term = enif_make_tuple2(env, enif_make_atom(env, "height"),
                                 enif_make_int(env, height));

  ERL_NIF_TERM channels_term;
  channels_term = enif_make_tuple2(env, enif_make_atom(env, "channels"),
                                   enif_make_int(env, channels));

  ERL_NIF_TERM items[3] = {width_term, height_term, channels_term};
  return enif_make_list_from_array(
    env, items, sizeof(items) / sizeof(ERL_NIF_TERM));
}

static ERL_NIF_TERM decode(ErlNifEnv *env, int argc,
                           const ERL_NIF_TERM argv[]) {
  ERL_NIF_TERM jpeg_binary_term;
  jpeg_binary_term = argv[0];
  if (!enif_is_binary(env, jpeg_binary_term)) {
    return enif_make_badarg(env);
  }

  ErlNifBinary jpeg_binary;
  enif_inspect_binary(env, jpeg_binary_term, &jpeg_binary);

  struct jpeg_decompress_struct cinfo;
  struct jpeg_error_mgr jerr;
  cinfo.err = jpeg_std_error(&jerr);
  jpeg_create_decompress(&cinfo);

  FILE * img_src = fmemopen(jpeg_binary.data, jpeg_binary.size, "rb");
  if (img_src == NULL)
    return enif_make_tuple2(env, enif_make_atom(env, "error"),
                            enif_make_atom(env, "fmemopen"));

  jpeg_stdio_src(&cinfo, img_src);

  int error_check;
  error_check = jpeg_read_header(&cinfo, TRUE);
  if (error_check != 1)
    return enif_make_tuple2(env, enif_make_atom(env, "error"),
                            enif_make_atom(env, "bad_jpeg"));

  jpeg_start_decompress(&cinfo);

  int width, height, num_pixels, row_stride;
  width = cinfo.output_width;
  height = cinfo.output_height;
  num_pixels = cinfo.output_components;
  unsigned long output_size;
  output_size = width * height * num_pixels;
  row_stride = width * num_pixels;

  ErlNifBinary bmp_binary;
  enif_alloc_binary(output_size, &bmp_binary);

  while (cinfo.output_scanline < cinfo.output_height) {
    unsigned char *buf[1];
    buf[0] = bmp_binary.data + cinfo.output_scanline * row_stride;
    jpeg_read_scanlines(&cinfo, buf, 1);
  }

  jpeg_finish_decompress(&cinfo);
  jpeg_destroy_decompress(&cinfo);

  fclose(img_src);

  ERL_NIF_TERM bmp_term;
  bmp_term = enif_make_binary(env, &bmp_binary);
  ERL_NIF_TERM properties_term;
  properties_term = decode_properties(env, width, height, num_pixels);

  return enif_make_tuple3(
    env, enif_make_atom(env, "ok"), bmp_term, properties_term);
}

static ErlNifFunc nif_funcs[] = {
  {"decode", 1, decode}
};

ERL_NIF_INIT(Elixir.Jaypeg, nif_funcs, NULL, NULL, NULL, NULL)

/* Local Variables: */
/* c-basic-offset: 2 */
/* End: */
