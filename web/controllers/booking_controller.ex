defmodule TartuParking.BookingController do
    use TartuParking.Web, :controller
  
    def index(conn, params) do

      user_id = 1

      parking_id =
        case Map.fetch(params, "parking_id") do
          :error            -> ""
          {:ok, parking_id} -> parking_id
        end
      
      render conn, "index.html", parking_id: parking_id, user_id: user_id

    end
    
  end
  