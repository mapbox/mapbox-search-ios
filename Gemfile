source "https://rubygems.org"

gem "cocoapods"
gem "fastlane"
gem "jazzy", "~> 0.14.4"
gem 'rexml', '~> 3.4.2' # Fix CVE-2025-58767

plugins_path = File.join(File.dirname(__FILE__), '.fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
