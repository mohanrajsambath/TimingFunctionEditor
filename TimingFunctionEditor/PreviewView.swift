//
//  PreviewView.swift
//  TimingFunctionEditor
//
//  Created by Jonathan Wight on 3/12/15.
//  Copyright (c) 2015 schwa. All rights reserved.
//

import Cocoa

import SwiftGraphics

class PreviewView: NSView {

    var demoLayer:CALayer!
    var controlPoints:[CGPoint] = []

    required init?(coder: NSCoder) {
        super.init(coder:coder)
        self.wantsLayer = true

        addGestureRecognizer(NSClickGestureRecognizer(target: self, action: Selector("click:")))

        layer?.backgroundColor = CGColor.lightGrayColor()

        demoLayer = CALayer()
        demoLayer.frame = CGRect(x:0, y:0, width:bounds.size.height, height:bounds.size.height)
        demoLayer.backgroundColor = CGColor.redColor()


        layer?.addSublayer(demoLayer)
    }

    func click(gestureRecognizer:NSGestureRecognizer!) {


        var slideAnimation = CABasicAnimation(keyPath: "position.x")
        slideAnimation.fromValue = demoLayer.position.x
        slideAnimation.toValue = bounds.size.width - demoLayer.frame.size.width * 0.5
        slideAnimation.beginTime = 0
        slideAnimation.duration = 1.0

        println(controlPoints)
        slideAnimation.timingFunction = CAMediaTimingFunction(controlPoints: Float(controlPoints[0].x), Float(controlPoints[0].y), Float(controlPoints[1].x), Float(controlPoints[1].y))


        var hangAnimation = CABasicAnimation(keyPath: "position.x")
        hangAnimation.fromValue = slideAnimation.toValue
        hangAnimation.toValue = slideAnimation.toValue
        hangAnimation.beginTime = slideAnimation.beginTime + slideAnimation.duration
        hangAnimation.duration = 0.5

        println(hangAnimation.beginTime)

        var groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [slideAnimation, hangAnimation]
        groupAnimation.duration = slideAnimation.duration + hangAnimation.duration

        demoLayer.addAnimation(groupAnimation, forKey: "demo")
    }

}
