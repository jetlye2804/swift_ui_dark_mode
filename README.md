# iOS Dark Mode in SwiftUI
Dark Mode pet project using SwiftUI

## Introduction
This project is inspired by this repository (Switch To The Dark Side in SwiftUI)[https://github.com/multitudes/SwitchToTheDarkSide] but with following changes:
* Use `@AppStorage` instead of making an extension for `UserDefaults` **(Not work with Observable macros, see [Migration of codes](#migration-of-codes))**
* Use App Protocol (introduced in iOS 14+) to replace `AppDelegate` and `SceneDelegate`
* Use a `Observable` macros to manage the app appearance **(Previously was `ObservableObject`)**

## Language and framework
It's purely Swift, and using SwiftUI.

## External dependencies used
(ObservableUserDefault by David Steppenbeck)[https://github.com/davidsteppenbeck/ObservableUserDefault]

## Startup
Just clone the whole repository into your Mac. Use Xcode 15 and above. 

The minimum deployment version is iOS 17.0 and iPadOS 17.0.

## What this app can do?
1. Provides three type of settings in List (under a sheet) - Manual Light mode that makes the whole app in light appearance, Manual Dark mode that makes the whole app in dark appearance, and system-wide mode to follow the devices appearance.
2. Store user settings into `UserDefaults`, so that the chosen appearance will be stored even though the app is "killed"
3. Display the value from `UserDefaults`.
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

2. A class with `Observable` macros called `AppearanceManager` was set to handle the app appearance.

```swift
import SwiftUI
import ObservableUserDefault

@Observable class AppearanceManager {
    @ObservableUserDefault(.init(key: "userInterfaceStyle", store: .standard))
    @ObservationIgnored
    var userInterfaceStyle: Int?
    
    var selectedAppearance: Appearance = .system

    // Rest of the codes...
}
```
We set the key `userInterfaceStyle` into `UserDefaults`, therefore we just need read it's value directly based on this key. Possible value are `0`, `1`, `2`, and `nil`. `0` and `nil` performs the same appearance.

By default, the selected appearance is follow system settings.

Three functions are also defined in the `AppearanceManager`:
1. `initAppearanceStyle`

Read the value from `UserDefaults` and override the whole app appearance via `window.overrideUserInterfaceStyle`:
a. `.light` makes the whole app mandate to be light mode<br>
b. `.dark` makes the whole app mandate to be dark mode<br>
c. `.unspecified` makes the whole app follow the system settings

To override the whole application instead of single view, you are required to use `UIApplication` to render all connected scenes.

```swift
    func initAppearanceStyle() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
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
    }
```

2. `applyAppearanceStyle`

Store the latest value into `@AppStorage` and override the whole app appearance via `window.overrideUserInterfaceStyle`.

```swift
func applyAppearanceStyle(_ selectedAppearance: Appearance) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                switch selectedAppearance {
                    case .system:
                        userInterfaceStyle = 0
                        window.overrideUserInterfaceStyle = .unspecified
                    case .light:
                        userInterfaceStyle = 1
                        window.overrideUserInterfaceStyle = .light
                    case .dark:
                        userInterfaceStyle = 2
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

4. Create a `@State` for the appearance manager, and apply `environment` to the app with the created `@State`.

```swift
import SwiftUI

@main
struct SwiftUIDarkModeApp: App {
    @State var appearanceManager = AppearanceManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appearanceManager)
                .onAppear {
                    appearanceManager.initAppearanceStyle()
                }
            
        }
    }
}
```

5. In the view that using `AppearanceManager`, add the `@Environment` property wrapper at the beginning.

```swift
struct ContentView: View {
    @State private var showingSheet = false
    @Environment(AppearanceManager.self) var appearanceManager: AppearanceManager

	// Rest of the codes...

}

```

## Migration of codes

### Override appearance via UIApplication
> **Note:**
> This migration requires iOS 15.0 and iPadOS 15.0 and later.

In iOS 13 and iOS 14, you may use the below code to apply appearance for the whole app:

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

### Observable macro
> **Note:**
> This migration requires iOS 17.0 and iPadOS 17.0 and later.

iOS 17.0 and iPadOS 17.0 introduced a new macro named `Observable` to replace the current `ObservableObject` protocol. 

According to Apple[https://developer.apple.com/documentation/Observation]:

> Observation provides a robust, type-safe, and performant implementation of the observer design pattern in Swift. This pattern allows an observable object to maintain a list of observers and notify them of specific or general state changes. This has the advantages of not directly coupling objects together and allowing implicit distribution of updates across potential multiple observers.

#### ObservableObject protocol and Published property wrapper
Prior to iOS 16, the `AppearanceManager` was using `ObservableObject` protocol:
```swift
class AppearanceManager: ObservableObject {
    @AppStorage("userInterfaceStyle") var userInterfaceStyle: Int?
    @Published var selectedAppearance: Appearance = .system
}
```

`Observable` macro not only eliminates the using of `@ObservableObject` protocol, it also removes `@Published` property, 

> Observation doesn’t require a property wrapper to make a property observable. Instead, the accessibility of the property in relationship to an observer, such as a view, determines whether a property is observable.

Thus, the code will become like this:

```swift
@Observable class AppearanceManager {
    @AppStorage("userInterfaceStyle") var userInterfaceStyle: Int?
    var selectedAppearance: Appearance = .system
}
```

But there's an error in the above code. Under the line of `@AppStorage`, it will show this error:
> Property wrapper cannot be applied to a computed property

This is because the property get rewritten as computed property. Of course you can use `@ObservationIgnored`,

There are two possible ways to solve it:
1. Use `@ObservationIgnored` on top of the `@AppStorage` property wrapper
```swift
@ObservationIgnored
@AppStorage("userInterfaceStyle") var userInterfaceStyle: Int?
```

But this creates another issue: `userInterfaceStyle` value has indeed been stored/updated into `UserDefaults`, but the value won't directly reflects in the following code in `ContentView`, unless you restart the app.

```swift
Text(appearanceManager.userInterfaceStyle != nil ? String(appearanceManager.userInterfaceStyle!) : "N/A")
```

2. Directly use `UserDefaults`
Thanks to the `ObservableUserDefault` dependency, we can use the `@ObservableUserDefault` macro in `@Observable` classes to read and write the properties in UserDefaults.

```swift
@Observable class AppearanceManager {
    @ObservableUserDefault(.init(key: "userInterfaceStyle", store: .standard))
    @ObservationIgnored
    var userInterfaceStyle: Int?

    var selectedAppearance: Appearance = .system
}
   
```

#### EnvironmentObject and StateObject property wrapper
Replace `@EnvironmentObject` to `@Environment` property wrapper
```swift
// Before changes
struct AppearanceSelectionPicker: View {
    @EnvironmentObject var appearanceManager: AppearanceManager
}

// After changes
struct AppearanceSelectionPicker: View {
    @Environment(AppearanceManager.self) var appearanceManager: AppearanceManager
}
```

Replace `@StateObject` to `@State` property wrapper, and `.environmentObject` to `.environment`
```swift
// Before changes
@StateObject var appearanceManager = AppearanceManager()

.environmentObject(appearanceManager)



// After changes
@State var appearanceManager = AppearanceManager()

.environment(appearanceManager)
```

### Deprecated onChanged
> **Note:**
> This migration requires iOS 17.0 and iPadOS 17.0 and later.

If you were using the `onChanged` codes as below:
```swift
.onChange(of: appearanceManager.selectedAppearance, perform: { value in
    appearanceManager.applyAppearanceStyle(value)
})
```

It will show the below warning message:
> 'onChange(of:perform:)' was deprecated in iOS 17.0: Use `onChange` with a two or zero parameter action closure instead.

To resolve this warning, use the new `onChange` method:
```swift
.onChange(of: appearanceManager.selectedAppearance) {
    appearanceManager.applyAppearanceStyle(appearanceManager.selectedAppearance)
}
```
