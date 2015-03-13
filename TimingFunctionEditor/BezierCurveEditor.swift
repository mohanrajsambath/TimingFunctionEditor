//
//  BezierCurveEditor.swift
//  TimingFunctionEditor
//
//  Created by Jonathan Wight on 3/12/15.
//  Copyright (c) 2015 schwa. All rights reserved.
//

import Cocoa

import SwiftGraphics

class Handle {
    var position:CGPoint

    init(position:CGPoint) {
        self.position = position
    }
}

protocol BezierCurveEditorViewDelegate {
    func bezierCurveEditorView(bezierCurveEditorView:BezierCurveEditorView, controlPointsDidChange:[CGPoint])
}

class BezierCurveEditorView: NSView {

    var delegate:BezierCurveEditorViewDelegate?

    var handles:[Handle] = [ Handle(position:CGPoint(x:0,y:0)), Handle(position:CGPoint(x:1,y:1)) ]
    private var draggedHandle:Handle?

    var controlPoints:[CGPoint] {
        get {
            return [handles[0].position, handles[1].position]
        }
        set {
            handles[0].position = newValue[0]
            handles[1].position = newValue[1]
            needsDisplay = true
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder:coder)

        addGestureRecognizer(NSPanGestureRecognizer(target: self, action: Selector("pan:")))
    }


    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        let context = NSGraphicsContext.currentContext()!.CGContext

        context.fillColor = CGColor.color(white: 0.95, alpha: 1.0)
        CGContextFillRect(context, bounds)

        CGContextTranslateCTM(context, bounds.midX - 100, bounds.midY - 100)

        let scale = CGAffineTransform(scale: CGSize(w:200, h:200))
        let controlPoint0 = handles[0].position
        let controlPoint1 = handles[1].position
        var bezierCurve = BezierCurve(start:CGPoint(x:0, y:0), controls:[controlPoint0, controlPoint1], end:CGPoint(x:1, y:1))
        bezierCurve = bezierCurve * scale

        var path = CGPathCreateMutable()
        path.move(CGPoint(x:0, y:0) * scale)
        path.addCurve(bezierCurve)
        path.addLine(CGPoint(x:1, y:0) * scale)
        path.close()

        context.with() {
            CGContextClipToRect(context, CGRect(size:CGSize(w:200, h:200)))

            context.fillColor = CGColor.whiteColor()
            context.fillRect(CGRect(size:CGSize(w:200, h:200)))

            context.fillColor = CGColor.greenColor().withAlpha(0.1)
            context.fillRect(CGRect(size:CGSize(w:200, h:200)))


            context.fillColor = CGColor.whiteColor()
            context.fillPath(path)
            context.fillColor = CGColor.redColor().withAlpha(0.1)
            context.fillPath(path)
        }

        context.lineWidth = 4
        context.strokeColor = CGColor.redColor()
        context.stroke(bezierCurve)

        context.lineWidth = 1
        context.strokeColor = CGColor.blackColor()
        context.strokeLine(CGPoint(x:0, y:0) * scale, controlPoint0 * scale)
        context.strokeLine(CGPoint(x:1, y:1) * scale, controlPoint1 * scale)

        var handleStyle = Style(elements: [
            .fillColor(CGColor.blueColor())
            ])

        context.draw(Circle(center: controlPoint0 * scale, diameter: 10), style:handleStyle)
        context.draw(Circle(center: controlPoint1 * scale, diameter: 10), style:handleStyle)

    }

    func pan(gestureRecognizer:NSPanGestureRecognizer) {



        let transform = CGAffineTransform(scale: CGSize(w:200, h:200)) + CGAffineTransform(tx: bounds.midX - 100, ty: bounds.midY - 100)


        let location = gestureRecognizer.locationInView(self)

        switch gestureRecognizer.state {
            case .Began:
                if ((handles[0].position * transform) - location).magnitude < ((handles[1].position * transform) - location).magnitude {
                    draggedHandle = handles[0]
                }
                else {
                    draggedHandle = handles[1]

                }
            case .Changed:
                var scaledLocation = location * transform.inverted()
                draggedHandle?.position = scaledLocation

                delegate?.bezierCurveEditorView(self, controlPointsDidChange: controlPoints)

                needsDisplay = true


            default:
                break
        }


    }

}
