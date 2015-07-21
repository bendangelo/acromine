Feature: change the ordering of the long forms returned

  Scenario: default frequency ordering is freq desc, year asc
    When I run `acromine lf HMM`
    Then the exit status should be 0
    And the output should match:
      """
      HMM may refer to:
        heavy meromyosin
        hidden Markov model
      """

  Scenario: set sort to freq desc, year asc
    When I run `acromine lf --sort fd,ya HMM`
    Then the exit status should be 0
    And the output should match:
      """
      HMM may refer to:
        heavy meromyosin
        hidden Markov model
      """

  Scenario: set sort to freq asc, year asc
    When I run `acromine lf --sort fa,ya HMM`
    Then the exit status should be 0
    And the output should match:
      """
      HMM may refer to:
        6a-hydroxymaackiain 3-O-methyltransferase
        Home Management of Malaria
      """

  Scenario: set sort to freq asc, year desc
    When I run `acromine lf --sort fa,yd HMM`
    Then the exit status should be 0
    And the output should match:
      """
      HMM may refer to:
        6a-hydroxymaackiain 3-O-methyltransferase
        Home Management of Malaria
      """

  Scenario: set sort to freq asc only
    When I run `acromine lf --sort fa HMM`
    Then the exit status should be 0
    And the output should match:
      """
      HMM may refer to:
        6a-hydroxymaackiain 3-O-methyltransferase
        Home Management of Malaria
      """

  Scenario: set sort to year desc only
    When I run `acromine lf --sort yd HMM`
    Then the exit status should be 0
    And the output should match:
      """
      HMM may refer to:
        Home Management of Malaria
        6a-hydroxymaackiain 3-O-methyltransferase
      """

  Scenario: invalid sort spec
    When I run `acromine lf --sort foo HMM`
    Then the exit status should not be 0
    And the output should match /error: invalid sort spec 'foo'/
    When I run `acromine lf --sort df,ay HMM`
    Then the exit status should not be 0
    And the output should match /error: invalid sort spec 'df,ay'/
