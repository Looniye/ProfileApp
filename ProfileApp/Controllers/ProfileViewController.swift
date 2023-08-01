//
//  ProfileViewController.swift
//  ProfileApp
//
//  Created by Артем Крикуненко on 01.08.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
	private lazy var customView: ProfileView = {
		let view = ProfileView()
		view.onButtonToggleEditButtonTapped = { [weak self] in
			self?.toggleEditMode()
		}
		view.onButtonAddSkillButtonTapped = { [weak self] in
			self?.addSkill()
		}
		return view
	}()
	
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
		setupNavigationController()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.profilePresenter.viewDidLoad(ui: self.customView)
		self.profilePresenter.fetchUserProfile()
	}
	
	@objc private func toggleEditMode() {
		customView.isEditMode = !customView.isEditMode
		customView.skillsCollectionView.reloadData()
	}
	
	@objc private func addSkill() {
		let alertController = UIAlertController(title: "Добавление навыка", message: "Введите название навыка которым вы владеете", preferredStyle: .alert)
		alertController.addTextField { textField in
			textField.placeholder = "Введите название"
		}
		let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
			if let skill = alertController.textFields?.first?.text {
				self?.customView.skills.append(skill)
				self?.customView.updateTable()
			}
		}
		let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
		alertController.addAction(addAction)
		alertController.addAction(cancelAction)
		present(alertController, animated: true, completion: nil)
	}
	
	func handleDeleteButtonTapped(at index: Int) {
		customView.skills.remove(at: index)
		customView.skillsCollectionView.reloadData()
	}
}

private extension ProfileViewController {
	func setupNavigationController(){
		navigationItem.title = AppConstants.NavigationTitle.profile
	}
}
