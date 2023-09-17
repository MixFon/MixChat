//
//  Keeper.swift
//  MixChat
//
//  Created by Михаил Фокин on 21.03.2023.
//

import Foundation

/// Менеджер для сохранения/загрузки информации пользователя.
final class Keeper {
	var isCancelled: Bool = false
	var fileName: String
	
	init(fileName: String) {
		self.fileName = fileName
	}
	
	func save(user: SaveData, completion: @escaping (Result<SaveData, SaveError>) -> Void) {
		let encoder = JSONEncoder()
		let jsonData = try? encoder.encode(user)
		let fileManager = FileManager.default
		guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
			completion(.failure(.errorFileManger))
			return
		}
		let fileURL = documentsDirectory.appendingPathComponent(self.fileName)
		do {
			if !self.isCancelled {
				try jsonData?.write(to: fileURL)
				completion(.success(user))
			}
		} catch {
			print(error.localizedDescription)
			completion(.failure(.errorWriteFile))
			return
		}
	}
	
	func fetch(completion: @escaping (Result<SaveData, SaveError>) -> Void) {
		let fileManager = FileManager.default
		guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
		let fileURL = documentsDirectory.appendingPathComponent(self.fileName)
		guard let jsonData = try? Data(contentsOf: fileURL) else {
			completion(.failure(.errorReadFile))
			return
		}
		let decoder = JSONDecoder()
		do {
			if !self.isCancelled {
				let person = try decoder.decode(SaveData.self, from: jsonData)
				completion(.success(person))
			}
		} catch {
			print(error.localizedDescription)
			completion(.failure(.errorParsingJSON))
		}
	}
}
