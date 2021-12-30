## 1.1.0

 - **FEAT**: remove the default tag and sets only in the DebugTree (#12).
 - **DOCS**: fix image to the pub.dev (#13).

## 1.0.2

 - **FIX**: export Log Level and Log Record (#5).

## 1.0.1

 - **FIX**: use dynamic in json instead of object (#3).
 - **BUILD**: update packages (#2).
 - **DOCS**: update README.md (#1).

# 1.0.0

Initial Version of the library.

- Includes the ability to plant a custom Tree by extending `Tree` class.
- Includes five log types, **fatal, error, warning, info and debug**.
- Captures error in current isolation and in a zone and send to log.
- Includes the `DebugTree` with tag, message, json, error, `StackTrace`, and with the possibility of colorized the output.