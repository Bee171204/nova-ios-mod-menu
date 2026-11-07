# NOVA iOS integration notes

NOVA is a **native SwiftUI overlay interface component** that you can integrate in your **own** iOS application's source. This repository does **not** contain a modified IPA, jailbreak tweak, dynamic library injector, anti-cheat bypass or game memory hooks.

## Native build on macOS

Requirements: macOS, a supported version of Xcode, iOS 16+, and optionally [XcodeGen](https://github.com/yonaskolb/XcodeGen).

```sh
cd ios
xcodegen generate
open NOVADemo.xcodeproj
```

Use the `NOVADemo` target with an iPhone simulator. Swift compilation and simulator tests have **not** been run in the Windows/Linux working environment where this project was authored. The Xcode project file is generated from `ios/project.yml` on Mac.

## In your own SwiftUI application

Copy `ios/NOVAOverlay/NOVAOverlay.swift` into your app target and mount the view above your owned game/app UI:

```swift
ZStack {
    YourAppRootView()
    NOVAOverlayView()
}
```

NOVA provides a draggable menu, floating restore launcher, categories, profile switching and interface state saved through `UserDefaults`. The menu labels are **demonstration-only**. Calling `NOVAStore.set()` changes local UI state, not game logic.

The full-screen overlay wrapper has not been evaluated for touch passthrough in third-party/UIKit apps; adapt hit testing and panel bounds to your own hierarchy and test on device. For an existing binary-only IPA, integration is not provided: you need the original application's source or an authorized extension point, appropriate signing and on-device testing.

## Security and scope

- Do not place login credentials, UDIDs, authorization tokens, user secrets or real game accounts in this repository.
- No `dlopen`, `MSHookFunction`, fishhook, jailbreak or anti-ban/anti-detection logic is used.
- Use publisher-authorized modding interfaces where available. A custom UI alone cannot alter behavior in an external game.
- Imported web JSON profiles are schema-validated and limited in size; native preferences use local `UserDefaults` and do not persist sensitive content.
