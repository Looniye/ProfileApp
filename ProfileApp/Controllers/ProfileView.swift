//
//  ProfileView.swift
//  ProfileApp
//
//  Created by Артем Крикуненко on 01.08.2023.
//

import UIKit

protocol IProfileView: AnyObject, UICollectionViewDelegate, UICollectionViewDataSource {
	func setDelegateDataSource(delegate: UICollectionViewDelegate & UICollectionViewDataSource)
	func updateUI(with data: UserProfile)
}

final class ProfileView: UIView {
	private var profile: UserProfile?
	var skills: [String] = []
	var isEditMode = false
	var onButtonToggleEditButtonTapped: (() -> Void)?
	var onButtonAddSkillButtonTapped: (() -> Void)?
	var skillsCollectionViewHeightConstraint: NSLayoutConstraint!
	
	private let scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.isDirectionalLockEnabled = true
		scrollView.backgroundColor = .white
		return scrollView
	}()
	
	private let topContainer: UIView = {
		let contentView = UIView()
		contentView.translatesAutoresizingMaskIntoConstraints = false
		contentView.backgroundColor = UIColor.backgroundProfile
		return contentView
	}()
	
	private let bottomContainer: UIView = {
		let contentView = UIView()
		contentView.translatesAutoresizingMaskIntoConstraints = false
		contentView.backgroundColor = UIColor.white
		return contentView
	}()
	
	private let profileImage: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.layer.cornerRadius = 60
		return imageView
	}()
	
	private lazy var nameProfileLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = AppConstants.Text.numberOFLinesTwo
		label.font = UIFont.SFProBold
		label.textAlignment = .center
		return label
	}()
	
	private lazy var experienceProfileLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = AppConstants.Text.numberOFLinesZero
		label.font = UIFont.SFProRegular
		label.textColor = .gray
		label.textAlignment = .center
		return label
	}()
	
	private lazy var cityProfileLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = AppConstants.Text.numberOFLinesZero
		label.font = UIFont.SFProRegular
		label.textColor = .gray
		label.textAlignment = .center
		return label
	}()
	
	private let locationImage: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.image = AppConstants.Image.locationImage
		return imageView
	}()
	
	private lazy var titleSkillsLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = AppConstants.Text.numberOFLinesZero
		label.font = UIFont.SFProMedium
		label.text = AppConstants.Text.titleSkillsLabel
		return label
	}()
	
	private lazy var toggleEditButton: UIButton = {
		let button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		let normalImage = AppConstants.Image.toggleEditButtonOff
		button.setImage(normalImage, for: .normal)
		button.tintColor = .black
		button.addTarget(self, action: #selector(toggleEditButtonTapped), for: .touchUpInside)
		return button
	}()
	
	let skillsCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.minimumLineSpacing = 12
		layout.minimumInteritemSpacing = 12
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.translatesAutoresizingMaskIntoConstraints = false
		cv.backgroundColor = .white
		cv.showsVerticalScrollIndicator = false
		cv.register(SkillsListCell.self, forCellWithReuseIdentifier: SkillsListCell.identifier)
		return cv
	}()
	
	private lazy var titleAboutMeLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.SFProMedium
		label.text = AppConstants.Text.titleAboutMeLabel
		return label
	}()
	
	private lazy var aboutMeLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = AppConstants.Text.numberOFLinesZero
		label.font = UIFont.SFProRegular
		return label
	}()
	
	init() {
		super.init(frame: .zero)
		self.configureView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc  func toggleEditButtonTapped() {
		if toggleEditButton.currentImage == AppConstants.Image.toggleEditButtonOff {
			toggleEditButton.setImage(AppConstants.Image.toggleEditButtonOn, for: .normal)
		} else {
			toggleEditButton.setImage(AppConstants.Image.toggleEditButtonOff, for: .normal)
		}
		onButtonToggleEditButtonTapped?()
	}
	
	@objc  func addSkillButtonTapped() {
		onButtonAddSkillButtonTapped?()
		updateTable()
	}
	
	@objc  func deleteSkill(sender: UIButton) {
		if let cell = sender.superview as? UICollectionViewCell, let indexPath = skillsCollectionView.indexPath(for: cell) {
			skills.remove(at: indexPath.row)
			skillsCollectionView.reloadData()
		}
	}
}

