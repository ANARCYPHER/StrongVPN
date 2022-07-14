
//
//  DKKeyframeAnimationFunction.swift
//  DKChainableAnimationKit
//
//  Copyright (c) 2015年 Draveness. All rights reserved.
//  This is a swift port for https://github.com/NachoSoto/NSBKeyframeAnimation/blob/master/NSBKeyframeAnimation/Classes/NSBKeyframeAnimation/NSBKeyframeAnimationFunctions.c file.

import UIKit

typealias DKKeyframeAnimationFunctionBlock = (Double, Double, Double, Double) -> Double

func DKKeyframeAnimationFunctionLinear(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    let t = t / d
    return c * t + b
}

func DKKeyframeAnimationFunctionEaseInQuad(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    let t = t / d
    return c * t * t + b;
}

func DKKeyframeAnimationFunctionEaseOutQuad(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    let t = t / d
    return -c * t * (t - 2) + b;
}

func DKKeyframeAnimationFunctionEaseInOutQuad(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    var t = t / (d / 2)
    if t < 1 {
        return c / 2 * t * t + b;
    }
    t -= 1
    return -c / 2 * ((t) * (t - 2) - 1) + b;
}

func DKKeyframeAnimationFunctionEaseInCubic(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    let t = t / d
    return c * t * t * t + b;
}

func DKKeyframeAnimationFunctionEaseOutCubic(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    let t = t / d - 1
    return c * (t * t * t + 1) + b;
}

func DKKeyframeAnimationFunctionEaseInOutCubic(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    var t = t / (d / 2)
    if t < 1 {
        return c / 2 * t * t * t + b;
    } else {
        t -= 2
        return c / 2 * (t * t * t + 2) + b;
    }
}

func DKKeyframeAnimationFunctionEaseInQuart(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    let t = t / d
    return c * t * t * t * t + b;
}

func DKKeyframeAnimationFunctionEaseOutQuart(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    let t = t / d - 1
    return -c * (t * t * t * t - 1) + b;
}

func DKKeyframeAnimationFunctionEaseInOutQuart(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    var t = t / (d / 2)
    if t < 1 {
        return c / 2 * t * t * t * t + b;
    } else {
        t -= 2
        return -c / 2 * (t * t * t * t - 2) + b;
    }
}

func DKKeyframeAnimationFunctionEaseInQuint(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    let t = t / d
    return c * t * t * t * t * t + b;
}

func DKKeyframeAnimationFunctionEaseOutQuint(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    let t = t / d - 1
    return c * (t * t * t * t * t + 1) + b;
}

func DKKeyframeAnimationFunctionEaseInOutQuint(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    var t = t / (d / 2)
    if t < 1 {
        return c / 2 * t * t * t * t * t + b;
    } else {
        t -= 2
        return c / 2 * (t * t * t * t * t + 2) + b;
    }
}

func DKKeyframeAnimationFunctionEaseInSine(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    return -c * cos(t / d * (Double.pi / 2)) + c + b;
}

func DKKeyframeAnimationFunctionEaseOutSine(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    return c * sin(t / d * (Double.pi / 2)) + b;
}

func DKKeyframeAnimationFunctionEaseInOutSine(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    return -c / 2 * (cos(Double.pi * t / d) - 1) + b;
}

func DKKeyframeAnimationFunctionEaseInExpo(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    return (t==0) ? b : c * pow(2, 10 * (t / d - 1)) + b;
}

func DKKeyframeAnimationFunctionEaseOutExpo(_ t: Double, b: Double, c: Double, d: Double) -> Double {

    return (t == d) ? b+c : c * (-pow(2, -10 * t / d) + 1) + b;
}

func DKKeyframeAnimationFunctionEaseInOutExpo(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    if t == 0 {
        return b
    }
    if t == d {
        return b + c
    }
    var t = t / (d / 2)
    if t < 1 {
        return c / 2 * pow(2, 10 * (t - 1)) + b
    }
    t -= 1
    return c / 2 * (-pow(2, -10 * t) + 2) + b
}

func DKKeyframeAnimationFunctionEaseInCirc(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    let t = t / d
    return -c * (sqrt(1 - t * t) - 1) + b;
}

func DKKeyframeAnimationFunctionEaseOutCirc(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    let t = t / d - 1
    return c * sqrt(1 - t * t) + b
}

