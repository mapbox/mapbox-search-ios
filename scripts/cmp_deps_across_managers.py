import json
import subprocess

def carthage_version(depName):
    command = f"grep {depName} Cartfile.resolved | cut -d \\\" -f4"
    return run_shell(command)

def cocoapods_version(depName):
    command = f"grep -o \"{depName}.*\" MapboxSearch.podspec | cut -d \\\" -f3 | grep -o \"\\d.*\""
    return run_shell(command)

def run_shell(command):
    return subprocess.run(command, shell=True, capture_output=True, text=True).stdout.strip()

# CocoaPods
commonVersion_cocoapods = cocoapods_version("MapboxCommon")
mobileEventsVersion_cocoapods = cocoapods_version("MapboxMobileEvents")

# Carthage
coreSearchVersion_carthage = carthage_version("MapboxCoreSearch")
commonVersion_carthage = carthage_version("MapboxCommon")
mobileEventsVersion_carthage = carthage_version("MapboxMobileEvents.json")


# SPM
coreSearchVersion_spm = run_shell('grep \"let (coreSearchVersion, coreSearchVersionHash)\" Package.swift| cut -d \\" -f2')
coreSearchHash_spm = run_shell('grep \"let (coreSearchVersion, coreSearchVersionHash)\" Package.swift| cut -d \\" -f4')

# MapboxCommon – SPM
with open('Package.resolved') as json_file:
    json_data = json.load(json_file)
    pins = json_data["object"]["pins"]
    commonVersion_spm = [x['state']['version'] for x in pins if x['repositoryURL'] == 'https://github.com/mapbox/mapbox-common-ios.git'][0]
    mobileEventsVersion_spm = [x['state']['version'] for x in pins if x['repositoryURL'] == 'https://github.com/mapbox/mapbox-events-ios.git'][0]

mapboxCoreSearch_build_with_commonVersion = run_shell('/usr/libexec/PlistBuddy -c \"Print :MBXCommonSDKVersion\" Carthage/Build/MapboxCoreSearch.xcframework/Info.plist | cut -c2-')

print("MapboxCoreSearch")
print(f"\tSPM: {coreSearchVersion_spm} ({coreSearchHash_spm})")
print("\tCarthage:", coreSearchVersion_carthage)

print(f"MapboxCommon (MapboxCoreSearch dependends on {mapboxCoreSearch_build_with_commonVersion} MapboxCommon)")
print("\tSPM:", commonVersion_spm)
print("\tCarthage:", commonVersion_carthage)
print("\tCocoaPods:", commonVersion_cocoapods)

print("MapboxMobileEvents")
print("\tSPM:", mobileEventsVersion_spm)
print("\tCarthage:", mobileEventsVersion_carthage)
print("\tCocoaPods:", mobileEventsVersion_cocoapods)

if coreSearchVersion_spm != coreSearchVersion_carthage:
    exit(1)

if commonVersion_spm != commonVersion_carthage or commonVersion_spm != mapboxCoreSearch_build_with_commonVersion or commonVersion_carthage != commonVersion_cocoapods:
    exit(2)

if mobileEventsVersion_carthage != mobileEventsVersion_spm or mobileEventsVersion_cocoapods != mobileEventsVersion_carthage:
    exit(3)

exit(0)