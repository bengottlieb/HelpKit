//
//  Tooltip.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/6/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit

open class TooltipView: UIView {
	public static var behavior = Behavior()
	
	deinit {
		self.targetView.removeObserver(self, forKeyPath: "center")
	}
	
	
	var targetView: UIView!
	var contentView: UIView!
	var targetArrowDirection = TipPosition.best
	var targetWindow: UIWindow { return self.targetView.window! }
	var appearance: Appearance!
	var blocker: TooltipBlockerView? { return self.superview as? TooltipBlockerView }
	var tooltipLayer: TooltipLayer!
	var fullSize: CGSize = .zero
	var effectiveArrowDirection: TipPosition = TipPosition.best { didSet {
		let insets = self.appearance.contentInset(for: self.effectiveArrowDirection)
		//self.contentView.frame = CGRect(x: insets.rightSide, y: insets.top, width: self.bounds.width - (insets.rightSide + insets.leftSide), height: self.bounds.height - (insets.top + insets.bottom))
		let contentSize = self.fullSize
//		self.contentView.center = CGPoint(x: insets.rightSide + contentSize.width / 2, y: insets.top + contentSize.height / 2)
		self.contentView.frame = CGRect(x: insets.left, y: insets.top, width: contentSize.width - (insets.left + insets.right), height: contentSize.height - (insets.top + insets.bottom))
	}}
	
	public convenience init(target: UIView, title: String? = nil, body: String? = nil, content: UIView? = nil, direction: TooltipView.TipPosition = .rightSide, appearance: Appearance = .standard) {
		self.init(frame: .zero)
		
		self.targetView = target
		self.targetArrowDirection = direction
		self.appearance = appearance
		
		if let content = content { self.contentView = content }
		else if body != nil || title != nil { self.contentView = UILabel(tooltipTitle: title, body: body, appearance: appearance) }
		
		self.frame = self.boundingFrame
		self.tooltipLayer = appearance.layerClass.init(frame: self.bounds, appearance: self.appearance, TipPosition: self.effectiveArrowDirection)
		self.layer.addSublayer(self.tooltipLayer)
		self.isUserInteractionEnabled = true
		self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
		self.addSubview(self.contentView)
	}
	
	func reposition() {
		self.frame = self.boundingFrame
		self.tooltipLayer?.TipPosition = self.effectiveArrowDirection
	}
	
	func tapped(recog: UITapGestureRecognizer) {
		if recog.state == .recognized && TooltipView.behavior.tapTipsToDismiss {
			self.hide(over: 0.2)
		}
	}
}


extension TooltipView {
	public func show(over duration: TimeInterval = 0.05) {
		let parent = TooltipBlocker.instance[self.targetWindow]
		parent.add(tooltip: self, over: duration)
		self.targetView.addObserver(self, forKeyPath: "center", options: [.new], context: nil)
	}
	
	open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		self.reposition()
	}
	
	public func hide(over duration: TimeInterval = 0.05) {
		self.blocker?.remove(tooltip: self, over: duration)
	}
	
	var contentSize: CGSize {
		return self.contentView.bounds.size
	}

	var boundingFrame: CGRect {
		var bounds = self.boundingFrame(for: self.targetArrowDirection)
		let windowFrame = self.targetWindow.bounds
		var directionThatFits = self.targetArrowDirection

		if windowFrame.intersection(bounds).size != bounds.size {
			let index = TipPosition.all.index(of: self.targetArrowDirection)!
			let directionCount = TipPosition.all.count

			for i in 1..<directionCount {
				let newDirection = TipPosition.all[(index + i) % directionCount]
				let newBounds = self.boundingFrame(for: newDirection)
				if windowFrame.intersection(newBounds).size == newBounds.size {
					bounds = newBounds
					directionThatFits = newDirection
					break
				}
			}
		}
		self.fullSize = bounds.size
		self.effectiveArrowDirection = directionThatFits
		return bounds
	}

	func boundingFrame(for direction: TipPosition) -> CGRect {
		let raw = self.targetWindow.convert(self.targetView.bounds, from: self.targetView)
		var frame = CGRect(x: ceil(raw.origin.x), y: ceil(raw.origin.y), width: ceil(raw.width), height: ceil(raw.height))
		let minContentSize = self.contentSize
		let insets = self.appearance.contentInset(for: direction)
		let contentWidth = minContentSize.width + insets.left + insets.right
		let contentHeight = minContentSize.height + insets.top + insets.bottom
		let diag = ceil(sqrt(pow(self.appearance.arrowDistance, 2) / 2))
		var viewSize = CGSize(width: contentWidth, height: contentHeight)
	
		
		switch direction {
		case .below, .above:				// arrow from the top or bottom of the target, make sure there's space above
			viewSize.height += self.appearance.arrowDistance + self.appearance.arrowLength

		case .rightSide, .leftSide:				// arrow from the left or right of the target, make sure there's space to the side
			viewSize.width += self.appearance.arrowDistance + self.appearance.arrowLength
			
		default:
			viewSize.width += self.appearance.arrowDistance + self.appearance.arrowLength
			viewSize.height += self.appearance.arrowDistance + self.appearance.arrowLength
		}
		
		switch direction {
		case .above:
			frame.origin.x = frame.midX - viewSize.width / 2
			frame.origin.y = frame.minY - (viewSize.height + self.appearance.arrowDistance)
			
		case .aboveLeft:
			frame.origin.x = frame.minX - (viewSize.width + diag)
			frame.origin.y = frame.minY - (viewSize.height + diag)
			
		case .aboveRight:
			frame.origin.x = frame.maxX + diag
			frame.origin.y = frame.minY - (viewSize.height + diag)

		case .below:
			frame.origin.x = frame.midX - viewSize.width / 2
			frame.origin.y = frame.maxY + self.appearance.arrowDistance
			
		case .belowLeft:
			frame.origin.x = frame.minX - (viewSize.width + diag)
			frame.origin.y = frame.maxY + diag
			
		case .belowRight:
			frame.origin.x = frame.maxX + diag
			frame.origin.y = frame.maxY + diag
			
		case .leftSide:
			frame.origin.y = frame.midY - viewSize.height / 2
			frame.origin.x = frame.minX - (viewSize.width + self.appearance.arrowDistance)
	
		case .rightSide:
			frame.origin.y = frame.midY - viewSize.height / 2
			frame.origin.x = frame.maxX + self.appearance.arrowDistance

		case .best:
			break
		}
		frame.size = viewSize

		return frame
	}
}

extension TooltipView {
	public enum TipPosition: String { case best, above, aboveRight, rightSide, belowRight, below, belowLeft, leftSide, aboveLeft
	
		static let all: [TipPosition] = [.below, .belowLeft, .leftSide, .aboveLeft, .above, .aboveRight, .rightSide, .belowRight]
	}
}
