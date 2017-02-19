//
//  UIView+Walkthrough.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/19/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit

extension Walkthrough {
	public enum Transition { case fade, moveLeft, moveRight, moveUp, moveDown, pop, drop
		init?(rawValue: String?) {
			switch rawValue ?? "" {
			case "fade": self = .fade
			case "moveLeft": self = .moveLeft
			case "moveRight": self = .moveRight
			case "moveUp": self = .moveUp
			case "moveDown": self = .moveDown
			case "pop": self = .pop
			case "drop": self = .drop
			default: return nil
			}
		}
		
		func transform(state: UIView.AnimatableState?, forTransitionOut: Bool, in parent: Scene) -> UIView.AnimatableState? {
			guard var result = state else { return nil }
			
			switch self {
			case .fade:
				result.alpha = 0
				
			case .moveLeft:
				result.frame.origin.x = forTransitionOut ? result.frame.origin.x - parent.view.bounds.width : result.frame.origin.x + parent.view.bounds.width
				
			case .moveRight:
				result.frame.origin.x = forTransitionOut ? result.frame.origin.x + parent.view.bounds.width : result.frame.origin.x - parent.view.bounds.width
				
			case .moveUp:
				result.frame.origin.y = forTransitionOut ? result.frame.origin.y - parent.view.bounds.height : result.frame.origin.y + parent.view.bounds.height
				
			case .moveDown:
				result.frame.origin.y = forTransitionOut ? result.frame.origin.y + parent.view.bounds.height : result.frame.origin.y - parent.view.bounds.height
				
			case .pop:
				result.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
				result.alpha = 0.0
				
			case .drop:
				result.transform = CGAffineTransform(scaleX: 10, y: 10)
				result.alpha = 0.0
			}
			
			return result
		}
	}
}
