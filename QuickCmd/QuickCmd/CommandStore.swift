//
//  CommandStore.swift
//  QuickCmd
//
//  Created by ay on 2025/11/28.
//

import Foundation
import Combine
import SwiftUI

class CommandStore: ObservableObject {
    @Published var commands: [Command] = []
    var windowSettings: WindowSettings?

    private var configURL: URL {
        let homeDir = FileManager.default.homeDirectoryForCurrentUser
        return homeDir.appendingPathComponent(".quickcmd_settings.json")
    }

    init() {
        loadSettings()
    }

    // MARK: - 数据持久化

    func loadSettings() {
        print("📁 配置文件路径: \(configURL.path)")

        // 检查文件是否存在
        if FileManager.default.fileExists(atPath: configURL.path) {
            print("✅ 配置文件存在")
        } else {
            print("❌ 配置文件不存在")
            commands = []
            windowSettings = nil
            return
        }

        // 尝试从配置文件加载
        do {
            let data = try Data(contentsOf: configURL)
            print("📄 文件大小: \(data.count) bytes")

            let decoder = JSONDecoder()
            let settings = try decoder.decode(AppSettings.self, from: data)
            commands = settings.commands
            windowSettings = settings.window
            print("✅ 成功加载 \(settings.commands.count) 条命令")
        } catch {
            print("❌ 加载失败: \(error)")
            commands = []
            windowSettings = nil
        }
    }

    func saveSettings() {
        let settings = AppSettings(commands: commands, window: windowSettings)

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        if let encoded = try? encoder.encode(settings) {
            try? encoded.write(to: configURL)
        }
    }

    // 便捷方法：只保存命令（保持窗口设置不变）
    func saveCommands() {
        saveSettings()
    }

    // MARK: - CRUD 操作

    func addCommand(_ command: Command) {
        commands.append(command)
        saveCommands()
    }

    func updateCommand(_ command: Command) {
        if let index = commands.firstIndex(where: { $0.id == command.id }) {
            commands[index] = command
            saveCommands()
        }
    }

    func deleteCommand(_ command: Command) {
        commands.removeAll { $0.id == command.id }
        saveCommands()
    }

    func deleteCommands(at offsets: IndexSet, in filteredCommands: [Command]) {
        let commandsToDelete = offsets.map { filteredCommands[$0] }
        commandsToDelete.forEach { deleteCommand($0) }
    }

    // 在分类内移动命令
    func moveCommands(in category: String, from source: IndexSet, to destination: Int) {
        var categoryCommands = commands.filter { $0.category == category }
        categoryCommands.move(fromOffsets: source, toOffset: destination)

        // 移除该分类的所有命令
        commands.removeAll { $0.category == category }

        // 找到插入位置（保持其他分类的顺序）
        let otherCategories = categories.filter { $0 != category }
        if let firstOtherCommand = commands.first(where: { otherCategories.contains($0.category) }),
           let insertIndex = commands.firstIndex(where: { $0.id == firstOtherCommand.id }) {
            commands.insert(contentsOf: categoryCommands, at: insertIndex)
        } else {
            commands.append(contentsOf: categoryCommands)
        }

        saveCommands()
    }

    // MARK: - 辅助方法

    // 按分类分组
    var groupedCommands: [String: [Command]] {
        Dictionary(grouping: commands, by: { $0.category })
    }

    // 获取所有分类
    var categories: [String] {
        Array(Set(commands.map { $0.category })).sorted()
    }
}
