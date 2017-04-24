//
//  StackViewController.swift
//  StackViewController
//
//  Created by Magnus Eriksson on 2017-04-23.
//  Copyright © 2017 Magnus Eriksson. All rights reserved.
//

import UIKit
import GLKit

public final class StackViewControllerFactory {
    public static func makeWithContentViews(_ contentViews: [UIView]) -> StackViewController {
        let vc = StackViewController()
        vc.contentViews = contentViews
        return vc
    }
}

//TODO: Rename to DeckViewController
public final class StackViewController: UIViewController {
    
    //MARK -  Public Properties
    
    //The number of visible cards, seen from above
    var numberOfVisibleCards = 6
    
    //The number of degrees to rotate the visible cards
    var rotationAngle: Float = 2.0
    
    //Circular setting (when discarding a card from the deck should it go back to the bot of the deck?)
    
    var contentViews: [UIView] = [] {
        didSet {
            contentContainerView.subviews.forEach { $0.removeFromSuperview() }
            contentViews.forEach { view in
                contentContainerView.addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false;
                view.widthAnchor.constraint(equalTo: contentContainerView.widthAnchor).isActive = true
                view.heightAnchor.constraint(equalTo: contentContainerView.heightAnchor).isActive = true
                view.centerXAnchor.constraint(equalTo: contentContainerView.centerXAnchor).isActive = true
                view.centerYAnchor.constraint(equalTo: contentContainerView.centerYAnchor).isActive = true
            }
            
            for (index, view) in contentViews.suffix(numberOfVisibleCards).dropLast().enumerated() {
                let direction: Float = index % 2 == 0 ? 1.0 : -1.0
                let degrees: Float = Float(index+1) * rotationAngle * direction
                view.layer.transform = CATransform3DMakeRotation(CGFloat(GLKMathDegreesToRadians(degrees)), 0, 0, 1)
            }
        }
    }
    
    //1) Add pan gesture recognizer
    //2) On pan changed, move the second top card interactively towards CATransform3DIdentity
    //3) On pan ended: use velocity to send the view. Maybe an animation like when dropping an item to the trashcan?
    
    //MARK - Private Properties
    
    let contentContainerView = UIView()
    
    //MARK: - Life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        createLayout()
    }
    
    private func createLayout() {
        var perspective = CATransform3DIdentity; perspective.m34 = -1/500
        contentContainerView.layer.sublayerTransform = perspective
        
        view.addSubview(contentContainerView)
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalTo: contentContainerView.widthAnchor, multiplier: 1).isActive = true
        view.heightAnchor.constraint(equalTo: contentContainerView.heightAnchor, multiplier: 1).isActive = true
        view.centerXAnchor.constraint(equalTo: contentContainerView.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: contentContainerView.centerYAnchor).isActive = true
    }
}
