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
		
		open override func viewDidLoad() {
			super.viewDidLoad()
			self.view.backgroundColor = nil
		}
		
		func remove(over: TimeInterval? = nil) {
			let duration = over ?? self.transitionDuration
			
			if duration > 0 {
				UIView.animate(withDuration: duration, animations: {
					self.view.transitionableViews.forEach { view in
						view.animatableState = view.transitionInfo?.outTransition?.transform(state: view.animatableState, forTransitionOut: true, in: self)
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
			
			self.view.frame = parent.contentFrame
			var persisted: [PersistedView] = []
			
			self.view.transitionableViews.forEach { view in
				guard let info = view.transitionInfo else { return }
				
				let finalState = view.animatableState
				view.animatableState = info.inTransition?.transform(state: view.animatableState, forTransitionOut: false, in: self)
				UIView.animate(withDuration: info.inDuration ?? duration, delay: info.inDelay, options: [], animations: {
					view.animatableState = finalState
				}, completion: nil)
			}
			
			for view in self.view.viewsWithSceneIDs {
				if let sceneID = view.transitionInfo?.id, let existing = self.walkthrough.existingView(with: sceneID), existing != view {
					persisted.append(PersistedView(oldView: existing, newView: view))
					view.isHidden = true
				}
			}

			
			parent.view.addSubview(self.view)
			if duration > 0 {
				UIView.animate(withDuration: duration, animations: {
					persisted.forEach { $0.oldView.frame = $0.newView.frame }
				}) { completed in
					persisted.forEach { $0.oldView.isHidden = true; $0.newView.isHidden = false }
				}
			}
		}

	}
//}

extension WalkthroughScene {
	struct PersistedView {
		let oldView: UIView
		let newView: UIView
	}
}
