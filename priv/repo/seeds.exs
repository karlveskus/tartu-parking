# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TartuParking.Repo.insert!(%TartuParking.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will halt execution if something goes wrong.
alias TartuParking.{Repo, Parking}

[%{address: "Vanemuise 4", available_slots: "10", total_slots: "10"},
 %{address: "Turu 2 ", available_slots: "20", total_slots: "20"},
 %{address: "Liivi 2", available_slots: "10", total_slots: "10"}]
|> Enum.map(fn parking -> Parking.changeset(%Parking{}, parking) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)