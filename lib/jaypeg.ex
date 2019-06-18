defmodule Jaypeg do
  @moduledoc """
  Documentation for Jaypeg.
  """

  @on_load :load_nifs

  @doc """
  TODO: Write documentation.

  ## Examples

      iex> Jaypeg.hello()
      :world

  """
  def decode(_encoded_image) do
    :erlang.nif_error(:nif_not_loaded)
  end

  @doc """
  TODO: Write documentation.

  ## Examples

  iex> Jaypeg.hello()
  :world

  """
  def resize(
        _in_binary,
        _in_width,
        _in_height,
        _num_channels,
        _out_width,
        _out_height
      ) do
    :erlang.nif_error(:nif_not_loaded)
  end

  def load_nifs do
    :ok = :erlang.load_nif(Application.app_dir(:jaypeg, "priv/jaypeg"), 0)
  end
end
