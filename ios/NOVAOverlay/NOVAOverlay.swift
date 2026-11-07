import SwiftUI

// NOVA is a source-level interface component for authorized apps.
// The control names below are presentation-only. No game memory access or modification occurs.

public enum NOVASection: String, CaseIterable, Identifiable {
    case overview = "Overview"
    case combat = "Combat"
    case visuals = "Visuals"
    case movement = "Movement"
    case automation = "Automation"
    case appearance = "Appearance"
    case profiles = "Profiles"
    case settings = "Settings"

    public var id: String { rawValue }
    var symbol: String {
        switch self {
        case .overview: return "square.grid.2x2"
        case .combat: return "scope"
        case .visuals: return "eye"
        case .movement: return "waveform.path.ecg"
        case .automation: return "cpu"
        case .appearance: return "slider.horizontal.3"
        case .profiles: return "square.3.layers.3d"
        case .settings: return "gearshape"
        }
    }
}

public struct NOVAFeature: Identifiable {
    public let id: String
    public let title: String
    public let detail: String
    public let symbol: String
    public let section: NOVASection

    public static let all: [NOVAFeature] = [
        .init(id: "assist", title: "Aim assistance", detail: "Target alignment concept", symbol: "scope", section: .combat),
        .init(id: "recoil", title: "Recoil compensation", detail: "Stabilization preset", symbol: "target", section: .combat),
        .init(id: "trigger", title: "Trigger response", detail: "Adaptive timing mockup", symbol: "bolt", section: .combat),
        .init(id: "targetPriority", title: "Target priority", detail: "Focus selection preference", symbol: "person.2", section: .combat),
        .init(id: "boxes", title: "Player bounding boxes", detail: "Preview outlines", symbol: "cube", section: .visuals),
        .init(id: "skeleton", title: "Skeleton rendering", detail: "Joint visualizer", symbol: "figure.stand", section: .visuals),
        .init(id: "tracers", title: "Direction tracers", detail: "Marker line effects", symbol: "point.topleft.down.to.point.bottomright.curvepath", section: .visuals),
        .init(id: "nametags", title: "Name and distance", detail: "Identity indicators", symbol: "tag", section: .visuals),
        .init(id: "radar", title: "Mini radar", detail: "Proximity display mockup", symbol: "dot.radiowaves.left.and.right", section: .visuals),
        .init(id: "chams", title: "Highlight layers", detail: "Silhouette color effects", symbol: "square.3.layers.3d", section: .visuals),
        .init(id: "sprint", title: "Sprint assist", detail: "Motion preference", symbol: "figure.run", section: .movement),
        .init(id: "strafe", title: "Adaptive strafe", detail: "Side-step demo", symbol: "arrow.left.and.right", section: .movement),
        .init(id: "jump", title: "Jump timing", detail: "Rhythm demonstration", symbol: "arrow.up", section: .movement),
        .init(id: "camera", title: "Free camera", detail: "Camera preview mode", symbol: "camera", section: .movement),
        .init(id: "loot", title: "Auto-loot queue", detail: "Pickup queue preview", symbol: "shippingbox", section: .automation),
        .init(id: "heal", title: "Smart healing", detail: "Threshold automation UI", symbol: "heart", section: .automation),
        .init(id: "swap", title: "Quick swap", detail: "Equipment workflow mockup", symbol: "arrow.triangle.2.circlepath", section: .automation),
        .init(id: "ping", title: "Auto ping", detail: "Team marker preview", symbol: "antenna.radiowaves.left.and.right", section: .automation)
    ]
}

@MainActor
public final class NOVAStore: ObservableObject {
    @Published public private(set) var enabled: [String: Bool]
    @Published public var masterEnabled: Bool { didSet { save() } }
    @Published public var accentIndex: Int { didSet { save() } }
    @Published public var intensity: Double { didSet { save() } }
    @Published public var fov: Double { didSet { save() } }
    @Published public var opacity: Double { didSet { save() } }
    @Published public private(set) var profile: String

