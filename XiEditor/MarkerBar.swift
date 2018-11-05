// Copyright 2018 The xi-editor Authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Cocoa

class Marker {
    //let description: String
    let line: Int
    let color: NSColor

    init(_ line: Int, color: NSColor) {
        self.line = line
        self.color = color
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MarkerBar: NSView, CALayerDelegate {
    var markers: [Marker] = []
    var backgroundColor: NSColor = NSColor.clear
    var parent: EditViewController!

    var markerBarWidth: CGFloat = 16.0 {
        didSet {
            self.needsDisplay = true
        }
    }

    var markerHeight: CGFloat = 1.0 {
        didSet {
            self.needsDisplay = true
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.needsDisplay = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setMarker(_ items: [Marker]) {
        markers = items
        self.needsDisplay = true
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        backgroundColor.setFill()
        dirtyRect.fill()

        let path = NSBezierPath()
        path.lineWidth = 1
        path.move(to: CGPoint(x: dirtyRect.minX, y: dirtyRect.minY))
        path.line(to: CGPoint(x: dirtyRect.maxX, y: dirtyRect.minY))
        path.stroke()

        for marker in markers {
            let totalLines = CGFloat(parent.lines.height)
            let visiblesLines = CGFloat(parent.visibleLines.count)
            let lineHeight = parent.textMetrics.linespace
            let markerBarHeight = CGFloat(min(totalLines, visiblesLines)) * lineHeight

            marker.color.setFill()
            marker.color.setStroke()
            path.lineWidth = markerHeight
            path.move(to: CGPoint(x: dirtyRect.minX, y: dirtyRect.maxY - CGFloat(marker.line) / (totalLines - 1) * markerBarHeight))
            path.line(to: CGPoint(x: dirtyRect.maxX, y: dirtyRect.maxY - CGFloat(marker.line) / (totalLines - 1) * markerBarHeight))
            path.stroke()
        }
    }
}