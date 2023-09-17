//
//  KeychainManager.swift
//  MixChat
//
//  Created by Михаил Фокин on 06.04.2023.
//

import UIKit
import Security
import Foundation

protocol KeychainManagerProtocol {
	func saveUUIDInKeychain()
	func getUUIDFromKeychain() -> String?
}

class KeychainManager: KeychainManagerProtocol {
	
	private let keychainIdentifier = "ru.mixfon.keychain.uuid"
	private lazy var logger = Logger()
	
	func saveUUIDInKeychain() {
		// Создаем идентификатор ключа
		guard let uuid = UIDevice.current.identifierForVendor?.uuidString else { return }
		
		guard let uuidData = uuid.data(using: .utf8) else { return }
		// Создаем словарь параметров, необходимых для добавления/обновления значения ключа
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: keychainIdentifier,
			kSecValueData as String: uuidData
		]
		
		// Добавляем/обновляем значение ключа в Keychain
		let status = SecItemAdd(query as CFDictionary, nil)
		guard status == errSecSuccess else {
			self.logger.log("Не удалось сохранить UUID в Keychain")
			return
		}
		
		self.logger.log("UUID успешно сохранен в Keychain")
	}
	
	func getUUIDFromKeychain() -> String? {
		
		// Создаем словарь параметров, необходимых для получения значения ключа
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: keychainIdentifier,
			kSecReturnData as String: kCFBooleanTrue ?? true,
			kSecMatchLimit as String: kSecMatchLimitOne
		]
		
		// Получаем значение ключа из Keychain
		var dataTypeRef: AnyObject?
		let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
		guard status == errSecSuccess, let data = dataTypeRef as? Data, let uuid = String(data: data, encoding: .utf8) else {
			self.logger.log("Не удалось получить UUID из Keychain")
			return nil
		}
		
		self.logger.log("UUID успешно получен из Keychain")
		return uuid
	}
}
