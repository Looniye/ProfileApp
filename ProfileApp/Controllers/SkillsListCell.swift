//
//  SkillsListCell.swift
//  ProfileApp
//
//  Created by Артем Крикуненко on 01.08.2023.
//

import UIKit

final class SkillsListCell: UICollectionViewCell {	
	
	var isDeleteButtonVisible: Bool = false {
		didSet {
			if isAddCell {
				deleteButton.isHidden = true // Скрываем кнопку удаления для ячейки с плюсом
			} else {
				deleteButton.isHidden = !isDeleteButtonVisible
				contentView.invalidateIntrinsicContentSize()
				
			}
		}
	}
	
	var deleteButtonHandler: (() -> Void)?
	var isAddCell: Bool = false
	
	static let identifier = "IngredientListCell"
	
	let containerView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	lazy var skillNameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		label.lineBreakMode = .byTruncatingTail
		label.font = UIFont.SFProRegular
		label.textAlignment = .center
		return label
	}()
	
	lazy var deleteButton: UIButton = {
		let button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		let normalImage = UIImage(named: "deleteButton")
		button.setImage(normalImage, for: .normal)
		button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
		return button
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureView()
		contentView.autoresizingMask = .flexibleRightMargin
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		deleteButton.isHidden = true
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configure(with text: String) {
		deleteButton.isHidden = true
		skillNameLabel.text = text
	}
	
	@objc func deleteButtonTapped() {
		deleteButtonHandler?()
	}
	
	override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
		setNeedsLayout()
		layoutIfNeeded()
		let size = contentView.systemLayoutSizeFitting(layoutAttributes.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
		var frame = layoutAttributes.frame
		frame.size.height = ceil(size.height)
		layoutAttributes.frame = frame
		return layoutAttributes
	}
}

private extension SkillsListCell {
	func configureView() {
		contentView.backgroundColor = UIColor.backgroundProfile
		contentView.layer.cornerRadius = 12.0
		contentView.addSubview(containerView)
		containerView.addSubview(skillNameLabel)
		containerView.addSubview(deleteButton)
		
		NSLayoutConstraint.activate([
			containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
			containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			
			skillNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
			skillNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
			skillNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
			
			deleteButton.leadingAnchor.constraint(equalTo: skillNameLabel.trailingAnchor, constant: 5),
			deleteButton.centerYAnchor.constraint(equalTo: skillNameLabel.centerYAnchor),
			deleteButton.widthAnchor.constraint(equalToConstant: 14),
			deleteButton.heightAnchor.constraint(equalTo: deleteButton.widthAnchor),
		])
	}
}

extension ProfileView: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout {
	
	// MARK: - UITableViewDataSource
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return isEditMode ? skills.count + 1 : skills.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkillsListCell.identifier, for: indexPath) as? SkillsListCell else {
			return UICollectionViewCell()
		}
		
		if isEditMode && indexPath.row == skills.count {
			cell.configure(with: "+")
			cell.isAddCell = true
			
		} else {
			cell.configure(with: skills[indexPath.row])
			cell.isAddCell = false
			
		}
		cell.isDeleteButtonVisible = isEditMode
		
		cell.deleteButtonHandler = { [weak self] in
			self?.handleDeleteButtonTapped(at: indexPath.item)
		}
		
		return cell
	}
	
	// MARK: UICollectionViewDelegate
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if isEditMode && indexPath.row == skills.count {
			addSkillButtonTapped()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		guard indexPath.row < skills.count else {
			return CGSize(width: 100, height: 44)
		}
		
		let cellWidth = skills[indexPath.row].width(withFont: UIFont.SFProRegular) + 48
		return CGSize(width: cellWidth, height: 44)
	}
}

extension ProfileView {
	func handleDeleteButtonTapped(at index: Int) {
		
		guard index >= 0, index < skills.count else {
			return
		}
		skills.remove(at: index)
		skillsCollectionView.reloadData()
	}
}
