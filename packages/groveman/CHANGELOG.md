## 1.2.1

 - **REFACTOR**: update all gitignore (#36).
 - **REFACTOR**: update all gitignore (#34).
 - **FIX**: error ci and lint errors (#41).

## 1.2.0

 - **REFACTOR**: remove unused package - stacktrace (#28).
 - **REFACTOR**: remove utils of the export (#25).
 - **REFACTOR**: rename json to extra (#24).
 - **REFACTOR**: return null if not get a file and number in stack trace (#18).
 - **FIX**: change name in pubspec of all examples (#21).
 - **FEAT**: add web compatibility (#17).
 - **DOCS**: add coverage flag badge (#27).
 - **DOCS**: update README.md with others trees (#23).

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