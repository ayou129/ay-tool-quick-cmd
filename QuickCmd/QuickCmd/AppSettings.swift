//
//  AppSettings.swift
//  QuickCmd
//
//  Created by ay on 2025/11/28.
//

import Foundation

// 应用配置（包含命令和窗口设置）
struct AppSettings: Codable {
    var commands: [Command]
    var window: WindowSettings?

    init(commands: [Command] = [], window: WindowSettings? = nil) {
        self.commands = commands
        self.window = window
    }
}

// 窗口设置
struct WindowSettings: Codable {
    var x: Double
    var y: Double
    var width: Double
    var height: Double

    init(x: Double = 0, y: Double = 0, width: Double = 380, height: Double = 550) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
}
