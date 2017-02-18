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
	var tip: TooltipView?
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.showTip(sender: button)
	}
	
	@IBAction func showTip(sender: UIButton!) {
//		let directions: [TooltipView.ArrowDirection] = [.left]
		let directions: [TooltipView.ArrowDirection] = [.up, .upRight, .right, .downRight, .down, .downLeft, .left, .upLeft]
		
		self.tip?.hide()
		
		var appearance = Appearance.standard
		appearance.tipCornerRadius = 10
		appearance.backgroundInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		appearance.tipBackgroundColor = UIColor(red: 0.1, green: 0.7, blue: 0.3, alpha: 1.0)
		appearance.titleColor = .white
		
		print("Attempting to display at: \(directions[self.index])")
		self.tip = sender.createTooltip(text: "Hello, this is my tip", direction: directions[self.index], appearance: appearance)
		self.tip?.show()
		self.index += 1
		if self.index >= directions.count { self.index = 0 }
	}
}
