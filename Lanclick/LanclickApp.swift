//
//  LanclickApp.swift
//  Lanclick
//
//  Created by Nikita Gostevsky on 23.04.2025.
//

import SwiftUI

@main
struct LanclickApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentSize)
    }
}
