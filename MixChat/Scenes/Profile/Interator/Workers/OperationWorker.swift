//
//  OperationWorker.swift
//  MixChat
//
//  Created by Михаил Фокин on 19.03.2023.
//

import Foundation

final class SaveOperation: Operation {
	
	private let fileName = GlobalConstants.nameFileUserInfo
	private var user: SaveData
	private let keeper = Keeper(fileName: GlobalConstants.nameFileUserInfo)
	
	var completion: ((Result<SaveData, SaveError>) -> Void)?
	
	init(user: SaveData) {
		self.user = user
	}

	override func main() {
		guard let completion else { return }
		if !self.isCancelled {
			self.keeper.save(user: self.user, completion: completion)
		}
	}
	
	override func cancel() {
		super.cancel()
		self.keeper.isCancelled = true
	}
}

final class FetchOperation: Operation {
	
	private let keeper = Keeper(fileName: GlobalConstants.nameFileUserInfo)
	var completion: ((Result<SaveData, SaveError>) -> Void)?
	
	override func main() {
		guard let completion else { return }
		if !self.isCancelled {
			self.keeper.fetch(completion: completion)
		}
	}
	
	override func cancel() {
		super.cancel()
		self.keeper.isCancelled = true
	}
}

final class OperationWorker: StorageProtocol {
	
	private let queue = OperationQueue()
	private var saveOperation: SaveOperation?
	private var fetchOperation: FetchOperation?
	
	func save(user: SaveData, completion: @escaping (Result<SaveData, SaveError>) -> Void) {
		self.saveOperation = SaveOperation(user: user)
		self.saveOperation?.completion = completion
		if let saveOperation {
			self.queue.addOperation(saveOperation)
		}
	}
	
	func fetch(completion: @escaping (Result<SaveData, SaveError>) -> Void) {
		self.fetchOperation = FetchOperation()
		self.fetchOperation?.completion = completion
		if let fetchOperation {
			self.queue.addOperation(fetchOperation)
		}
	}
	
	func cancel() {
		self.saveOperation?.cancel()
		self.fetchOperation?.cancel()
	}
}
