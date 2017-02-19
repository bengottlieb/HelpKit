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

extension String {
	func substring(withPrefix prefix: String) -> String? {
		let splits = CharacterSet(charactersIn: ":= ")
		for component in self.components(separatedBy: ",") {
			if component.trimmingCharacters(in: .whitespaces).hasPrefix(prefix) {
				let subs = component.components(separatedBy: splits)
				if subs.count > 1 { return subs.last }
			}
		}
		return nil
	}
}

extension UIView {
	var transitionIn: Walkthrough.Transition? { return Walkthrough.Transition(rawValue: self.sceneTransition?.substring(withPrefix: "in") ?? "") }
	var transitionOut: Walkthrough.Transition? { return Walkthrough.Transition(rawValue: self.sceneTransition?.substring(withPrefix: "out") ?? "") }

	var transitionableViews: [UIView] {
		var views: [UIView] = []
		
		for view in self.subviews {
			if view.sceneTransition != nil { views.append(view) }
			views += view.transitionableViews
		}
		return views
	}
	
	var animatableState: AnimatableState? {
		get { return AnimatableState(frame: self.frame, alpha: self.alpha, transform: self.transform) }
		set {
			guard let state = newValue else { return }
			self.center = CGPoint(x: state.frame.midX, y: state.frame.midY)
			self.alpha = state.alpha
			self.transform = state.transform
		}
	}
	
	struct AnimatableState {
		var frame: CGRect
		var alpha: CGFloat
		var transform: CGAffineTransform
	}
}

extension UIView {
	private struct Keys {
		static var tipTitle = "hk:title"
		static var tipBody = "hk:body"
		static var tipAppearance = "hk:appearance"
		static var tipPosition = "hk:position"
		static var sceneID = "hk:sceneID"
		static var sceneTransition = "hk:Transition"
	}
	
	@IBInspectable public var sceneID: String? {
		get { return objc_getAssociatedObject(self, &Keys.sceneID) as? String }
		set { objc_setAssociatedObject(self, &Keys.sceneID, newValue as NSString?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC ) }
	}
	@IBInspectable public var sceneTransition: String? {
		get { return objc_getAssociatedObject(self, &Keys.sceneTransition) as? String }
		set { objc_setAssociatedObject(self, &Keys.sceneTransition, newValue as NSString?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC ) }
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
