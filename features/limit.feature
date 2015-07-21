Feature: limit the number of longforms returned

  Scenario: no limit on the number of longforms
    When I run `acromine lf HMM`
    Then the exit status should be 0
    And the number of longforms should be greater than 5

  Scenario: limit the number of longforms to 3
    When I run `acromine lf --limit 3 HMM`
    Then the exit status should be 0
    And the number of longforms should not be greater than 3

  Scenario: invalid limit
    When I run `acromine lf --limit A foo`
    Then the exit status should not be 0
    And the output should match /invalid limit 'A'/
    When I run `acromine lf --limit -1`
    Then the exit status should not be 0
    And the output should match /invalid limit '-1'/