func DKKeyframeAnimationFunctionEaseInOutCirc(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    var t = t / (d / 2)
    if t < 1 {
        return -c / 2 * (sqrt(1 - t * t) - 1) + b
    }
    t -= 2
    return c / 2 * (sqrt(1 - t * t) + 1) + b
}

func DKKeyframeAnimationFunctionEaseInElastic(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    var s = 1.70158
    var p = 0.0
    var a = c

    if t == 0 {
        return b
    }
    var t = t / d
    if t == 1 {
        return b + c
    }
    if p == 0.0 {
        p = d * 0.3
    }
    if a < fabs(c) {
        a = c
        s = p / 4
    } else {
        s = p / (2 * Double.pi) * asin (c / a)
    }
    t -= 1
    return -(a * pow(2, 10 * t) * sin((t * d - s) * (2 * Double.pi) / p )) + b;
}

func DKKeyframeAnimationFunctionEaseOutElastic(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    var s = 1.70158
    var p = 0.0
    var a = c
    if t == 0 {
        return b
    }
    var t = t / d
    if t == 1 {
        return b + c
    }
    if p == 0.0 {
        p = d * 0.3
    }
    if a < fabs(c) {
        a = c
        s = p / 4
    } else {
        s = p / (2 * Double.pi) * asin (c / a)
    }
    t -= 1
    return (a * pow(2, 10 * t) * sin((t * d - s) * (2 * Double.pi) / p)) + b;
}

func DKKeyframeAnimationFunctionEaseInOutElastic(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    var s = 1.70158
    var p = 0.0
    var a = c;
    if t == 0 {
        return b
    }
    var t = t / d
    if t == 2 {
        return b + c
    }
    if p == 0.0 {
        p = d * 0.3 * 1.5
    }
    if a < fabs(c) {
        a = c
        s = p / 4
    } else {
        s = p / (2 * Double.pi) * asin (c / a)
    }

    if t < 1 {
        t -= 1
        return -0.5 * (a * pow(2,10 * t) * sin( (t * d - s) * (2 * Double.pi) / p )) + b
    } else {
        t -= 1
        return a * pow(2,-10 * t) * sin( (t * d - s) * (2 * Double.pi) / p ) * 0.5 + c + b
    }
}

func DKKeyframeAnimationFunctionEaseInBack(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    let s = 1.70158
    let t = t / d
    return c * t * t * ((s + 1) * t - s) + b;
}

func DKKeyframeAnimationFunctionEaseOutBack(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    let s = 1.70158
    let t = t / d - 1
    return c * (t * t * ((s + 1) * t + s) + 1) + b;
}

func DKKeyframeAnimationFunctionEaseInOutBack(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    var s = 1.70158
    var t = t / (d / 2)

    if t < 1 {
        s *= 1.525
        return c / 2 * (t * t * ((s + 1) * t - s)) + b;
    } else {
        t -= 2
        s *= 1.525
        return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b;
    }
}

func DKKeyframeAnimationFunctionEaseInBounce(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    return c - DKKeyframeAnimationFunctionEaseOutBounce(d - t, b: 0, c: c, d: d) + b;
}

func DKKeyframeAnimationFunctionEaseOutBounce(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    var t = t / d
    if t < 1 / 2.75 {
        return c * (7.5625 * t * t) + b;
    } else if t < 2 / 2.75 {
        t -= 1.5 / 2.75
        return c * (7.5625 * t * t + 0.75) + b;
    } else if t < 2.5 / 2.75 {
        t -= 2.25 / 2.75
        return c * (7.5625 * t * t + 0.9375) + b;
    } else {
        t -= 2.625 / 2.75
        return c * (7.5625 * t * t + 0.984375) + b;
    }
}

func DKKeyframeAnimationFunctionEaseInOutBounce(_ t: Double, b: Double, c: Double, d: Double) -> Double {
    if t < d / 2 {
        return DKKeyframeAnimationFunctionEaseInBounce (t * 2, b: 0, c: c, d: d) * 0.5 + b;
    } else {
        return DKKeyframeAnimationFunctionEaseOutBounce(t * 2 - d, b: 0, c: c, d: d) * 0.5 + c * 0.5 + b;
    }
}
