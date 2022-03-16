defmodule AppbWeb.PageController do
  use AppbWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
