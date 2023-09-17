//
//  GCDWorker.swift
//  MixChat
//
//  Created by Михаил Фокин on 19.03.2023.
//

import Foundation

struct SaveData: Codable {
	var userBio: String?
	var userName: String?
	var userPhoto: Data?
}

enum SaveError: Error {
	case errorUnknown
	case errorReadFile
	case errorWriteFile
	case errorFileManger
	case errorParsingJSON
}

final class GCDWorker: StorageProtocol {

	let queue = DispatchQueue(label: "ru.mixfon.myqueue", qos: .utility)
	let keeper = Keeper(fileName: GlobalConstants.nameFileUserInfo)
	var saveItem: DispatchWorkItem?
	var fetchItem: DispatchWorkItem?
	
	func save(user: SaveData, completion: @escaping (Result<SaveData, SaveError>) -> Void) {
		self.keeper.isCancelled = false
		self.saveItem = DispatchWorkItem { [weak self] in
			if self?.saveItem?.isCancelled == false {
				self?.keeper.save(user: user, completion: completion)
			}
		}
		if let wortItem = self.saveItem {
			self.queue.async(execute: wortItem)
		}
	}

	func fetch(completion: @escaping (Result<SaveData, SaveError>) -> Void) {
		self.keeper.isCancelled = false
		self.fetchItem = DispatchWorkItem { [weak self] in
			if self?.fetchItem?.isCancelled == false {
				self?.keeper.fetch(completion: completion)
			}
		}
		if let wortItem = self.fetchItem {
			self.queue.async(execute: wortItem)
		}
	}
	
	func cancel() {
		self.saveItem?.cancel()
		self.fetchItem?.cancel()
		self.keeper.isCancelled = true
		print("cancel")
	}
}
