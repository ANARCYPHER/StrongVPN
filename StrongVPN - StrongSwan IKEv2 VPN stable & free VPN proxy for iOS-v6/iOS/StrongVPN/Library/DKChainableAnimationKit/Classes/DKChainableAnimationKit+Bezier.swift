//
//  DKChainableAnimationKit+Bezier.swift
//  DKChainableAnimationKit
//
//  Created by Draveness on 15/6/14.
//  Copyright (c) 2015年 Draveness. All rights reserved.
//

import UIKit

public extension DKChainableAnimationKit {

    func moveOnPath(_ path: UIBezierPath) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let pathAnimation = self.basicAnimationForKeyPath("position")
            pathAnimation.path = path.cgPath
            self.addAnimationFromCalculationBlock(pathAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let endPoint = path.currentPoint
            view.layer.position = endPoint
        }
        return self
    }

    func moveAndRotateOnPath(_ path: UIBezierPath) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let pathAnimation = self.basicAnimationForKeyPath("position")
            pathAnimation.path = path.cgPath
            pathAnimation.rotationMode = CAAnimationRotationMode.rotateAuto
            self.addAnimationFromCalculationBlock(pathAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let endPoint = path.currentPoint
            view.layer.position = endPoint
        }
        return self
    }

    func moveAndReverseRotateOnPath(_ path: UIBezierPath) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let pathAnimation = self.basicAnimationForKeyPath("position")
            pathAnimation.path = path.cgPath
            pathAnimation.rotationMode = CAAnimationRotationMode.rotateAutoReverse
            self.addAnimationFromCalculationBlock(pathAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let endPoint = path.currentPoint
            view.layer.position = endPoint
        }
        return self
    }
}
