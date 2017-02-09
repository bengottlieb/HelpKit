//
//  UIKit Extensions.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/6/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit

extension UIView {
	@discardableResult public func createTooltip(text: String, direction: TooltipView.ArrowDirection = .left, appearance: Appearance = .standard) -> TooltipView {
		
		let tip = TooltipView(target: self, text: text, direction: direction, appearance: appearance)
		return tip
	}
}
