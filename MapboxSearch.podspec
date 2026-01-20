Pod::Spec.new do |m|
  m.name = 'MapboxSearch'
  m.version = '2.19.0-SNAPSHOT-01-20--12-42.git-3dbbdd7'
  m.summary = 'Search SDK for Mapbox Search API'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  m.description      = <<-DESC
MapboxSearch SDK implements basic search functionality over Mapbox Search API
Some iOS platform specifics applies.
                        DESC

  m.homepage         = 'https://www.mapbox.com/search-service'
  m.license          = { :type => 'Mapbox TOS', :file => 'MapboxSearch.xcframework/LICENSE.md' }
  m.author           = { 'Mapbox' => 'mobile@mapbox.com'  }
  m.source           = { :http => "https://api.mapbox.com/downloads/v2/search-sdk/releases/ios/packages/#{m.version.to_s}/#{m.name}.zip" }

  m.ios.deployment_target = '12.0'
  m.swift_version = "5.9"

  m.vendored_frameworks = "**/#{m.name}.xcframework"

  m.dependency 'MapboxCoreSearch', '2.19.0-SNAPSHOT-01-20--12-42.git-3dbbdd7'
  m.dependency 'MapboxCommon', '24.19.0-SNAPSHOT-01-20--12-42.git-3dbbdd7'
end
