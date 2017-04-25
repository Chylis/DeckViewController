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
        rootVc.view.backgroundColor = UIColor.magenta
        
        rootVc.addChildViewController(vc)
        rootVc.view.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.widthAnchor.constraint(equalTo: rootVc.view.widthAnchor, multiplier: 0.5).isActive = true
        vc.view.heightAnchor.constraint(equalTo: rootVc.view.widthAnchor, multiplier: 0.5).isActive = true
        vc.view.centerXAnchor.constraint(equalTo: rootVc.view.centerXAnchor).isActive = true
        vc.view.centerYAnchor.constraint(equalTo: rootVc.view.centerYAnchor).isActive = true
        vc.didMove(toParentViewController: rootVc)
        
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

