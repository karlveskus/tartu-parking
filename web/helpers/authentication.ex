defmodule TartuParking.Authentication do
  def check_credentials(conn, user, password) do

    login_feedback = Comeonin.Pbkdf2.check_pass(user, password)
                     |> elem(0)

    if login_feedback == :ok do
      {:ok, conn}
    else
      {:error, conn}
    end
  end
end