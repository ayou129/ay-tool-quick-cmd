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
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // 获取主窗口
        if let window = NSApplication.shared.windows.first {
            self.window = window

            // 设置窗口样式
            window.styleMask = [.titled, .closable, .resizable, .fullSizeContentView]
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden
            window.isMovableByWindowBackground = true

            // 半透明背景
            window.backgroundColor = NSColor.clear
            window.isOpaque = false

            // 始终置顶
            window.level = .floating

            // 从存储恢复位置和大小
            restoreWindowFrame()

            // 监听窗口变化以保存位置
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(windowDidMove),
                name: NSWindow.didMoveNotification,
                object: window
            )
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(windowDidResize),
                name: NSWindow.didResizeNotification,
                object: window
            )
        }
    }

    @objc func windowDidMove() {
        saveWindowFrame()
    }

    @objc func windowDidResize() {
        saveWindowFrame()
    }

    func saveWindowFrame() {
        guard let window = window else { return }
        let frame = window.frame
        UserDefaults.standard.set(frame.origin.x, forKey: "windowX")
        UserDefaults.standard.set(frame.origin.y, forKey: "windowY")
        UserDefaults.standard.set(frame.size.width, forKey: "windowWidth")
        UserDefaults.standard.set(frame.size.height, forKey: "windowHeight")
    }

    func restoreWindowFrame() {
        guard let window = window else { return }

        let x = UserDefaults.standard.double(forKey: "windowX")
        let y = UserDefaults.standard.double(forKey: "windowY")
        let width = UserDefaults.standard.double(forKey: "windowWidth")
        let height = UserDefaults.standard.double(forKey: "windowHeight")

        if width > 0 && height > 0 {
            window.setFrame(NSRect(x: x, y: y, width: width, height: height), display: true)
        } else {
            // 默认位置：右上角
            let screenFrame = NSScreen.main?.visibleFrame ?? .zero
            let defaultWidth: CGFloat = 450
            let defaultHeight: CGFloat = 600
            let defaultX = screenFrame.maxX - defaultWidth - 20
            let defaultY = screenFrame.maxY - defaultHeight - 20
            window.setFrame(NSRect(x: defaultX, y: defaultY, width: defaultWidth, height: defaultHeight), display: true)
        }
    }
}
