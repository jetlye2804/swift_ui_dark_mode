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
TBD

## Language and framework
It's purely Swift, and using SwiftUI.

## Startup
Just clone the whole repository into your local computer. You are recommended to use Xcode 14 and above. 

Due to the using of `NavigationStack`, the minimum deployment version is iOS 16.0 and iPadOS 16.0. Otherwise, if you are using `NavigationView`, the minimum deployment version is iOS 15.0 and iPadOS 15.0.
