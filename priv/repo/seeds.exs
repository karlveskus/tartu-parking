alias TartuParking.{Repo, Parking}
[%{address: "Turu 2", available_slots: "20", total_slots: "20", coordinates: %Geo.MultiPoint{coordinates: [{58.378142,26.730588}, {58.377779, 26.731264}, {58.377447,26.730622},  {58.37787, 26.729930}], srid: 4326}},
 %{address: "Turu 4", available_slots: "30", total_slots: "10", coordinates: %Geo.MultiPoint{coordinates: [{58.388142,26.730588}, {58.387779, 26.741264}, {58.387447,26.740622},  {58.34787, 26.779930}], srid: 4326}}
]
|> Enum.map(fn parking -> Parking.changeset(%Parking{}, parking) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)