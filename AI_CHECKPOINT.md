# AI_CHECKPOINT — NOVA iOS Overlay

- PROJECT: NOVA iOS Game Overlay UI
- GOAL: Public GitHub project with polished game-style control panel, functional demonstration, native SwiftUI reference and real screenshots.
- ROOT_PATH: `/mnt/data/nova-ios-mod-menu` (generated source); Windows working copy may be elsewhere if downloaded.
- REPO: https://github.com/Bee171204/nova-ios-mod-menu
- ENVIRONMENT: Node.js 22, headless Chromium, Python Playwright, Swift parser; iOS build requires macOS+Xcode.
- DESIGN: Original graphical NOVA design; Space Grotesk + DM Sans; mint accent; graphite panels; 8 categories; 25 configurable demo functions.
- FILES: index.html, src/*, ios/*, assets/screenshots/*, docs/*, tests/*, README.md, PROMPT.md, .github/workflows/pages.yml.
- TESTS: Windows Node v24.21.0; npm install PASS, npm test 7/7 PASS; npm run build PASS (Vite 6.4.5). Chromium UI/mobile demo previously exercised; Swift source syntax parse success. iOS native build not run.
- LIMITS: UI-only; no game-process modifications, hooking, IPA build, real in-game mod functionality.
- DEPLOYMENT: Repository published with 3 real screenshots and package-lock.json. GitHub Pages Settings > Build and deployment > Source = GitHub Actions enabled. Verify latest workflow and live site.
- NEXT_EXACT_STEP: Check latest GitHub Pages workflow and live site; test SwiftUI on Mac/iPhone for native release.
- ROLLBACK: Public Git history; ZIP artifact stored in chat. Do not modify or delete other user projects.
- TIMESTAMP: 2026-11-08 Asia/Ho_Chi_Minh.
