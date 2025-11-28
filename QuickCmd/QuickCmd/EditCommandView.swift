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
    @State private var shortcut: String
    @State private var description: String

    init(command: Command) {
        self.command = command
        _category = State(initialValue: command.category)
        _shortcut = State(initialValue: command.shortcut)
        _description = State(initialValue: command.description)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("编辑命令")
                .font(.headline)

            Form {
                TextField("分类", text: $category)
                TextField("快捷键或命令", text: $shortcut)
                TextField("描述", text: $description)
            }
            .textFieldStyle(.roundedBorder)

            HStack {
                Button("取消") {
                    dismiss()
                }
                .keyboardShortcut(.escape)

                Button("保存") {
                    var updatedCommand = command
                    updatedCommand.category = category.trimmingCharacters(in: .whitespaces)
                    updatedCommand.shortcut = shortcut.trimmingCharacters(in: .whitespaces)
                    updatedCommand.description = description.trimmingCharacters(in: .whitespaces)
                    store.updateCommand(updatedCommand)
                    dismiss()
                }
                .keyboardShortcut(.return)
                .disabled(category.isEmpty || shortcut.isEmpty || description.isEmpty)
            }
        }
        .padding(20)
        .frame(width: 400)
    }
}

#Preview {
    EditCommandView(command: Command.sampleData[0])
        .environmentObject(CommandStore())
}
