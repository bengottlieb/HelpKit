//
//  Appearance.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/6/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit

extension TooltipView {
	public struct Appearance {
		public static var standard = Appearance()
		
		public static var maxTooltipWidth: CGFloat = 200

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
		
		public var arrowDistance: CGFloat = 5		/// how far is the arrow from its target view?
		public var arrowSpread: CGFloat = 8			/// how wide is the base of the arrow?
		public var arrowPoint: CGFloat = 1			/// how wide is the tip of the arrow?
		public var arrowLength: CGFloat = 8			/// how 'long' is the arrow?
		
		public var layerClass = TooltipView.BackgroundLayer.self
	}
}

extension TooltipView.Appearance {
	var titleAttributes: [NSAttributedStringKey: Any] {
		let paraStyle = NSMutableParagraphStyle(); paraStyle.alignment = self.titleAlignment
		return [ NSAttributedStringKey.font: self.titleFont, NSAttributedStringKey.foregroundColor: self.titleColor, NSAttributedStringKey.paragraphStyle: paraStyle ]
	}

	var bodyAttributes: [NSAttributedStringKey: Any] {
		let paraStyle = NSMutableParagraphStyle(); paraStyle.alignment = self.bodyAlignment
		return [ NSAttributedStringKey.font: self.bodyFont, NSAttributedStringKey.foregroundColor: self.bodyColor, NSAttributedStringKey.paragraphStyle: paraStyle ]
	}
	
	func minimumHeight(forTitle title: String?, and body: String?) -> CGFloat {
		var height: CGFloat = 0
		if title != nil { height += self.titleFont.lineHeight }
		if body != nil { height += self.titleFont.lineHeight }
		
		return height
	}
	
	func contentInset(for direction: TooltipView.TipPosition) -> UIEdgeInsets {
		var insets = self.backgroundInset
		
		let diag = sqrt(pow(self.arrowDistance, 2) / 2)

		switch direction {
		case .belowRight: insets.top += diag + self.arrowLength; //insets.rightSide += diag
		case .belowLeft: insets.top += diag + self.arrowLength; //insets.leftSide += diag

		case .below: insets.top += self.arrowDistance + self.arrowLength
		case .rightSide: insets.left += self.arrowDistance + self.arrowLength
		case .leftSide: insets.right += self.arrowDistance + self.arrowLength
		case .above: insets.bottom += self.arrowDistance + self.arrowLength

		case .aboveRight: insets.bottom += diag + self.arrowLength; //insets.rightSide += diag
		case .aboveLeft: insets.bottom += diag + self.arrowLength; //insets.leftSide += diag
			
		case .best: break
		}
		
		return insets
	}
}
