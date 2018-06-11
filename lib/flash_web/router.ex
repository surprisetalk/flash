defmodule FlashWeb.Router do
  use FlashWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FlashWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", FlashWeb do
    pipe_through :api

    resources "/cards", CardController, except: [:new, :edit]
    resources "/facts", FactController, except: [:new, :edit]
    resources "/tasks", TaskController, except: [:new, :edit]
  end
end
