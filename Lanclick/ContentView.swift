//
//  ContentView.swift
//  Lanclick
//
//  Created by Nikita Gostevsky on 23.04.2025.
//

import SwiftUI

enum TabItem: String, CaseIterable {
    case general = "General"
    case langs = "Language"
    case shortcuts = "Shortcuts"
    case tools = "Tools"

    var icon: String {
        switch self {
        case .general: return "gearshape"
        case .langs: return "globe"
        case .shortcuts: return "command"
        case .tools: return "hammer"
        }
    }
}

struct ContentView: View {
    @Namespace private var animationNamespace
    @State private var selectedTab: TabItem = .general
    @State private var startAtLogin: Bool = true
    @State private var menubarActive: Bool = true
    @State private var hotKeyString: String = "Command + Shift + L"
    let appDelegate: AppDelegate

    var body: some View {
        ZStack {
            VisualEffectView(material: .sidebar, blendingMode: .withinWindow)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    ForEach(TabItem.allCases, id: \.self) { tab in
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                selectedTab = tab
                            }
                        }) {
                            VStack {
                                Image(systemName: tab.icon)
                                    .font(.system(size: 20))
                                Text(tab.rawValue)
                            }
                            .padding(8)
                            .foregroundColor(selectedTab == tab ? .blue : .gray)
                            .background(
                                ZStack {
                                    if selectedTab == tab {
                                        RoundedRectangle(cornerRadius: 9, style: .continuous)
                                            .fill(Color.gray.opacity(0.2))
                                            .matchedGeometryEffect(id: "tabHighlight", in: animationNamespace)
                                    }
                                }
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                Divider()
                Spacer()

                ZStack {
                    switch selectedTab {
                    case .general:
                        generalView
                            .transition(.opacity.combined(with: .slide))
                    case .langs:
                        Text("Language Settings")
                            .transition(.opacity.combined(with: .move(edge: .trailing)))
                    case .shortcuts:
                        shortcutsView
                            .transition(.opacity.combined(with: .move(edge: .trailing)))
                    case .tools:
                        Text("Tools Settings")
                            .transition(.opacity.combined(with: .move(edge: .trailing)))
                    }
                }
                .animation(.easeInOut(duration: 0.25), value: selectedTab)

                Spacer()
            }
            .padding()
            .frame(minWidth: 300, minHeight: 250)
            .onAppear {
                startAtLogin = appDelegate.isStartAtLoginEnabled()
            }
            .onChange(of: menubarActive) { newValue in
                appDelegate.setStatusItemVisibility(newValue)
            }
        }
    }

    var generalView: some View {
        VStack {
            GroupBox(
                label: Text("App")
                    .fontWeight(.bold)
                    .font(.subheadline)
                    .padding(3),
                content: {
                    VStack {
                        HStack {
                            Text("Start at login")
                            Spacer()
                            Toggle("", isOn: $startAtLogin.animation(.easeInOut(duration: 0.2)))
                                .labelsHidden()
                                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                                .onChange(of: startAtLogin) { newValue in
                                    appDelegate.setStartAtLogin(newValue)
                                }
                        }
                        Divider()
                            .padding(3)
                        HStack {
                            Text("Show menu bar icon")
                            Spacer()
                            Toggle("", isOn: $menubarActive.animation(.easeInOut(duration: 0.2)))
                                .labelsHidden()
                                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                        }
                    }
                    .padding(5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            )
            GroupBox(
                label: Text("")
                    .fontWeight(.bold)
                    .font(.subheadline)
                    .padding(3),
                content: {
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                // Code
                            }) {
                                Text("Check for updates")
                            }
                            Spacer()
                        }
                    }
                    .padding(5)
                }
            )
        }
    }

    var shortcutsView: some View {
        VStack {
            GroupBox(
                label: Text("Shortcuts Settings")
                    .fontWeight(.bold)
                    .font(.subheadline)
                    .padding(3),
                content: {
                    VStack {
                        HStack {
                            Text("Hot Key")
                            Spacer()
                            TextField("Enter hotkey", text: $hotKeyString)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(5)
                                .frame(width: 180)
                                .onSubmit {
                                    print("Hotkey submitted: \(hotKeyString)")
                                }
                        }
                            .padding(3)
                    }
                    .padding(5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            )
        }
    }
}

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

#Preview {
    ContentView(appDelegate: AppDelegate())
}
