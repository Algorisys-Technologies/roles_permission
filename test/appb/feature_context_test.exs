defmodule Appb.FeatureContextTest do
  use Appb.DataCase

  alias Appb.FeatureContext

  describe "features" do
    alias Appb.FeatureContext.Feature

    import Appb.FeatureContextFixtures

    @invalid_attrs %{name: nil}

    test "list_features/0 returns all features" do
      feature = feature_fixture()
      assert FeatureContext.list_features() == [feature]
    end

    test "get_feature!/1 returns the feature with given id" do
      feature = feature_fixture()
      assert FeatureContext.get_feature!(feature.id) == feature
    end

    test "create_feature/1 with valid data creates a feature" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Feature{} = feature} = FeatureContext.create_feature(valid_attrs)
      assert feature.name == "some name"
    end

    test "create_feature/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FeatureContext.create_feature(@invalid_attrs)
    end

    test "update_feature/2 with valid data updates the feature" do
      feature = feature_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Feature{} = feature} = FeatureContext.update_feature(feature, update_attrs)
      assert feature.name == "some updated name"
    end

    test "update_feature/2 with invalid data returns error changeset" do
      feature = feature_fixture()
      assert {:error, %Ecto.Changeset{}} = FeatureContext.update_feature(feature, @invalid_attrs)
      assert feature == FeatureContext.get_feature!(feature.id)
    end

    test "delete_feature/1 deletes the feature" do
      feature = feature_fixture()
      assert {:ok, %Feature{}} = FeatureContext.delete_feature(feature)
      assert_raise Ecto.NoResultsError, fn -> FeatureContext.get_feature!(feature.id) end
    end

    test "change_feature/1 returns a feature changeset" do
      feature = feature_fixture()
      assert %Ecto.Changeset{} = FeatureContext.change_feature(feature)
    end
  end
end
