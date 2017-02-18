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
		
		UIView.animate(withDuration: 0.2) { view.animateIn() }
		
		return view
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
		case .left:
			return CGAffineTransform(scaleX: 0.01, y: 1.0).concatenating(CGAffineTransform(translationX: -self.bounds.width / 2, y: 0))
			
		case .right:
			return CGAffineTransform(scaleX: 0.01, y: 1.0).concatenating(CGAffineTransform(translationX: self.bounds.width / 2, y: 0))
			
		case .up, .upLeft, .upRight:
			return CGAffineTransform(scaleX: 1.0, y: 0.01).concatenating(CGAffineTransform(translationX: 0, y: -self.bounds.height / 2))
			
		case .down, .downLeft, .downRight:
			return CGAffineTransform(scaleX: 1.0, y: 0.01).concatenating(CGAffineTransform(translationX: 0, y: self.bounds.height / 2))
			
		default:
			return CGAffineTransform(scaleX: 0.01, y: 0.01)
		}

	}
}
