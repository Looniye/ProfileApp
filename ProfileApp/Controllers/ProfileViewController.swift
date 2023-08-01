//
//  ViewController.swift
//  ProfileApp
//
//  Created by Артем Крикуненко on 01.08.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
	private let customView = ProfileView()
	var profilePresenter: ProfilePresenter
	
	init(with presenter: ProfilePresenter) {
		self.profilePresenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		self.view = self.customView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.profilePresenter.viewDidLoad(ui: self.customView)
	}
}


