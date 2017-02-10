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
	var blocker: TooltipBlockerView? { return self.superview as? TooltipBlockerView }
	
	convenience init(target: UIView, text: String, direction: TooltipView.ArrowDirection = .left, appearance: Appearance = .standard) {
		self.init(frame: .zero)
		self.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
		self.layer.borderColor = UIColor.black.cgColor
		self.layer.borderWidth = 1
		
		self.targetView = target
		self.targetArrowDirection = direction
		self.appearance = appearance
		
		self.frame = self.boundingFrame
	}

	open override func draw(_ rect: CGRect) {
		
	}
}


extension TooltipView {
	public func show() {
		let parent = TooltipBlocker.instance[self.targetWindow]
		parent.add(tooltip: self)
	}
	
	public func hide() {
		self.blocker?.remove(tooltip: self)
	}
	
	var contentSize: CGSize {
		return CGSize(width: 100, height: 30)
	}

	var boundingFrame: CGRect {
		let bounds = self.boundingFrame(for: self.targetArrowDirection)
		let windowFrame = self.targetWindow.bounds

		if windowFrame.intersection(bounds).size == bounds.size { return bounds }
		let index = ArrowDirection.all.index(of: self.targetArrowDirection)!
		let directionCount = ArrowDirection.all.count

		for i in 1..<directionCount {
			let newDirection = ArrowDirection.all[(index + i) % directionCount]
			let newBounds = self.boundingFrame(for: newDirection)
			if windowFrame.intersection(newBounds).size == newBounds.size { return newBounds }
		}
		return bounds
	}

	func boundingFrame(for direction: ArrowDirection) -> CGRect {
		var frame = self.targetWindow.convert(self.targetView.bounds, from: self.targetView)
		let viewSize: CGSize
		let minContentSize = self.contentSize
		let contentWidth = minContentSize.width + self.appearance.contentInset.left + self.appearance.contentInset.right
		let contentHeight = minContentSize.height + self.appearance.contentInset.top + self.appearance.contentInset.bottom
		let diag = sqrt(pow(self.appearance.arrowDistance, 2) / 2)
	
		
		switch direction {
		case .up, .down:				// arrow from the top or bottom of the target, make sure there's space above
			viewSize = CGSize(width: contentWidth, height: contentHeight + self.appearance.arrowDistance + self.appearance.arrowLength)

		case .left, .right:				// arrow from the left or right of the target, make sure there's space to the side
			viewSize = CGSize(width: contentWidth + self.appearance.arrowDistance + self.appearance.arrowLength, height: contentHeight)
			
		default:
			viewSize = CGSize(width: contentWidth + self.appearance.arrowDistance + self.appearance.arrowLength, height: contentHeight + self.appearance.arrowDistance + self.appearance.arrowLength)
		}
		
		switch direction {
		case .up:
			frame.origin.x = frame.midX - viewSize.width / 2
			frame.origin.y = frame.minY - (viewSize.height + self.appearance.arrowDistance)
			
		case .upLeft:
			frame.origin.x = frame.minX - (viewSize.width + diag)
			frame.origin.y = frame.minY - (viewSize.height + diag)
			
		case .upRight:
			frame.origin.x = frame.maxX + diag
			frame.origin.y = frame.minY - (viewSize.height + diag)

		case .down:
			frame.origin.x = frame.midX - viewSize.width / 2
			frame.origin.y = frame.maxY + self.appearance.arrowDistance
			
		case .downLeft:
			frame.origin.x = frame.minX - (viewSize.width + diag)
			frame.origin.y = frame.maxY + diag
			
		case .downRight:
			frame.origin.x = frame.maxX + diag
			frame.origin.y = frame.maxY + diag
			
		case .left:
			frame.origin.y = frame.midY - viewSize.height / 2
			frame.origin.x = frame.minX - (viewSize.width + self.appearance.arrowDistance)
	
		case .right:
			frame.origin.y = frame.midY - viewSize.height / 2
			frame.origin.x = frame.maxX + self.appearance.arrowDistance

		}
		frame.size = viewSize

		return frame
	}
}

extension TooltipView {
	public enum ArrowDirection: Int { case up, upRight, right, downRight, down, downLeft, left, upLeft
	
		static let all: [ArrowDirection] = [.up, .upRight, .right, .downRight, .down, .downLeft, .left, .upLeft]
	}
}
