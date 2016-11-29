# NumberPad

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Features
- [x] optional buttons (plus, dot, hide)
- [ ] long press support for delete key  
- [ ] system slyles (light, dark) + vibrancy
- [ ] custom styles
- [ ] customize action key
- [ ] improve InputControlller (ask delegate aboult shouldChangeCharactersInRange)
- [ ] appearance from UIInputTraits.keyboardAppearance

## Usage

### Standart InputController

```swift
let textField = UITextField(frame: CGRect.zero)
...
textField.inputView = NumberPad(buttons: [.plus, .hide])
                        .configure(with: textField)
                        .withInputController()
```

### Custom InputController

```swift
let pad = NumberPad(buttons: [.hide])
            .configure(with: textField)
            .onTextInput { (symbol) in
                // proccess symbol input
            }.onReturn {
                // proccess action button
            }.onDismiss {
                // proccess hide button
            }.onBackspace {
                // proccess backspace button
            }

```
## Requirements

- Swift 3.0+
- xCode 8.0+
- iOS 8.0+

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```
To integrate NumberPad into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "OlegKetrar/NumberPad"
```
Run `carthage update` to build the framework and drag the built `NumberPad.framework` into your Xcode project.
