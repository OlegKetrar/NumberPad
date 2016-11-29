# NumberPad
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
