//
//  UIColor + Extension.swift
//  ProfileApp
//
//  Created by Артем Крикуненко on 01.08.2023.
//

import UIKit

extension UIColor {
	static var backgroundProfile: UIColor { UIColor(named: "BackgroundProfile") ?? .white}
	static var backgroundSkills: UIColor { UIColor(named: "BackgroundSkills") ?? .white}
	static var gray = UIColor(red: 150.0 / 255.0, green: 149.0 / 255.0, blue: 155.0 / 255.0, alpha: 1.0)
}

extension String {
	func width(withFont font: UIFont) -> CGFloat {
		let fontAttributes = [NSAttributedString.Key.font: font]
		let size = (self as NSString).size(withAttributes: fontAttributes)
		return ceil(size.width)
	}
}
