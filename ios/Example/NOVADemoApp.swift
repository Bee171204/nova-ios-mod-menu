import SwiftUI

// Standalone host app for previews on a Mac with Xcode.
// Copy NOVAOverlay.swift into this app target first.
@main
struct NOVADemoApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                LinearGradient(colors: [Color(red: 8/255,green: 15/255,blue: 20/255),
                                        Color(red: 18/255,green: 33/255,blue: 39/255)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                VStack(spacing: 12) {
                    Image(systemName: "gamecontroller.fill")
                        .font(.system(size: 46)).foregroundStyle(.mint.opacity(0.45))
                    Text("YOUR GAME VIEW")
                        .font(.system(size: 12,weight:.bold,design:.monospaced))
                        .tracking(3).foregroundStyle(.white.opacity(0.35))
                    Text("NOVA overlays this host preview.")
                        .foregroundStyle(.white.opacity(0.35)).font(.caption)
                }
                NOVAOverlayView()
            }
        }
    }
}
