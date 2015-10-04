//
//  SpringAnimation.swift
//  Stormy
//  Created by Aaron A
//  Big Thanks goes out to Meng To for this :) Check out his site https://designcode.io

import Foundation

import UIKit

var duration = 0.7
var delay = 0.0
var damping = 0.7
var velocity = 0.7

func spring(duration: NSTimeInterval, animations: (() -> Void)!) {
    
    UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations: {
        
        animations()
        
        }, completion: { finished in
            
    })
}

func springWithDelay(duration: NSTimeInterval, delay: NSTimeInterval, animations: (() -> Void)!) {
    
    UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
        
        animations()
        
        }, completion: { finished in
            
    })
}

func slideUp(duration: NSTimeInterval, animations: (() -> Void)!) {
    UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
        
        animations()
        
        }, completion: nil)
}

func springWithCompletion(duration: NSTimeInterval, animations: (() -> Void)!, completion: ((Bool) -> Void)!) {
    
    UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations: {
        
        animations()
        
        }, completion: { finished in
            completion(true)
    })
}

func springScaleFrom (view: UIView, x: CGFloat, y: CGFloat, scaleX: CGFloat, scaleY: CGFloat) {
    let translation = CGAffineTransformMakeTranslation(x, y)
    let scale = CGAffineTransformMakeScale(scaleX, scaleY)
    view.transform = CGAffineTransformConcat(translation, scale)
    
    UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations: {
        
        let translation = CGAffineTransformMakeTranslation(0, 0)
        let scale = CGAffineTransformMakeScale(1, 1)
        view.transform = CGAffineTransformConcat(translation, scale)
        
        }, completion: nil)
}

func springScaleTo (view: UIView, x: CGFloat, y: CGFloat, scaleX: CGFloat, scaleY: CGFloat) {
    let translation = CGAffineTransformMakeTranslation(0, 0)
    let scale = CGAffineTransformMakeScale(1, 1)
    view.transform = CGAffineTransformConcat(translation, scale)
    
    UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations: {
        
        let translation = CGAffineTransformMakeTranslation(x, y)
        let scale = CGAffineTransformMakeScale(scaleX, scaleY)
        view.transform = CGAffineTransformConcat(translation, scale)
        
        }, completion: nil)
}

func popoverTopRight(view: UIView) {
    view.hidden = false
    let translate = CGAffineTransformMakeTranslation(200, -200)
    let scale = CGAffineTransformMakeScale(0.3, 0.3)
    view.alpha = 0
    view.transform = CGAffineTransformConcat(translate, scale)
    
    UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [], animations: {
        
        let translate = CGAffineTransformMakeTranslation(0, 0)
        let scale = CGAffineTransformMakeScale(1, 1)
        view.transform = CGAffineTransformConcat(translate, scale)
        view.alpha = 1
        
        }, completion: nil)
}