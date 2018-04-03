#!/bin/bash

# This script automatically sets the version and short version string of
# an Xcode project from the Git repository containing the project.
#
# To use this script in Xcode, add the contents to a "Run Script" build
# phase for your application target.

# NOTE: make sure you add a new value to your Info plist called "FullVersion"
#
# NOTE: if you receive error saying 'fatal: Not a git responsitory', make sure |--git-dir| points
# to the root dir of your repo
#
# NOTE: if your git repo has no tags, this would fail, so make sure you create at least one tag
# (I usually create a tag '0.0.0' at the very first commit, you can do the same).

set -o errexit
set -o nounset

INFO_PLIST="${INFOPLIST_FILE}"

echo "$INFO_PLIST"

# Get git tag and hash in the FullVersion
FULL_VERSION=$(git --git-dir="${PROJECT_DIR}/.git" --work-tree="${PROJECT_DIR}/" describe --dirty | sed -e 's/^v//' -e 's/g//')

# Use the latest tag for short version (You'll have to make sure that all your tags are of the format 0.0.0,
# this is to satisfy Apple's rule that short version be three integers separated by dots)
# using git tag for version also encourages you to create tags that match your releases
SHORT_VERSION=$(git --git-dir="${PROJECT_DIR}/.git" --work-tree="${PROJECT_DIR}/" describe --abbrev=0 --tags | sed -e 's/^v//' -e 's/g//')

# I'd like to use the Git commit hash for CFBundleVersion.
# VERSION=$(git --git-dir="${PROJECT_DIR}/.git" --work-tree="${PROJECT_DIR}" rev-parse --short HEAD)

# But Apple wants this value to be a monotonically increasing integer, so
# instead use the number of commits on the master branch. If you like to
# play fast and loose with your Git history, this may cause you problems.
# Thanks to @amrox for pointing out the issue and fix.
VERSION=$(git --git-dir="${PROJECT_DIR}/.git" --work-tree="${PROJECT_DIR}/" rev-list master | wc -l)

/usr/libexec/PlistBuddy -c "Set CFBundleShortVersionString $SHORT_VERSION" $INFO_PLIST
/usr/libexec/PlistBuddy -c "Set CFBundleVersion $VERSION" $INFO_PLIST
/usr/libexec/PlistBuddy -c "Set FullVersion $FULL_VERSION" $INFO_PLIST

echo "VERSION: ${VERSION}"
echo "SHORT VERSION: ${SHORT_VERSION}"
echo "FULL VERSION: ${FULL_VERSION}"