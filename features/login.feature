Feature: Login
 As a customer
 Such that for parking vehicle in the destination
 I want to login to later checkin

Scenario: Login in
   Given the following users are registered
        | name  | username  | password
        | user1 | user1     | user1
        | user2 | user2     | user2
   
   And I want to log in as "user1"
   And I open FindMeParking mobile application
   And I navigated to login page
   And I filled in my user and password
   When I click submit
   Then I should return to map while logged in