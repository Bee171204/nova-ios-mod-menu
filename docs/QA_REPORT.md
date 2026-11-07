# NOVA — Quality assurance report

Date: 2026-11-08 (Asia/Ho_Chi_Minh)

## Unit test results

- `node --test tests/*.test.mjs`: **7/7 passed**.
- Unique control/category IDs, valid category references, quantized/clamped sliders, sanitized import data, accurate active counts, valid presets, at least 25 controls.

## Browser interaction verification

Ran the browser UI in headless Chromium with its source HTML/CSS/JavaScript loaded from local files (local navigation to arbitrary URLs is restricted in the authoring runtime):

- Desktop viewport 1440×1080; browser page renders without runtime JavaScript errors.
- Overview, Combat, Visuals, Profiles, Appearance and Settings can be opened.
- Combat toggle updates checked state; Visuals category shows six toggles.
- Cinematic profile can be applied; alternate color theme is reflected in controls.
- Master switch disables demo feature toggles; Restore defaults re-enables them.
- Search modal returns matching features and closes on Escape.
- Insert shortcut toggles minimized launcher and full panel.
- Mobile viewport 390×844 renders compact icon navigation; Visuals opens and skeleton toggle works.
- Document horizontal overflow at 390px and 1440px: **0 pixels**.
- Screenshots exported at `assets/screenshots/{desktop,features,mobile}.png`.

## Native code validation

- `swiftc -frontend -parse ios/NOVAOverlay/NOVAOverlay.swift ios/Example/NOVADemoApp.swift`: **syntax parse passed**.
- iOS compile, linking, simulator behavior and touch passthrough: **not verified** (requires macOS/Xcode).

## Not included

- Actual game modifications or cheats, game account login, IPA binary patching/injection, anti-cheat bypass, backend/payment/network services.
- A production-signed IPA.
