#!/bin/sh



####### Prepare

# 1
# Set bash script to exit immediately if any commands fail.
set -e

# The root folder of this repository.
ROOT_FOLDER=$(pwd)

# The folder to store build output.
BUILD_FOLDER=$(pwd)/build

# The UIKit project folder.
UIKIT_PROJECT_FOLDER=$(pwd)/UpstraUIKit

# The folder to save amity-uikit.zip.
RELEASE_FOLDER=$(pwd)/build/release

# 2
# If remnants from a previous build exist, delete them.
if [ -d "${BUILD_FOLDER}" ]; then
rm -rf "${BUILD_FOLDER}"
fi
mkdir -p ${BUILD_FOLDER}



####### Make AmityUIKit.xcframework

# 1. build the framework for device and for simulator (using all needed architectures).
cd ${UIKIT_PROJECT_FOLDER}
xcodebuild clean archive \
    -workspace UpstraUIKit.xcworkspace \
    -scheme AmityUIKit \
    -configuration Release \
    -arch arm64 \
    -sdk "iphoneos" \
    -archivePath "${BUILD_FOLDER}/uikit/ios.xcarchive" \
    SKIP_INSTALL=NO
xcodebuild clean archive \
    -workspace UpstraUIKit.xcworkspace \
    -scheme AmityUIKit \
    -configuration Release \
    -arch x86_64 \
    -sdk "iphonesimulator" \
    -archivePath "${BUILD_FOLDER}/uikit/ios_sim.xcarchive" \
    SKIP_INSTALL=NO
cd ${ROOT_FOLDER}

# 2 combine all archive and create .xcframework

# 2.1 Make xcframework.
xcodebuild -create-xcframework \
    -framework "${BUILD_FOLDER}/uikit/ios.xcarchive/Products/Library/Frameworks/AmityUIKit.framework" \
    -debug-symbols "${BUILD_FOLDER}/uikit/ios.xcarchive/dSYMs/AmityUIKit.framework.dSYM" \
    -framework "${BUILD_FOLDER}/uikit/ios_sim.xcarchive/Products/Library/Frameworks/AmityUIKit.framework" \
    -output "${BUILD_FOLDER}/AmityUIKit.xcframework"

####### Make AmityUIKitLiveStream.xcframework

# 1. build the framework for device and for simulator (using all needed architectures).
cd ${UIKIT_PROJECT_FOLDER}
xcodebuild clean archive \
    -workspace UpstraUIKit.xcworkspace \
    -scheme AmityUIKitLiveStream \
    -configuration Release \
    -arch arm64 \
    -sdk "iphoneos" \
    -archivePath "${BUILD_FOLDER}/uikit-livestream/ios.xcarchive" \
    SKIP_INSTALL=NO
xcodebuild clean archive \
    -workspace UpstraUIKit.xcworkspace \
    -scheme AmityUIKitLiveStream \
    -configuration Release \
    -arch x86_64 \
    -sdk "iphonesimulator" \
    -archivePath "${BUILD_FOLDER}/uikit-livestream/ios_sim.xcarchive" \
    SKIP_INSTALL=NO
cd ${ROOT_FOLDER}

# 2 combine all archive and create .xcframework

# 2.1 Make xcframework.
xcodebuild -create-xcframework \
    -framework "${BUILD_FOLDER}/uikit-livestream/ios.xcarchive/Products/Library/Frameworks/AmityUIKitLiveStream.framework" \
    -debug-symbols "${BUILD_FOLDER}/uikit-livestream/ios.xcarchive/dSYMs/AmityUIKitLiveStream.framework.dSYM" \
    -framework "${BUILD_FOLDER}/uikit-livestream/ios_sim.xcarchive/Products/Library/Frameworks/AmityUIKitLiveStream.framework" \
    -output "${BUILD_FOLDER}/AmityUIKitLiveStream.xcframework"

####### Make amity-uikit.zip

mkdir -p "${RELEASE_FOLDER}"

# Copy AmityUIKit.xcframework into release
mv "${BUILD_FOLDER}/AmityUIKit.xcframework" "${RELEASE_FOLDER}"

mv "${BUILD_FOLDER}/AmityUIKitLiveStream.xcframework" "${RELEASE_FOLDER}"

# Copy AmitySDK.xcframework into release
cp -r "${UIKIT_PROJECT_FOLDER}/Shared/AmitySDK.xcframework" "${RELEASE_FOLDER}"

# Copy Realm.xcframework into release
cp -r "${UIKIT_PROJECT_FOLDER}/Shared/Realm.xcframework" "${RELEASE_FOLDER}"

# Copy AmityVideoPlayerKit.xcframework into release
cp -r "${UIKIT_PROJECT_FOLDER}/Shared/AmityVideoPlayerKit.xcframework" "${RELEASE_FOLDER}"

# Copy AmityLiveVideoBroadcastKit.xcframework into release
cp -r "${UIKIT_PROJECT_FOLDER}/Shared/AmityLiveVideoBroadcastKit.xcframework" "${RELEASE_FOLDER}"

cd ${RELEASE_FOLDER}
zip -r ${ROOT_FOLDER}/amity-uikit.zip .
cd -

echo "Finish the build, the output is at ${ROOT_FOLDER}/amityuikit.zip"
