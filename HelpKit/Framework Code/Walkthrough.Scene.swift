//
//  Walkthrough.Scene.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/18/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit

extension Walkthrough {
	public class Scene {
		var isOpaque = false
		var view: UIView!
		var duration: TimeInterval? { return nil }
		
		init(view: UIView) {
			self.view = view
		}
		
		convenience init(nib: UINib) { self.init(view: nib.instantiate(withOwner: nil, options: nil).first as! UIView) }
		
		convenience init(nibName: String, bundle: Bundle = .main) { self.init(nib: UINib(nibName: nibName, bundle: bundle)) }
	}
}
