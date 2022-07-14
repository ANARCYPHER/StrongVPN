//
//  DKKeyFrameAnimation.swift
//  DKChainableAnimationKit
//
//  Created by Draveness on 15/5/13.
//  Copyright (c) 2015年 Draveness. All rights reserved.
//

import UIKit

open class DKKeyFrameAnimation: CAKeyframeAnimation {

    internal let kFPS = 60

    internal typealias DKKeyframeAnimationFunction = (Double, Double, Double, Double) -> Double;

    internal var fromValue: AnyObject!
    internal var toValue: AnyObject!
    internal var functionBlock: DKKeyframeAnimationFunction!

    convenience init(keyPath path: String!) {
        self.init()
        self.keyPath = path
        self.functionBlock = DKKeyframeAnimationFunctionLinear
    }

    internal func calculte() {
        self.createValueArray()
    }

    internal func createValueArray() {
        if let fromValue: AnyObject = self.fromValue, let toValue: AnyObject = self.toValue {
            if valueIsKindOf(NSNumber.self) {
                self.values = self.valueArrayFor(startValue: CGFloat(fromValue.floatValue), endValue: CGFloat(toValue.floatValue)) as [AnyObject]
            } else if valueIsKindOf(UIColor.self) {
                guard let fromColor = self.fromValue.cgColor else { fatalError("Could not extract CGColor") }
                guard let toColor = self.toValue.cgColor else { fatalError("Could not extract CGColor") }
                guard let fromComponents = fromColor.components else { fatalError("Could not extract color components") }
                guard let toComponents = toColor.components else { fatalError("Could not extract color components") }

                let red, green, blue: (start: CGFloat, end: CGFloat)
                let alphaStart = fromComponents.last
                let alphaEnd = toComponents.last

                let numberOfComponentsInMonotoneColor = 2

                switch fromColor.numberOfComponents {
                case numberOfComponentsInMonotoneColor:
                    red.start = fromComponents[0]
                    green.start = fromComponents[0]
                    blue.start = fromComponents[0]
                default:
                    red.start = fromComponents[0]
                    green.start = fromComponents[1]
                    blue.start = fromComponents[2]
                }

                switch toColor.numberOfComponents {
                case numberOfComponentsInMonotoneColor:
                    red.end = toComponents[0]
                    green.end = toComponents[0]
                    blue.end = toComponents[0]
                default:
                    red.end = toComponents[0]
                    green.end = toComponents[1]
                    blue.end = toComponents[2]
                }

                let redValues = self.valueArrayFor(startValue: red.start, endValue: red.end) as! [CGFloat]
                let greenValues = self.valueArrayFor(startValue: green.start, endValue: green.end) as! [CGFloat]
                let blueValues = self.valueArrayFor(startValue: blue.start, endValue: blue.end) as! [CGFloat]
                let alphaValues = self.valueArrayFor(startValue: alphaStart!, endValue: alphaEnd!) as! [CGFloat]

                self.values = self.colorArrayFrom(redValues: redValues, greenValues: greenValues, blueValues: blueValues, alphaValues: alphaValues) as [AnyObject]
            } else if valueIsKindOf(NSValue.self) {
                let valueType: NSString! = NSString(cString: self.fromValue.objCType, encoding: 1)
                if valueType.contains("CGRect") {
                    let fromRect = self.fromValue.cgRectValue
                    let toRect = self.toValue.cgRectValue

                    let xValues = self.valueArrayFor(startValue: (fromRect?.origin.x)!, endValue: (toRect?.origin.x)!) as! [CGFloat]
                    let yValues = self.valueArrayFor(startValue: (fromRect?.origin.y)!, endValue: (toRect?.origin.x)!) as! [CGFloat]
                    let widthValues = self.valueArrayFor(startValue: (fromRect?.size.width)!, endValue: (toRect?.size.width)!) as! [CGFloat]
                    let heightValues = self.valueArrayFor(startValue: (fromRect?.size.height)!, endValue: (toRect?.size.height)!) as! [CGFloat]

                    self.values = self.rectArrayFrom(xValues: xValues, yValues: yValues, widthValues: widthValues, heightValues: heightValues) as [AnyObject]

                } else if valueType.contains("CGPoint") {
                    let fromPoint = self.fromValue.cgPointValue
                    let toPoint = self.toValue.cgPointValue
                    let path = self.createPathFromXYValues(self.valueArrayFor(startValue: (fromPoint?.x)!, endValue: (toPoint?.x)!), yValues: self.valueArrayFor(startValue: (fromPoint?.y)!, endValue: (toPoint?.y)!))
                    self.path = path
                } else if valueType.contains("CGSize") {
                    let fromSize = self.fromValue.cgSizeValue
                    let toSize = self.toValue.cgSizeValue
                    let path = self.createPathFromXYValues(self.valueArrayFor(startValue: (fromSize?.width)!, endValue: (toSize?.width)!), yValues: self.valueArrayFor(startValue: (fromSize?.height)!, endValue: (toSize?.height)!))
                    self.path = path
                } else if valueType.contains("CATransform3D") {
                    let fromTransform = self.fromValue.caTransform3DValue
                    let toTransform = self.toValue.caTransform3DValue

                    let m11 = self.valueArrayFor(startValue: (fromTransform?.m11)!, endValue: (toTransform?.m11)!)
                    let m12 = self.valueArrayFor(startValue: (fromTransform?.m12)!, endValue: (toTransform?.m12)!)
                    let m13 = self.valueArrayFor(startValue: (fromTransform?.m13)!, endValue: (toTransform?.m13)!)
                    let m14 = self.valueArrayFor(startValue: (fromTransform?.m14)!, endValue: (toTransform?.m14)!)
                    let m21 = self.valueArrayFor(startValue: (fromTransform?.m21)!, endValue: (toTransform?.m21)!)
                    let m22 = self.valueArrayFor(startValue: (fromTransform?.m22)!, endValue: (toTransform?.m22)!)
                    let m23 = self.valueArrayFor(startValue: (fromTransform?.m23)!, endValue: (toTransform?.m23)!)
                    let m24 = self.valueArrayFor(startValue: (fromTransform?.m24)!, endValue: (toTransform?.m24)!)
                    let m31 = self.valueArrayFor(startValue: (fromTransform?.m31)!, endValue: (toTransform?.m31)!)
                    let m32 = self.valueArrayFor(startValue: (fromTransform?.m32)!, endValue: (toTransform?.m32)!)
                    let m33 = self.valueArrayFor(startValue: (fromTransform?.m33)!, endValue: (toTransform?.m33)!)
                    let m34 = self.valueArrayFor(startValue: (fromTransform?.m34)!, endValue: (toTransform?.m34)!)
                    let m41 = self.valueArrayFor(startValue: (fromTransform?.m41)!, endValue: (toTransform?.m41)!)
                    let m42 = self.valueArrayFor(startValue: (fromTransform?.m42)!, endValue: (toTransform?.m42)!)
                    let m43 = self.valueArrayFor(startValue: (fromTransform?.m43)!, endValue: (toTransform?.m43)!)
                    let m44 = self.valueArrayFor(startValue: (fromTransform?.m44)!, endValue: (toTransform?.m44)!)

                    self.values = self.createTransformArrayFrom(
                        m11: m11, m12: m12, m13: m13, m14: m14,
                        m21: m21, m22: m22, m23: m23, m24: m24,
                        m31: m31, m32: m32, m33: m33, m34: m34,
                        m41: m41, m42: m42, m43: m43, m44: m44) as [AnyObject]
                }
            }
            self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        }
    }

