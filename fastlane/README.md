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

### ios custom_build_for_testing

```sh
[bundle exec] fastlane ios custom_build_for_testing
```

Сборка приложения без тестирования.

### ios custom_run_ui_tests

```sh
[bundle exec] fastlane ios custom_run_ui_tests
```

Запуск UI тестов уже собранного приложения.

### ios custom_run_unit_tests

```sh
[bundle exec] fastlane ios custom_run_unit_tests
```

Запуск Unit тестов уже собранного приложения.

### ios custom_run_tests

```sh
[bundle exec] fastlane ios custom_run_tests
```

Запуск UI и Unit.

### ios custom_build_and_test

```sh
[bundle exec] fastlane ios custom_build_and_test
```

Последовательный запуск сборки и тестирования.

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
