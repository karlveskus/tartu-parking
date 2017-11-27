Feature: Parking searching
 As a customer
 Such that for parking vehicle in the destination
 I want to arrange it beforehand

Scenario: Choosing place via mobile phone (with available places)
   Given the following parking places are in the area
         | address     | available_slots | total_slots |
         | Vanemuise 4 | 5		     | 10          |
         | Turu 2      | 2		     | 20          |
         | Liivi 2     | 1		     | 10          |

   And I want to park vehicle to "Vanemuise 4"
   And I open FindMeParking mobile application
   And I enter the destination address
   When I submit the request
   Then Map with parkings places should be displayed

 Scenario: Choosing place via mobile phone (with no parking places)
   Given the following parking places are in the area
         | address     | available_slots | total_slots |
         | Vanemuise 4 | 0               | 10          |
         | Turu 2      | 0               | 20          |
	   | Liivi 2     | 0               | 10          |

   And I want to park vehicle to "Vanemuise 4"
   And I open FindMeParking mobile application
   And I enter the destination address
   When I submit the request
   Then I should receive a rejection message
