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
	var walkthrough = Walkthrough()
	
	func showWalkthrough() {
		self.walkthrough.add(scene: Scene())
		self.walkthrough.add(ids: ["page1", "page2", "page3"], from: UIStoryboard(name: "Walkthrough", bundle: nil))
		let lastScene = UIStoryboard(name: "Walkthrough", bundle: nil).instantiateViewController(withIdentifier: "page4") as! Scene
		lastScene.replacesExisting = true
		self.walkthrough.add(scene: lastScene)
		self.walkthrough.present(in: self)
		self.walkthrough.view.backgroundColor = .white
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		//self.showAllTips()
		self.showWalkthrough()
	}
	
	func showAllTips() {
		var delay: TimeInterval = 0.1
		let queue = DispatchQueue.main
		
		self.view.subviews.forEach { view in
			queue.asyncAfter(deadline: .now() + delay) {
				if let button = view as? UIButton {
					self.showTip(sender: button)
				}
				self.tip = nil
			}
			delay += 0.02
		}
	}
	
	@IBAction func showTip(sender: UIButton!) {
//		let directions: [TooltipView.TipPosition] = [.rightSide]
		let directions: [TooltipView.TipPosition] = [.below, .belowLeft, .leftSide, .aboveLeft, .above, .aboveRight, .rightSide, .belowRight]
		
		self.tip?.hide()
		
		var appearance = TooltipView.Appearance.standard
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
