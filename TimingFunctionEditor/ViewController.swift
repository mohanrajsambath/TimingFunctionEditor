//
//  ViewController.swift
//  TimingFunctionEditor
//
//  Created by Jonathan Wight on 3/12/15.
//  Copyright (c) 2015 schwa. All rights reserved.
//

import Cocoa

class NamedCurve: NSObject {
    var name:String
    var controlPoints:[CGPoint]

    init(name:String, controlPoints:[CGPoint]) {
        self.name = name
        self.controlPoints = controlPoints
    }
    convenience init(name:String, controls:[CGFloat]) {
        self.init(name:name, controlPoints:[ CGPoint(x:controls[0], y:controls[1]), CGPoint(x:controls[2], y:controls[3]) ])
    }
}


class ViewController: NSViewController {

    @IBOutlet var bezierCurveEditorView: BezierCurveEditorView!
    @IBOutlet var previewView: PreviewView!

    @objc dynamic var namedCurves: [NamedCurve]!
    @objc dynamic var selectionIndexes: NSIndexSet! {
        didSet {
            update()
        }
    }
    @objc dynamic var codeSnippet: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        namedCurves = [
            NamedCurve(name: "Linear", controlPoints: [ CGPoint(x:0,y:0), CGPoint(x:1,y:1) ]),

            NamedCurve(name: "CoreAnimation Default", controlPoints: [ CGPoint(x:0.25,y:0.1), CGPoint(x:0.25,y:0.1) ]),
            NamedCurve(name: "CoreAnimation Ease In Ease Out", controlPoints: [ CGPoint(x:0.42,y:0), CGPoint(x:0.58,y:1) ]),
            NamedCurve(name: "CoreAnimation Ease In", controlPoints: [ CGPoint(x:0.42,y:0), CGPoint(x:1.0,y:1) ]),
            NamedCurve(name: "CoreAnimation Ease Out", controlPoints: [ CGPoint(x:0,y:0), CGPoint(x:0.58,y:1) ]),

            NamedCurve(name: "easeInSine", controls: [0.39, 0.575, 0.565, 1]),
            NamedCurve(name: "easeOutSine", controls: [0.445, 0.05, 0.55, 0.95]),
            NamedCurve(name: "easeInOutSine", controls: [0.55, 0.085, 0.68, 0.53]),
            NamedCurve(name: "easeInQuad", controls: [0.25, 0.46, 0.45, 0.94]),
            NamedCurve(name: "easeOutQuad", controls: [0.455, 0.03, 0.515, 0.955]),
            NamedCurve(name: "easeInOutQuad", controls: [0.55, 0.055, 0.675, 0.19]),
            NamedCurve(name: "easeInCubic", controls: [0.215, 0.61, 0.355, 1]),
            NamedCurve(name: "easeOutCubic", controls: [0.645, 0.045, 0.355, 1]),
            NamedCurve(name: "easeInOutCubic", controls: [0.895, 0.03, 0.685, 0.22]),
            NamedCurve(name: "easeInQuart", controls: [0.165, 0.84, 0.44, 1]),
            NamedCurve(name: "easeOutQuart", controls: [0.77, 0, 0.175, 1]),
            NamedCurve(name: "easeInOutQuart", controls: [0.755, 0.05, 0.855, 0.06]),
            NamedCurve(name: "easeInQuint", controls: [0.23, 1, 0.32, 1]),
            NamedCurve(name: "easeOutQuint", controls: [0.86, 0, 0.07, 1]),
            NamedCurve(name: "easeInOutQuint", controls: [0.95, 0.05, 0.795, 0.035]),
            NamedCurve(name: "easeInExpo", controls: [0.19, 1, 0.22, 1]),
            NamedCurve(name: "easeOutExpo", controls: [1, 0, 0, 1]),
            NamedCurve(name: "easeInOutExpo", controls: [0.6, 0.04, 0.98, 0.335]),
            NamedCurve(name: "easeInCirc", controls: [0.075, 0.82, 0.165, 1]),
            NamedCurve(name: "easeOutCirc", controls: [0.785, 0.135, 0.15, 0.86]),
            NamedCurve(name: "easeInOutCirc", controls: [0.6, -0.28, 0.735, 0.045]),
            NamedCurve(name: "easeInBack", controls: [0.175, 0.885, 0.32, 1.275]),
            NamedCurve(name: "easeOutBack", controls: [0.68, -0.55, 0.265, 1.55]),
            NamedCurve(name: "easeInOutBack", controls: [0.68, -0.55, 0.265, 1.55]),


        ]

        bezierCurveEditorView.delegate = self
        bezierCurveEditorView.controlPoints = namedCurves[0].controlPoints
        previewView.controlPoints = bezierCurveEditorView.controlPoints

        update()
    }

    func update() {
        let index = selectionIndexes.firstIndex
        let controlPoints = namedCurves[index].controlPoints
        bezierCurveEditorView.controlPoints = controlPoints
        previewView.controlPoints = controlPoints
        updateSnippet(controlPoints)
    }

    func updateSnippet(controlPoints:[CGPoint]) {
        self.codeSnippet = "CAMediaTimingFunction(controlPoints: \(controlPoints[0].x), \(controlPoints[0].y), \(controlPoints[1].x), \(controlPoints[1].y))"
        }
}

extension ViewController: BezierCurveEditorViewDelegate {
    func bezierCurveEditorView(bezierCurveEditorView:BezierCurveEditorView, controlPointsDidChange:[CGPoint]) {
        previewView.controlPoints = controlPointsDidChange

        updateSnippet(controlPointsDidChange)
    }
}