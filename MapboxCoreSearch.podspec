Pod::Spec.new do |s|
  s.name             = 'MapboxCoreSearch'
  s.version          = '2.1.0'
  s.summary          = 'Search Core SDK for Mapbox Search API'

  s.description      = <<-DESC
MapboxSearchSDK implement basic search functionality over Mapbox Search API
Some iOS platfrom specifics applies.
                        DESC

  s.homepage         = 'https://www.mapbox.com/search-service'
  s.license          = { :type => 'Mapbox TOS', :text => <<-LICENSE
                          Copyright © 2024 Mapbox, Inc.
                          You may use this code with your Mapbox account and under the Mapbox Terms of Service (available at: https://www.mapbox.com/legal/tos).
                          All other rights reserved.
                        LICENSE
                      }
  s.author           = { 'Mapbox' => 'mobile@mapbox.com'  }
  s.source           = { :http => "https://api.mapbox.com/downloads/v2/search-core-sdk/releases/ios/packages/#{s.version.to_s}/#{s.name}.xcframework.zip" }

  s.ios.deployment_target = '12.0'
  s.library = "stdc++"
  s.frameworks = "CoreLocation"
  s.cocoapods_version = ">= 1.9.0" # The first public version with XCFrameworks support

  # Force user_target_xcconfig instead of pod_target_xcconfig cause binary framework will not work with pod config.
  # It looks like c++ integration will be ignored for Aggregate target that CocoaPods make for binary frameworks
  s.user_target_xcconfig = {
    'CLANG_CXX_LIBRARY' => 'libc++',
    'OTHER_LDFLAGS' => '$(inherited) -ObjC'
  }

  s.vendored_frameworks = "**/#{s.name}.xcframework"
  s.dependency "MapboxCommon", "24.4.0"
end
