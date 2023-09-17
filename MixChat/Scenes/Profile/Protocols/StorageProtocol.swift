//
//  StorageProtocol.swift
//  MixChat
//
//  Created by Михаил Фокин on 19.03.2023.
//

import Foundation

protocol StorageProtocol {
	func save(user: SaveData, completion: @escaping (Result<SaveData, SaveError>) -> Void)
	func fetch(completion: @escaping (Result<SaveData, SaveError>) -> Void)
	func cancel()
}
