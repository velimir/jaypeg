defmodule JaypegTest do
  use ExUnit.Case
  doctest Jaypeg

  alias Jaypeg.Test.Helper
  alias ImgUtils.Formats.PPM

  test "decoding" do
    encoded = Helper.fixture!("image.jpg")
    {:ok, decoded, props} = Jaypeg.decode(encoded)

    assert 3 == props[:channels]

    ppm_image = PPM.encode(decoded, props[:width], props[:height])
    expected = Helper.fixture!("image.ppm")
    assert expected == ppm_image
  end
end
