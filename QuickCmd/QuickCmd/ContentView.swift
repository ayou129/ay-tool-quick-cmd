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
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("搜索命令...", text: $searchText)
                    .textFieldStyle(.plain)
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(10)
            .background(Color(NSColor.controlBackgroundColor))

            Divider()

            // 命令列表
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12, pinnedViews: [.sectionHeaders]) {
                    ForEach(groupedFilteredCommands.keys.sorted(), id: \.self) { category in
                        Section {
                            ForEach(groupedFilteredCommands[category] ?? []) { command in
                                CommandRow(command: command)
                                    .environmentObject(store)
                            }
                        } header: {
                            HStack {
                                Text(categoryIcon(for: category))
                                Text(category)
                                    .font(.headline)
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(NSColor.windowBackgroundColor))
                        }
                    }
                }
                .padding(.vertical, 8)
            }

            Divider()

            // 底部按钮
            HStack {
                Button(action: { showingAddSheet = true }) {
                    Label("添加命令", systemImage: "plus")
                }
                .buttonStyle(.borderless)

                Spacer()

                Text("\(filteredCommands.count) 条命令")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(10)
            .background(Color(NSColor.controlBackgroundColor))
        }
        .frame(width: 450, height: 600)
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
