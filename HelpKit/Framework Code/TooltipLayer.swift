//
//  TooltipLayer.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/11/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit

open class TooltipLayer: CALayer {
	var TipPosition: TooltipView.TipPosition { didSet { self.setNeedsDisplay() } }
	var fill: UIColor
	var border: UIColor
	var tipBorderWidth: CGFloat
	var appearance: Appearance
	
	public required init(frame: CGRect, appearance: Appearance, TipPosition: TooltipView.TipPosition) {
		self.TipPosition = TipPosition
		self.appearance = appearance
		self.border = appearance.borderColor
		self.fill = appearance.tipBackgroundColor
		self.tipBorderWidth = appearance.borderWidth
		super.init()
		//self.backgroundColor = UIColor.orange.cgColor
		self.frame = frame
		self.setNeedsDisplay()
	}
	
	public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
	func arrowLocation(in bounds: CGRect) -> CGPoint? {
		switch self.TipPosition {
		case .aboveLeft: return CGPoint(x: bounds.maxX, y: bounds.maxY)
		case .leftSide: return CGPoint(x: bounds.maxX, y: bounds.midY)
		case .belowLeft: return CGPoint(x: bounds.maxX, y: bounds.minY)
		case .below: return CGPoint(x: bounds.midX, y: bounds.minY)
		case .belowRight: return CGPoint(x: bounds.minX, y: bounds.minY)
		case .rightSide: return CGPoint(x: bounds.minX, y: bounds.midY)
		case .aboveRight: return CGPoint(x: bounds.minX, y: bounds.maxY)
		case .above: return CGPoint(x: bounds.midX, y: bounds.maxY)
		
		case .best: return nil
		}
	}
	
