//
//  Command.swift
//  QuickCmd
//
//  Created by ay on 2025/11/28.
//

import Foundation

struct Command: Identifiable, Codable, Hashable {
    var id = UUID()
    var category: String    // 分类：访达、iTerm2、Nano 等
    var shortcut: String    // 快捷键或命令
    var description: String // 描述

    // 用于搜索匹配
    func matches(_ searchText: String) -> Bool {
        if searchText.isEmpty { return true }
        let lowercased = searchText.lowercased()
        return category.lowercased().contains(lowercased) ||
               shortcut.lowercased().contains(lowercased) ||
               description.lowercased().contains(lowercased)
    }
}

// 示例数据
extension Command {
    static let sampleData = [
        // 访达命令
        Command(category: "访达", shortcut: "Shift+Cmd+.", description: "展示所有隐藏文件夹"),

        // iTerm2
        Command(category: "iTerm2", shortcut: "Cmd+O", description: "快速打开终端"),

        // Nano
        Command(category: "Nano", shortcut: "Ctrl+O → Enter", description: "保存文件"),
        Command(category: "Nano", shortcut: "Ctrl+X", description: "退出"),
        Command(category: "Nano", shortcut: "Ctrl+K", description: "剪切当前行"),
        Command(category: "Nano", shortcut: "Ctrl+U", description: "粘贴"),
        Command(category: "Nano", shortcut: "Ctrl+A", description: "跳到行首"),
        Command(category: "Nano", shortcut: "Ctrl+E", description: "跳到行尾"),
        Command(category: "Nano", shortcut: "Ctrl+/", description: "跳到指定行"),
        Command(category: "Nano", shortcut: "Ctrl+W", description: "搜索文本"),

        // Linux
        Command(category: "Linux", shortcut: "wget -L -O", description: "接受跳转并指定路径"),
        Command(category: "Linux", shortcut: "tree -d -L 2", description: "显示2层文件夹结构"),
        Command(category: "Linux", shortcut: "nvidia-smi", description: "查看GPU状态"),
        Command(category: "Linux", shortcut: "lsb_release -a", description: "查看系统版本"),
        Command(category: "Linux", shortcut: "nproc", description: "查看CPU核心数"),
        Command(category: "Linux", shortcut: "uname -m", description: "查看架构 (aarch64=arm64)"),
        Command(category: "Linux", shortcut: "sudo shutdown", description: "关机"),
    ]
}
