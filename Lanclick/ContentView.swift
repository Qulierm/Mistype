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
    @State private var selectedTab: TabItem = .general
    @State private var vibrateOnSilent: Bool = true

    var body: some View {
        VStack {
            HStack {
                ForEach(TabItem.allCases, id: \.self) { tab in
                    Button(action: {
                        selectedTab = tab
                    }) {
                        VStack {
                            Image(systemName: tab.icon)
                                .font(.system(size: 20))
                            Text(tab.rawValue)
                        }
                        .padding(8)
                        .foregroundColor(selectedTab == tab ? .blue : .gray)
                        .background(
                            selectedTab == tab ? Color.gray.opacity(0.2) : Color.clear
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            Divider()
            Spacer()

            // Пример отображения контента
            switch selectedTab {
            case .general:
                GroupBox(
                    label: Text("App")
                        .fontWeight(.bold)
                        .font(.subheadline)
                        .padding(3),
                    content: {
                        VStack{
                            HStack {
                                Text("Start at login")
                                Spacer()
                                Toggle("", isOn: $vibrateOnSilent)
                                    .labelsHidden()
                                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                            }
                            Divider()
                                .padding(3)
                            HStack{
                                Text("Show menu bar icon")
                                Spacer()
                                Toggle("", isOn: $vibrateOnSilent)
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
                        VStack{
                            HStack{
                                Button(action: {
                                    // Code
                                }) {
                                    Text("Default")
                                }
                            }
                        }
                        .padding(5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                )
                .frame(maxWidth: .infinity) // растягивание самого GroupBox
                .padding()
            case .langs:
                Text("Language Settings")
            case .shortcuts:
                Text("Shortcuts Settings")
            case .tools:
                Text("Tools Settings")
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
