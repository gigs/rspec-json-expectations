Feature: match_json matcher

  As a developer writing expectations against JSON with RSpec
  I want to be able to match against the exact structure of a JSON object
  So I have confidence no additional fields are included

  Background:
    Given a file "spec/spec_helper.rb" with:
          """ruby
          require "rspec/json_expectations"
          """
    And a local "SIMPLE_HASH" with:
          """ruby
          {
            id: 25,
            email: "john.smith@example.com",
            name: "John"
          }
          """
    And a local "SIMPLE_JSON" with:
          """json
          {
            "name": "Matthew",
            "age": 33
          }
          """
    And a local "NESTED_JSON" with:
          """json
          {
            "nested": {
              "a": 1,
              "b": 2
            }
          }
          """
          
    

  Scenario: Correctly expecting hash to include simple json
    Given a file "spec/simple_example_spec.rb" with:
          """ruby
          require "spec_helper"

          RSpec.describe "A json response" do
            subject { %{SIMPLE_HASH} }

            it "has basic info about user" do
              expect(subject).to match_json(
                id: 25,
                email: "john.smith@example.com",
                name: "John"
              )
            end
          end
          """
    When I run "rspec spec/simple_example_spec.rb"
    Then I see:
          """
          1 example, 0 failures
          """

  Scenario: Wrongly expecting hash to include simple json
    Given a file "spec/simple_with_fail_spec.rb" with:
          """ruby
          require "spec_helper"

          RSpec.describe "A json response" do
            subject { %{SIMPLE_HASH} }

            it "has basic info about user" do
              expect(subject).to match_json(
                id: 25,
                email: "john.smith@example.com",
              )
            end
          end
          """
    When I run "rspec spec/simple_with_fail_spec.rb"
    Then I see:
          """
          1 example, 1 failure
          """
    And I see:
          """
                             expected: {id: 25, email: "john.smith@example.com"}
                                  got: {id: 25, email: "john.smith@example.com", name: "John"}
          """

  Scenario: Wrongly expecting JSON string to include simple JSON
    Given a file "spec/json_string_with_fail_spec.rb" with:
          """ruby
          require "spec_helper"

          RSpec.describe "test" do
            subject { '%{SIMPLE_JSON}' }

            it "passes" do
              expect(subject).to match_json(name: "Matthew")
            end
          end
          """
    When I run "rspec spec/json_string_with_fail_spec.rb"
    Then I see:
          """
          1 example, 1 failure
          """
    And I see:
          """
                             expected: {name: "Matthew"}
                                  got: {"name" => "Matthew", "age" => 33}
          """

  Scenario: Wrongly expecting JSON string to include nested JSON
    Given a file "spec/fail_in_nested_json.rb" with:
          """ruby
          require "spec_helper"

          RSpec.describe "test" do
            subject { '%{NESTED_JSON}' }

            it "passes" do
              expect(subject).to match_json(nested: {a: 1})
            end
          end
          """
    When I run "rspec spec/fail_in_nested_json.rb"
    Then I see:
          """
          1 example, 1 failure
          """
    And I see:
          """
                           json atom at path "nested" is not equal to expected value:
          """
    And I see:
          """
                             expected: {a: 1}
                                  got: {"a" => 1, "b" => 2}
          """
