Feature: booking a slot
 As a customer
 Such that for parking vehicle in the destination
 I want to book it beforehand

Scenario: Book place via mobile phone
   Given the following parking places are in the area
         | address                  | total_slots     | zone_id | coordinates                                                                                                                                                                                            |
         | Turu 6                   | 20		      | 1       | [{26.7309567,58.3771372}? {26.7321262,58.3764495}? {26.733073,58.3768869}? {26.7318392,58.3775929}? {26.7309567,58.3771372}]                                                                           |
         | Riia 2                   | 20		      | 1       | [{26.7276657,58.3770697}? {26.7288083,58.3763637}? {26.7302513,58.3770444}? {26.7291248,58.3776941}? {26.7276657,58.3770697}]                                                                          |
         | Liivi 2                  | 20		      | 1       | [{26.7307717,58.3773538}? {26.7315549,58.3777279}? {26.7309755,58.378026}? {26.732499,58.3785351}? {26.7319196,58.3787714}? {26.7311472,58.3787939}? {26.7297632,58.3779219}? {26.7307717,58.3773538}] |
         

   And I want to book place in "Turu 6"
   When I open FindMeParking mobile application
   And I enter the destination address
   And I submit the request
   And Map with parking places should be displayed
   And I click on marker and see the details of that parking
   And I click see more
   When I click Book a spot
   Then booking is placed
