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
            // 搜索框
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.system(size: 14))
                TextField("搜索命令...", text: $searchText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 13))
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.system(size: 13))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(NSColor.controlBackgroundColor).opacity(0.5))
            )
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)

            // 命令列表
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8, pinnedViews: [.sectionHeaders]) {
                    ForEach(groupedFilteredCommands.keys.sorted(), id: \.self) { category in
                        Section {
                            ForEach(groupedFilteredCommands[category] ?? []) { command in
                                CommandRow(command: command)
                                    .environmentObject(store)
                            }
                        } header: {
                            HStack(spacing: 6) {
                                Text(categoryIcon(for: category))
                                    .font(.system(size: 14))
                                Text(category)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Color(NSColor.windowBackgroundColor).opacity(0.95)
                                    .blur(radius: 10)
                            )
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .background(Color.clear)

            // 底部按钮
            HStack {
                Button(action: { showingAddSheet = true }) {
                    Label("添加命令", systemImage: "plus.circle.fill")
                        .font(.system(size: 12))
                }
                .buttonStyle(.borderless)

                Spacer()

                Text("\(filteredCommands.count) 条命令")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color(NSColor.controlBackgroundColor).opacity(0.5))
            )
        }
        .background(
            VisualEffectBlur(material: .hudWindow, blendingMode: .behindWindow)
        )
        .frame(minWidth: 350, idealWidth: 450, maxWidth: 600, minHeight: 400, idealHeight: 600, maxHeight: 900)
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
