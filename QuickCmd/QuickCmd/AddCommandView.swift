//
//  AddCommandView.swift
//  QuickCmd
//
//  Created by ay on 2025/11/28.
//

import SwiftUI

struct AddCommandView: View {
    @EnvironmentObject var store: CommandStore
    @Environment(\.dismiss) var dismiss

    @State private var category = ""
    @State private var shortcut = ""
    @State private var description = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("添加新命令")
                .font(.headline)

            Form {
                TextField("分类（如：访达、iTerm2）", text: $category)
                TextField("快捷键或命令", text: $shortcut)
                TextField("描述", text: $description)
            }
            .textFieldStyle(.roundedBorder)

            HStack {
                Button("取消") {
                    dismiss()
                }
                .keyboardShortcut(.escape)

                Button("添加") {
                    let command = Command(
                        category: category.trimmingCharacters(in: .whitespaces),
                        shortcut: shortcut.trimmingCharacters(in: .whitespaces),
                        description: description.trimmingCharacters(in: .whitespaces)
                    )
                    store.addCommand(command)
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
    AddCommandView()
        .environmentObject(CommandStore())
}
