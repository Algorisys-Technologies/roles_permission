defmodule Appb.FeatureContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Appb.FeatureContext` context.
  """

  @doc """
  Generate a feature.
  """
  def feature_fixture(attrs \\ %{}) do
    {:ok, feature} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Appb.FeatureContext.create_feature()

    feature
  end
end
