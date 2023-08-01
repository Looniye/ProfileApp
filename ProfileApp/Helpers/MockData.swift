//
//  MockData.swift
//  ProfileApp
//
//  Created by Артем Крикуненко on 01.08.2023.
//

import UIKit

func createMockUserProfile() -> UserProfile {
	return UserProfile(
		firstName: "Артем",
		lastName: "Крикуненко",
		patronymic: "Геннадьевич",
		photo: UIImage(named: "photo"),
		experience: "iOS-разработчик, опыт менее 1-го года",
		city: "Тюмень",
		skills: ["Swift", "XCode", "MVP/MVC", "ООП и SOLID", "CoreData"],
		aboutMe: "Что-то тут когда-нибудь будет написано, но не сейчас, потому что я занят."
	)
}
