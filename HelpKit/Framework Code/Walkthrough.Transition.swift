//
//  Walkthrough+Transition.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/19/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit

extension Walkthrough {
	public enum Direction { case `in`, out, none }
	public enum EndPoint { case begin, end }
	public struct Transition {
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
		
		public init(kind: Kind, duration: TimeInterval? = nil, delay: TimeInterval = 0) {
			self.kind = kind
			self.duration = duration
			self.delay = delay
		}
		
		var inverse: Transition {
			switch self.kind {
			case .moveLeft:	return Transition(kind: .moveRight, duration: self.duration, delay: self.delay)
			case .moveRight:	return Transition(kind: .moveLeft, duration: self.duration, delay: self.delay)
			case .moveUp:	return Transition(kind: .moveDown, duration: self.duration, delay: self.delay)
			case .moveDown:	return Transition(kind: .moveUp, duration: self.duration, delay: self.delay)
			default: return self
			}
		}
		
		func transform(state: UIView.AnimatableState?, direction: Direction, endPoint: EndPoint, in parent: Scene) -> UIView.AnimatableState? {
			guard var result = state else { return nil }
			
			let disappearing = direction != .in
			
			if endPoint == .begin {			//how should we set things up before the animation begins?
				switch self.kind {
				case .fade:
					result.alpha = disappearing ? 1.0 : 0.0
					
				case .moveLeft:
					if !disappearing { result.frame.origin.x = result.frame.origin.x + parent.view.bounds.width }
					
				case .moveRight:
					if !disappearing { result.frame.origin.x = result.frame.origin.x - parent.view.bounds.width }
					
				case .moveUp:
					if !disappearing { result.frame.origin.y = result.frame.origin.y + parent.view.bounds.height }
					
				case .moveDown:
					if !disappearing { result.frame.origin.y = result.frame.origin.y - parent.view.bounds.height }
					
				case .pop:
					if !disappearing {
						result.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
						result.alpha = 0.0
					} else {
						result.transform = .identity
						result.alpha = 1.0
					}
					
				case .drop:
					if !disappearing {
						result.transform = CGAffineTransform(scaleX: 10.0, y: 10.0)
						result.alpha = 0.0
					} else {
						result.transform = .identity
						result.alpha = 1.0
					}
				}
			} else {
				switch self.kind {
				case .fade:
					result.alpha = disappearing ? 0.0 : 1.0
					
				case .moveLeft:
					if disappearing { result.frame.origin.x = result.frame.origin.x + parent.view.bounds.width }
					
				case .moveRight:
					if disappearing { result.frame.origin.x = result.frame.origin.x - parent.view.bounds.width }
					
				case .moveUp:
					if disappearing { result.frame.origin.y = result.frame.origin.y + parent.view.bounds.height }
					
				case .moveDown:
					if disappearing { result.frame.origin.y = result.frame.origin.y - parent.view.bounds.height }
					
				case .pop:
					if disappearing {
						result.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
						result.alpha = 0.0
					} else {
						result.transform = .identity
						result.alpha = 1.0
					}
					
				case .drop:
					if disappearing {
						result.transform = CGAffineTransform(scaleX: 10.0, y: 10.0)
						result.alpha = 0.0
					} else {
						result.transform = .identity
						result.alpha = 1.0
					}
				}
			}
			
			return result
		}
	}
}

extension Walkthrough.Transition {
	public static let fade = Walkthrough.Transition(kind: .fade, duration: 0.2)
	public static let moveLeft = Walkthrough.Transition(kind: .moveLeft, duration: 0.2)
	public static let moveRight = Walkthrough.Transition(kind: .moveRight, duration: 0.2)
	public static let moveUp = Walkthrough.Transition(kind: .moveUp, duration: 0.2)
	public static let moveDown = Walkthrough.Transition(kind: .moveDown, duration: 0.2)
	public static let pop = Walkthrough.Transition(kind: .pop, duration: 0.2)
	public static let drop = Walkthrough.Transition(kind: .drop, duration: 0.2)
}

