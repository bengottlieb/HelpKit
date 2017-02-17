//
//  Appearance.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/6/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit

public struct Appearance {
	
	public static var standard = Appearance()
	
	
	var backgroundColor = UIColor(white: 0.75, alpha: 0.9)
	var textColor = UIColor.black
	var titleFont = UIFont.boldSystemFont(ofSize: 14)
	var bodyFont = UIFont.systemFont(ofSize: 13)
	
	var backgroundInset = UIEdgeInsets.zero
	
	var arrowDistance: CGFloat = 30
	var arrowSpread: CGFloat = 10			// how wide is the base of the arrow?
	var arrowPoint: CGFloat = 1				// how wide is the tip of the arrow?
	var arrowLength: CGFloat = 20			// how 'long' is the arrow?
	
	var layerClass = TooltipLayer.self
	
	var titleAttributes: [String: Any] { return [ NSFontAttributeName: self.titleFont, NSForegroundColorAttributeName: self.textColor ] }
	var bodyAttributes: [String: Any] { return [ NSFontAttributeName: self.bodyFont, NSForegroundColorAttributeName: self.textColor ] }
	
	func minimumHeight(forTitle title: String?, and body: String?) -> CGFloat {
		var height: CGFloat = 0
		if title != nil { height += self.titleFont.lineHeight }
		if body != nil { height += self.titleFont.lineHeight }
		
		return height
	}
	
	func contentInset(for direction: TooltipView.ArrowDirection) -> UIEdgeInsets {
		var insets = self.backgroundInset
		
		
//		let diag = sqrt(pow(self.appearance.arrowDistance, 2) / 2)
//
//		switch direction {
//		case .upLeft:
//			
//		}
		
		return insets
	}
}
