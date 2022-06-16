format:
	swift format \
		--ignore-unparsable-files \
		--in-place \
		--recursive \
		./Sources ./Tests ./App Package.swift \
		--configuration swift-format.json

test-all: test-latest test-13 test-10

test-xcode-13.3:
	@xcodebuild test \
			-project App/videocall.xcodeproj \
			-scheme videocall \
			-destination platform="iOS Simulator,name=iPhone 13 Pro"

test-xcode-12.4:
	@xcodebuild test \
			-project App/videocall.xcodeproj \
			-scheme videocall \
			-destination platform="iOS Simulator,name=iPhone 11 Pro,OS=13.3"

test-xcode-11.4.1:
	@xcodebuild test \
			-project App/videocall.xcodeproj \
			-scheme videocall \
			-destination platform="iOS Simulator,name=iPhone 8,OS=13.4"
