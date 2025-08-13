import json
import subprocess

def carthage_version(depName):
    command = f"grep {depName} Cartfile.resolved | cut -d \\\" -f4"
    return run_shell(command)

def cocoapods_version(depName):
    command = f"grep -o \"{depName}.*\" MapboxSearch.podspec | cut -d \"'\" -f2"
    return run_shell(command)

def run_shell(command):
    return subprocess.run(command, shell=True, capture_output=True, text=True).stdout.strip()

# CocoaPods
commonVersion_cocoapods = cocoapods_version("MapboxCommon")

# Carthage
coreSearchVersion_carthage = carthage_version("MapboxCoreSearch")
commonVersion_carthage = carthage_version("MapboxCommon")

# SPM
coreSearchVersion_spm = run_shell('grep \"let (coreSearchVersion, coreSearchVersionHash)\" Package.swift| cut -d \\" -f2')
coreSearchHash_spm = run_shell('grep \"let (coreSearchVersion, coreSearchVersionHash)\" Package.swift| cut -d \\" -f4')

# MapboxCommon – SPM
with open('Package.resolved') as json_file:
    json_data = json.load(json_file)
    pins = json_data["pins"]
    commonVersion_spm = [x['state']['version'] for x in pins if x['location'] == 'https://github.com/mapbox/mapbox-common-ios.git'][0]

mapboxCoreSearch_build_with_commonVersion = run_shell('/usr/libexec/PlistBuddy -c \"Print :MBXCommonSDKVersion\" Carthage/Build/MapboxCoreSearch.xcframework/Info.plist | cut -c2-')

print("MapboxCoreSearch")
print(f"\tSPM: {coreSearchVersion_spm} ({coreSearchHash_spm})")
print(f"\tCarthage {coreSearchVersion_carthage} (Resolved)")

print(f"MapboxCommon (MapboxCoreSearch dependends on {mapboxCoreSearch_build_with_commonVersion} MapboxCommon)")
print(f"\tSPM {commonVersion_spm} (Resolved)")
print(f"\tCarthage {commonVersion_carthage} (Resolved)")
print("\tCocoaPods:", commonVersion_cocoapods)

#if coreSearchVersion_spm != coreSearchVersion_carthage:
#    exit(1)
#if commonVersion_carthage != mapboxCoreSearch_build_with_commonVersion:
#    exit(2)
exit(0)
