CURRENT_DIR := $(shell pwd)
PRODUCTS_DIR := $(CURRENT_DIR)/Products
VERSION ?= $(shell git describe --tags $(shell git rev-list --tags='v*' --max-count=1) --abbrev=0)
VERSION_STRIPPED ?= $(VERSION:v%=%)
MARKETING_VERSION := $(shell echo "${VERSION}" | perl -nle 'print $$v if ($$v)=/([0-9]+([.][0-9]+)+)/')

build products ios: generate-xcodeproj
	$(CURRENT_DIR)/scripts/build.sh

dependencies deps:
	swift package resolve
	xcodebuild -resolvePackageDependencies -project MapboxSearch.xcodeproj
    
generate-xcodeproj:
	scripts/xcodegen_prepare_dependencies.sh
	xcodegen generate

offline:
	aws s3 cp s3://vng-temp/HERE/luxembourg.tgz - | tar -xz -C Demo/offline/

ci-dev-test: dependencies
	bundle exec fastlane scan --scheme "Demo" --device "iPhone 15" --result_bundle "true" --testplan "CI-dev" --output_directory "output"

ci-full-test: dependencies
	bundle exec fastlane scan --scheme "Demo" --device "iPhone 15" --result_bundle "true" --testplan "Demo" --output_directory "output"

test: dependencies
	xcodebuild -scheme MapboxSearchUI -destination platform\=iOS\ Simulator,name\=iPhone\ 15 clean test

xctest: dependencies
	xcodebuild -scheme MapboxSearch -destination platform\=iOS\ Simulator,name\=iPhone\ 15 clean test

codecov:
	scripts/coverage/gather_coverage.sh "^MapboxSearch$$" coverage
	scripts/coverage/upload_codecov.sh coverage/MapboxSearch.framework.coverage.txt

generate-docs: generate-xcodeproj
	VERSION="${VERSION}" $(CURRENT_DIR)/scripts/generate_docs.sh

release-docs: generate-docs
	git worktree add documentation-production publisher-production
	cp -r docs/MapboxSearch/ "documentation-production/core/${VERSION_STRIPPED}"
	cp -r docs/MapboxSearchUI/ "documentation-production/ui/${VERSION_STRIPPED}"
	git -C documentation-production add "core/${VERSION_STRIPPED}" "ui/${VERSION_STRIPPED}"
	git -C documentation-production config user.email "release-bot@mapbox.com"
	git -C documentation-production config user.name "Release SDK bot"
	git -C documentation-production commit -m "[bot] Release ${VERSION_STRIPPED} documentation"
	git -C documentation-production push
	git worktree remove documentation-production --force

generate-maki:
	$(CURRENT_DIR)/scripts/generate_maki.sh

internal-release: dependencies
	$(CURRENT_DIR)/scripts/release_version.sh

validate-spm-build:
	$(CURRENT_DIR)/scripts/build_spm_sample.sh

clean:
	-rm -rf $(PRODUCTS_DIR) $(CURRENT_DIR)/docs $(CURRENT_DIR)/jazzy-theme

pristine:
	git reset --hard && git clean -dfx && git submodule foreach "git reset --hard && git clean -dfx"

lint:
	pod lib lint MapboxSearch.podspec
	pod lib lint MapboxSearchUI.podspec --include-podspecs=MapboxSearch.podspec

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
.PHONY: dependencies deps ios codecov list-registry-latest

