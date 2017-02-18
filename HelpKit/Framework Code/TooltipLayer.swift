//
//  TooltipLayer.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/11/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit

open class TooltipLayer: CALayer {
	var arrowDirection: TooltipView.ArrowDirection { didSet { self.setNeedsDisplay() } }
	var fill: UIColor
	var border: UIColor
	var tipBorderWidth: CGFloat
	var appearance: Appearance
	
	public required init(frame: CGRect, appearance: Appearance, arrowDirection: TooltipView.ArrowDirection) {
		self.arrowDirection = arrowDirection
		self.appearance = appearance
		self.border = appearance.borderColor
		self.fill = appearance.backgroundColor
		self.tipBorderWidth = appearance.borderWidth
		super.init()
		//self.backgroundColor = UIColor.orange.cgColor
		self.frame = frame
		self.setNeedsDisplay()
	}
	
	public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
	func arrowLocation(in bounds: CGRect) -> CGPoint? {
		switch self.arrowDirection {
		case .downRight: return CGPoint(x: bounds.maxX, y: bounds.maxY)
		case .right: return CGPoint(x: bounds.maxX, y: bounds.midY)
		case .upRight: return CGPoint(x: bounds.maxX, y: bounds.minY)
		case .up: return CGPoint(x: bounds.midX, y: bounds.minY)
		case .upLeft: return CGPoint(x: bounds.minX, y: bounds.minY)
		case .left: return CGPoint(x: bounds.minX, y: bounds.midY)
		case .downLeft: return CGPoint(x: bounds.minX, y: bounds.maxY)
		case .down: return CGPoint(x: bounds.midX, y: bounds.maxY)
		
		case .none: return nil
		}
	}
	
	open override func draw(in ctx: CGContext) {
		print("Drawing \(self.arrowDirection)")
		UIGraphicsPushContext(ctx)
		let tipBounds = self.bounds.insetBy(dx: self.tipBorderWidth, dy: self.tipBorderWidth)
		var bezier = UIBezierPath(ovalIn: tipBounds)
//		let inset = self.appearance.backgroundInset
//		let bounds = CGRect(x: tipBounds.origin.x - inset.left,
//		                    y: tipBounds.origin.y - inset.top,
//		                    width: tipBounds.width + (inset.left + inset.right),
//		                    height: tipBounds.height + (inset.top + inset.bottom))
		var bubble = tipBounds
		
		if let arrowStart = self.arrowLocation(in: bounds) {
			bezier.move(to: arrowStart)
		}
		
		let stemWidth: CGFloat = self.appearance.arrowSpread
		var stemLocation: CGFloat = 0.5
		
		switch self.arrowDirection {
		case .downRight, .down, .downLeft:
			if self.arrowDirection == .upLeft { stemLocation = 0.8 }
			else if self.arrowDirection == .upRight { stemLocation = 0.2 }
			
			bezier = UIBezierPath()
			if let arrowStart = self.arrowLocation(in: bounds) { bezier.move(to: arrowStart) }
			bubble.size.height -= self.appearance.arrowLength
			bezier.addLine(to: CGPoint(x: bubble.minX + bubble.width * stemLocation - stemWidth / 2, y: bubble.maxY))
			bezier.addLine(to: CGPoint(x: bubble.minX, y: bubble.maxY))
			bezier.addLine(to: CGPoint(x: bubble.minX, y: bubble.minY))
			bezier.addLine(to: CGPoint(x: bubble.maxX, y: bubble.minY))
			bezier.addLine(to: CGPoint(x: bubble.maxX, y: bubble.maxY))
			bezier.addLine(to: CGPoint(x: bubble.minX + bubble.width * stemLocation + stemWidth / 2, y: bubble.maxY))
			if let arrowStart = self.arrowLocation(in: bounds) { bezier.addLine(to: arrowStart) }
			break
			
		case .upLeft, .up, .upRight:
			if self.arrowDirection == .downLeft { stemLocation = 0.8 }
			else if self.arrowDirection == .downRight { stemLocation = 0.3 }
			
			bezier = UIBezierPath()
			if let arrowStart = self.arrowLocation(in: bounds) { bezier.move(to: arrowStart) }
			bubble.size.height -= self.appearance.arrowLength
			bubble.origin.y += self.appearance.arrowLength
			bezier.addLine(to: CGPoint(x: bubble.minX + bubble.width * stemLocation - stemWidth / 2, y: bubble.minY))
			bezier.addLine(to: CGPoint(x: bubble.minX, y: bubble.minY))
			bezier.addLine(to: CGPoint(x: bubble.minX, y: bubble.maxY))
			bezier.addLine(to: CGPoint(x: bubble.maxX, y: bubble.maxY))
			bezier.addLine(to: CGPoint(x: bubble.maxX, y: bubble.minY))
			bezier.addLine(to: CGPoint(x: bubble.minX + bubble.width * stemLocation + stemWidth / 2, y: bubble.minY))
			if let arrowStart = self.arrowLocation(in: bounds) { bezier.addLine(to: arrowStart) }
			break
			
		case .right:
			bezier = UIBezierPath()
			if let arrowStart = self.arrowLocation(in: bounds) { bezier.move(to: arrowStart) }
			bubble.size.width -= self.appearance.arrowLength
			bezier.addLine(to: CGPoint(x: bubble.maxX, y: bubble.minY + bubble.height * stemLocation + stemWidth / 2))
			bezier.addLine(to: CGPoint(x: bubble.maxX, y: bubble.maxY))
			bezier.addLine(to: CGPoint(x: bubble.minX, y: bubble.maxY))
			bezier.addLine(to: CGPoint(x: bubble.minX, y: bubble.minY))
			bezier.addLine(to: CGPoint(x: bubble.maxX, y: bubble.minY))
			bezier.addLine(to: CGPoint(x: bubble.maxX, y: bubble.minY + bubble.height * stemLocation - stemWidth / 2))
			if let arrowStart = self.arrowLocation(in: bounds) { bezier.addLine(to: arrowStart) }
			break
			
		case .left:
			bezier = UIBezierPath()
			if let arrowStart = self.arrowLocation(in: bounds) { bezier.move(to: arrowStart) }
			bubble.size.width -= self.appearance.arrowLength
			bubble.origin.x += self.appearance.arrowLength
			bezier.addLine(to: CGPoint(x: bubble.minX, y: bubble.minY + bubble.height * stemLocation + stemWidth / 2))
			bezier.addLine(to: CGPoint(x: bubble.minX, y: bubble.maxY))
			bezier.addLine(to: CGPoint(x: bubble.maxX, y: bubble.maxY))
			bezier.addLine(to: CGPoint(x: bubble.maxX, y: bubble.minY))
			bezier.addLine(to: CGPoint(x: bubble.minX, y: bubble.minY))
			bezier.addLine(to: CGPoint(x: bubble.minX, y: bubble.minY + bubble.height * stemLocation - stemWidth / 2))
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
