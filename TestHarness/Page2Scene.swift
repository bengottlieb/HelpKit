//
//  Page2Scene.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/19/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit
import HelpKit

class Page1Scene: Scene {
	override func viewDidLoad() {
		super.viewDidLoad()
		self.hideAll()
		
		self.script.then(.pop, batchID: "welcome", direction: .in, duration: 1.0)
		self.script.wait(2)
		self.script.finish()
	}
}

class Page3Scene:  Scene {

}

class Page2Scene:  Scene {
	@IBOutlet var thirdPartLabel: UILabel!
	override func viewDidLoad() {
		super.viewDidLoad()
		self.hideAll()
		
		self.script.then(.fade, sceneID: "DEMO", direction: .in, duration: 1.0)
		self.script.then(.moveLeft, sceneID: "DEMO", direction: .out, duration: 1.0)
		self.script.finish()
	}
	
	@IBAction func advance() {
		self.walkthrough.advance()
	}
}

class Page4Scene:  Scene {
	
	@IBAction func continueWalkthrough() {
		let duration = self.walkthrough.apply(.fade, batchID: "#1", over: 3.0)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
//			let transition = Walkthrough.Transition(kind: .moveLeft)
//			let nextDuration = self.apply(transition, over: 4.0)
//			DispatchQueue.main.asyncAfter(deadline: .now() + nextDuration) {
				self.walkthrough.apply(.fade, direction: .in, sceneID: "#5", over: 3.0)
			//	self.walkthrough.dismiss()
//			}
		}
	}
}
