CURRENT_DIR := $(shell pwd)
CARTHAGE_MIN_VERSION = 0.39.1
CARTHAGE_BUILD_DIR := $(CURRENT_DIR)/Carthage/Build
PRODUCTS_DIR := $(CURRENT_DIR)/Products
VERSION ?= $(shell git describe --tags $(git rev-list --tags='v*' --max-count=1) --abbrev=0)
MARKETING_VERSION := $(shell echo "${VERSION}" | perl -nle 'print $$v if ($$v)=/([0-9]+([.][0-9]+)+)/')

build products ios: dependencies
	$(CURRENT_DIR)/scripts/build.sh

carthage-min-version:
# Test minimal Carthage version.
#    1. Build a string "0.39.1\n0.38.0" (one value is actual version, second one – minimal)
#    2. Sort string with `sort -V` to apply SemVer sorting algo
#    3. Get the first (minimal) version with `head -n1`
#    4. Compare minimal version from the list with the required minimal.
#       Fail if actual version is lower than min requirement
	@test $(shell echo "$(shell carthage version)\n${CARTHAGE_MIN_VERSION}" | sort -V | head -n1) = ${CARTHAGE_MIN_VERSION}


dependencies deps: carthage-min-version
	XCODE_XCCONFIG_FILE="${CURRENT_DIR}/scripts/carthage-support.xcconfig" carthage bootstrap --use-xcframeworks --cache-builds --use-netrc
	scripts/generate_sdk_version_swift.sh

dependencies-update deps-update: carthage-min-version
	XCODE_XCCONFIG_FILE="${CURRENT_DIR}/scripts/carthage-support.xcconfig" carthage update --use-xcframeworks --cache-builds --use-netrc
	scripts/generate_sdk_version_swift.sh

offline:
	aws s3 cp s3://vng-temp/HERE/luxembourg.tgz - | tar -xz -C Sources/Demo/offline/

ci-dev-test: dependencies
	fastlane scan --scheme "Demo" --device "iPhone 11 Pro" --result_bundle "true" --testplan "CI-dev" --output_directory "output"

ci-full-test: dependencies
	fastlane scan --scheme "Demo" --device "iPhone 11 Pro" --result_bundle "true" --testplan "Demo" --output_directory "output"

test: dependencies
	xcodebuild -scheme MapboxSearchUI -destination platform\=iOS\ Simulator,name\=iPhone\ 11\ Pro clean test

xctest: dependencies
	xcodebuild -scheme MapboxSearch -destination platform\=iOS\ Simulator,name\=iPhone\ 11\ Pro clean test

codecov:
	scripts/coverage/gather_coverage.sh "^MapboxSearch$$" coverage
	scripts/coverage/upload_codecov.sh coverage/MapboxSearch.framework.coverage.txt

generate-docs: dependencies
	VERSION="${VERSION}" $(CURRENT_DIR)/scripts/generate_docs.sh

release-docs: generate-docs
	git worktree add documentation-production publisher-production
	cp -r docs/MapboxSearch/ "documentation-production/core/${VERSION}"
	cp -r docs/MapboxSearchUI/ "documentation-production/ui/${VERSION}"
	git -C documentation-production add "core/${VERSION}" "ui/${VERSION}"
	git -C documentation-production config user.email "release-bot@mapbox.com"
	git -C documentation-production config user.name "Release SDK bot"
	git -C documentation-production commit -m "[bot] Release ${VERSION} documentation"
	git -C documentation-production push
	git worktree remove documentation-production --force

generate-maki:
	$(CURRENT_DIR)/scripts/generate_maki.sh

internal-release: dependencies
	$(CURRENT_DIR)/scripts/release_version.sh

validate-spm-build:
	$(CURRENT_DIR)/scripts/build_spm_sample.sh

clean:
	-rm -rf $(CARTHAGE_BUILD_DIR) $(PRODUCTS_DIR) $(CURRENT_DIR)/docs $(CURRENT_DIR)/jazzy-theme

pristine:
	git reset --hard && git clean -dfx && git submodule foreach "git reset --hard && git clean -dfx"

lint:
	pod spec lint MapboxSearch.podspec --silent
	pod lib lint MapboxSearchUI.podspec --include-podspecs=MapboxSearch.podspec --silent

# This target send local podspecs to the official CocoaPods repository
push-trunk:
	pod trunk push MapboxSearch.podspec
	pod trunk push MapboxSearchUI.podspec --synchronous

update-registry: check-aws
	aws s3 cp $(CURRENT_DIR)/Products/MapboxSearch.zip   s3://mapbox-api-downloads-production/v2/search-sdk/releases/ios/$(VERSION:v%=%)/packages/MapboxSearch.zip
	aws s3 cp $(CURRENT_DIR)/Products/MapboxSearchUI.zip s3://mapbox-api-downloads-production/v2/search-sdk/releases/ios/$(VERSION:v%=%)/packages/MapboxSearchUI.zip

list-registry-latest: check-aws
	aws s3 ls s3://mapbox-api-downloads-production/v2/search-sdk/releases/ios/$(VERSION:v%=%)/packages/

check-aws:
	@aws s3 ls s3://mapbox-api-downloads-production &>/dev/null

git-versions:
	@echo "Tag version: ${VERSION}"
	@echo "Marketing version: ${MARKETING_VERSION}"

git-version:
	@echo "${VERSION}"


.PHONY: git-version git-versions check-aws update-registry push-trunk lint pristine clean internal-release generate-maki
.PHONY: generate-docs xctest test ci-full-test ci-dev-test dependencies products build validate-spm-build
.PHONY: deps-update deps ios carthage-min-version codecov list-registry-latest

