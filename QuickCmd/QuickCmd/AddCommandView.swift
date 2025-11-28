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
    @State private var command = ""
    @State private var briefDesc = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("添加新命令")
                .font(.system(size: 13, weight: .semibold))

            Form {
                TextField("分类（如：Linux、Nano）", text: $category)
                    .font(.system(size: 12))
                TextField("命令或快捷键", text: $command)
                    .font(.system(size: 12))
                TextField("简短描述", text: $briefDesc)
                    .font(.system(size: 12))
            }
            .textFieldStyle(.roundedBorder)

            Text("提示：添加后可右键编辑以添加参数和示例")
                .font(.system(size: 10))
                .foregroundColor(.secondary)

            HStack {
                Button("取消") {
                    dismiss()
                }
                .keyboardShortcut(.escape)

                Button("添加") {
                    let newCommand = Command(
                        category: category.trimmingCharacters(in: .whitespaces),
                        command: command.trimmingCharacters(in: .whitespaces),
                        briefDesc: briefDesc.trimmingCharacters(in: .whitespaces)
                    )
                    store.addCommand(newCommand)
                    dismiss()
                }
                .keyboardShortcut(.return)
                .disabled(category.isEmpty || command.isEmpty || briefDesc.isEmpty)
            }
        }
        .padding(20)
        .frame(width: 380)
    }
}

#Preview {
    AddCommandView()
        .environmentObject(CommandStore())
}
