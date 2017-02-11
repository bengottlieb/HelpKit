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
		self.backgroundColor = UIColor(white: 0.1, alpha: 0)
	}
	
	func animateIn() {
		self.backgroundColor = UIColor(white: 0.1, alpha: 0.35)
	}

	func animateOut() {
		self.backgroundColor = UIColor(white: 0.1, alpha: 0)
	}

	func add(tooltip: TooltipView) {
		self.addSubview(tooltip)
	}
	
	func remove(tooltip: TooltipView) {
		tooltip.removeFromSuperview()
		
		if self.subviews.count == 0 {
			TooltipBlocker.instance.remove(blocker: self)
		}
	}
}