    private let key = "nova.overlay.demo.v1"
    public init() {
        let defaults: [String: Bool] = [
            "assist": true, "recoil": true, "trigger": false, "targetPriority": true,
            "boxes": true, "skeleton": false, "tracers": true, "nametags": true,
            "radar": true, "chams": false, "sprint": true, "strafe": false,
            "jump": false, "camera": false, "loot": false, "heal": true,
            "swap": false, "ping": true
        ]
        let saved = UserDefaults.standard.dictionary(forKey: key) ?? [:]
        let storedEnabled = saved["enabled"] as? [String: Bool] ?? [:]
        enabled = defaults.merging(storedEnabled) { _, new in new }
        masterEnabled = saved["master"] as? Bool ?? true
        accentIndex = min(4, max(0, saved["accent"] as? Int ?? 0))
        intensity = saved["intensity"] as? Double ?? 72
        fov = saved["fov"] as? Double ?? 85
        opacity = saved["opacity"] as? Double ?? 0.96
        profile = saved["profile"] as? String ?? "Balanced"
    }
    public func isOn(_ id: String) -> Bool { enabled[id] == true }
    public var activeCount: Int { enabled.values.filter { $0 }.count }
    public func set(_ id: String, to value: Bool) {
        guard enabled[id] != nil else { return }
        enabled[id] = value
        profile = "Custom"
        save()
    }
    public func apply(_ name: String) {
        let overrides: [String: Bool]
        switch name {
        case "Cinematic": overrides = ["assist": false, "boxes": true, "skeleton": true, "chams": true, "radar": true]
        case "Performance": overrides = ["assist": false, "boxes": false, "skeleton": false, "tracers": false, "radar": false, "chams": false]
        case "Creator": overrides = ["assist": true, "boxes": true, "skeleton": true, "tracers": true, "radar": true, "chams": true]
        default: overrides = ["assist": true, "recoil": true, "boxes": true, "tracers": true, "radar": true]
        }
        for (id, value) in overrides { enabled[id] = value }
        profile = name
        save()
    }
    public func reset() {
        UserDefaults.standard.removeObject(forKey: key)
        enabled = ["assist": true, "recoil": true, "trigger": false, "targetPriority": true,
                   "boxes": true, "skeleton": false, "tracers": true, "nametags": true,
                   "radar": true, "chams": false, "sprint": true, "strafe": false,
                   "jump": false, "camera": false, "loot": false, "heal": true,
                   "swap": false, "ping": true]
        masterEnabled = true; accentIndex = 0; intensity = 72; fov = 85; opacity = 0.96
        profile = "Balanced"
        save()
    }
    private func save() {
        UserDefaults.standard.set(["enabled": enabled, "master": masterEnabled,
                                  "accent": accentIndex, "intensity": intensity,
                                  "fov": fov, "opacity": opacity, "profile": profile] as [String: Any], forKey: key)
    }
}

public struct NOVAOverlayView: View {
    @StateObject private var store = NOVAStore()
    @State private var expanded = true
    @State private var selection: NOVASection = .overview
    @State private var settledOffset: CGSize = .zero
    @GestureState private var dragOffset: CGSize = .zero
    @State private var searchText = ""
    @State private var showSearch = false

    private let bg = Color(red: 9 / 255, green: 15 / 255, blue: 20 / 255)
    private let surface = Color(red: 20 / 255, green: 28 / 255, blue: 34 / 255)
    private let muted = Color(red: 119 / 255, green: 146 / 255, blue: 148 / 255)
    private let white = Color(red: 239 / 255, green: 248 / 255, blue: 245 / 255)
    private var accent: Color {
        [Color(red: 167 / 255, green: 243 / 255, blue: 208 / 255),
         Color(red: 199 / 255, green: 185 / 255, blue: 1),
         Color(red: 1, green: 213 / 255, blue: 164 / 255),
         Color(red: 168 / 255, green: 233 / 255, blue: 1),
         Color(red: 1, green: 167 / 255, blue: 190 / 255)][store.accentIndex]
    }

    public init() {}

    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.clear.allowsHitTesting(false)
                if expanded {
                    window(proxy)
                        .frame(width: min(proxy.size.width - 16, 840),
                               height: min(proxy.size.height - 24, 600))
                        .background(bg.opacity(store.opacity))
                        .clipShape(RoundedRectangle(cornerRadius: 17))
                        .overlay(RoundedRectangle(cornerRadius: 17)
                            .stroke(accent.opacity(0.20), lineWidth: 1))
                        .shadow(color: .black.opacity(0.58), radius: 35, y: 18)
                        .offset(x: settledOffset.width + dragOffset.width,
                                y: settledOffset.height + dragOffset.height)
                        .transition(.scale(scale: 0.92).combined(with: .opacity))
                } else {
                    Button { withAnimation(.spring(response: 0.33)) { expanded = true } } label: {
                        HStack(spacing: 10) {
                            Text("N").font(.system(size: 20, weight: .black, design: .rounded))
                                .foregroundStyle(bg).frame(width: 31, height: 31).background(accent, in: Circle())
                            Text("OPEN NOVA").font(.system(size: 11, weight: .bold, design: .monospaced))
                                .tracking(1.5).foregroundStyle(accent)
                        }
                        .padding(9).background(bg, in: Capsule())
                        .overlay(Capsule().stroke(accent.opacity(0.4), lineWidth: 1))
                    }
                    .offset(x: settledOffset.width, y: settledOffset.height)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .preferredColorScheme(.dark)
    }

