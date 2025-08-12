Feature: Using custom RSpec matchers

  As a developer testing against JSON with complex values
  I want to be able to use custom RSpec matchers
  So that I can make more meaningful assertions on my data

  Background:
    Given a file "spec/spec_helper.rb" with:
          """ruby
          require "rspec/json_expectations"
          require "time"

          RSpec::Matchers.define :be_iso8601_within do |delta, of:|
            match do |actual|
              puts "actual, delta, of: #{actual}, #{delta}, #{of}"
              t = Time.iso8601(actual) rescue nil
              puts "t: #{t}"
              puts "result: #{(t - of).abs} < #{delta}"
              !!t && ((t - of).abs < delta)
            end

            failure_message do |actual|
              "expected it to be an ISO8601 timestamp within desired range"
            end

            failure_message_when_negated do |actual|
              "expected it not to be an ISO8601 timestamp within desired range"
            end
          end
          """
    And a local "HASH" with:
          """ruby
          {
            time: Time.now.utc.iso8601
          }
          """
    And a local "NESTED_HASH" with:
          """ruby
          {
            nested: {
              time: Time.now.utc.iso8601
            }
          }
          """

  Scenario: Correctly expecting a value to match
    Given a file "spec/correct_custom_matcher_spec.rb" with:
          """ruby
          require "spec_helper"

          RSpec.describe "test" do
            subject { %{HASH} }

            it "passes" do
              expect(subject).to include_json(
                time: be_iso8601_within(60, of: Time.now.utc)
              )
            end
          end
          """
    When I run "rspec spec/correct_custom_matcher_spec.rb"
    Then I see:
          """
          1 example, 0 failures
          """

  Scenario: Wrongly expecting a value to match
    Given a file "spec/wrong_custom_matcher_spec.rb" with:
          """ruby
          require "spec_helper"

          RSpec.describe "test" do
            subject { %{HASH} }

            let(:five_days) { 5 * 24 * 60 * 60 }

            it "passes" do
              expect(subject).to include_json(
                time: be_iso8601_within(60, of: Time.now.utc - five_days)
              )
            end
          end
          """
    When I run "rspec spec/wrong_custom_matcher_spec.rb"
    Then I see:
          """
          1 example, 1 failure
          """
    And I see:
          """
                           json atom at path "time" does not match:
          
                             expected it to be an ISO8601 timestamp within desired range
          """

  Scenario: Wrongly expecting a nested value to match
    Given a file "spec/nested_wrong_custom_matcher_spec.rb" with:
          """ruby
          require "spec_helper"

          RSpec.describe "test" do
            subject { %{NESTED_HASH} }

            let(:five_days) { 5 * 24 * 60 * 60 }

            it "passes" do
              expect(subject).to include_json(
                nested: {
                  time: be_iso8601_within(60, of: Time.now.utc - five_days)
                }
              )
            end
          end
          """
    When I run "rspec spec/nested_wrong_custom_matcher_spec.rb"
    Then I see:
          """
          1 example, 1 failure
          """
    And I see:
          """
                           json atom at path "nested/time" does not match:
          
                             expected it to be an ISO8601 timestamp within desired range
          """

  Scenario: Wrongly expecting a negated custom matcher
    Given a file "spec/negated_wrong_custom_matcher_spec.rb" with:
          """ruby
          require "spec_helper"

          RSpec.describe "test" do
            subject { %{HASH} }

            it "passes" do
              expect(subject).not_to include_json(
                time: be_iso8601_within(60, of: Time.now.utc)
              )
            end
          end
          """
    When I run "rspec spec/negated_wrong_custom_matcher_spec.rb"
    Then I see:
          """
          1 example, 1 failure
          """
    And I see:
          """
                           json atom at path "time" does not match:
          
                             expected it not to be an ISO8601 timestamp within desired range
          """
