//
//  SceneDelegate.swift
//  ProfileApp
//
//  Created by Артем Крикуненко on 01.08.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	
	var window: UIWindow?
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		let viewController = ProfileViewController(with: ProfilePresenter())
		let navigationController = UINavigationController(rootViewController: viewController)
		
		let window = UIWindow(windowScene: windowScene)
		window.rootViewController = navigationController
		self.window = window
		window.makeKeyAndVisible()
	}
}
