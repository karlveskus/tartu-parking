defmodule TartuParking.SessionAPIControllerTest do
    use TartuParking.ConnCase
    alias TartuParking.{Repo, User}
  
    test "Wrong username", %{conn: conn} do
      
        [
            %{name: "User", username: "user", password: "user"},
            %{name: "Admin", username: "admin", password: "admin"}
        ]
        |> Enum.map(fn user -> User.changeset(%User{}, user) end)
        |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
        response = build_conn
                    |> post(session_api_path(conn, :create), %{username: "wrong", password: "user"})
                    |> Map.get(:resp_body)
                    |> Poison.Parser.parse!

        assert response["message"] == "Bad credentials"
  
    end  

    test "Wrong password", %{conn: conn} do
        
        [
            %{name: "User", username: "user", password: "user"},
            %{name: "Admin", username: "admin", password: "admin"}
        ]
        |> Enum.map(fn user -> User.changeset(%User{}, user) end)
        |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
        response = build_conn
                    |> post(session_api_path(conn, :create), %{username: "admin", password: "wrong_pass"})
                    |> Map.get(:resp_body)
                    |> Poison.Parser.parse!
        IO.inspect response
        assert response["message"] == "Bad credentials"
    
    end 
  
    test "Wrong password and username", %{conn: conn} do
        
        [
            %{name: "User", username: "user", password: "user"},
            %{name: "Admin", username: "admin", password: "admin"}
        ]
        |> Enum.map(fn user -> User.changeset(%User{}, user) end)
        |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
        response = build_conn
                    |> post(session_api_path(conn, :create), %{username: "wrong_user", password: "wron_pass"})
                    |> Map.get(:resp_body)
                    |> Poison.Parser.parse!
      
        assert response["message"] == "Bad credentials"
    
    end

    test "Right Username and Password", %{conn: conn} do
        
        [
            %{name: "User", username: "user", password: "user"},
            %{name: "Admin", username: "admin", password: "admin"}
        ]
        |> Enum.map(fn user -> User.changeset(%User{}, user) end)
        |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
        response = build_conn
                    |> post(session_api_path(conn, :create), %{username: "admin", password: "admin"})
                    |> Map.get(:resp_body)
                    |> Poison.Parser.parse!
        
        assert response["message"] == "Right credentials"
    
    end

  end
  
