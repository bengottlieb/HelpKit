//
//  Tooltip.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/6/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit

open class TooltipView: UIView {
	var targetView: UIView!
	var targetArrowDirection = ArrowDirection.up
	var targetWindow: UIWindow { return self.targetView.window! }
	var appearance: Appearance!
	
	convenience init(target: UIView, text: String, direction: TooltipView.ArrowDirection = .left, appearance: Appearance = .standard) {
		self.init(frame: .zero)
		self.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
		
		self.targetView = target
		self.targetArrowDirection = direction
		self.appearance = appearance
		
		self.frame = self.boundingFrame
		target.window?.addSubview(self)
	}

	open override func draw(_ rect: CGRect) {
		
	}
}

extension TooltipView {
	var contentSize: CGSize {
		return CGSize(width: 100, height: 30)
	}
	
	var boundingFrame: CGRect {
		let windowSize = self.targetWindow.bounds.size
		var direction = self.targetArrowDirection
		var frame = self.targetWindow.convert(self.targetView.bounds, from: self.targetView)
		let viewSize: CGSize
		
		switch self.targetArrowDirection {
		case .up, .down:				// arrow from the top or bottom of the target, make sure there's space above
			viewSize = CGSize(width: self.contentSize.width + self.appearance.contentInset.right + self.appearance.contentInset.left, height: self.contentSize.height + self.appearance.contentInset.top + self.appearance.contentInset.bottom + self.appearance.arrowDistance + self.appearance.arrowLength)

		case .left, .right:				// arrow from the left or right of the target, make sure there's space to the side
			viewSize = CGSize(width: self.contentSize.width + self.appearance.contentInset.right + self.appearance.contentInset.left + self.appearance.arrowDistance + self.appearance.arrowLength, height: self.contentSize.height + self.appearance.contentInset.top + self.appearance.contentInset.bottom)
		}
		
		switch direction {
		case .up: if frame.minY < viewSize.height { direction = .down }
		case .down: if (windowSize.height - frame.maxY) < viewSize.height { direction = .up }
		case .left: if frame.minY < viewSize.height { direction = .right }
		case .right: if (windowSize.height - frame.maxY) < viewSize.height { direction = .left }
		}
		
		let maxX = windowSize.width - viewSize.width
		let maxY = windowSize.height - viewSize.height
		
		switch direction {
		case .up, .down:
			switch self.appearance.arrowPlacement {
			case .min:
				frame.origin.x = min(maxX, frame.midX - (self.appearance.arrowSpread / 2 + self.appearance.arrowSpacingFromEdge))

			case .mid:
				frame.origin.x = min(maxX, max(0, frame.midX - viewSize.width / 2))
				
			case .max:
				frame.origin.x = max(0, (frame.midX + self.appearance.arrowSpread / 2 + self.appearance.arrowSpacingFromEdge) - viewSize.width)
				
			}
			frame.origin.y = direction == .up ? frame.minY - viewSize.height : frame.maxY
			frame.size = viewSize
			
		case .left, .right:
			switch self.appearance.arrowPlacement {
			case .min:
				frame.origin.y = min(maxY, frame.midY - (self.appearance.arrowSpread / 2 + self.appearance.arrowSpacingFromEdge))
				
			case .mid:
				frame.origin.y = min(maxY, max(0, frame.midY - viewSize.height / 2))
				
			case .max:
				frame.origin.y = max(0, (frame.midY + self.appearance.arrowSpread / 2 + self.appearance.arrowSpacingFromEdge) - viewSize.height)
				
			}
			frame.origin.x = direction == .left ? frame.minX - viewSize.width : frame.maxX
			frame.size = viewSize
		}
		
		return frame
	}
}

extension TooltipView {
	public enum ArrowDirection { case up, left, right, down }
	public enum ArrowPlacement { case min, mid, max }
}
