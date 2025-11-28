//
//  EditCommandView.swift
//  QuickCmd
//
//  Created by ay on 2025/11/28.
//

import SwiftUI

struct EditCommandView: View {
    let command: Command
    @EnvironmentObject var store: CommandStore
    @Environment(\.dismiss) var dismiss

    @State private var category: String
    @State private var cmd: String
    @State private var briefDesc: String
    @State private var details: String
    @State private var example: String

    init(command: Command) {
        self.command = command
        _category = State(initialValue: command.category)
        _cmd = State(initialValue: command.command)
        _briefDesc = State(initialValue: command.briefDesc)
        _details = State(initialValue: command.details ?? "")
        _example = State(initialValue: command.example ?? "")
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("编辑命令")
                    .font(.system(size: 13, weight: .semibold))

                Form {
                    Section("基本信息") {
                        TextField("分类", text: $category)
                            .font(.system(size: 12))
                        TextField("命令", text: $cmd)
                            .font(.system(size: 12))
                        TextField("简短描述", text: $briefDesc)
                            .font(.system(size: 12))
                    }

                    Section("详细信息（可选）") {
                        TextField("详细说明", text: $details, axis: .vertical)
                            .font(.system(size: 11))
                            .lineLimit(2...4)
                        TextField("示例", text: $example, axis: .vertical)
                            .font(.system(size: 11, design: .monospaced))
                            .lineLimit(3...6)
                    }
                }
                .textFieldStyle(.roundedBorder)

                Text("提示：参数功能即将支持")
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)

                HStack {
                    Button("取消") {
                        dismiss()
                    }
                    .keyboardShortcut(.escape)

                    Button("保存") {
                        var updatedCommand = command
                        updatedCommand.category = category.trimmingCharacters(in: .whitespaces)
                        updatedCommand.command = cmd.trimmingCharacters(in: .whitespaces)
                        updatedCommand.briefDesc = briefDesc.trimmingCharacters(in: .whitespaces)
                        updatedCommand.details = details.isEmpty ? nil : details
                        updatedCommand.example = example.isEmpty ? nil : example
                        store.updateCommand(updatedCommand)
                        dismiss()
                    }
                    .keyboardShortcut(.return)
                    .disabled(category.isEmpty || cmd.isEmpty || briefDesc.isEmpty)
                }
            }
            .padding(20)
        }
        .frame(width: 420, height: 480)
    }
}

#Preview {
    EditCommandView(command: Command.sampleData[0])
        .environmentObject(CommandStore())
}
