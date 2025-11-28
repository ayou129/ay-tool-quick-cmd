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
    @State private var isExpanded = false
    @State private var showingEditSheet = false
    @State private var copied = false

    var hasDetails: Bool {
        (command.params != nil && !command.params!.isEmpty) ||
        command.details != nil ||
        command.example != nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 主行：命令 + 描述 + 复制按钮
            HStack(spacing: 8) {
                // 展开指示器（固定宽度以对齐）
                Group {
                    if hasDetails {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 9))
                            .foregroundColor(.secondary)
                            .rotationEffect(.degrees(isExpanded ? 90 : 0))
                    } else {
                        Color.clear
                    }
                }
                .frame(width: 12)

                // 命令
                Text(command.command)
                    .font(.system(size: 11, design: .monospaced))
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                // 描述
                Text(command.briefDesc)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .lineLimit(1)

                Spacer()

                // 复制按钮
                Button(action: copyToClipboard) {
                    Image(systemName: copied ? "checkmark" : "doc.on.doc")
                        .font(.system(size: 10))
                        .foregroundColor(copied ? .green : .secondary)
                }
                .buttonStyle(.plain)
                .help("复制命令")
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.clear)
            .contentShape(Rectangle())
            .onTapGesture {
                if hasDetails {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isExpanded.toggle()
                    }
                }
            }

            // 展开的详情
            if isExpanded {
                VStack(alignment: .leading, spacing: 6) {
                    // 参数列表
                    if let params = command.params, !params.isEmpty {
                        VStack(alignment: .leading, spacing: 3) {
                            ForEach(params, id: \.param) { param in
                                HStack(spacing: 6) {
                                    Text("•")
                                        .foregroundColor(.secondary)
                                        .font(.system(size: 9))
                                    Text(param.param)
                                        .font(.system(size: 10, design: .monospaced))
                                        .fontWeight(.medium)
                                        .foregroundColor(.accentColor)
                                    Text(param.desc)
                                        .font(.system(size: 9))
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.bottom, 4)
                    }

                    // 详细说明
                    if let details = command.details {
                        Text(details)
                            .font(.system(size: 9))
                            .foregroundColor(.secondary)
                            .padding(.bottom, 4)
                    }

                    // 示例
                    if let example = command.example {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("示例:")
                                .font(.system(size: 9))
                                .foregroundColor(.secondary)
                            Text(example)
                                .font(.system(size: 9, design: .monospaced))
                                .foregroundColor(.secondary.opacity(0.8))
                                .padding(6)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.black.opacity(0.1))
                                )
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.leading, hasDetails ? 20 : 0)
                .padding(.bottom, 6)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(isExpanded ? Color(NSColor.controlBackgroundColor).opacity(0.3) : Color.clear)
        )
        .contextMenu {
            Button(action: copyToClipboard) {
                Label("复制命令", systemImage: "doc.on.doc")
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
        pasteboard.setString(command.command, forType: .string)

        copied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            copied = false
        }
    }
}

#Preview {
    VStack {
        CommandRow(command: Command.sampleData[0])
        CommandRow(command: Command.sampleData[14]) // wget with params
    }
    .environmentObject(CommandStore())
    .frame(width: 400)
    .padding()
}
