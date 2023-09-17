//
//  CombineWorker.swift
//  MixChat
//
//  Created by Михаил Фокин on 28.03.2023.
//

import Combine
import Foundation

final class CombineWorker: StorageProtocol {
	
	private let queue = DispatchQueue(label: "ru.mixfon.myqueue", qos: .utility)
	
	private let encoder = JSONEncoder()
	private let decoder = JSONDecoder()
	
	private var cancellable: AnyCancellable?
	
	func save(user: SaveData, completion: @escaping (Result<SaveData, SaveError>) -> Void) {
		let publisher = Just(user)
			.subscribe(on: queue)
			.encode(encoder: encoder)
			.mapError { $0 as Error }
			.tryMap { jsonData in
				let fileManager = FileManager.default
				guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
					throw SaveError.errorFileManger
				}
				let fileURL = documentsDirectory.appendingPathComponent(GlobalConstants.nameFileUserInfo)
				try jsonData.write(to: fileURL)
				return user
			}
			.eraseToAnyPublisher()
		self.cancellable = publisher
			.sink(
				receiveCompletion: { completionResult in
					switch completionResult {
					case .failure(let error):
						if let savedError = error as? SaveError {
							completion(.failure(savedError))
						} else {
							completion(.failure(.errorUnknown))
						}
					case .finished:
						print("finished")
					}
					print("Completion: \(completionResult)")
				},
				receiveValue: { savedData in
					print("Saved file: \(savedData)")
					completion(.success(savedData))
				}
			)
	}
	
	func fetch(completion: @escaping (Result<SaveData, SaveError>) -> Void) {
		let publisher = Just(GlobalConstants.nameFileUserInfo)
			.subscribe(on: queue)
			.tryMap { fileName in
				let fileManager = FileManager.default
				guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
					throw SaveError.errorFileManger
				}
				let fileURL = documentsDirectory.appendingPathComponent(fileName)
				guard let jsonData = try? Data(contentsOf: fileURL) else {
					throw SaveError.errorReadFile
				}
				return jsonData
			}
			.mapError { $0 as Error }
			.decode(type: SaveData.self, decoder: self.decoder)
			.eraseToAnyPublisher()
		
		self.cancellable = publisher
			.sink(
				receiveCompletion: { completionResult in
					switch completionResult {
					case .failure(let error):
						if let savedError = error as? SaveError {
							completion(.failure(savedError))
						} else {
							completion(.failure(.errorUnknown))
						}
					case .finished:
						print("finished")
					}
					print("Completion: \(completionResult)")
				},
				receiveValue: { savedData in
					print("Loaded file: \(savedData)")
					completion(.success(savedData))
				}
			)
	}
	
	func cancel() {
		self.cancellable?.cancel()
	}
}
