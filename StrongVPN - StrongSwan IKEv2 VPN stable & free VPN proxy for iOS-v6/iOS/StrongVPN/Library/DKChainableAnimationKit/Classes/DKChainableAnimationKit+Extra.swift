//
//  DKChainableAnimationKit+Extra.swift
//  DKChainableAnimationKit
//
//  Created by Draveness on 15/6/14.
//  Copyright (c) 2015年 Draveness. All rights reserved.
//

import Foundation
import UIKit

public extension DKChainableAnimationKit {

    func makeOpacity(_ opacity: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let opacityAnimation = self.basicAnimationForKeyPath("opacity")
            opacityAnimation.fromValue = view.alpha as AnyObject
            opacityAnimation.toValue = opacity as AnyObject
            self.addAnimationFromCalculationBlock(opacityAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            view.alpha = opacity
        }
        return self
    }

    func makeAlpha(_ alpha: CGFloat) -> DKChainableAnimationKit {
        return makeOpacity(alpha)
    }

    func makeBackground(_ color: UIColor) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let backgroundColorAnimation = self.basicAnimationForKeyPath("backgroundColor")
            backgroundColorAnimation.fromValue = view.backgroundColor
            backgroundColorAnimation.toValue = color
            self.addAnimationFromCalculationBlock(backgroundColorAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            view.backgroundColor = color
        }
        return self
    }

    func makeBorderColor(_ color: UIColor) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let borderColorAnimation = self.basicAnimationForKeyPath("borderColor")
            borderColorAnimation.fromValue = UIColor(cgColor: view.layer.borderColor!)
            borderColorAnimation.toValue = color
            self.addAnimationFromCalculationBlock(borderColorAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            view.layer.borderColor = color.cgColor
        }
        return self
    }

    func makeBorderWidth(_ width: CGFloat) -> DKChainableAnimationKit {
        let width = max(0, width)
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let borderColorAnimation = self.basicAnimationForKeyPath("borderWidth")
            borderColorAnimation.fromValue = view.layer.borderWidth as AnyObject
            borderColorAnimation.toValue = width as AnyObject
            self.addAnimationFromCalculationBlock(borderColorAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            view.layer.borderWidth = width
        }
        return self
    }

    func makeCornerRadius(_ cornerRadius: CGFloat) -> DKChainableAnimationKit {
        let cornerRadius = max(0, cornerRadius)
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let cornerRadiusAnimation = self.basicAnimationForKeyPath("cornerRadius")
            cornerRadiusAnimation.fromValue = view.layer.cornerRadius as AnyObject
            cornerRadiusAnimation.toValue = cornerRadius as AnyObject
            self.addAnimationFromCalculationBlock(cornerRadiusAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            view.layer.cornerRadius = cornerRadius
        }
        return self
    }
}

