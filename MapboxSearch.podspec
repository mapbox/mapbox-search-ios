Pod::Spec.new do |s|
  s.name             = 'MapboxSearch'
  s.version          = '1.4.1'
  s.summary          = 'Search SDK for Mapbox Search API '

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
MapboxSearch SDK implements basic search functionality over Mapbox Search API
Some iOS platform specifics applies.
                        DESC

  s.homepage         = 'https://www.mapbox.com/search-service'
  s.license          = { :type => 'Mapbox TOS', :file => 'MapboxSearch.xcframework/LICENSE.md' }
  s.author           = { 'Mapbox' => 'mobile@mapbox.com'  }
  s.source           = { :http => "https://api.mapbox.com/downloads/v2/search-sdk/releases/ios/packages/#{s.version.to_s}/#{s.name}.zip" }

  s.ios.deployment_target = '12.0'
  s.swift_versions = [5.7]

  s.vendored_frameworks = "**/#{s.name}.xcframework"

  s.dependency "MapboxCommon", '~> 23.10.1'
end
