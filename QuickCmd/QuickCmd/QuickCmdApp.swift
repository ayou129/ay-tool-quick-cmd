//
//  QuickCmdApp.swift
//  QuickCmd
//
//  Created by ay on 2025/11/28.
//

import SwiftUI

@main
struct QuickCmdApp: App {
    @StateObject var store = CommandStore()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .onAppear {
                    // 在视图出现时传递 store
                    appDelegate.store = store
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?
    var store: CommandStore?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // 获取 CommandStore 实例
        if let appDelegate = NSApplication.shared.delegate as? QuickCmdApp {
            store = appDelegate.store
        }

        // 获取主窗口
        if let window = NSApplication.shared.windows.first {
            self.window = window

            // 设置窗口样式
            window.styleMask = [.titled, .closable, .resizable, .fullSizeContentView]
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden
            window.isMovableByWindowBackground = false  // 禁用背景拖动，避免与命令拖动冲突

            // 半透明背景
            window.backgroundColor = NSColor.clear
            window.isOpaque = false

            // 始终置顶
            window.level = .floating

            // 从配置文件恢复位置和大小
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
        guard let window = window, let store = store else { return }
        let frame = window.frame

        // 保存到 CommandStore 的窗口设置
        store.windowSettings = WindowSettings(
            x: frame.origin.x,
            y: frame.origin.y,
            width: frame.size.width,
            height: frame.size.height
        )
        store.saveSettings()
    }

    func restoreWindowFrame() {
        guard let window = window else { return }

        // 从配置文件读取窗口设置
        if let settings = store?.windowSettings,
           settings.width > 0 && settings.height > 0 {
            window.setFrame(
                NSRect(x: settings.x, y: settings.y, width: settings.width, height: settings.height),
                display: true
            )
        } else {
            // 默认位置：右上角
            let screenFrame = NSScreen.main?.visibleFrame ?? .zero
            let defaultWidth: CGFloat = 380
            let defaultHeight: CGFloat = 550
            let defaultX = screenFrame.maxX - defaultWidth - 20
            let defaultY = screenFrame.maxY - defaultHeight - 20
            window.setFrame(NSRect(x: defaultX, y: defaultY, width: defaultWidth, height: defaultHeight), display: true)
        }
    }
}