    fileprivate func createTransformArrayFrom(
        m11: NSArray, m12: NSArray, m13: NSArray, m14: NSArray,
        m21: NSArray, m22: NSArray, m23: NSArray, m24: NSArray,
        m31: NSArray, m32: NSArray, m33: NSArray, m34: NSArray,
        m41: NSArray, m42: NSArray, m43: NSArray, m44: NSArray) -> NSArray {
            let numberOfTransforms = m11.count;
            let values = NSMutableArray(capacity: numberOfTransforms)
            var value: CATransform3D!
            for i in 0..<numberOfTransforms {
                value = CATransform3DIdentity;
                value.m11 = CGFloat((m11.object(at: i) as AnyObject).floatValue)
                value.m12 = CGFloat((m12.object(at: i) as AnyObject).floatValue)
                value.m13 = CGFloat((m13.object(at: i) as AnyObject).floatValue)
                value.m14 = CGFloat((m14.object(at: i) as AnyObject).floatValue)

                value.m21 = CGFloat((m21.object(at: i) as AnyObject).floatValue)
                value.m22 = CGFloat((m22.object(at: i) as AnyObject).floatValue)
                value.m23 = CGFloat((m23.object(at: i) as AnyObject).floatValue)
                value.m24 = CGFloat((m24.object(at: i) as AnyObject).floatValue)

                value.m31 = CGFloat((m31.object(at: i) as AnyObject).floatValue)
                value.m32 = CGFloat((m32.object(at: i) as AnyObject).floatValue)
                value.m33 = CGFloat((m33.object(at: i) as AnyObject).floatValue)
                value.m44 = CGFloat((m34.object(at: i) as AnyObject).floatValue)

                value.m41 = CGFloat((m41.object(at: i) as AnyObject).floatValue)
                value.m42 = CGFloat((m42.object(at: i) as AnyObject).floatValue)
                value.m43 = CGFloat((m43.object(at: i) as AnyObject).floatValue)
                value.m44 = CGFloat((m44.object(at: i) as AnyObject).floatValue)

                values.add(NSValue(caTransform3D: value))
            }
            return values
    }

