Feature: gracefully handle the acronym not being found

  Scenario: REST service cannot be reached
    When I run `acromine --uri http://localhost:12345 lf foo`
    Then the exit status should not be 0
    And the output should match /error: Connection refused/
