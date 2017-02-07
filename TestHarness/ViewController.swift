//
//  ViewController.swift
//  TestHarness
//
//  Created by Ben Gottlieb on 11/15/15.
//  Copyright © 2015 Stand Alone, Inc. All rights reserved.
//

import UIKit
import HelpKit

class TestViewController: UIViewController {
	@IBOutlet var button: UIButton!
	
	
	@IBAction func showTip(sender: UIButton!) {
		self.button.showTooltip(text: "Hello, this is my tip", direction: .left)
	}
}