    fileprivate func createPathFromXYValues(_ xValues: NSArray, yValues: NSArray) -> CGPath {
        let numberOfPoints = xValues.count
        let path = CGMutablePath()
        var value = CGPoint(
            x: CGFloat((xValues.object(at: 0) as AnyObject).floatValue),
            y: CGFloat((yValues.object(at: 0) as AnyObject).floatValue))
        path.move(to: value)
        for i in 1..<numberOfPoints {
            value = CGPoint(
                x: CGFloat((xValues.object(at: i) as AnyObject).floatValue),
                y: CGFloat((yValues.object(at: i) as AnyObject).floatValue))
            path.move(to: value)
        }
        return path
    }

    fileprivate func valueIsKindOf(_ klass: AnyClass) -> Bool {
        return self.fromValue.isKind(of: klass) && self.toValue.isKind(of: klass)
    }

    fileprivate func rectArrayFrom(xValues: [CGFloat], yValues: [CGFloat], widthValues: [CGFloat], heightValues: [CGFloat]) -> NSArray {
        let numberOfRects = xValues.count
        let values: NSMutableArray = []
        var value: NSValue

        for i in 1..<numberOfRects {
            value = NSValue(cgRect: CGRect(x: xValues[i], y: yValues[i], width: widthValues[i], height: heightValues[i]))
            values.add(value)
        }
        return values

    }

    fileprivate func colorArrayFrom(redValues: [CGFloat], greenValues: [CGFloat], blueValues: [CGFloat], alphaValues: [CGFloat]) -> [CGColor] {
        let numberOfColors = redValues.count
        var values: [CGColor] = []
        var value: CGColor!

        for i in 1..<numberOfColors {
            value = UIColor(red: redValues[i], green: greenValues[i], blue: blueValues[i], alpha: alphaValues[i]).cgColor
            values.append(value)
        }
        return values
    }

    fileprivate func valueArrayFor(startValue: CGFloat, endValue: CGFloat) -> NSArray {
        let startValue = Double(startValue)
        let endValue = Double(endValue)

        let steps: Int = Int(ceil(Double(kFPS) * self.duration)) + 2
        let increment = 1.0 / (Double)(steps - 1)
        var progress = 0.0
        var v = 0.0
        var value = 0.0

        var valueArray: [Double] = []

        for _ in 0..<steps {
            v = self.functionBlock(self.duration * progress * 1000, 0, 1, self.duration * 1000);
            value = startValue + v * (endValue - startValue);

            valueArray.append(value)
            progress += increment
        }

        return valueArray as NSArray
    }

}
