# ci_scripts

Used for Xcode Cloud.

Documentation: https://developer.apple.com/documentation/xcode/making-dependencies-available-to-xcode-cloud#Use-a-custom-build-script-to-install-a-third-party-dependency-or-tool

### Directory structure

Xcode Cloud requires that the project files be co-located with the Xcode project. We are using a Demo.xcodeproj to triage Xcode Cloud. This Demo project mimics the Demo target within the top-level MapboxSearch.xcodeproj with the key difference that this project imports mapbox-search-ios through SPM.

From their documentaion:

> Create a directory next to your Xcode project or workspace and name it ci_scripts
