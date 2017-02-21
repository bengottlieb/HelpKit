//
//  Page2Scene.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/19/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit
import HelpKit

class Page2Scene:  Scene {
	@IBOutlet var thirdPartLabel: UILabel!
	override func viewDidLoad() {
		super.viewDidLoad()
		self.transitionDuration = 0.2
		self.onScreenDuration = 5.0
		
		self.timeline.queueEvent(at: 0.0, closure: { print("#0: \(Date())") } )
		self.timeline.queueEvent(at: 1.0, closure: { print("#1: \(Date())") } )
		self.timeline.queueEvent(at: 2.0, closure: { print("#2: \(Date())") } )
		self.timeline.queueEvent(at: 3.0, closure: { print("#3: \(Date())") } )
		self.timeline.queueEvent(at: 4.0, closure: { print("#4: \(Date())") } )
	}
	
	@IBAction func advance() {
		self.walkthrough.advance()
	}
}

class Page4Scene:  Scene {

	@IBAction func continueWalkthrough() {
		let duration = self.walkthrough.apply(batchID: "#1", over: 3.0)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
			let transition = Walkthrough.Transition(kind: .moveLeft)
			let nextDuration = self.apply(transition: transition, over: 4.0)
			DispatchQueue.main.asyncAfter(deadline: .now() + nextDuration) {
				self.walkthrough.dismiss()
			}
		}
	}
}
