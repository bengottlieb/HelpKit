//
//  UIView+Tooltips.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/18/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit

extension UIView {
	@discardableResult public func createTooltip(text: String, direction: TooltipView.TipPosition = .rightSide, appearance: TooltipView.Appearance = .standard) -> TooltipView {
		
		let tip = TooltipView(target: self, title: text, direction: direction, appearance: appearance)
		return tip
	}
}

extension UIView {
	private struct Keys {
		static var tipTitle = "tt:title"
		static var tipBody = "tt:body"
		static var tipAppearance = "tt:appearance"
		static var tipPosition = "tt:position"
	}
	
	@IBInspectable public var tooltipTitle: String? {
		get { return objc_getAssociatedObject(self, &Keys.tipTitle) as? String }
		set { objc_setAssociatedObject(self, &Keys.tipTitle, newValue as NSString?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC ) }
	}
	@IBInspectable public var tooltipBody: String? {
		get { return objc_getAssociatedObject(self, &Keys.tipBody) as? String }
		set { objc_setAssociatedObject(self, &Keys.tipBody, newValue as NSString?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC ) }
	}
	@IBInspectable public var tooltipAppearance: String? {
		get { return objc_getAssociatedObject(self, &Keys.tipAppearance) as? String }
		set { objc_setAssociatedObject(self, &Keys.tipAppearance, newValue as NSString?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC ) }
	}
	@IBInspectable public var tooltipPositioningString: String? {
		get { return objc_getAssociatedObject(self, &Keys.tipPosition) as? String }
		set { objc_setAssociatedObject(self, &Keys.tipPosition, newValue as NSString?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC ) }
	}
	
	public var tooltipPositioning: TooltipView.TipPosition {
		get { return TooltipView.TipPosition(rawValue: objc_getAssociatedObject(self, &Keys.tipPosition) as? String ?? "") ?? .best }
		set { objc_setAssociatedObject(self, &Keys.tipPosition, newValue.rawValue as NSString?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC ) }
	}
	
	

}
