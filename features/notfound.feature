Feature: expand an acronym to its long forms

  Scenario: the acronym is not found
    When I run `acromine lf definitelynotfound`
    Then the exit status should not be 0
    And the output should match /no long forms found for 'definitelynotfound'/
