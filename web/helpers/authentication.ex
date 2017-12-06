defmodule TartuParking.Authentication do
    def check_credentials(conn, user, password) do
      if user && Comeonin.Pbkdf2.check_pass(user, password) do
        {:ok, conn}
      else
        {:error, conn}
      end
    end
  end