#!/bin/sh

#  BuildFramework.sh
#  FrameworkTest
#
#  Created by Ben Gottlieb on 11/14/15.
#  Copyright (c) 2015 Stand Alone, Inc. All rights reserved.

BASE_BUILD_DIR="Build"		#${BUILD_DIR}
FRAMEWORK_NAME="HelpKit"
PROJECT_NAME="HelpKit"
IOS_SUFFIX=""
CONFIG="Release"
UNIVERSAL_OUTPUTFOLDER="Build/${CONFIG}-universal"

GIT_BRANCH=`git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1/"`
GIT_REV=`git rev-parse --short HEAD`

BUILD_DATE=`date`
PROJECT_DIRECTORY=`pwd`

IOS_PLIST_PATH="${PROJECT_DIRECTORY}/HelpKit/iOS/info.plist"
echo $IOS_PLIST_PATH
/usr/libexec/PlistBuddy "${IOS_PLIST_PATH}" -c "Add :branch string ${GIT_BRANCH}"
/usr/libexec/PlistBuddy "${IOS_PLIST_PATH}" -c "Add :rev string ${GIT_REV}"
/usr/libexec/PlistBuddy "${IOS_PLIST_PATH}" -c "Add :built string ${BUILD_DATE}"

# make sure the output directory exists
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"

# Step 1. Build Device and Simulator versions
xcodebuild -target "${PROJECT_NAME}" -configuration ${CONFIG} -sdk iphoneos ONLY_ACTIVE_ARCH=NO  BUILD_DIR="${BASE_BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build
xcodebuild -target "${PROJECT_NAME}" -configuration ${CONFIG} -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO BUILD_DIR="${BASE_BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build

# Step 2. Copy the framework structure (from iphoneos build) to the universal folder
echo "copying device framework"
cp -R "${BASE_BUILD_DIR}/${CONFIG}-iphoneos/${FRAMEWORK_NAME}${IOS_SUFFIX}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"

# Step 3. Copy Swift modules (from iphonesimulator build) to the copied framework directory
echo "integrating sim framework"
cp -R "${BASE_BUILD_DIR}/${CONFIG}-iphonesimulator/${FRAMEWORK_NAME}${IOS_SUFFIX}.framework/Modules/${FRAMEWORK_NAME}${IOS_SUFFIX}.swiftmodule/" "${UNIVERSAL_OUTPUTFOLDER}/${FRAMEWORK_NAME}${IOS_SUFFIX}.framework/Modules/${FRAMEWORK_NAME}${IOS_SUFFIX}.swiftmodule/"

# Step 4. Create universal binary file using lipo and place the combined executable in the copied framework directory
echo "lipo'ing files"
lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${FRAMEWORK_NAME}${IOS_SUFFIX}.framework/${FRAMEWORK_NAME}${IOS_SUFFIX}" "${BASE_BUILD_DIR}/${CONFIG}-iphonesimulator/${FRAMEWORK_NAME}${IOS_SUFFIX}.framework/${FRAMEWORK_NAME}${IOS_SUFFIX}" "${BASE_BUILD_DIR}/${CONFIG}-iphoneos/${FRAMEWORK_NAME}${IOS_SUFFIX}.framework/${FRAMEWORK_NAME}${IOS_SUFFIX}"

/usr/libexec/PlistBuddy "${IOS_PLIST_PATH}" -c "Delete :branch"
/usr/libexec/PlistBuddy "${IOS_PLIST_PATH}" -c "Delete :rev"
/usr/libexec/PlistBuddy "${IOS_PLIST_PATH}" -c "Delete :built"

# Step 5. Convenience step to copy the framework to the project's directory
mkdir -p "${PROJECT_DIRECTORY}/iOS Framework/"
rm -rf "${PROJECT_DIRECTORY}/iOS Framework/${FRAMEWORK_NAME}.framework"
cp -R "${UNIVERSAL_OUTPUTFOLDER}/${FRAMEWORK_NAME}.framework" "${PROJECT_DIRECTORY}/iOS Framework"
