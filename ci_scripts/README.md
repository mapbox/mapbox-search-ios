# ci_scripts

Used for Xcode Cloud.

Documentation: https://developer.apple.com/documentation/xcode/making-dependencies-available-to-xcode-cloud#Use-a-custom-build-script-to-install-a-third-party-dependency-or-tool

### Why is this in Sources?

Xcode Cloud requires that this directoy be co-located with the Xcode project and we are using Sources/Demo.xcodeproj to triage Xcode Cloud.

From their documentaion:

> Create a directory next to your Xcode project or workspace and name it ci_scripts
