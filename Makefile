format:
	swift format \
		--ignore-unparsable-files \
		--in-place \
		--recursive \
		./Sources ./Tests ./App Package.swift \
		--configuration swift-format.json

PLATFORM_IOS_LATEST = iOS Simulator,name=iPhone 13 Pro
PLATFORM_IOS_13 = iOS Simulator,name=iPhone 11 Pro,OS=13.3
PLATFORM_IOS_10 = iOS Simulator,name=iPhone 8,OS=10

test:
	@xcodebuild test \
			-project App/videocall.xcodeproj \
			-scheme videocall \
			-destination platform="$(PLATFORM_IOS_LATEST)"

	@xcodebuild test \
			-project App/videocall.xcodeproj \
			-scheme videocall \
			-destination platform="$(PLATFORM_IOS_13)"

	@xcodebuild test \
			-project App/videocall.xcodeproj \
			-scheme videocall \
			-destination platform="$(PLATFORM_IOS_10)"
