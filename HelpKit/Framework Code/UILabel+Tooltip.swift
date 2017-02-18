//
//  UILabel+Tooltip.swift
//  HelpKit
//
//  Created by Ben Gottlieb on 2/17/17.
//  Copyright © 2017 Stand Alone, Inc. All rights reserved.
//

import UIKit

public extension UILabel {
	public convenience init?(tooltipTitle title: String?, body: String?, appearance: Appearance) {
		if (title == nil || title!.isEmpty) && (body == nil || body!.isEmpty) { self.init(frame: CGRect.zero); return nil }
		
		let minHeight = appearance.minimumHeight(forTitle: title, and: body)
		var labelSize = CGSize(width: TooltipView.maxTooltipWidth, height: minHeight)
		let minWidth: CGFloat = 20
		let content = NSMutableAttributedString()
		let checkChunk: CGFloat = 15.0
		
		if let title = title, !title.isEmpty { content.append(NSAttributedString(string: title, attributes: appearance.titleAttributes)) }
		if let body = body, !body.isEmpty { content.append(NSAttributedString(string: body, attributes: appearance.bodyAttributes)) }
		
		while labelSize.width > minWidth, labelSize.height < labelSize.width {
			let limit = CGSize(width: labelSize.width - checkChunk, height: CGFloat.greatestFiniteMagnitude)
			let size = content.boundingRect(with: limit, options: [.usesLineFragmentOrigin], context: nil).size
			
			if size.width < minWidth || size.height > size.width || size.height < minHeight { break }
			labelSize = size
		}
		
		self.init(frame: CGRect(origin: .zero, size: CGSize(width: ceil(labelSize.width), height: ceil(labelSize.height))))
		self.attributedText = content
		self.numberOfLines = 0
		self.lineBreakMode = .byWordWrapping
		
		self.backgroundColor = .clear
		//self.backgroundColor = .green
	}
	
	
}
