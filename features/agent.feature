Feature: Agent

  In order to monitor system and network resources
  As an administrator
  I will run an agent to report data

  Scenario: configuration
    Given an agent
    Then it should load the given sensors
    And it should load the given outputs

  Scenario: startup
    Given an agent
    When I run the agent
    Then it should report data from the configured sensors
