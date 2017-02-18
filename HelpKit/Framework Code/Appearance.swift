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
	
	
	var backgroundColor = UIColor.white
	var textColor = UIColor.black
	
	
	var titleFont = UIFont.systemFont(ofSize: 14)
	var titleAlignment: NSTextAlignment = .center

	var bodyFont = UIFont.systemFont(ofSize: 13)
	var bodyAlignment: NSTextAlignment = .center
	
	var borderWidth: CGFloat = 0.5
	var borderColor = UIColor.gray
	
	var backgroundInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
	
	var arrowDistance: CGFloat = 00
	var arrowSpread: CGFloat = 8			// how wide is the base of the arrow?
	var arrowPoint: CGFloat = 1				// how wide is the tip of the arrow?
	var arrowLength: CGFloat = 8			// how 'long' is the arrow?
	
	var layerClass = TooltipLayer.self
	
	var titleAttributes: [String: Any] {
		let paraStyle = NSMutableParagraphStyle(); paraStyle.alignment = self.titleAlignment
		return [ NSFontAttributeName: self.titleFont, NSForegroundColorAttributeName: self.textColor, NSParagraphStyleAttributeName: paraStyle ]
	}

	var bodyAttributes: [String: Any] {
		let paraStyle = NSMutableParagraphStyle(); paraStyle.alignment = self.bodyAlignment
		return [ NSFontAttributeName: self.bodyFont, NSForegroundColorAttributeName: self.textColor, NSParagraphStyleAttributeName: paraStyle ]
	}
	
	func minimumHeight(forTitle title: String?, and body: String?) -> CGFloat {
		var height: CGFloat = 0
		if title != nil { height += self.titleFont.lineHeight }
		if body != nil { height += self.titleFont.lineHeight }
		
		return height
	}
	
	func contentInset(for direction: TooltipView.ArrowDirection) -> UIEdgeInsets {
		var insets = self.backgroundInset
		
		let diag = sqrt(pow(self.arrowDistance, 2) / 2)

		switch direction {
		case .upLeft: insets.top += diag + self.arrowLength; //insets.left += diag
		case .upRight: insets.top += diag + self.arrowLength; //insets.right += diag

		case .up: insets.top += self.arrowDistance + self.arrowLength
		case .left: insets.left += self.arrowDistance + self.arrowLength
		case .right: insets.right += self.arrowDistance + self.arrowLength
		case .down: insets.bottom += self.arrowDistance + self.arrowLength

		case .downLeft: insets.bottom += diag + self.arrowLength; //insets.left += diag
		case .downRight: insets.bottom += diag + self.arrowLength; //insets.right += diag
			
		case .none: break
		}
		
		return insets
	}
}
