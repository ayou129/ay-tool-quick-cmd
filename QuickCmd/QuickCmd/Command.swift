//
//  Command.swift
//  QuickCmd
//
//  Created by ay on 2025/11/28.
//

import Foundation

struct Command: Identifiable, Codable, Hashable {
    var id = UUID()
    var category: String        // 分类
    var command: String         // 命令/快捷键
    var briefDesc: String       // 简短描述（一行）
    var params: [CommandParam]? // 参数列表（可选）
    var details: String?        // 详细说明（可选）
    var example: String?        // 示例输出（可选）

    // 用于搜索匹配
    func matches(_ searchText: String) -> Bool {
        if searchText.isEmpty { return true }
        let lowercased = searchText.lowercased()
        let paramsText = params?.map { $0.param + $0.desc }.joined() ?? ""
        return category.lowercased().contains(lowercased) ||
               command.lowercased().contains(lowercased) ||
               briefDesc.lowercased().contains(lowercased) ||
               paramsText.lowercased().contains(lowercased) ||
               (details?.lowercased().contains(lowercased) ?? false)
    }
}

struct CommandParam: Codable, Hashable {
    var param: String  // 参数名，如 "-L"
    var desc: String   // 参数说明，如 "接受跳转"
}

// 示例数据
extension Command {
    static let sampleData = [
        // 访达
        Command(category: "访达", command: "Shift+Cmd+.", briefDesc: "展示所有文件夹"),

        // iTerm2
        Command(category: "iTerm2", command: "Cmd+O", briefDesc: "快速打开终端"),

        // Nano
        Command(category: "Nano", command: "Ctrl+O", briefDesc: "保存", details: "保存当前文件，按 Enter 确认"),
        Command(category: "Nano", command: "Ctrl+X", briefDesc: "退出"),
        Command(category: "Nano", command: "Ctrl+K", briefDesc: "剪切当前行"),
        Command(category: "Nano", command: "Ctrl+U", briefDesc: "粘贴"),
        Command(category: "Nano", command: "Ctrl+A", briefDesc: "跳到行首"),
        Command(category: "Nano", command: "Ctrl+E", briefDesc: "跳到行尾"),
        Command(category: "Nano", command: "Ctrl+/", briefDesc: "跳到指定行"),
        Command(category: "Nano", command: "Ctrl+Y", briefDesc: "向上翻页"),
        Command(category: "Nano", command: "Ctrl+V", briefDesc: "向下翻页"),
        Command(category: "Nano", command: "Ctrl+W", briefDesc: "搜索文本"),
        Command(category: "Nano", command: "Ctrl+Option+6", briefDesc: "开启Mark标记起点"),
        Command(category: "Nano", command: "Ctrl+V+Ctrl+K", briefDesc: "删除"),

        // Linux
        Command(
            category: "Linux",
            command: "wget",
            briefDesc: "下载文件",
            params: [
                CommandParam(param: "-L", desc: "接受跳转"),
                CommandParam(param: "-O", desc: "指定路径和文件名")
            ]
        ),
        Command(
            category: "Linux",
            command: "tree",
            briefDesc: "显示目录树",
            params: [
                CommandParam(param: "-d", desc: "只显示文件夹"),
                CommandParam(param: "-L 2", desc: "只显示2层"),
                CommandParam(param: "-h", desc: "显示文件大小")
            ]
        ),
        Command(category: "Linux", command: "nvidia-smi", briefDesc: "查看GPU状态"),
        Command(
            category: "Linux",
            command: "lsb_release -a",
            briefDesc: "查看系统版本",
            example: """
            No LSB modules are available.
            Distributor ID: Ubuntu
            Description: Ubuntu 24.04.3 LTS
            Release: 24.04
            Codename: noble
            """
        ),
        Command(
            category: "Linux",
            command: "cat /etc/nv_tegra_release",
            briefDesc: "查看Jetson版本",
            example: "R38 (release), REVISION: 2.0, GCID: 41844464, BOARD: generic, EABI: aarch64"
        ),
        Command(category: "Linux", command: "nproc", briefDesc: "查看CPU核心数"),
        Command(category: "Linux", command: "uname -m", briefDesc: "查看架构", details: "aarch64 = arm64"),
        Command(category: "Linux", command: "sudo shutdown", briefDesc: "关机"),
        Command(
            category: "Linux",
            command: "scp",
            briefDesc: "远程复制文件",
            params: [
                CommandParam(param: "源路径", desc: "/tmp/file.tar"),
                CommandParam(param: "目标", desc: "user@ip:~/path/")
            ],
            example: "scp /tmp/ros.tar ay@192.168.3.133:~/Desktop/"
        ),
    ]
}