extension ProfileView: IProfileView {
	func setDelegateDataSource(delegate: UICollectionViewDelegate & UICollectionViewDataSource) {
		skillsCollectionView.dataSource = delegate
		skillsCollectionView.delegate = delegate
	}
	
	func updateTable(){
		skillsCollectionView.reloadData()
		updateCollectionViewHeight()
	}
	
	func updateUI(with data: UserProfile) {
		profile = data
		nameProfileLabel.text = "\(data.lastName) \(data.firstName)\n\(data.patronymic)"
		
		experienceProfileLabel.text = data.experience
		cityProfileLabel.text = data.city
		skills.append(contentsOf: data.skills)
		aboutMeLabel.text = data.aboutMe
		profileImage.image = data.photo
		
		DispatchQueue.main.async { [weak self] in
			guard let self else { return }
			self.skillsCollectionView.collectionViewLayout.invalidateLayout()
			self.skillsCollectionView.reloadData()
			
		}
	}
	
	func updateCollectionViewHeight() {
		let itemHeight: CGFloat = 44
		let collectionViewHeight = CGFloat(skills.count) * itemHeight / 1.5
		skillsCollectionViewHeightConstraint.constant = collectionViewHeight
		layoutIfNeeded()
	}
}

private extension ProfileView {
	func configureView() {
		self.backgroundColor = UIColor.backgroundProfile
		self.addSubview(scrollView)
		scrollView.addSubview(topContainer)
		scrollView.addSubview(bottomContainer)
		topContainer.addSubview(profileImage)
		topContainer.addSubview(nameProfileLabel)
		topContainer.addSubview(experienceProfileLabel)
		topContainer.addSubview(cityProfileLabel)
		topContainer.addSubview(locationImage)
		
		bottomContainer.addSubview(titleSkillsLabel)
		bottomContainer.addSubview(toggleEditButton)
		bottomContainer.addSubview(skillsCollectionView)
		bottomContainer.addSubview(titleAboutMeLabel)
		bottomContainer.addSubview(aboutMeLabel)
		
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			
			topContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
			topContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			topContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			topContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
			
			bottomContainer.topAnchor.constraint(equalTo: topContainer.bottomAnchor),
			bottomContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			bottomContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			bottomContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			
			profileImage.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 24),
			profileImage.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor),
			profileImage.widthAnchor.constraint(equalToConstant: 120),
			profileImage.heightAnchor.constraint(equalToConstant: 120),
			
			nameProfileLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 16),
			nameProfileLabel.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor),
			
			experienceProfileLabel.topAnchor.constraint(equalTo: nameProfileLabel.bottomAnchor, constant: 4),
			experienceProfileLabel.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor),
			
			cityProfileLabel.topAnchor.constraint(equalTo: experienceProfileLabel.bottomAnchor),
			cityProfileLabel.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor),
			cityProfileLabel.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: -19),
			
			locationImage.trailingAnchor.constraint(equalTo: cityProfileLabel.leadingAnchor, constant: -2),
			locationImage.centerYAnchor.constraint(equalTo: cityProfileLabel.centerYAnchor),
			locationImage.widthAnchor.constraint(equalToConstant: 16),
			
			titleSkillsLabel.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 21),
			titleSkillsLabel.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 16),
			
			toggleEditButton.centerYAnchor.constraint(equalTo: titleSkillsLabel.centerYAnchor),
			toggleEditButton.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: -16),
			
			skillsCollectionView.topAnchor.constraint(equalTo: titleSkillsLabel.bottomAnchor, constant: 16),
			skillsCollectionView.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 16),
			skillsCollectionView.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: -16),
			skillsCollectionView.bottomAnchor.constraint(equalTo: titleAboutMeLabel.topAnchor, constant: -24),
			
			titleAboutMeLabel.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 16),
			
			aboutMeLabel.topAnchor.constraint(equalTo: titleAboutMeLabel.bottomAnchor, constant: 8),
			aboutMeLabel.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 16),
			aboutMeLabel.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: -16),
			aboutMeLabel.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor, constant: -24),
		])
		
		skillsCollectionViewHeightConstraint = skillsCollectionView.heightAnchor.constraint(equalToConstant: 100)
		skillsCollectionViewHeightConstraint.isActive = true
	}
}
