//
//  CommandStore.swift
//  QuickCmd
//
//  Created by ay on 2025/11/28.
//

import Foundation
import Combine

class CommandStore: ObservableObject {
    @Published var commands: [Command] = []

    private let saveKey = "SavedCommands"

    init() {
        loadCommands()
    }

    // MARK: - 数据持久化

    func loadCommands() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Command].self, from: data) {
            commands = decoded
        } else {
            // 首次启动，加载示例数据
            commands = Command.sampleData
            saveCommands()
        }
    }

    func saveCommands() {
        if let encoded = try? JSONEncoder().encode(commands) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
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
