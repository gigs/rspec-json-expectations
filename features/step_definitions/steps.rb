# frozen_string_literal: true

require "fileutils"

DUMMY_FOLDER = "dummy"

FileUtils.rm_rf(DUMMY_FOLDER)
FileUtils.mkdir_p(DUMMY_FOLDER)

Given(/^a file "(.*?)" with:$/) do |filename, contents|
  @locals ||= {}
  path = File.join(DUMMY_FOLDER, filename)
  FileUtils.mkdir_p(File.dirname(path))
  File.write(path, contents % @locals)
end

Given(/^a local "(.*?)" with:$/) do |key, value|
  @locals ||= {}
  @locals[key.to_sym] = value
end

When(/^I run "(.*?)"$/) do |command|
  @output = Dir.chdir(DUMMY_FOLDER) { `#{command}` }
end

Then(/^I see:$/) do |what|
  expect(@output.to_s).to include(what)
end
