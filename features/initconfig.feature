Feature: CLI config file

  Scenario: generate config file
    Given a mocked home directory
    When I run `acromine initconfig`
    Then the exit status should be 0
    And the file named ".acromine.conf" should exist

  Scenario: change limit default value
    Given a mocked home directory
    When I run `acromine help lf`
    Then the exit status should be 0
    And the output should match /limit number of long forms returned \(default: none\)/
    Given a file named ".acromine.conf" with:
      """
      ---
      commands:
        :longform:
          :limit: 5
      """
    When I run `acromine help lf`
    Then the exit status should be 0
    And the output should match /limit number of long forms returned \(default: 5\)/
