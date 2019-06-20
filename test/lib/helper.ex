defmodule Jaypeg.Test.Helper do
  @moduledoc """
  Test helpers
  """

  @doc """
  Return a content of a fixture with a given name
  """
  @spec fixture!(filename :: binary) :: binary
  def fixture!(filename) do
    File.read!(Path.join(["test", "fixtures", filename]))
  end
end
