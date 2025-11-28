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
            VStack(alignment: .leading, spacing: 5) {
                Text(command.shortcut)
                    .font(.system(size: 13, design: .monospaced))
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                Text(command.description)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }

            Spacer()

            // 复制按钮
            Button(action: copyToClipboard) {
                Image(systemName: copied ? "checkmark.circle.fill" : "doc.on.doc.fill")
                    .font(.system(size: 14))
                    .foregroundColor(copied ? .green : .accentColor)
            }
            .buttonStyle(.plain)
            .help("复制到剪贴板")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(NSColor.controlBackgroundColor).opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color.gray.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal, 16)
        .contextMenu {
            Button(action: copyToClipboard) {
                Label("复制", systemImage: "doc.on.doc")
            }
            Button(action: { showingEditSheet = true }) {
                Label("编辑", systemImage: "pencil")
            }
            Divider()
            Button(role: .destructive) {
                store.deleteCommand(command)
            } label: {
                Label("删除", systemImage: "trash")
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
