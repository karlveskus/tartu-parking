Feature: Parking booking
 As a customer
 Such that for parking vehicle in the destination
 I want to arrange it beforehand

Scenario: Choosing place via mobile phone (with available places)
   Given the following parking places are in the area
         | location    | available slots |
         | Vanemuise 4 | 5		     |
         | Turu 2      | 2		     |
         | Liivi 2     | 1		     |

   And I want to park vehicle to "Vanemuise 4"
   And I open FindMeParking mobile application
   And I enter the destination address
   When I submit the request
   Then Map with parkings places should be displayed

 Scenario: Choosing place via mobile phone (with no parking places)
   Given the following parking places are in the area
         | location    | available slots |
         | Vanemuise 4 | 0               |
         | Turu 2      | 0               |
	   | Liivi 2     | 0               |

   And I want to park vehicle to "Vanemuise 4"
   And I open FindMeParking mobile application
   And I enter the destination address
   When I submit the request
   Then Map should be displayed with “there are  no available parking places”
