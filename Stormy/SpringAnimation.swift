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

func spring(_ duration: TimeInterval, animations: (() -> Void)!) {
    
    UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations: {
        
        animations()
        
        }, completion: { finished in
            
    })
}

func springWithDelay(_ duration: TimeInterval, delay: TimeInterval, animations: (() -> Void)!) {
    
    UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
        
        animations()
        
        }, completion: { finished in
            
    })
}

func slideUp(_ duration: TimeInterval, animations: (() -> Void)!) {
    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
        
        animations()
        
        }, completion: nil)
}

func springWithCompletion(_ duration: TimeInterval, animations: (() -> Void)!, completion: ((Bool) -> Void)!) {
    
    UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations: {
        
        animations()
        
        }, completion: { finished in
            completion(true)
    })
}

func springScaleFrom (_ view: UIView, x: CGFloat, y: CGFloat, scaleX: CGFloat, scaleY: CGFloat) {
    let translation = CGAffineTransform(translationX: x, y: y)
    let scale = CGAffineTransform(scaleX: scaleX, y: scaleY)
    view.transform = translation.concatenating(scale)
    
    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations: {
        
        let translation = CGAffineTransform(translationX: 0, y: 0)
        let scale = CGAffineTransform(scaleX: 1, y: 1)
        view.transform = translation.concatenating(scale)
        
        }, completion: nil)
}

func springScaleTo (_ view: UIView, x: CGFloat, y: CGFloat, scaleX: CGFloat, scaleY: CGFloat) {
    let translation = CGAffineTransform(translationX: 0, y: 0)
    let scale = CGAffineTransform(scaleX: 1, y: 1)
    view.transform = translation.concatenating(scale)
    
    UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations: {
        
        let translation = CGAffineTransform(translationX: x, y: y)
        let scale = CGAffineTransform(scaleX: scaleX, y: scaleY)
        view.transform = translation.concatenating(scale)
        
        }, completion: nil)
}

func popoverTopRight(_ view: UIView) {
    view.isHidden = false
    let translate = CGAffineTransform(translationX: 200, y: -200)
    let scale = CGAffineTransform(scaleX: 0.3, y: 0.3)
    view.alpha = 0
    view.transform = translate.concatenating(scale)
    
    UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [], animations: {
        
        let translate = CGAffineTransform(translationX: 0, y: 0)
        let scale = CGAffineTransform(scaleX: 1, y: 1)
        view.transform = translate.concatenating(scale)
        view.alpha = 1
        
        }, completion: nil)
}
