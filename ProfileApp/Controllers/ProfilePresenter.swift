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
	private var model: UserProfile?
	
	func fetchUserProfile() {
		self.model = createMockUserProfile()
		
		if let ui = ui, let model = self.model {
			ui.updateUI(with: model)
		}
	}
}

extension ProfilePresenter: IProfilePresenter {
	func viewDidLoad(ui: IProfileView) {
		self.ui = ui
		self.ui?.setDelegateDataSource(delegate: ui)
		guard let profile = model else { return }
		self.ui?.updateUI(with: profile)
	}
}
