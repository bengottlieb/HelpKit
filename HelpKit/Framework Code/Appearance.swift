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
	
	
	public var tipBackgroundColor = UIColor.white			/// what color is the 'bubble' of the tooltip?
	public static var backgroundColor = UIColor.clear		/// what color (if any) is the 'blocking' view behind the tip?
	public var tipCornerRadius: CGFloat = 5					/// how round are the tip's bubble's corners?
	
	
	public var titleColor = UIColor.black
	public var titleFont = UIFont.systemFont(ofSize: 14)
	public var titleAlignment: NSTextAlignment = .center

	public var bodyColor = UIColor.black
	public var bodyFont = UIFont.systemFont(ofSize: 13)
	public var bodyAlignment: NSTextAlignment = .center
	
	public var borderWidth: CGFloat = 0.5
	public var borderColor = UIColor.gray
	
	public var backgroundInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
	
	public var arrowDistance: CGFloat = 00		/// how far is the arrow from its target view?
	public var arrowSpread: CGFloat = 8			/// how wide is the base of the arrow?
	public var arrowPoint: CGFloat = 1			/// how wide is the tip of the arrow?
	public var arrowLength: CGFloat = 8			/// how 'long' is the arrow?
	
	public var layerClass = TooltipLayer.self
}

extension Appearance {
	var titleAttributes: [String: Any] {
		let paraStyle = NSMutableParagraphStyle(); paraStyle.alignment = self.titleAlignment
		return [ NSFontAttributeName: self.titleFont, NSForegroundColorAttributeName: self.titleColor, NSParagraphStyleAttributeName: paraStyle ]
	}

	var bodyAttributes: [String: Any] {
		let paraStyle = NSMutableParagraphStyle(); paraStyle.alignment = self.bodyAlignment
		return [ NSFontAttributeName: self.bodyFont, NSForegroundColorAttributeName: self.bodyColor, NSParagraphStyleAttributeName: paraStyle ]
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
