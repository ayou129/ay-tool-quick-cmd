//
//  DragWindowArea.swift
//  QuickCmd
//
//  Created by ay on 2025/11/28.
//

import SwiftUI

struct DragWindowArea: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = DraggableView()
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

class DraggableView: NSView {
    override var mouseDownCanMoveWindow: Bool {
        return true
    }
}
