defmodule TartuParking.ParkingAllocator do
    use GenServer
    import Ecto.Query, only: [from: 2]
    alias TartuParking.{Repo,Parking}
  
    @decision_timeout Application.get_env(:tartu_parking, :decision_timeout)
    
    def start_link(request, origin) do
        GenServer.start_link(TartuParking.ParkingAllocator, request, name: origin)
    end
        
    def init(request) do
        {:ok, {request, [], %{}}}
    end

     def find_parking(origin) do
         GenServer.cast(origin, :find_parking)
     end

    # def handle_cast(:find_parking, {origin}) do
    #     query = from p in Parking, where: p.available_slots != "0", select: p
    #     available_taxis = Repo.all(query)
    #         |> Enum.filter(fn taxi -> not (taxi in contacted_taxis) end)
    #     if length(available_taxis) > 0 do
    #         locations = Enum.map(available_taxis, fn taxi -> taxi.location end)

    #         index = 
    #             Takso.Geolocator.durations_for(locations, request["pickup_address"])
    #             |> Enum.with_index
    #             |> Enum.min_by(fn {{_text, value}, _index} -> value end)
    #             |> elem(1)

    #         taxi = Enum.at(available_taxis, index)

    #         Takso.Endpoint.broadcast("driver:"<>taxi.username, "requests", request)
    #         timer = Process.send_after(self(), {:notify_customer, taxi.username}, @decision_timeout)
            
    #         {:noreply, {request, [taxi|contacted_taxis], timers |> Map.put(taxi.username, timer)}}
    #     else
    #         Takso.Endpoint.broadcast("customer:"<>request.customer_username, "requests", %{msg: "no taxi available"})
    #         {:noreply, {request, contacted_taxis, timers}}
    #     end
    # end

    # def accept_booking(booking_reference, taxi_username) do
    #     GenServer.cast(booking_reference, {:accept_booking, taxi_username})
    # end

    # def handle_cast({:accept_booking, taxi_username}, {request, contacted_taxis, timers}) do
    #     if (Map.has_key?(timers, taxi_username)) do
    #         timer = timers[taxi_username]
    #         Process.cancel_timer(timer)
    #         Takso.Endpoint.broadcast("customer:"<>request.customer_username, "requests", %{msg: "taxi arriving soon"})        
    #         {:noreply, {request, contacted_taxis, timers |> Map.delete(taxi_username)}}
    #     else
    #         Takso.Endpoint.broadcast("driver:"<>taxi_username, "notifications", %{msg: "Your response has been discarded (arrived too late)"})
    #         {:noreply, {request, contacted_taxis, timers}}
    #     end
    # end

    # def reject_booking(booking_reference, taxi_username) do
    #     GenServer.cast(booking_reference, {:reject_booking, taxi_username})
    # end

    # def handle_cast({:reject_booking, taxi_username}, {request, contacted_taxis, timers}) do
    #     if (Map.has_key?(timers, taxi_username)) do
    #         timer = timers[taxi_username]
    #         Process.cancel_timer(timer)
    #     end
    #     handle_cast(:find_taxi, {request, contacted_taxis, timers})
    # end

    # def handle_info({:notify_customer, taxi_username}, {request, contacted_taxis, timers}) do
    #     handle_cast(:find_taxi, {request, contacted_taxis, timers |> Map.delete(taxi_username)})
    # end
end