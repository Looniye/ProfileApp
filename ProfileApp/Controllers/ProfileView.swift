//
//  ProfileView.swift
//  ProfileApp
//
//  Created by Артем Крикуненко on 01.08.2023.
//

import UIKit

protocol IProfileView: AnyObject {
}

final class ProfileView: UIView {
	init() {
		super.init(frame: .zero)
		self.configureView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension ProfileView: IProfileView {
}

private extension ProfileView {
	func configureView() {
		self.backgroundColor = UIColor.white
	}
}

