defmodule MoneyTracker.Router do
  use MoneyTracker.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug MoneyTracker.Plug.CurrentUserProvider
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MoneyTracker do
    pipe_through [:browser, :browser_auth] # Use the default browser stack

    get "/", PageController, :index

    get "/sign_in", SessionController, :index
    post "/sign_in", SessionController, :create
    delete "/sign_out", SessionController, :delete

    get "/transactions", TransactionController, :index

    resources "/places", PlaceController do
      resources "/transactions", PlaceTransactionController , as: :transaction
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", MoneyTracker do
  #   pipe_through :api
  # end
end
