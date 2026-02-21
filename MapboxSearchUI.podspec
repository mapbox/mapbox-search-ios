Pod::Spec.new do |m|
  m.name = 'MapboxSearchUI'
  m.version = '2.20.0-SNAPSHOT-02-21--04-48.git-ace6a0a'
  m.summary = 'Search UI for Mapbox Search API'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  m.description      = <<-DESC
Card style custom UI with full search functionality powered by Mapbox Search API.
                        DESC

  m.homepage         = 'https://www.mapbox.com/search-service'
  m.license          = { :type => 'Mapbox TOS', :file => 'MapboxSearchUI.xcframework/LICENSE.md' }
  m.author           = { 'Mapbox' => 'mobile@mapbox.com'  }
  m.source           = { :http => "https://api.mapbox.com/downloads/v2/search-sdk/releases/ios/packages/#{m.version.to_s}/#{m.name}.zip" }

  m.ios.deployment_target = '12.0'
  m.swift_version = "5.9"

  m.vendored_frameworks = "**/#{m.name}.xcframework"

  m.dependency 'MapboxSearch', '2.20.0-SNAPSHOT-02-21--04-48.git-ace6a0a'
end
