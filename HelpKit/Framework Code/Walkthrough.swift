//
//  Walkthrough.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/18/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit

public typealias Scene = WalkthroughScene

open class Walkthrough: UIViewController {
	public var contentInset: UIEdgeInsets = .zero
	var scenes: [Scene] = []
	var visible: [Scene] = []
	weak var nextSceneTimer: Timer?
	var contentFrame: CGRect {
		let bounds = self.view.bounds
		return CGRect(x: bounds.origin.x + self.contentInset.left,
		              y: bounds.origin.y + self.contentInset.top,
		              width: bounds.width + (self.contentInset.left + self.contentInset.right),
		              height: bounds.height + (self.contentInset.top + self.contentInset.bottom))
	}
	
	required public init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder); self.didInit() }
	public init() { super.init(nibName: nil, bundle: nil); self.didInit() }
	
	open func didInit() { }
	
	open func present(in parent: UIViewController) {
		self.willMove(toParentViewController: parent)
		parent.addChildViewController(self)
		self.view.frame = parent.view.bounds
		parent.view.addSubview(self.view)
		self.didMove(toParentViewController: parent)
	}
	
	open func dismiss(animated: Bool = true) {
		self.willMove(toParentViewController: nil)
		self.removeFromParentViewController()
		
		self.view.removeFromSuperview()
		self.didMove(toParentViewController: nil)
	}
	
	public func add(scene: Scene) {
		if scene.walkthroughOrder == nil { scene.walkthroughOrder = self.scenes.count }
		if self.scenes.count == 0 { scene.replacesExisting = true }
		scene.walkthrough = self
		self.scenes.append(scene)
	}
	
	public func add(ids: [String], from storyboard: UIStoryboard) {
		for id in ids {
			if let scene = storyboard.instantiateViewController(withIdentifier: id) as? Scene { self.add(scene: scene) }
		}
	}
	
	@discardableResult public func apply(_ transition: Transition? = nil, direction: Walkthrough.Direction = .out, batchID: String, over duration: TimeInterval) -> TimeInterval {
		let views = self.viewsWith(batchID: batchID)
		if views.count == 0 {
			print("Unable to find any views with a batch ID: \(batchID)")
			return 0
		}
		return self.apply(transition, direction: direction, to: views, over: duration)
	}

	@discardableResult public func apply(_ transition: Transition? = nil, direction: Walkthrough.Direction = .out, sceneID: String, over duration: TimeInterval) -> TimeInterval {
		guard let view = self.existingView(with: sceneID) else {
			print("Unable to find any views with a sceneID: \(sceneID)")
			return 0
		}
		return self.apply(transition, direction: direction, to: [view], over: duration)
	}
	
	@discardableResult public func apply(_ transition: Transition? = nil, direction: Walkthrough.Direction = .out, to views: [UIView], over duration: TimeInterval) -> TimeInterval {
		guard let current = self.visible.last else { return 0 }
		var maxDuration: TimeInterval = 0
		
		views.forEach { view in
			guard let tran = transition ?? view.transitionInfo?.otherTransition else { return }
			maxDuration = max(maxDuration, view.apply(tran, for: direction, duration: duration, in: current))
		}
		
		return maxDuration
	}
}

extension Walkthrough {
	open override func viewDidLoad() {
		super.viewDidLoad()
		self.start()
	}
}

extension Walkthrough {
	public func start() {
		self.show(next: self.scenes.first!, over: 0)
	}
	
	public func show(next scene: Scene, over interval: TimeInterval?) {
		if scene.replacesExisting {
			self.visible.forEach { $0.remove(over: $0.transitionDuration) }
			self.visible = []
		}
		
		self.visible.append(scene)
		scene.show(in: self)
		if scene.onScreenDuration != 0 {
			self.nextSceneTimer = Timer.scheduledTimer(timeInterval: scene.onScreenDuration, target: self, selector: #selector(advanceToNext), userInfo: nil, repeats: false)
		}
	}
	
	func advanceToNext() { self.advance() }
	public func advance(over: TimeInterval? = nil) {
		guard let current = self.visible.last, let index = self.scenes.index(of: current) else { return }
		
		if index >= self.scenes.count - 1 {
			
		} else {
			let scene = self.scenes[index + 1]
			self.show(next: scene, over: scene.transitionDuration)
		}
	}
}

extension Walkthrough {
	func existingView(with id: String) -> UIView? {
		for view in self.viewsWithSceneIDs { if view.transitionInfo?.id == id {
			return view
		}}
		return nil
	}
	
	var viewsWithSceneIDs: [UIView] {
		var views: [UIView] = []
		
		for scene in self.visible { views += scene.view.viewsWithSceneIDs }
		
		return views
	}

	func viewsWith(batchID: String) -> [UIView] {
		var views: [UIView] = []
		
		for scene in self.visible { views += scene.view.viewsMatching(batchID: batchID) }
		
		return views
	}
}
