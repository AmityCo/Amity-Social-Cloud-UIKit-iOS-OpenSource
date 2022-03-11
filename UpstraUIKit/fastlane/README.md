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

### ios update_build_number

```sh
[bundle exec] fastlane ios update_build_number
```

Update build number for EkoChat project and sample app

### ios build_framework

```sh
[bundle exec] fastlane ios build_framework
```

Builds (but not releases) the EkoChat framework

### ios test_framework

```sh
[bundle exec] fastlane ios test_framework
```

Runs the framework tests

### ios devcenter

```sh
[bundle exec] fastlane ios devcenter
```

Initializes app on apple developer center

### ios build_sample_app

```sh
[bundle exec] fastlane ios build_sample_app
```

Builds Enterprise Sample App and ensure all the cert and provisioning are available

### ios release_sample_app

```sh
[bundle exec] fastlane ios release_sample_app
```



### ios notify_bot

```sh
[bundle exec] fastlane ios notify_bot
```



### ios clean

```sh
[bundle exec] fastlane ios clean
```

force cleans repo -- warning: this will remove all local changes so be careful with it!

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
