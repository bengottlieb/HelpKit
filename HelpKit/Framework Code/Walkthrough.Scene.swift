//
//  Walkthrough.Scene.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/18/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit

//extension Walkthrough {
	open class WalkthroughScene: UIViewController {
		public var replacesExisting = false
		public var walkthrough: Walkthrough!
		public var script = Walkthrough.Script()
		
		open override func viewDidLoad() {
			super.viewDidLoad()
			self.view.backgroundColor = nil
		}
		
		public func hide(batchID: String) {
			self.walkthrough.viewsWith(batchID: batchID).forEach { $0.isHidden = true }
		}
		
		public func hideAll() {
			self.view.subviews.forEach { $0.isHidden = true }
		}
		
		func remove() {
			if !self.isViewLoaded || self.view.superview == nil { return }
			
			self.viewWillDisappear(true)
			self.view.removeFromSuperview()
			self.viewDidDisappear(true)
		}
		
		@discardableResult public func apply(_ transition: Walkthrough.Transition, direction: Walkthrough.Direction = .out, over duration: TimeInterval) -> TimeInterval {
			return self.walkthrough.apply(transition, direction: direction, to: self.view.subviews, over: duration)
		}

		func show(in parent: Walkthrough) {
			self.view.frame = parent.contentFrame
			
			self.viewWillAppear(true)
			parent.view.addSubview(self.view)
			self.script.start(in: self)
			self.viewDidAppear(true)
		}

	}
//}

extension UIView {
	func apply(_ transition: Walkthrough.Transition?, for direction: Walkthrough.Direction, duration: TimeInterval, in scene: Scene, completion: (() -> Void)? = nil) -> TimeInterval {
		guard let transition = transition else {
			completion?()
			return 0
		}
		let finalState: AnimatableState?
		let actualDuration = duration == 0 ? transition.duration ?? 0 : duration
		
		switch direction {
		case .in:
			self.animatableState = transition.transform(state: self.animatableState, direction: .in, endPoint: .begin, in: scene)
			finalState = transition.transform(state: self.animatableState, direction: .in, endPoint: .end, in: scene)
			self.isHidden = false

		case .out:
			self.animatableState = transition.transform(state: self.animatableState, direction: .out, endPoint: .begin, in: scene)
			finalState = transition.transform(state: self.animatableState, direction: .out, endPoint: .end, in: scene)

		case .none:
			finalState = transition.transform(state: self.animatableState, direction: .in, endPoint: .end, in: scene)
			self.isHidden = false
			
		}
		
		UIView.animate(withDuration: actualDuration, delay: transition.delay, options: [], animations: {
			self.animatableState = finalState
		}) { finished in
			completion?()
		}
		
		return transition.delay > 0 ? 0 : actualDuration
	}
}

extension WalkthroughScene {
	struct PersistedView {
		let oldView: UIView
		let newView: UIView
	}
}
