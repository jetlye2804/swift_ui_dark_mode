# iOS Dark Mode in SwiftUI
Dark Mode pet project using SwiftUI

## Introduction
This project is inspired by this repository (Switch To The Dark Side in SwiftUI)[https://github.com/multitudes/SwitchToTheDarkSide] but with following changes:
* Use `@AppStorage` instead of making an extension for `UserDefaults`
* Use App Protocol (introduced in iOS 14+) to replace `AppDelegate` and `SceneDelegate`
* Use a `ObservableObject` to manage the app appearance

## What this app can do?
1. Provides three type of settings in List (under a sheet) - Manual Light mode that makes the whole app in light appearance, Manual Dark mode that makes the whole app in dark appearance, and system-wide mode to follow the devices appearance.
2. Store user settings via `@AppStorage`, so that the chosen appearance will be stored even though the app is "killed"
3. Display the value from `@AppStorage`.
4. Provides a navigation link and a sheet to check whether the chosen appeanrance affects the app properly or not.

## How does it work?
1. A model was created for the appearance.
```swift
enum Appearance: LocalizedStringKey, CaseIterable, Identifiable {
    case light
    case dark
    case system

    var id: String { UUID().uuidString }
}

```

2. A `ObservableObject` class called `AppearanceManager` was set to handle the app appearance.

```swift
import SwiftUI

class AppearanceManager: ObservableObject {
    @AppStorage("userInterfaceStyle") var userInterfaceStyle: Int?
    
    @Published var selectedAppearance: Appearance = .system

    // Rest of the codes...
}
```

Since `@AppStorage` is built on top of `UserDefaults`, therefore we just need to find the key `userInterfaceStyle` and read it's value. Possible value are `0`, `1`, `2`, and `nil`. `0` and `nil` performs the similar appearance.

Property wrapper `@Published` has been used to trigger view updates when the value of selected appearance has been changed. By default, the selected appearance is follow system settings.

Three functions are also defined in the `AppearanceManager`:
1. `initAppearanceStyle`

Read the value from `@AppStorage` and override the whole app appearance via `window.overrideUserInterfaceStyle`.

```swift
func initAppearanceStyle() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        
        windowScene?.windows.forEach { window in
            switch userInterfaceStyle {
                case 0:
                    window.overrideUserInterfaceStyle = .unspecified
                case 1:
                    window.overrideUserInterfaceStyle = .light
                case 2:
                    window.overrideUserInterfaceStyle = .dark
                default:
                    window.overrideUserInterfaceStyle = .unspecified
            }
        }
    }
```

2. `applyAppearanceStyle`

Store the latest value into `@AppStorage` and override the whole app appearance via `window.overrideUserInterfaceStyle`.

```swift
func applyAppearanceStyle(_ selectedAppearance: Appearance) {
        switch selectedAppearance {
            case .system:
                userInterfaceStyle = 0
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    windowScene.windows.forEach { window in
                        window.overrideUserInterfaceStyle = .unspecified
                    }
                }
            case .light:
                userInterfaceStyle = 1
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    windowScene.windows.forEach { window in
                        window.overrideUserInterfaceStyle = .light
                    }
                }
            case .dark:
                userInterfaceStyle = 2
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    windowScene.windows.forEach { window in
                        window.overrideUserInterfaceStyle = .dark
                    }
                }
        }
    }
```

3. `setInitialSelectedAppearance`

Based on the `@AppStorage` to load the respective selected value for selection view.

```swift
func setInitialSelectedAppearance() {
        switch userInterfaceStyle {
            case 0:
                selectedAppearance = .system
            case 1:
                selectedAppearance = .light
            case 2:
                selectedAppearance = .dark
            default:
                selectedAppearance = .system
        }
    }
```

Using `overrideUserInterfaceStyle` to override the appearance:<br>
a. `.light` makes the whole app mandate to be light mode<br>
b. `.dark` makes the whole app mandate to be dark mode<br>
c. `.unspecified` makes the whole app follow the system settings

To override the whole application instead of single view, you are required to use `UIApplication` to render all connected scenes.

```swift
UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified; // or .dark or .light
```

However, the code above has been deprecated since iOS 15.0 and iPadOS 15.0. If your minimum deployment target is iOS 15.0 and iPadOS 15.0, to prevent deprecation message, you may change to the following code:

```swift
// Method 1
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        
        windowScene?.windows.forEach { window in
            switch userInterfaceStyle {
                case 0:
                    window.overrideUserInterfaceStyle = .unspecified
                case 1:
                    window.overrideUserInterfaceStyle = .light
                case 2:
                    window.overrideUserInterfaceStyle = .dark
                default:
                    window.overrideUserInterfaceStyle = .unspecified
            }
        }

// Method 2
        var appliedStyle: UIUserInterfaceStyle = .unspecified;
        
        switch userInterfaceStyle {
            case 0:
                appliedStyle = .unspecified
            case 1:
                appliedStyle = .light
            case 2:
                appliedStyle = .dark
            default:
                appliedStyle = .unspecified
        }
        
        
        UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first{ $0.isKeyWindow }?.window?.overrideUserInterfaceStyle = appliedStyle
```

4. Create a `@StateObject` for the appearance manager, and apply `environmentObject` to the parent view with the created `@StateObject`.

```swift
@StateObject var appearanceManager = AppearanceManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appearanceManager)
        }
    }
```

## Language and framework
It's purely Swift, and using SwiftUI.

## Startup
Just clone the whole repository into your local computer. You are recommended to use Xcode 14 and above. 

Due to the using of `NavigationStack`, the minimum deployment version is iOS 16.0 and iPadOS 16.0. Otherwise, if you are using `NavigationView`, the minimum deployment version is iOS 15.0 and iPadOS 15.0.
