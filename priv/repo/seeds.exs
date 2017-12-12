alias TartuParking.{Repo,Parking,User, Zone, DataParser}

zone_a_data =
  Poison.decode! '{"type":"FeatureCollection","crs":{"type":"name","properties":{"name":"urn:ogc:def:crs:OGC:1.3:CRS84"}},"features":[{"type":"Feature","properties":{"Name":"Lossi","description":null,"timestamp":null,"begin":null,"end":null,"altitudeMode":null,"tessellate":-1,"extrude":0,"visibility":-1,"drawOrder":null,"icon":null},"geometry":{"type":"Polygon","coordinates":[[[26.7155421,58.3786729,0.0],[26.7156547,58.3786659,0.0],[26.7159605,58.378957,0.0],[26.7164808,58.3793451,0.0],[26.7167598,58.3793873,0.0],[26.7208904,58.3801776,0.0],[26.7208716,58.3802381,0.0],[26.7176234,58.3796348,0.0],[26.7164218,58.3793929,0.0],[26.7157513,58.3788782,0.0],[26.7155421,58.3786729,0.0]]]}},{"type":"Feature","properties":{"Name":"Karl Ernst von Baeri","description":null,"timestamp":null,"begin":null,"end":null,"altitudeMode":null,"tessellate":-1,"extrude":0,"visibility":-1,"drawOrder":null,"icon":null},"geometry":{"type":"Polygon","coordinates":[[[26.7155844,58.378714,0.0],[26.7150727,58.3787334,0.0],[26.7134848,58.3788628,0.0],[26.7126828,58.3789457,0.0],[26.7125461,58.3789865,0.0],[26.712487,58.379047,0.0],[26.7124763,58.3791525,0.0],[26.712538,58.3792804,0.0],[26.7126909,58.3796376,0.0],[26.7128223,58.3797501,0.0],[26.7129457,58.3799948,0.0],[26.7129564,58.3801523,0.0],[26.7129403,58.3803435,0.0],[26.712817,58.3807148,0.0],[26.7126292,58.3810973,0.0],[26.7125756,58.3813701,0.0],[26.7127311,58.3814994,0.0],[26.7129296,58.3815923,0.0],[26.7133802,58.3817694,0.0],[26.7140561,58.3820057,0.0],[26.7142439,58.3821153,0.0],[26.7145228,58.3824163,0.0],[26.714437,58.3824416,0.0],[26.714142,58.3821238,0.0],[26.7137128,58.3819438,0.0],[26.7130584,58.3817047,0.0],[26.7128438,58.3816204,0.0],[26.7126399,58.3815107,0.0],[26.7125058,58.3813954,0.0],[26.7125112,58.3812491,0.0],[26.7125863,58.3809876,0.0],[26.7127579,58.380622,0.0],[26.712876,58.3802367,0.0],[26.7128491,58.3800257,0.0],[26.7127258,58.3797586,0.0],[26.7126077,58.3796376,0.0],[26.7124093,58.379227,0.0],[26.7123985,58.3790526,0.0],[26.7125273,58.3789429,0.0],[26.7128062,58.3788839,0.0],[26.7135546,58.3788178,0.0],[26.7150539,58.3786968,0.0],[26.7155421,58.3786729,0.0],[26.7155844,58.378714,0.0]]]}},{"type":"Feature","properties":{"Name":"Vallikraavi","description":null,"timestamp":null,"begin":null,"end":null,"altitudeMode":null,"tessellate":-1,"extrude":0,"visibility":-1,"drawOrder":null,"icon":null},"geometry":{"type":"Polygon","coordinates":[[[26.7156547,58.3786659,0.0],[26.7161858,58.3783621,0.0],[26.7164835,58.3781723,0.0],[26.7167383,58.377981,0.0],[26.7170978,58.3777222,0.0],[26.7172319,58.3776435,0.0],[26.7173606,58.3776069,0.0],[26.7175055,58.3776097,0.0],[26.7176986,58.3776407,0.0],[26.7182779,58.3777785,0.0],[26.7188466,58.3779219,0.0],[26.7192113,58.3779782,0.0],[26.719721,58.3780429,0.0],[26.7202896,58.3780738,0.0],[26.72059,58.3780654,0.0],[26.7210406,58.378012,0.0],[26.7220545,58.3778966,0.0],[26.7222583,58.3778882,0.0],[26.7224246,58.377891,0.0],[26.7225051,58.3779191,0.0],[26.7225909,58.3779613,0.0],[26.7228162,58.3781441,0.0],[26.7232132,58.3784142,0.0],[26.7231488,58.3784592,0.0],[26.7227089,58.378147,0.0],[26.7225158,58.3779866,0.0],[26.7224246,58.3779529,0.0],[26.7222798,58.3779388,0.0],[26.7220062,58.3779529,0.0],[26.7209548,58.3780682,0.0],[26.7205685,58.3781104,0.0],[26.7202199,58.3781104,0.0],[26.7197371,58.3780879,0.0],[26.7188948,58.3779838,0.0],[26.7176181,58.3776829,0.0],[26.7175055,58.3776632,0.0],[26.7174196,58.3776547,0.0],[26.7172909,58.3776885,0.0],[26.7165399,58.3782088,0.0],[26.7156926,58.3787025,0.0],[26.7156547,58.3786659,0.0]]]}}]}'

