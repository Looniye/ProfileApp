//
//  AppConstants.swift
//  ProfileApp
//
//  Created by Артем Крикуненко on 01.08.2023.
//

import UIKit

struct AppConstants {
	struct NavigationTitle {
		static let profile = "Профиль"
	}
	
	struct Text {
		static let titleAlertController = "Добавление навыка"
		static let message = "Введите название навыка которым вы владеете"
		static let placeholderAlert = "Введите название"
		static let titleAddAction = "Добавить"
		static let titleCancelAction = "Отмена"
		
		static let titleSkillsLabel = "Мои навыки"
		static let titleAboutMeLabel = "О себе"
		
		static let numberOFLinesZero: Int = 0
		static let numberOFLinesOne: Int = 1
		static let numberOFLinesTwo: Int = 2
	}
	
	struct Image {
		static let toggleEditButtonOff = UIImage(named: "editMode_off")
		static let toggleEditButtonOn = UIImage(systemName: "checkmark.circle")
		static let locationImage = UIImage(named: "locationImage")
		static let deleteButton = UIImage(named: "deleteButton")
		static let placeholderRecipeImage = UIImage(named: "PlaceholderRecipeImage")
		static let placeholderIngredientImage = UIImage(named: "PlaceholderIngredientImage")
	}
}
