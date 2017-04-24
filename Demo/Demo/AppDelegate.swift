//
//  AppDelegate.swift
//  Demo
//
//  Created by Magnus Eriksson on 2017-04-23.
//  Copyright © 2017 Magnus Eriksson. All rights reserved.
//

import UIKit
import StackViewController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        let vc = StackViewControllerFactory.makeWithContentViews(createViews(count: 10))
        let rootVc = UIViewController()
        rootVc.view.addSubview(vc.view)
        vc.view.bounds = CGRect(x: 0,
                               y: 0,
                               width: window.screen.bounds.size.width/2.0,
                               height: window.screen.bounds.size.width/2.0)
        vc.view.center = rootVc.view.center
        window.rootViewController = rootVc
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
    
    private func createViews(count: Int) -> [UIView] {
        return (0..<count).map { i -> UIView in
            let view = UIView()
            view.backgroundColor = UIColor.random
            return view
        }
    }
}

extension UIColor {
    fileprivate static var random: UIColor {
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
    }
}

