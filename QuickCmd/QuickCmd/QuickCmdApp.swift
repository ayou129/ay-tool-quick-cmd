//
//  QuickCmdApp.swift
//  QuickCmd
//
//  Created by ay on 2025/11/28.
//

import SwiftUI

@main
struct QuickCmdApp: App {
    @StateObject private var store = CommandStore()

    var body: some Scene {
        MenuBarExtra("QuickCmd", systemImage: "terminal") {
            ContentView()
                .environmentObject(store)
        }
        .menuBarExtraStyle(.window)
    }
}
