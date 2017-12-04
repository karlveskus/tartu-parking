alias TartuParking.{Repo, Parking}
[
  %{address: "Turu 6", available_slots: "20", total_slots: "20",
    coordinates: %Geo.MultiPoint{coordinates: [{26.7309567,58.3771372}, {26.7321262,58.3764495}, {26.733073,58.3768869}, {26.7318392,58.3775929}, {26.7309567,58.3771372}], srid: 4326} },
  %{address: "Riia 2", available_slots: "20", total_slots: "20",
    coordinates: %Geo.MultiPoint{coordinates: [{26.7276657,58.3770697}, {26.7288083,58.3763637}, {26.7302513,58.3770444}, {26.7291248,58.3776941}, {26.7276657,58.3770697}], srid: 4326} },
  %{address: "Turu 2", available_slots: "20", total_slots: "20",
    coordinates: %Geo.MultiPoint{coordinates: [{26.7307717,58.3773538}, {26.7315549,58.3777279}, {26.7309755,58.378026}, {26.732499,58.3785351}, {26.7319196,58.3787714}, {26.7311472,58.3787939}, {26.7297632,58.3779219}, {26.7307717,58.3773538}], srid: 4326} },


]
|> Enum.map(fn parking -> Parking.changeset(%Parking{}, parking) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)