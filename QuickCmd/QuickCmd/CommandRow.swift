//
//  CommandRow.swift
//  QuickCmd
//
//  Created by ay on 2025/11/28.
//

import SwiftUI
import AppKit

struct CommandRow: View {
    let command: Command
    @EnvironmentObject var store: CommandStore
    @State private var showingEditSheet = false
    @State private var copied = false

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(command.shortcut)
                    .font(.system(.body, design: .monospaced))
                    .fontWeight(.semibold)

                Text(command.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // 复制按钮
            Button(action: copyToClipboard) {
                Image(systemName: copied ? "checkmark" : "doc.on.doc")
                    .foregroundColor(copied ? .green : .blue)
            }
            .buttonStyle(.plain)
            .help("复制到剪贴板")
        }
        .padding(10)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(6)
        .padding(.horizontal, 12)
        .contextMenu {
            Button("复制", action: copyToClipboard)
            Button("编辑", action: { showingEditSheet = true })
            Divider()
            Button("删除", role: .destructive) {
                store.deleteCommand(command)
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditCommandView(command: command)
                .environmentObject(store)
        }
    }

    func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(command.shortcut, forType: .string)

        // 显示复制成功反馈
        copied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            copied = false
        }
    }
}

#Preview {
    CommandRow(command: Command.sampleData[0])
        .environmentObject(CommandStore())
        .frame(width: 400)
}
