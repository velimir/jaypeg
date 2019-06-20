defmodule Jaypeg do
  @moduledoc """
  Simple library for JPEG processing.

  ## Decoding

  ``` elixir
  {:ok, <<104, 146, ...>>, [width: 2000, height: 1333, channels: 3]} =
      Jaypeg.decode(File.read!("file/image.jpg"))
  ```
  """

  @on_load :load_nifs

  @doc """
  Decode JPEG image and return information about the decode image such
  as width, height and number of channels.

  ## Usage

  ``` elixir
  {:ok, <<104, 146, ...>>, [width: 2000, height: 1333, channels: 3]} =
      Jaypeg.decode(File.read!("file/image.jpg"))
  ```

  """
  @spec decode(binary) ::
          {:ok, binary} | {:error, :fmemopen} | {:error, :bad_jpeg}
  def decode(_encoded_image) do
    # coveralls-ignore-start
    :erlang.nif_error(:nif_not_loaded)
    # coveralls-ignore-stop
  end

  @doc false
  def load_nifs do
    :ok = :erlang.load_nif(Application.app_dir(:jaypeg, "priv/jaypeg"), 0)
  end
end
