# hockey-playoffs

[![Build Status](https://travis-ci.org/petester42/hockey-playoffs.svg?branch=master)](https://travis-ci.org/petester42/hockey-playoffs)
[![Coverage Status](https://coveralls.io/repos/petester42/hockey-playoffs/badge.svg)](https://coveralls.io/r/petester42/hockey-playoffs)

iOS application that keeps track of the NHL playoffs

## Setup Project

```sh
bundle install
```

## Run tests

```sh
bundle exec fastlane test
```

## Regenerate screenshots

```sh
bundle exec fastlane snapshot
```

## Update App Store Metadata

```sh
# without regenerating screenshots
bundle exec fastlane marketing

# with regenerating screenshots
bundle exec fastlane marketing screenshots:true
```

## Publish a beta build

```sh
# without regenerating screenshots
bundle exec fastlane beta

# with regenerating screenshots
bundle exec fastlane beta screenshots:true
```

## Publish an AppStore build

```sh
# without regenerating screenshots
bundle exec fastlane deploy

# with regenerating screenshots
bundle exec fastlane deploy screenshots:true
```
