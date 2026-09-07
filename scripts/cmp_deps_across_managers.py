import json
import subprocess


def cocoapods_version(depName):
    command = f'grep -o "{depName}.*" MapboxSearch.podspec | cut -d "\'" -f2'
    return run_shell(command)


def run_shell(command):
    return subprocess.run(command, shell=True, capture_output=True, text=True).stdout.strip()


# CocoaPods
commonVersion_cocoapods = cocoapods_version("MapboxCommon")

# SPM
coreSearchVersion_spm = run_shell('grep "let (coreSearchVersion, coreSearchVersionHash)" Package.swift| cut -d \\" -f2')
coreSearchHash_spm = run_shell('grep "let (coreSearchVersion, coreSearchVersionHash)" Package.swift| cut -d \\" -f4')

# MapboxCommon – SPM
with open("Package.resolved") as json_file:
    json_data = json.load(json_file)
    pins = json_data["pins"]
    commonVersion_spm = [
        x["state"]["version"] for x in pins if x["location"] == "https://github.com/mapbox/mapbox-common-ios.git"
    ][0]

print("MapboxCoreSearch:")
print(f"\tSPM: {coreSearchVersion_spm} ({coreSearchHash_spm})")

print("MapboxCommon (MapboxCoreSearch dependends on MapboxCommon:")
print(f"\tSPM {commonVersion_spm} (Resolved)")
print("\tCocoaPods:", commonVersion_cocoapods)

exit(0)
