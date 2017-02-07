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
		self.layer.borderColor = UIColor.black.cgColor
		self.layer.borderWidth = 1
		
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
		let minContentSize = self.contentSize
		let contentWidth = minContentSize.width + self.appearance.contentInset.left + self.appearance.contentInset.right
		let contentHeight = minContentSize.height + self.appearance.contentInset.top + self.appearance.contentInset.bottom
		
		
		switch self.targetArrowDirection {
		case .up, .down:				// arrow from the top or bottom of the target, make sure there's space above
			viewSize = CGSize(width: contentWidth, height: contentHeight + self.appearance.arrowDistance + self.appearance.arrowLength)

		case .left, .right:				// arrow from the left or right of the target, make sure there's space to the side
			viewSize = CGSize(width: contentWidth + self.appearance.arrowDistance + self.appearance.arrowLength, height: contentHeight)
			
		default:
			viewSize = CGSize(width: contentWidth + self.appearance.arrowDistance + self.appearance.arrowLength, height: contentHeight + self.appearance.arrowDistance + self.appearance.arrowLength)
		}
		
		let tooFarUp = viewSize.height > frame.minY
		let tooFarLeft = viewSize.width > frame.minX
		let tooFarDown = (windowSize.height - frame.maxY) < viewSize.height
		let tooFarRight = (windowSize.width - frame.maxX) < viewSize.width
		
		switch direction {
		case .up: if tooFarUp { direction = .down }
		case .upRight:
			if tooFarUp { direction = tooFarRight ? .downLeft : .downRight }
			else if tooFarRight { direction = .downLeft }
		case .right: if tooFarRight { direction = .left }
		case .downRight:
			if tooFarDown { direction = tooFarRight ? .upLeft : .upRight }
			else if tooFarRight { direction = .downLeft }
		case .down: if tooFarDown { direction = .up }
		case .downLeft:
			if tooFarDown { direction = tooFarLeft ? .upRight : .downLeft }
			else if tooFarLeft { direction = .downRight }
		case .left: if tooFarLeft { direction = .right }
		case .upLeft:
			if tooFarUp { direction = tooFarLeft ? .downRight : .downLeft }
			else if tooFarLeft { direction = .downRight }
		}
		
		let maxX = windowSize.width - viewSize.width
		let maxY = windowSize.height - viewSize.height
		let diag = sqrt(pow(self.appearance.arrowDistance, 2) / 2)
		
		switch direction {
		case .up:
			frame.origin.x = min(maxX, max(0, frame.midX - viewSize.width / 2))
			frame.origin.y = frame.minY - (viewSize.height + self.appearance.arrowDistance)
			
		case .upLeft:
			frame.origin.x = max(0, frame.minX - (viewSize.width + diag))
			frame.origin.y = frame.minY - (viewSize.height + diag)
			
		case .upRight:
			frame.origin.x = frame.maxX + diag
			frame.origin.y = frame.minY - (viewSize.height + diag)

		case .down:
			frame.origin.x = min(maxX, max(0, frame.midX - viewSize.width / 2))
			frame.origin.y = frame.maxY + self.appearance.arrowDistance
			
		case .downLeft:
			frame.origin.x = max(0, frame.minX - (viewSize.width + diag))
			frame.origin.y = frame.maxY + diag
			
		case .downRight:
			frame.origin.x = frame.maxX + diag
			frame.origin.y = frame.maxY + diag
			
		case .left:
			frame.origin.y = min(maxY, max(0, frame.midY - viewSize.height / 2))
			frame.origin.x = max(0, frame.minX - (viewSize.width + self.appearance.arrowDistance))
	
		case .right:
			frame.origin.y = min(maxY, max(0, frame.midY - viewSize.height / 2))
			frame.origin.x = min(maxX, frame.maxX + self.appearance.arrowDistance)

		}
		frame.size = viewSize

		return frame
	}
}

extension TooltipView {
	public enum ArrowDirection { case up, upRight, right, downRight, down, downLeft, left, upLeft }
}
