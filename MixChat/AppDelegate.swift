//
//  AppDelegate.swift
//  MixChat
//
//  Created by Михаил Фокин on 19.02.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	private let logger = Logger()
	
	private enum Condition: String {
		case active
		case inactive
		case notRunning = "not running"
		case background
	}

	// Приложение было запущено, но еще не появилось на экране.
	// В этой функции можно выполнить необходимые настройки перед запуском приложения,
	// например, инициализировать базу данных, установить обработчики ошибок и т.д.
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		printLog(from: .notRunning, to: .inactive, functionName: #function)
		
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.rootViewController = setupTabBarController()
		self.window = window
		window.makeKeyAndVisible()
		let manager = ThemeManager()
		manager.setSavedUserInterfaceStyle()
		let keychaimManager = KeychainManager()
		if keychaimManager.getUUIDFromKeychain() == nil {
			keychaimManager.saveUUIDInKeychain()
		}
		return true
	}

	func applicationDidFinishLaunching(_ application: UIApplication) {
		printLog(from: .notRunning, to: .inactive, functionName: #function)
	}
	
	// Переход в активное состояние появляется на экране и готово к работе.
	// В этой функции можно выполнять дополнительные настройки, например,
	// обновлять данные, загружать рекламу и т.д.
	func applicationDidBecomeActive(_ application: UIApplication) {
		printLog(from: .inactive, to: .active, functionName: #function)
	}

	// Пеходит в состояние фотового выполнения, например, когда пользователь сворачивает приложение.
	// В этой функции можно сохранить данные и приостановить некоторые операции,
	// чтобы уменьшить нагрузку на систему.
	func applicationWillResignActive(_ application: UIApplication) {
		printLog(from: .active, to: .inactive, functionName: #function)
	}
	
	// Приложение полностью перешло в фотовый режим.
	// В этой функции можно сохранить данные, завершить некоторые операции и освободить занятые ресурсы.
	func applicationDidEnterBackground(_ application: UIApplication) {
		printLog(from: .inactive, to: .background, functionName: #function)
	}
	
	// Приложение возвращается из фонового режима и переходит в состояние ожидания.
	// В этой функции можно обновить данные и выполнить другие необходимые операции
	// перед возобновлением работы приложения.
	func applicationWillEnterForeground(_ application: UIApplication) {
		printLog(from: .background, to: .inactive, functionName: #function)
	}
	
	// Приложение завершает свою работу и выходит из системы.
	// В этой функции можно сохранить данные и освободить занятые ресурсы перед выходом из приложения.
	func applicationWillTerminate(_ application: UIApplication) {
		printLog(from: .background, to: .notRunning, functionName: #function)
	}
	
	private func printLog(from: Condition, to: Condition, functionName: String) {
		self.logger.log("Application moved from \(from.rawValue) to \(to.rawValue): \(functionName)")
	}
	
	private func setupTabBarController() -> UITabBarController {
		let tabBarController = UITabBarController()
		tabBarController.viewControllers = [
			getChannalFlow(),
			getSettingslFlow(),
			getProfilelFlow()
		]
		tabBarController.tabBar.tintColor = .systemBlue
		return tabBarController
	}
	
	private func getChannalFlow() -> UINavigationController {
		let configurator = ConversationConfigurator()
		let conversationsController = configurator.configure()
		let navigation = UINavigationController(rootViewController: conversationsController)
		navigation.tabBarItem.title = "Channels"
		navigation.tabBarItem.image = UIImage(systemName: "bubble.left.and.bubble.right")
		return navigation
	}
	
	private func getSettingslFlow() -> UINavigationController {
		let themeManager = ThemeManager()
		let themeController = ThemeViewController(themeDelegate: themeManager)
		let navigation = UINavigationController(rootViewController: themeController)
		navigation.tabBarItem.title = "Settings"
		navigation.tabBarItem.image = UIImage(systemName: "gear")
		return navigation
	}
	
	private func getProfilelFlow() -> UINavigationController {
        let configurator = ProfileConfigurator()
        let profileController = configurator.configure()
		let navigationController = UINavigationController(rootViewController: profileController)
		profileController.tabBarItem.title = "Profile"
		profileController.tabBarItem.image = UIImage(systemName: "person.circle")
		return navigationController
	}
}
