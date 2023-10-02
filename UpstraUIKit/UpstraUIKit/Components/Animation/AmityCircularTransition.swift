//
//  AmityCircularTransition.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 1/12/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit

final class AmityCircularTransition {
    
    private var containerView = UIView()
    private var circleView = UIView()
    
    var circleColor: UIColor = UIColor.white
    var presentedView: UIView?
    
    private var presenterViewCenter: CGPoint = CGPoint.zero
    
    var startingPoint = CGPoint.zero
    
    var duration: TimeInterval = 0.3
    
    func show(for contentView: UIView) {
        if let presentedView = self.presentedView {
            containerView.frame = UIScreen.main.bounds
            presentedView.frame = containerView.frame
            let viewCenter = containerView.center
            let viewSize = containerView.frame.size
            
            circleView = UIView()
            circleView.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
            circleView.layer.cornerRadius = circleView.frame.size.height / 2
            circleView.center = startingPoint
            circleView.backgroundColor = circleColor
            circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            containerView.addSubview(circleView)
            
            presenterViewCenter = viewCenter
            presentedView.center = startingPoint
            
            containerView.addSubview(presentedView)
            
            contentView.addSubview(containerView)
            
            UIView.animate(withDuration: duration) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.circleView.transform = CGAffineTransform.identity
                strongSelf.presentedView?.center = strongSelf.presenterViewCenter
            }
        }
    }
    
    func hide() {
        if let presentedView = presentedView {
            let viewCenter = containerView.center
            let viewSize = containerView.frame.size
            
            circleView.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
            
            circleView.layer.cornerRadius = circleView.frame.size.height / 2
            circleView.center = startingPoint
            UIView.animate(withDuration: duration, animations: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                strongSelf.presentedView?.center = strongSelf.startingPoint
            }, completion: { [weak self] (success) in
                guard let strongSelf = self else { return }
                presentedView.center = viewCenter
                strongSelf.circleView.removeFromSuperview()
                strongSelf.presentedView?.removeFromSuperview()
                strongSelf.containerView.removeFromSuperview()
            })
        }
    }
    
}

private extension AmityCircularTransition {
    func frameForCircle (withViewCenter viewCenter:CGPoint, size viewSize:CGSize, startPoint:CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)
        
        let offestVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offestVector, height: offestVector)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
}