	open override func draw(in ctx: CGContext) {
		//print("Drawing \(self.TipPosition)")
		UIGraphicsPushContext(ctx)
		let tipBounds = self.bounds.insetBy(dx: self.tipBorderWidth, dy: self.tipBorderWidth)
		var bezier = UIBezierPath(ovalIn: tipBounds)
//		let inset = self.appearance.backgroundInset
//		let bounds = CGRect(x: tipBounds.origin.x - inset.rightSide,
//		                    y: tipBounds.origin.y - inset.top,
//		                    width: tipBounds.width + (inset.rightSide + inset.leftSide),
//		                    height: tipBounds.height + (inset.top + inset.bottom))
		var bubble = tipBounds
		
		if let arrowStart = self.arrowLocation(in: bounds) {
			bezier.move(to: arrowStart)
		}
		
		let stemWidth: CGFloat = self.appearance.arrowSpread
		var stemLocation: CGFloat = 0.5
		let radius = self.appearance.tipCornerRadius
		let pi = CGFloat.pi

		switch self.TipPosition {
		case .aboveLeft, .above, .aboveRight:
			if self.TipPosition == .belowRight { stemLocation = 0.8 }
			else if self.TipPosition == .belowLeft { stemLocation = 0.2 }
			
			bezier = UIBezierPath()
			if let arrowStart = self.arrowLocation(in: bounds) { bezier.move(to: arrowStart) }
			bubble.size.height -= self.appearance.arrowLength
			bezier.addLine(to: CGPoint(x: bubble.minX + bubble.width * stemLocation - stemWidth / 2, y: bubble.maxY))			// left border of arrow stem
			bezier.addLine(to: CGPoint(x: bubble.minX + radius, y: bubble.maxY))												// left portion of bottom border
			bezier.addArc(withCenter: bubble.bottomLeft(inset: radius), radius: radius, startAngle: pi * 0.5, endAngle: -pi, clockwise: true)
			bezier.addLine(to: CGPoint(x: bubble.minX, y: bubble.minY + radius))												// left border
			bezier.addArc(withCenter: bubble.topLeft(inset: radius), radius: radius, startAngle: -pi, endAngle: -pi * 0.5, clockwise: true)
			bezier.addLine(to: CGPoint(x: bubble.maxX - radius, y: bubble.minY))												// top border
			bezier.addArc(withCenter: bubble.topRight(inset: radius), radius: radius, startAngle: -pi * 0.5, endAngle: 0, clockwise: true)
			bezier.addLine(to: CGPoint(x: bubble.maxX, y: bubble.maxY - radius))												// right border
			bezier.addArc(withCenter: bubble.bottomRight(inset: radius), radius: radius, startAngle: 0, endAngle: pi * 0.5, clockwise: true)
			bezier.addLine(to: CGPoint(x: bubble.minX + bubble.width * stemLocation + stemWidth / 2, y: bubble.maxY))			// right portion of bottom border
			if let arrowStart = self.arrowLocation(in: bounds) { bezier.addLine(to: arrowStart) }								// right border of arrow stem
			break
			
		case .belowRight, .below, .belowLeft:
			if self.TipPosition == .aboveRight { stemLocation = 0.8 }
			else if self.TipPosition == .aboveLeft { stemLocation = 0.3 }
			
			bezier = UIBezierPath()
			if let arrowStart = self.arrowLocation(in: bounds) { bezier.move(to: arrowStart) }
			bubble.size.height -= self.appearance.arrowLength
			bubble.origin.y += self.appearance.arrowLength
			bezier.addLine(to: CGPoint(x: bubble.minX + bubble.width * stemLocation - stemWidth / 2, y: bubble.minY))			// left border of arrow stem
			bezier.addLine(to: CGPoint(x: bubble.minX + radius, y: bubble.minY))												// left portion of top border
			bezier.addArc(withCenter: bubble.topLeft(inset: radius), radius: radius, startAngle: -pi * 0.5, endAngle: -pi, clockwise: false)
			bezier.addLine(to: CGPoint(x: bubble.minX, y: bubble.maxY - radius))												// left border
			bezier.addArc(withCenter: bubble.bottomLeft(inset: radius), radius: radius, startAngle: -pi, endAngle: pi * 0.5, clockwise: false)
			bezier.addLine(to: CGPoint(x: bubble.maxX - radius, y: bubble.maxY))												// bottom border
			bezier.addArc(withCenter: bubble.bottomRight(inset: radius), radius: radius, startAngle: pi * 0.5, endAngle: 0, clockwise: false)
			bezier.addLine(to: CGPoint(x: bubble.maxX, y: bubble.minY + radius))												// right border
			bezier.addArc(withCenter: bubble.topRight(inset: radius), radius: radius, startAngle: 0, endAngle: -pi * 0.5, clockwise: false)
			bezier.addLine(to: CGPoint(x: bubble.minX + bubble.width * stemLocation + stemWidth / 2, y: bubble.minY))			// right portion of top border
			if let arrowStart = self.arrowLocation(in: bounds) { bezier.addLine(to: arrowStart) }								// right border of arrow stem
			break
			
		case .leftSide:
			bezier = UIBezierPath()
			if let arrowStart = self.arrowLocation(in: bounds) { bezier.move(to: arrowStart) }
			bubble.size.width -= self.appearance.arrowLength
			bezier.addLine(to: CGPoint(x: bubble.maxX, y: bubble.minY + bubble.height * stemLocation + stemWidth / 2))			// bottom border of arrow stem
			bezier.addLine(to: CGPoint(x: bubble.maxX, y: bubble.maxY - radius))												// bottom portion of right border
			bezier.addArc(withCenter: bubble.bottomRight(inset: radius), radius: radius, startAngle: 0, endAngle: pi * 0.5, clockwise: true)
			bezier.addLine(to: CGPoint(x: bubble.minX + radius, y: bubble.maxY))												// bottom border
			bezier.addArc(withCenter: bubble.bottomLeft(inset: radius), radius: radius, startAngle: pi * 0.5, endAngle: pi, clockwise: true)
			bezier.addLine(to: CGPoint(x: bubble.minX, y: bubble.minY + radius))												// left border
			bezier.addArc(withCenter: bubble.topLeft(inset: radius), radius: radius, startAngle: pi, endAngle: -pi * 0.5, clockwise: true)
			bezier.addLine(to: CGPoint(x: bubble.maxX - radius, y: bubble.minY))												// top border
			bezier.addArc(withCenter: bubble.topRight(inset: radius), radius: radius, startAngle: -pi * 0.5, endAngle: 0, clockwise: true)
			bezier.addLine(to: CGPoint(x: bubble.maxX, y: bubble.minY + bubble.height * stemLocation - stemWidth / 2))			// top portion of right border
			if let arrowStart = self.arrowLocation(in: bounds) { bezier.addLine(to: arrowStart) }								// top border of arrow stem
			break
			
		case .rightSide:
			bezier = UIBezierPath()
			if let arrowStart = self.arrowLocation(in: bounds) { bezier.move(to: arrowStart) }
			bubble.size.width -= self.appearance.arrowLength
			bubble.origin.x += self.appearance.arrowLength
			bezier.addLine(to: CGPoint(x: bubble.minX, y: bubble.minY + bubble.height * stemLocation + stemWidth / 2))			// bottom border of arrow stem
			bezier.addLine(to: CGPoint(x: bubble.minX, y: bubble.maxY - radius))												// bottom portion of left border
			bezier.addArc(withCenter: bubble.bottomLeft(inset: radius), radius: radius, startAngle: -pi, endAngle: pi * 0.5, clockwise: false)
			bezier.addLine(to: CGPoint(x: bubble.maxX - radius, y: bubble.maxY))												// bottom border
			bezier.addArc(withCenter: bubble.bottomRight(inset: radius), radius: radius, startAngle: pi * 0.5, endAngle: 0, clockwise: false)
			bezier.addLine(to: CGPoint(x: bubble.maxX, y: bubble.minY + radius))												// right border
			bezier.addArc(withCenter: bubble.topRight(inset: radius), radius: radius, startAngle: 0, endAngle: -pi * 0.5, clockwise: false)
			bezier.addLine(to: CGPoint(x: bubble.minX + radius, y: bubble.minY))												// top border
			bezier.addArc(withCenter: bubble.topLeft(inset: radius), radius: radius, startAngle: -pi * 0.5, endAngle: -pi, clockwise: false)
			bezier.addLine(to: CGPoint(x: bubble.minX, y: bubble.minY + bubble.height * stemLocation - stemWidth / 2))			// top portion of left border
			if let arrowStart = self.arrowLocation(in: bounds) { bezier.addLine(to: arrowStart) }
			break
			
		default:
			break
		}
		
		self.fill.setFill()
		self.border.setStroke()
		bezier.lineWidth = self.tipBorderWidth
		
		bezier.fill()
		bezier.stroke()
		UIGraphicsPopContext()
	}
}

extension CGRect {
	func topLeft(inset: CGFloat) -> CGPoint { return CGPoint(x: self.minX + inset, y: self.minY + inset) }
	func topRight(inset: CGFloat) -> CGPoint { return CGPoint(x: self.maxX - inset, y: self.minY + inset) }
	func bottomLeft(inset: CGFloat) -> CGPoint { return CGPoint(x: self.minX + inset, y: self.maxY - inset) }
	func bottomRight(inset: CGFloat) -> CGPoint { return CGPoint(x: self.maxX - inset, y: self.maxY - inset) }
}
