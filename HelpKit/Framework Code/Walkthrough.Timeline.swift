//
//  Walkthrough.Timeline.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/20/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit

extension Walkthrough {
	public class Timeline {
		var startedAt: Date!
		weak var timer: Timer?
		var nextOffset: TimeInterval?
		
		public func start() {
			self.startedAt = Date()
			self.sortEvents()
		}
		
		public func reset() {
			self.startedAt = Date()
			self.events = []
			self.tags = [:]
		}
		
		public func end( ){
			self.timer?.invalidate()
		}
		
		public func queueEvent(tag: Tag? = nil, at: TimeInterval, relativeTo: Tag? = nil, closure: @escaping () -> Void) {
			let event = Event(offset: at, tag: tag, relativeTo: relativeTo, closure: closure)
			self.events.append(event)
			if let tag = tag { self.tags[tag] = event }
			
			self.sortEvents()
		}
		
		var events: [Event] = []
		
		var nextEvent: Event? {
			return self.events.first
		}
		
		var tags: [Tag: Event] = [:]
		
		func sortEvents() {
			if self.startedAt == nil { return }
			
			self.events = self.events.sorted { e1, e2 in
				let o1 = e1.offset(self.tags)
				let o2 = e2.offset(self.tags)
				
				if o1 == o2 {
					if e1.relativeTo != nil { return false }
					return true
				}
				return o1 < o2
			}
			
			self.setupTimer()
		}
		
		func setupTimer() {
			if let next = self.events.first?.offset(self.tags), self.nextOffset != next {
				let interval = next - Date().timeIntervalSince(self.startedAt)
				self.timer?.invalidate()
				
				if interval < 0 {
					self.fireAll(upTo: next)
				} else {
					self.timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(fireNext), userInfo: next, repeats: false)
				}
				self.nextOffset = next
			}
		}
		
		@objc func fireNext(timer: Timer) {
			self.fireAll(upTo: timer.userInfo as! TimeInterval)
		}
		
		func fireAll(upTo: TimeInterval) {
			while let next = self.events.first {
				let offset = next.offset(self.tags)
				
				if offset <= upTo {
					next.closure()
					self.events.remove(at: 0)
				} else {
					self.setupTimer()
					break
				}
			}
		}
	}
}

extension Walkthrough.Timeline {
	public typealias Tag = String
	struct Event: Equatable {
		let offset: TimeInterval
		let tag: Tag?
		let relativeTo: Tag?
		let closure: () -> Void
		
		func offset(_ tags: [Tag: Event]) -> TimeInterval {
			if let tag = self.relativeTo, let tagOffset = tags[tag]?.offset(tags) {
				return tagOffset + self.offset
			}
			return self.offset
		}
		
		init(offset: TimeInterval, tag: Tag? = nil, relativeTo: Tag? = nil, closure: @escaping () -> Void) {
			self.offset = offset
			self.tag = tag
			self.closure = closure
			self.relativeTo = relativeTo
		}
		
		static func ==(lhs: Event, rhs: Event) -> Bool {
			if let ltag = lhs.tag, ltag != rhs.tag { return false }
			if let rtag = rhs.tag, rtag != lhs.tag { return false }
			return lhs.offset == rhs.offset
		}
	}
}
