//
//  ProfilePresenter.swift
//  ProfileApp
//
//  Created by Артем Крикуненко on 01.08.2023.
//

protocol IProfilePresenter {
	func viewDidLoad(ui: IProfileView)
}

final class ProfilePresenter {
	var ui: IProfileView?
}

extension ProfilePresenter: IProfilePresenter {
	func viewDidLoad(ui: IProfileView) {
		self.ui = ui
	}
}
