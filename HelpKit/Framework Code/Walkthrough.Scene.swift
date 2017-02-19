//
//  Walkthrough.Scene.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/18/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit

extension Walkthrough {
	open class Scene: UIViewController {
		public var replacesExisting = false
		public var duration: TimeInterval?
		public var walkthroughOrder: Int?
		public var transitionDuration: TimeInterval = 0
		
		func remove(over: TimeInterval? = nil) {
			let duration = over ?? self.transitionDuration
			
			if duration > 0 {
				UIView.animate(withDuration: duration, animations: {
					self.view.transitionableViews.forEach { view in
						view.animatableState = view.transitionOutType?.transform(state: view.animatableState, forTransitionOut: true, in: self)
					}
				}) { completed in
					self.view.removeFromSuperview()
				}
			} else {
				self.view.removeFromSuperview()
			}
		}

		func show(in parent: Walkthrough, over: TimeInterval? = nil) {
			let duration = over ?? self.transitionDuration
			
			self.view.frame = parent.view.bounds
			var finalStates: [Int: UIView.AnimatableState] = [:]
			
			self.view.transitionableViews.forEach { view in
				finalStates[view.hashValue] = view.animatableState
				view.animatableState = view.transitionOutType?.transform(state: view.animatableState, forTransitionOut: false, in: self)
			}
			
			if duration > 0 {
				UIView.animate(withDuration: duration, animations: {
					self.view.transitionableViews.forEach { view in
						view.animatableState = finalStates[view.hashValue]
					}
				}) { completed in
					self.view.removeFromSuperview()
				}
			} else {
				parent.view.addSubview(self.view)
			}
		}

	}
}
