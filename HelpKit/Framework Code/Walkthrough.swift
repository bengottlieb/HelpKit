//
//  Walkthrough.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/18/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit

public typealias Scene = WalkthroughScene

public class Walkthrough: UIViewController {
	var scenes: [Scene] = []
	var current: Scene?
	weak var nextSceneTimer: Timer?
	
	public func add(scene: Scene) {
		if scene.walkthroughOrder == nil { scene.walkthroughOrder = self.scenes.count }
		if self.scenes.count == 0 { scene.replacesExisting = true }
		self.scenes.append(scene)
	}
	
	public func add(ids: [String], from storyboard: UIStoryboard) {
		for id in ids {
			if let scene = storyboard.instantiateViewController(withIdentifier: id) as? Scene { self.add(scene: scene) }
		}
	}
	
	public func present(in parent: UIViewController) {
		self.willMove(toParentViewController: parent)
		parent.addChildViewController(self)
		self.view.frame = parent.view.bounds
		parent.view.addSubview(self.view)
		self.didMove(toParentViewController: parent)
	}
}

extension Walkthrough {
	public override func viewDidLoad() {
		super.viewDidLoad()
		self.start()
	}
}

extension Walkthrough {
	public func start() {
		self.show(next: self.scenes.first!, over: 0)
	}
	
	public func show(next scene: Scene, over interval: TimeInterval?) {
		if scene.replacesExisting { self.current?.remove(over: interval) }
		
		self.current = scene
		self.current!.show(in: self)
		if let duration = scene.onScreenDuration {
			self.nextSceneTimer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(proceed), userInfo: nil, repeats: false)
		}
	}
	
	func proceed() {
		guard let current = self.current, let index = self.scenes.index(of: current) else { return }
		
		if index >= self.scenes.count - 1 {
			
		} else {
			let scene = self.scenes[index + 1]
			self.show(next: scene, over: scene.transitionDuration)
		}
	}
}
