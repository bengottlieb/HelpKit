//
//  Walkthrough+Transition.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/19/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit

extension Walkthrough {
	public struct Transition {
		public enum Phase { case `in`, out, other }
		public enum Kind: String { case fade, moveLeft, moveRight, moveUp, moveDown, pop, drop }
		public let kind: Kind
		public let duration: TimeInterval?
		public let delay: TimeInterval
		
		public init?(rawValue: String?) {
			guard let components = rawValue?.components(separatedBy: ","), let kind = Kind(rawValue: components.first ?? "") else {
				self.kind = .drop
				return nil
			}
			
			self.kind = kind
			
			if components.count > 1, let dur = TimeInterval(components[1]) {
				self.duration = dur
			} else {
				self.duration = nil
			}

			if components.count > 2, let delay = TimeInterval(components[2]) {
				self.delay = delay
			} else {
				self.delay = 0
			}
		}
		
		func transform(state: UIView.AnimatableState?, phase: Phase, in parent: Scene) -> UIView.AnimatableState? {
			guard var result = state else { return nil }
			
			switch self.kind {
			case .fade:
				result.alpha = 0
				
			case .moveLeft:
				result.frame.origin.x = phase != .in ? result.frame.origin.x - parent.view.bounds.width : result.frame.origin.x + parent.view.bounds.width
				
			case .moveRight:
				result.frame.origin.x = phase != .in ? result.frame.origin.x + parent.view.bounds.width : result.frame.origin.x - parent.view.bounds.width
				
			case .moveUp:
				result.frame.origin.y = phase != .in ? result.frame.origin.y - parent.view.bounds.height : result.frame.origin.y + parent.view.bounds.height
				
			case .moveDown:
				result.frame.origin.y = phase != .in ? result.frame.origin.y + parent.view.bounds.height : result.frame.origin.y - parent.view.bounds.height
				
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
