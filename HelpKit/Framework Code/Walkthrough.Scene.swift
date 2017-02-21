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
		public var onScreenDuration: TimeInterval = 0.5
		public var walkthroughOrder: Int?
		public var transitionDuration: TimeInterval = 0.2
		public var walkthrough: Walkthrough!
		public var timeline = Walkthrough.Timeline()
		
		open override func viewDidLoad() {
			super.viewDidLoad()
			self.view.backgroundColor = nil
		}
		
		@discardableResult func remove(over: TimeInterval? = nil) -> TimeInterval {
			let duration = over ?? self.transitionDuration
			var effectiveDuration: TimeInterval = 0

			self.view.transitionableViews.forEach { view in
				effectiveDuration = max(effectiveDuration, view.apply(view.transitionInfo?.outTransition, for: .out, duration: duration, in: self) {
					view.isHidden = true
				})
			}
			
			DispatchQueue.main.asyncAfter(deadline: .now() + effectiveDuration) {
				self.removeFromWalkthrough()
			}
			
			return effectiveDuration
		}
		
		func removeFromWalkthrough() {
			self.timeline.end()
			self.view.removeFromSuperview()
		}
		
		@discardableResult public func apply(_ transition: Walkthrough.Transition? = nil, direction: Walkthrough.Transition.Direction, over duration: TimeInterval) -> TimeInterval {
			return self.walkthrough.apply(transition, direction: direction, to: self.view.subviews, over: duration)
		}

		@discardableResult func show(in parent: Walkthrough, over: TimeInterval? = nil) -> TimeInterval {
			let duration = over ?? self.transitionDuration
			var effectiveDuration: TimeInterval = 0
			
			self.view.frame = parent.contentFrame
			var persisted: [PersistedView] = []
			
			self.view.transitionableViews.forEach { view in
				effectiveDuration = max(effectiveDuration, view.apply(view.transitionInfo?.inTransition, for: .in, duration: duration, in: self))
			}
			
			for view in self.view.viewsWithSceneIDs {
				if let sceneID = view.transitionInfo?.id, let existing = self.walkthrough.existingView(with: sceneID), existing != view {
					persisted.append(PersistedView(oldView: existing, newView: view))
					view.isHidden = true
				}
			}

			parent.view.addSubview(self.view)
			if duration > 0, persisted.count > 0 {
				effectiveDuration = max(effectiveDuration, duration)
				UIView.animate(withDuration: duration, animations: {
					persisted.forEach { $0.oldView.frame = $0.newView.frame }
				}) { completed in
					persisted.forEach { $0.oldView.isHidden = true; $0.newView.isHidden = false }
				}
			}
			
			self.timeline.start()
			return effectiveDuration
		}

	}
//}

extension UIView {
	func apply(_ transition: Walkthrough.Transition?, for direction: Walkthrough.Transition.Direction, duration: TimeInterval, in scene: Scene, completion: (() -> Void)? = nil) -> TimeInterval {
		guard let transition = transition else {
			completion?()
			return 0
		}
		let finalState: AnimatableState?
		let actualDuration = duration == 0 ? transition.duration ?? 0 : duration
		
		switch direction {
		case .in:
			finalState = self.animatableState
			self.isHidden = false
			self.animatableState = transition.transform(state: self.animatableState, direction: direction, in: scene)
		case .out:
			finalState = transition.transform(state: self.animatableState, direction: direction, in: scene)

		case .other:
			self.isHidden = false
			self.animatableState = transition.transform(state: self.animatableState, direction: .out, in: scene)
			finalState = transition.transform(state: self.animatableState, direction: .in, in: scene)
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
