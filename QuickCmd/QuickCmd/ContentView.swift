//
//  ContentView.swift
//  QuickCmd
//
//  Created by ay on 2025/11/28.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: CommandStore
    @State private var searchText = ""
    @State private var showingAddSheet = false

    var filteredCommands: [Command] {
        store.commands.filter { $0.matches(searchText) }
    }

    var groupedFilteredCommands: [String: [Command]] {
        Dictionary(grouping: filteredCommands, by: { $0.category })
    }

    var body: some View {
        VStack(spacing: 0) {
            // 顶部拖动区域 + 搜索框
            VStack(spacing: 0) {
                // 拖动区域
                DragWindowArea()
                    .frame(height: 8)

                // 搜索框 - 更紧凑
                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                        .font(.system(size: 11))
                    TextField("搜索", text: $searchText)
                        .textFieldStyle(.plain)
                        .font(.system(size: 11))
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                                .font(.system(size: 11))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(NSColor.controlBackgroundColor).opacity(0.4))
                )
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
            }
            .padding(.top, 4)

            // 命令列表 - 更紧凑
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 2, pinnedViews: [.sectionHeaders]) {
                    ForEach(groupedFilteredCommands.keys.sorted(), id: \.self) { category in
                        Section {
                            ForEach(groupedFilteredCommands[category] ?? []) { command in
                                CommandRow(command: command)
                                    .environmentObject(store)
                            }
                            .onMove { source, destination in
                                store.moveCommands(in: category, from: source, to: destination)
                            }
                        } header: {
                            HStack(spacing: 5) {
                                Text(categoryIcon(for: category))
                                    .font(.system(size: 12))
                                Text(category)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(.primary)
                                Spacer()
                                Text("\(groupedFilteredCommands[category]?.count ?? 0)")
                                    .font(.system(size: 9))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                            .background(
                                VisualEffectBlur(material: .menu, blendingMode: .withinWindow)
                            )
                        }
                    }
                }
                .padding(.vertical, 2)
            }
            .background(Color.clear)

            // 底部栏 - 更紧凑
            HStack(spacing: 8) {
                Button(action: { showingAddSheet = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                        Text("添加")
                    }
                    .font(.system(size: 10))
                }
                .buttonStyle(.borderless)

                Button(action: { store.loadSettings() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.clockwise")
                        Text("刷新")
                    }
                    .font(.system(size: 10))
                }
                .buttonStyle(.borderless)
                .help("重新加载配置文件")

                Spacer()

                Text("\(filteredCommands.count) 条")
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Color(NSColor.controlBackgroundColor).opacity(0.3)
            )
        }
        .background(
            VisualEffectBlur(material: .hudWindow, blendingMode: .behindWindow)
        )
        .frame(minWidth: 300, idealWidth: 380, maxWidth: 600, minHeight: 350, idealHeight: 550)
        .sheet(isPresented: $showingAddSheet) {
            AddCommandView()
                .environmentObject(store)
        }
    }

    func categoryIcon(for category: String) -> String {
        switch category {
        case "访达": return "📁"
        case "iTerm2": return "💻"
        case "Nano": return "⌨️"
        case "Linux": return "🐧"
        default: return "📦"
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(CommandStore())
}
