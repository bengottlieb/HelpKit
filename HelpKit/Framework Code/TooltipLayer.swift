//
//  TooltipLayer.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/11/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit

open class TooltipLayer: CALayer {
	var arrowDirection: TooltipView.ArrowDirection
	var fill = UIColor.orange
	var border = UIColor.black
	
	public required init(frame: CGRect, arrowDirection: TooltipView.ArrowDirection) {
		self.arrowDirection = arrowDirection
		super.init()
		self.frame = frame
		self.setNeedsDisplay()
	}
	
	public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
	open override func draw(in ctx: CGContext) {
		UIGraphicsPushContext(ctx)
		let bezier = UIBezierPath(ovalIn: self.bounds)
		
		self.fill.setFill()
		self.border.setStroke()
		
		bezier.fill()
		bezier.stroke()
		UIGraphicsPopContext()
	}
}
