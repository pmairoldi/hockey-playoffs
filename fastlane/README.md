fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios setup

```sh
[bundle exec] fastlane ios setup
```

Sets up project

### ios test

```sh
[bundle exec] fastlane ios test
```

Runs all the tests

### ios coverage

```sh
[bundle exec] fastlane ios coverage
```

Runs all the tests and generates a coverage report

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Submit a new Beta Build to Apple TestFlight

### ios deploy

```sh
[bundle exec] fastlane ios deploy
```

Deploy a new version to the App Store

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
