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
	
	var index = 0
	var tip: UIView?
	
	@IBAction func showTip(sender: UIButton!) {
		let directions: [TooltipView.ArrowDirection] = [.up, .upRight, .right, .downRight, .down, .downLeft, .left, .upLeft]
		
		self.tip?.removeFromSuperview()
		
		self.tip = self.button.showTooltip(text: "Hello, this is my tip", direction: directions[self.index])
		print("Showing: \(directions[self.index])")
		self.index += 1
		if self.index >= directions.count { self.index = 0 }
	}
}
