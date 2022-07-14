//
//  SplashScreenView.swift
//  witBooster
//
//  Created by witworkapp on 11/4/20.
//

import Foundation
import UIKit
import PureLayout
import Lottie
class SplashScreenView: UIViewController {
    @IBOutlet weak var animationView: UIView!
    let animationViewLayer = AnimationView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let animation = Animation.named("lt_splashscreen", subdirectory: "lottie")
            self.animationViewLayer.animation = animation
            self.animationViewLayer.contentMode = .scaleAspectFit
            self.animationView.addSubview(self.animationViewLayer)
            self.animationViewLayer.autoPinEdgesToSuperviewEdges()
            
            self.animationViewLayer.play(fromProgress: 0,
                               toProgress: 1,
                               loopMode: LottieLoopMode.playOnce,
                               completion: { (finished) in
                                if finished {
                                    self.openLogin()
                                    debugPrint("Animation Complete")
                                } else {
                                    debugPrint("Animation cancelled")
                                }
            })
        }
    }

    func openLogin() {
        let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabbarViewController")
        self.navigationController?.pushViewController(loginView, animated: true)
    }
}
