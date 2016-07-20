defmodule Pxblog.SessionController do
  use Pxblog.Web, :controller
  alias Pxblog.User
  require Logger

  # Import from the Comeonin.Bcrypt module, only the checkpw function with an arity of 2
  import Comeonin.Bcrypt, only: [checkpw: 2]

  plug :scrub_params, "user" when action in [:create]
  # “scrub_params” is a special function that cleans up any user input;
  # in the case where something is passed in as a blank string, for example,
  # scrub_params will convert it into a nil value instead to avoid creating
  # entries in your database that have empty strings.

  def new(conn, _params) do
    render conn, "new.html", changeset: User.changeset(%User{})
  end

  def create(conn, %{"user" => %{"username" => username, "password" => password}}) when not is_nil(username) and not is_nil(password) do
    user = Repo.get_by(User, username: username)
    sign_in(user, password, conn)
  end

  def create(conn, _) do
    failed_login(conn)
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:info, "Signed out successfully!")
    |> redirect(to: page_path(conn, :index))
  end

  defp sign_in(user, _password, conn) when is_nil(user) do
    failed_login(conn)
  end

  defp sign_in(user, password, conn) do
    if checkpw(password, user.password_digest) do
      conn
      |> put_session(:current_user, %{id: user.id, username: user.username})
      |> put_flash(:info, "Sign in successful!")
      |> redirect(to: page_path(conn, :index))
    else
      failed_login(conn)
    end
  end

  defp failed_login(conn) do
    conn
    |> put_session(:current_user, nil)
    |> put_flash(:error, "Invalid username/password combination!")
    |> redirect(to: page_path(conn, :index))
    |> halt()
  end

end
