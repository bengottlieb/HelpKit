//
//  Appearance.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/6/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit

public struct Appearance {
	
	public static var standard = Appearance()
	
	
	var backgroundColor = UIColor(white: 0.75, alpha: 0.9)
	var textColor = UIColor.black
	var titleFont = UIFont.boldSystemFont(ofSize: 14)
	var bodyFont = UIFont.systemFont(ofSize: 13)
	
	var contentInset = UIEdgeInsets.zero
	
	var arrowDistance: CGFloat = 10
	var arrowSpread: CGFloat = 10			// how wide is the base of the arrow?
	var arrowPoint: CGFloat = 1				// how wide is the tip of the arrow?
	var arrowLength: CGFloat = 20			// how 'long' is the arrow?
	var arrowSpacingFromEdge: CGFloat = 5
}