zone_a_parkings = Map.get(zone_a_data, "features")

IO.inspect(DataParser.get_coordinates_by_address(zone_a_parkings, "Lossi"))

[
  %{name: "Zone A", price_per_hour: 2.0, price_per_min: 0.12, free_time: 15},
  %{name: "Zone B", price_per_hour: 1.0, price_per_min: 0.08, free_time: 90}
]
|> Enum.map(fn zone -> Zone.changeset(%Zone{}, zone) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)


[
  %{address: "Lossi", total_slots: "20", zone_id: 1, coordinates: %Geo.MultiPoint{coordinates: DataParser.get_coordinates_by_address(zone_a_parkings, "Lossi"), srid: 4326} },
  %{address: "Karl Ernst von Baeri", total_slots: "20", zone_id: 1, coordinates: %Geo.MultiPoint{coordinates: DataParser.get_coordinates_by_address(zone_a_parkings, "Karl Ernst von Baeri"), srid: 4326} },
  %{address: "Vallikraavi", total_slots: "20", zone_id: 1, coordinates: %Geo.MultiPoint{coordinates: DataParser.get_coordinates_by_address(zone_a_parkings, "Vallikraavi"), srid: 4326} }
]
|> Enum.map(fn parking -> Parking.changeset(%Parking{}, parking) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)


#[
#  %{address: "Lossi", total_slots: "20", zone_id: 1,
#    coordinates: %Geo.MultiPoint{coordinates: [{26.7309567,58.3771372}, {26.7321262,58.3764495}, {26.733073,58.3768869}, {26.7318392,58.3775929}, {26.7309567,58.3771372}], srid: 4326} },
#  %{address: "Riia 2", total_slots: "20",zone_id: 2,
#    coordinates: %Geo.MultiPoint{coordinates: [{26.7276657,58.3770697}, {26.7288083,58.3763637}, {26.7302513,58.3770444}, {26.7291248,58.3776941}, {26.7276657,58.3770697}], srid: 4326} },
#  %{address: "Turu 2", total_slots: "20",zone_id: 1,
#    coordinates: %Geo.MultiPoint{coordinates: [{26.7307717,58.3773538}, {26.7315549,58.3777279}, {26.7309755,58.378026}, {26.732499,58.3785351}, {26.7319196,58.3787714}, {26.7311472,58.3787939}, {26.7297632,58.3779219}, {26.7307717,58.3773538}], srid: 4326} }
#]
#|> Enum.map(fn parking -> Parking.changeset(%Parking{}, parking) end)
#|> Enum.each(fn changeset -> Repo.insert!(changeset) end)


[
  %{name: "User", username: "user", password: "user"},
  %{name: "Admin", username: "admin", password: "admin"}
]
|> Enum.map(fn user -> User.changeset(%User{}, user) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)
