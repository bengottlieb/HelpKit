//
//  Walkthrough.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/18/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit

public class Walkthrough: UIViewController {
	var scenes: [Scene] = []
	var current: Scene?
	
	func add(scene: Scene) {
		if scene.walkthroughOrder == nil { scene.walkthroughOrder = self.scenes.count }
		self.scenes.append(scene)
	}
	
	func add(from storyboard: UIStoryboard, with ids: [String]) {
		for id in ids {
			if let scene = storyboard.instantiateViewController(withIdentifier: id) as? Scene { self.add(scene: scene) }
		}
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
		precondition(self.scenes.first!.replacesExisting, "First walkthrough scene must have 'replacesExisiting' set")
		
		self.show(next: self.scenes.first!, over: 0)
	}
	
	public func show(next scene: Scene, over interval: TimeInterval?) {
		if scene.replacesExisting { self.current?.remove(over: interval) }
		
		
	}
}
