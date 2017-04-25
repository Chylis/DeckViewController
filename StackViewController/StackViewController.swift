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
    var circulateViews: Bool = true
    
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
                view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onPan(_:))))
            }
            
            //Rotate the 'numberOfVisibleCards' last cards
            for (index, view) in contentViews.suffix(numberOfVisibleCards).dropLast().enumerated() {
                let direction: Float = index % 2 == 0 ? 1.0 : -1.0
                let degrees: Float = Float(index+1) * rotationAngle * direction
                view.layer.transform = CATransform3DRotate(view.layer.transform, CGFloat(GLKMathDegreesToRadians(degrees)), 0, 0, 1)
            }
        }
    }
    
    
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
    
    //MARK: - Pan
    
//    private func calculateAnimationSecondsFromRemainingDistance(_ distance: CGFloat, velocityPointsPerSecond: CGFloat) {
//        let seconds = fabs(distance / velocityPointsPerSecond)
//    }
//    
//    const CGFloat MinSeconds = DEFAULT_ANIMATION_DURATION*2;
//    const CGFloat MaxSeconds = DEFAULT_ANIMATION_DURATION*5;
//    
//    CGFloat seconds = fabs(remainingDistance / velocityPointsPerSecond);
//    if (seconds < MinSeconds){
//    seconds = MinSeconds;
//    } else if (seconds > MaxSeconds){
//    seconds = MaxSeconds;
//    }
//    
//    DLog(@"Animation seconds: %f", seconds);
//    return seconds;
//    }
    
    @objc private func onPan(_ sender: UIPanGestureRecognizer) {
        guard let contentView = sender.view else {
            return
        }
        
        let translationInDeck = sender.translation(in: contentContainerView)
        let translationInSuperview = sender.translation(in: view.superview!)
        
        print("x deck: \(translationInDeck.x), x super: \(translationInSuperview.x), y deck: \(translationInDeck.y), y super: \(translationInSuperview.y)")
        
        switch sender.state {
        case .began:
            UIView.animate(withDuration: 0.25) {
                contentView.layer.transform = CATransform3DMakeTranslation(0, 0, 100)
            }
        case .changed:
            //2) On pan changed, move the second top card interactively towards CATransform3DIdentity
            contentView.layer.transform = CATransform3DMakeTranslation(translationInSuperview.x, translationInSuperview.y, 100)
            
        case .ended, .cancelled:
            UIView.animate(withDuration: 0.25) {
                contentView.layer.transform = CATransform3DMakeTranslation(translationInSuperview.x, translationInSuperview.y, 0)
            }
            
            let discardView = translationInDeck.x < -(contentContainerView.bounds.width / 2.0) ||
                translationInDeck.x > contentContainerView.bounds.width / 2.0
            
            if discardView {
                // Hide view animated
                
            } else {
                
            }
            
            
            let remainingDistance = sender.translation(in: view.superview!).x
            let velocityPointsPerSeconds = sender.velocity(in: view.superview!).x
            let velocityPerSecond = fabs(velocityPointsPerSeconds / remainingDistance)
            let animationDurationSeconds = Double(fabs(remainingDistance / velocityPointsPerSeconds))
            
            print("remaining distance: \(remainingDistance)")
            
            UIView.animate(withDuration: animationDurationSeconds,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: velocityPerSecond,
                           options: .curveLinear,
                           animations: { 
                            contentView.layer.transform = CATransform3DMakeTranslation(contentView.bounds.width * -1.5, 0, 0)
            }, completion: { _ in
                if self.circulateViews {
                    contentView.layer.transform = CATransform3DIdentity;
                }
            })
    
//            if sender.view?.layer.transform.
            //3) On pan ended: use velocity to send the view. Maybe an animation like when dropping an item to the trashcan?
            break
            
        case .failed, .possible:
            break
        }
        
//        sender.setTranslation(CGPoint(x: 1, y: 1), in: self.view)
    }
}
