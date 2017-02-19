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
	}
	
	@IBAction func advance() {
		self.walkthrough.advance()
	}
}
