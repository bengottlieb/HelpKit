//
//  Walkthrough.Script.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/22/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import Foundation
import UIKit

extension Walkthrough { 
	public class Script {
		public typealias ActionClosure = (@escaping () -> Void) -> Void
		
		var actions: [ScriptAction] = []
		var currentAction: ScriptAction?
		var index = 0
		var completion: (() -> Void)?
		var walkthrough: Walkthrough { return self.scene.walkthrough }
		var scene: Scene!
		var actionStartedAt: Date!
		
		func start(in scene: Scene, completion: (() -> Void)? = nil) {
			if self.actions.count == 0 { return }
			self.currentAction = self.actions.first
			self.actionStartedAt = Date()
			self.index = 0
			self.scene = scene
			self.currentAction?.run(in: self.walkthrough) {
				self.continue()
			}
		}
		
		func `continue`() {
			self.index += 1
			self.currentAction?.duration = self.actionStartedAt!.timeIntervalSinceNow

			if self.index < self.actions.count {
				self.currentAction = self.actions[self.index]
				self.currentAction?.run(in: self.walkthrough) {
					self.continue()
				}
			} else {
				self.currentAction = nil
				self.completion?()
			}
		}
		
		public func wait(_ duration: TimeInterval) {
			self.actions.append(ScriptAction(duration: duration))
		}
		
		public func then(_ transition: Walkthrough.Transition, sceneID: String, direction: Direction = .in, duration: TimeInterval? = nil) {
			self.actions.append(ScriptAction(transition: transition, sceneID: sceneID, batchID: nil, direction: direction, duration: duration))
		}

		public func then(_ transition: Walkthrough.Transition, batchID: String, direction: Direction = .in, duration: TimeInterval? = nil) {
			self.actions.append(ScriptAction(transition: transition, sceneID: nil, batchID: batchID, direction: direction, duration: duration))
		}
		
		public func then(_ closure: @escaping Script.ActionClosure) {
			self.actions.append(ScriptAction(closure: closure))
		}

		public func finish() {
			self.actions.append(ScriptAction(.finish))
		}
	}
	
	public struct ScriptAction {
		enum Special { case finish }
		var duration: TimeInterval
		var sceneID: String?
		var batchID: String?
		var transition: Transition?
		var direction: Direction = .in
		var closure: Script.ActionClosure?
		var special: Special?
		
		init(duration: TimeInterval) {
			self.duration = duration
		}
		
		init(_ special: Special) {
			self.special = special
			self.duration = 0
		}
		
		init(transition: Walkthrough.Transition, sceneID: String? = nil, batchID: String? = nil, direction: Direction = .in, duration: TimeInterval?) {
			self.transition = transition
			self.sceneID = sceneID
			self.batchID = batchID
			self.direction = direction
			self.duration = duration ?? transition.duration!
		}
		
		init(closure: @escaping Script.ActionClosure) {
			self.closure = closure
			self.duration = -1
		}
		
		mutating func run(in walkthrough: Walkthrough, completion: @escaping () -> Void) {
			if let closure = self.closure {
				closure() { completion() }
			} else
			if let sceneID = self.sceneID, let transition = self.transition {
				walkthrough.apply(transition, direction: self.direction, sceneID: sceneID, over: self.duration)
				DispatchQueue.main.asyncAfter(deadline: .now() + self.duration, execute: completion)
			} else if let batchID = self.batchID, let transition = self.transition {
				walkthrough.apply(transition, direction: self.direction, batchID: batchID, over: self.duration)
				DispatchQueue.main.asyncAfter(deadline: .now() + self.duration, execute: completion)
			} else if let special = self.special {
				switch special {
				case .finish:
					walkthrough.advance()
				}
			} else {
				DispatchQueue.main.asyncAfter(deadline: .now() + self.duration, execute: completion)
			}
		}
	}
}
