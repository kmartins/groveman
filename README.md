# Groveman

[![License: MIT][license_badge]][license_link]
[![codecov][codecov_badge]][codecov_link]

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[codecov_badge]: https://codecov.io/gh/kmartins/groveman/branch/main/graph/badge.svg?token=9OHL7Q2V5A
[codecov_link]: https://codecov.io/gh/kmartins/groveman

Logging for **Dart/Flutter** applications.

It's very similar to Android logging library called [Timber](https://github.com/JakeWharton/timber) and also with the package for Dart/Flutter called [Fimber](https://github.com/magillus/flutter-fimber) that implements the same concept of the tree and planting logging tree.

Behavior is added through `Tree` instances. You can install an instance by calling Groveman.plantTree. Installation of Trees should be done as early as possible, e.g, in the function `main`.

There are no Tree implementations installed by default because, second `Timber`, every time you log in production, a puppy dies.

Start with the base package [groveman](https://pub.dev/packages/groveman).

## Trees officially supported

- debug_tree (included in the `groveman` package)
- [groveman_crashlytics](https://pub.dev/packages/groveman_crashlytics)

You can create your, just extend the `Tree` class. 
Take a look at the `DebugTree` code to know more.

## 📝 Maintainers

[Kauê Martins](https://github.com/kmartins)

## 🤝 Support

You liked this package? Then give it a ⭐️. If you want to help then:

- Fork this repository
- Send a Pull Request with new features
- Share this package
- Create issues if you find a bug or want to suggest a new extension

**Pull Request title follows [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/). </br>**
The scope available are:
- `groveman`
- `groveman_crashlytics`

## 📝 License

Copyright © 2022 [Kauê Martins](https://github.com/kmartins).<br />
This project is [MIT](https://opensource.org/licenses/MIT) licensed.