    @ViewBuilder private func window(_ geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "circle.grid.3x2.fill").font(.system(size: 11)).foregroundStyle(muted)
                Text("OVERLAY / \(selection.rawValue.uppercased())")
                    .font(.system(size: 9, weight: .bold, design: .monospaced)).tracking(1.2).foregroundStyle(muted)
                Spacer()
                HStack(spacing: 5) {
                    Circle().fill(accent).frame(width: 5, height: 5)
                    Text("SIMULATION").font(.system(size: 8, weight: .bold, design: .monospaced)).tracking(1)
                }.foregroundStyle(accent)
                .padding(.horizontal, 9).padding(.vertical, 6)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(accent.opacity(0.24)))
                Button { withAnimation(.spring(response: 0.3)) { expanded = false } } label: {
                    Image(systemName: "minus").font(.system(size: 13)).foregroundStyle(muted).frame(width: 28, height: 30)
                }.accessibilityLabel("Minimize NOVA")
            }
            .padding(.horizontal, 14).frame(height: 43)
            .contentShape(Rectangle())
            .gesture(DragGesture(minimumDistance: 4).updating($dragOffset) { value, state, _ in
                state = value.translation
            }.onEnded { value in
                settledOffset.width += value.translation.width
                settledOffset.height += value.translation.height
            })
            Rectangle().fill(.white.opacity(0.07)).frame(height: 1)
            HStack(spacing: 0) {
                sideRail(compact: geometry.size.width < 550)
                    .frame(width: geometry.size.width < 550 ? 61 : 175)
                Rectangle().fill(.white.opacity(0.07)).frame(width: 1)
                VStack(spacing: 0) {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("NOVA COMMAND SYSTEM").font(.system(size: 8, weight: .bold, design: .monospaced))
                                .tracking(2).foregroundStyle(accent)
                            Text(selection.rawValue + ".")
                                .font(.system(size: geometry.size.width < 550 ? 25 : 30, weight: .bold, design: .rounded))
                                .foregroundStyle(white)
                        }
                        Spacer()
                        Button { showSearch = true } label: {
                            Image(systemName: "magnifyingglass").foregroundStyle(muted)
                                .frame(width: 34, height: 34).background(surface, in: RoundedRectangle(cornerRadius: 8))
                        }.accessibilityLabel("Search modules")
                    }.padding(.horizontal, 18).frame(height: 92)
                    Rectangle().fill(.white.opacity(0.07)).frame(height: 1)
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 17) { content }
                            .padding(18).frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Rectangle().fill(.white.opacity(0.07)).frame(height: 1)
                    HStack {
                        Text("◈ NOVA SYSTEMS")
                        Spacer()
                        Text("UI DEMO · NO GAME ACCESS")
                    }.font(.system(size: 8, weight: .bold, design: .monospaced))
                        .foregroundStyle(muted).padding(.horizontal, 13).frame(height: 32)
                }
            }
        }
        .sheet(isPresented: $showSearch) {
            NavigationStack {
                List {
                    ForEach(NOVAFeature.all.filter { searchText.isEmpty || $0.title.localizedCaseInsensitiveContains(searchText) }) { feature in
                        Button { selection = feature.section; showSearch = false } label: {
                            Label(feature.title, systemImage: feature.symbol)
                        }
                    }
                }
                .navigationTitle("Find a module")
                .searchable(text: $searchText)
                .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { showSearch = false } } }
            }.presentationDetents([.medium, .large])
        }
    }

    private func sideRail(compact: Bool) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 9) {
                Text("N").font(.system(size: 23, weight: .black, design: .rounded))
                    .foregroundStyle(bg).frame(width: 38, height: 38)
                    .background(accent, in: RoundedRectangle(cornerRadius: 9))
                if !compact {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("NOVA®").font(.system(size: 18, weight: .black, design: .rounded)).foregroundStyle(white)
                        Text("OVERLAY SYSTEM").font(.system(size: 7, weight: .bold, design: .monospaced)).foregroundStyle(muted)
                    }
                }
            }.padding(.bottom, 18)
            ForEach(NOVASection.allCases) { section in
                Button { withAnimation(.easeInOut(duration: 0.16)) { selection = section } } label: {
                    HStack(spacing: 10) {
                        Image(systemName: section.symbol).frame(width: 22, height: 22)
                        if !compact { Text(section.rawValue).font(.system(size: 12, weight: .semibold)) }
                        Spacer(minLength: 0)
                    }
                    .foregroundStyle(selection == section ? accent : muted)
                    .padding(.horizontal, compact ? 6 : 10)
                    .frame(height: 38)
                    .background(selection == section ? accent.opacity(0.10) : .clear, in: RoundedRectangle(cornerRadius: 6))
                }
                .accessibilityLabel(section.rawValue)
            }
            Spacer(minLength: 5)
            if !compact {
                HStack(spacing: 6) {
                    Circle().fill(accent).frame(width: 7, height: 7)
                    Text("LOCAL DEMO").font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundStyle(accent)
                }.padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(accent.opacity(0.07), in: RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(.horizontal, compact ? 9 : 12).padding(.vertical, 22)
        .frame(maxHeight: .infinity)
        .background(Color(red: 14 / 255, green: 21 / 255, blue: 27 / 255))
    }

    @ViewBuilder private var content: some View {
        switch selection {
        case .overview: overview
        case .combat, .visuals, .movement, .automation: featureList
        case .appearance: appearance
        case .profiles: profiles
        case .settings: settings
        }
    }

    private var overview: some View {
        VStack(alignment: .leading, spacing: 17) {
            VStack(alignment: .leading, spacing: 10) {
                Label("SYSTEMS OPERATIONAL", systemImage: "diamond.fill")
                    .font(.system(size: 9, weight: .bold, design: .monospaced)).tracking(1)
                    .foregroundStyle(accent)
                Text("Built for your\nnext level.")
                    .font(.system(size: 27, weight: .bold, design: .rounded)).tracking(-0.6)
                    .foregroundStyle(white)
                Text("Precision-crafted settings, rich visual feedback and instant profiles.")
                    .font(.system(size: 11)).foregroundStyle(muted)
                Button { selection = .combat } label: {
                    Label("Explore modules", systemImage: "arrow.right")
                        .font(.system(size: 11, weight: .bold)).foregroundStyle(bg)
                        .padding(10).background(accent, in: RoundedRectangle(cornerRadius: 5))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(18).background(accent.opacity(0.065), in: RoundedRectangle(cornerRadius: 9))
            HStack(spacing: 9) {
                metric("ACTIVE MODULES", "\(store.activeCount)/18")
                metric("PROFILE", store.profile)
                metric("SIMULATION", store.masterEnabled ? "ONLINE" : "PAUSED")
            }
            sectionLabel("EXPLORE MODULES")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 9) {
                ForEach([NOVASection.combat, .visuals, .movement, .automation]) { section in
                    Button { selection = section } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Image(systemName: section.symbol).font(.system(size: 21)).foregroundStyle(accent)
                            Text(section.rawValue).font(.system(size: 12, weight: .bold)).foregroundStyle(white)
                            Text("Tap to configure  ↗").font(.system(size: 9)).foregroundStyle(muted)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(13).background(surface.opacity(0.9), in: RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }

    private func metric(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.system(size: 8, weight: .bold, design: .monospaced)).foregroundStyle(muted)
            Text(value).font(.system(size: 16, weight: .bold, design: .rounded)).foregroundStyle(accent).lineLimit(1).minimumScaleFactor(0.6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(11).background(surface, in: RoundedRectangle(cornerRadius: 8))
    }

    private var featureList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Configuration only · no game process attached")
                .font(.system(size: 11)).foregroundStyle(muted)
            ForEach(NOVAFeature.all.filter { $0.section == selection }) { feature in
                HStack(spacing: 11) {
                    Image(systemName: feature.symbol)
                        .font(.system(size: 15)).foregroundStyle(accent)
                        .frame(width: 33, height: 33).background(accent.opacity(0.08), in: RoundedRectangle(cornerRadius: 7))
                    VStack(alignment: .leading, spacing: 4) {
                        Text(feature.title).font(.system(size: 12, weight: .semibold)).foregroundStyle(white)
                        Text(feature.detail).font(.system(size: 10)).foregroundStyle(muted)
                    }
                    Spacer(minLength: 4)
                    Toggle(feature.title, isOn: Binding(get: { store.isOn(feature.id) }, set: { store.set(feature.id, to: $0) }))
                        .labelsHidden().tint(accent).disabled(!store.masterEnabled)
                }
                .padding(12).background(surface.opacity(0.8), in: RoundedRectangle(cornerRadius: 8))
            }
            if selection == .combat {
                slider("Assist intensity", value: $store.intensity, range: 0...100, unit: "%")
                slider("Target FOV", value: $store.fov, range: 10...180, unit: "°")
            }
            Label("No memory access, hooking or injection is implemented.", systemImage: "shield.lefthalf.filled")
                .font(.system(size: 10)).foregroundStyle(muted).padding(.top, 10)
        }
    }

    private func slider(_ title: String, value: Binding<Double>, range: ClosedRange<Double>, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Text(title).font(.system(size: 11, weight: .bold)).foregroundStyle(white)
                Spacer()
                Text("\(Int(value.wrappedValue))\(unit)").font(.system(size: 11, weight: .bold, design: .monospaced)).foregroundStyle(accent)
            }
            Slider(value: value, in: range).tint(accent).disabled(!store.masterEnabled)
        }
        .padding(14).background(surface, in: RoundedRectangle(cornerRadius: 8))
    }

    private var appearance: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionLabel("ACCENT PALETTE")
            HStack(spacing: 11) {
                ForEach(0..<5, id: \.self) { i in
                    let colors = [Color(red: 167/255, green: 243/255, blue: 208/255),
                                  Color(red: 199/255, green: 185/255, blue: 1),
                                  Color(red: 1, green: 213/255, blue: 164/255),
                                  Color(red: 168/255, green: 233/255, blue: 1),
                                  Color(red: 1, green: 167/255, blue: 190/255)]
                    Button { store.accentIndex = i } label: {
                        RoundedRectangle(cornerRadius: 8).fill(colors[i]).frame(width: 33, height: 33)
                            .padding(4).overlay(RoundedRectangle(cornerRadius: 11)
                                .stroke(store.accentIndex == i ? colors[i] : .clear, lineWidth: 1))
                    }
                }
            }
            sectionLabel("PANEL OPACITY")
            slider("Overlay opacity", value: $store.opacity, range: 0.65...1, unit: "")
        }
    }

    private var profiles: some View {
        VStack(alignment: .leading, spacing: 11) {
            sectionLabel("READY-TO-USE PROFILES")
            ForEach(["Balanced", "Cinematic", "Performance", "Creator"], id: \.self) { name in
                Button { store.apply(name) } label: {
                    HStack(spacing: 13) {
                        Image(systemName: name == "Performance" ? "bolt.fill" : "square.3.layers.3d")
                            .foregroundStyle(accent).font(.system(size: 19)).frame(width: 30)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(name).font(.system(size: 13, weight: .bold)).foregroundStyle(white)
                            Text("Apply configuration").font(.system(size: 10)).foregroundStyle(muted)
                        }
                        Spacer()
                        if name == store.profile { Image(systemName: "checkmark.circle.fill").foregroundStyle(accent) }
                        else { Image(systemName: "chevron.right").foregroundStyle(muted) }
                    }
                    .padding(15).background(surface, in: RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }

    private var settings: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                Image(systemName: "power").foregroundStyle(accent)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Master switch").font(.system(size: 12, weight: .bold)).foregroundStyle(white)
                    Text("Enable interface switches").font(.system(size: 10)).foregroundStyle(muted)
                }
                Spacer()
                Toggle("Master switch", isOn: $store.masterEnabled).labelsHidden().tint(accent)
            }.padding(15).background(surface, in: RoundedRectangle(cornerRadius: 8))
            sectionLabel("ABOUT THIS BUILD")
            info("Version", "1.0.0 / SWIFTUI")
            info("Status", "UI PREVIEW")
            info("Profile", store.profile)
            info("Game process", "NOT CONNECTED")
            Button(role: .destructive) { store.reset(); selection = .overview } label: {
                Label("Restore defaults", systemImage: "arrow.counterclockwise")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }.padding(15).background(surface, in: RoundedRectangle(cornerRadius: 8))
            Text("Only integrate into apps that you own or are authorized to modify.")
                .font(.system(size: 10)).foregroundStyle(muted)
        }
    }

    private func info(_ key: String, _ value: String) -> some View {
        HStack {
            Text(key).foregroundStyle(muted)
            Spacer()
            Text(value).foregroundStyle(white)
        }.font(.system(size: 11)).padding(12).background(surface, in: RoundedRectangle(cornerRadius: 7))
    }
    private func sectionLabel(_ text: String) -> some View {
        Text(text).font(.system(size: 9, weight: .bold, design: .monospaced))
            .tracking(1.5).foregroundStyle(muted)
    }
}
