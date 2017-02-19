//
//  TooltipBlocker.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/8/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit

class TooltipBlocker {
	static let instance = TooltipBlocker()
	
	var blockingViews: [Int: TooltipBlockerView] = [:]
	
	subscript(_ window: UIWindow) -> TooltipBlockerView {
		if let view = self.blockingViews[window.hashValue] { return view }
		
		let view = TooltipBlockerView(frame: window.bounds)
		self.blockingViews[window.hashValue] = view
		view.setup()
		
		window.addSubview(view)
		view.isUserInteractionEnabled = false
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		
		if TooltipView.behavior.tapOutsideTipsToDismissAll {
			view.isUserInteractionEnabled = true
			view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
		}
		
		UIView.animate(withDuration: 0.2) { view.animateIn() }
		
		return view
	}
	
	@objc func tapped(_ recog: UITapGestureRecognizer) {
		self.hide(tips: self.allTips, duration: 0.05, interval: 0.05)
	}
	
	func hide(tips: [TooltipView], duration: TimeInterval, interval: TimeInterval) {
		var delay: TimeInterval = 0.1
		let queue = DispatchQueue.main
		
		tips.forEach { tip in
			queue.asyncAfter(deadline: .now() + delay) {
				tip.hide(over: duration)
			}
			delay += interval
		}
	}
	
	var allTips: [TooltipView] {
		return self.blockingViews.values.reduce([]) { $0 + ($1.subviews as? [TooltipView] ?? []) }
	}
	
	func remove(blocker: TooltipBlockerView) {
		self.blockingViews[blocker.window?.hashValue ?? 0] = nil
		
		UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: { 
			blocker.animateOut()
		}) { completed in
			blocker.removeFromSuperview()
		}
	}
}


class TooltipBlockerView: UIView {
	func setup() {
		self.backgroundColor = .clear
	}
	
	func animateIn() {
		self.backgroundColor = Appearance.backgroundColor
	}

	func animateOut() {
		self.backgroundColor = .clear
	}

	func add(tooltip: TooltipView, over duration: TimeInterval) {
		self.addSubview(tooltip)
		tooltip.transform = tooltip.hiddenTransform
		tooltip.alpha = 0.0

		UIView.animate(withDuration: duration) {
			tooltip.alpha = 1.0
			tooltip.transform = .identity
		}
	}
	
	func remove(tooltip: TooltipView, over duration: TimeInterval) {
		UIView.animate(withDuration: duration, animations: {
			tooltip.transform = tooltip.hiddenTransform
			tooltip.alpha = 0.0
		}) { finished in
			tooltip.removeFromSuperview()
			if self.subviews.count == 0 {
				TooltipBlocker.instance.remove(blocker: self)
			}
		}
	}
}

extension TooltipView {
	var hiddenTransform: CGAffineTransform {
		switch self.effectiveArrowDirection {
		case .rightSide:
			return CGAffineTransform(scaleX: 0.01, y: 1.0).concatenating(CGAffineTransform(translationX: -self.bounds.width / 2, y: 0))
			
		case .leftSide:
			return CGAffineTransform(scaleX: 0.01, y: 1.0).concatenating(CGAffineTransform(translationX: self.bounds.width / 2, y: 0))
			
		case .below, .belowRight, .belowLeft:
			return CGAffineTransform(scaleX: 1.0, y: 0.01).concatenating(CGAffineTransform(translationX: 0, y: -self.bounds.height / 2))
			
		case .above, .aboveRight, .aboveLeft:
			return CGAffineTransform(scaleX: 1.0, y: 0.01).concatenating(CGAffineTransform(translationX: 0, y: self.bounds.height / 2))
			
		default:
			return CGAffineTransform(scaleX: 0.01, y: 0.01)
		}

	}
}
