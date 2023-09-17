//
//  StorageMock.swift
//  MixChatUnitTests
//
//  Created by Михаил Фокин on 10.05.2023.
//

import XCTest
import Combine
import TFSChatTransport
@testable import MixChat

final class StorageMock: StorageProtocol {

	var invokedSave = false
	var invokedSaveCount = 0
	var invokedSaveParameters: (user: SaveData, Void)?
	var invokedSaveParametersList = [(user: SaveData, Void)]()
	var stubbedSaveCompletionResult: (Result<SaveData, SaveError>, Void)?

	func save(user: SaveData, completion: @escaping (Result<SaveData, SaveError>) -> Void) {
		invokedSave = true
		invokedSaveCount += 1
		invokedSaveParameters = (user, ())
		invokedSaveParametersList.append((user, ()))
		if let result = stubbedSaveCompletionResult {
			completion(result.0)
		}
	}

	var invokedFetch = false
	var invokedFetchCount = 0
	var stubbedFetchCompletionResult: (Result<SaveData, SaveError>, Void)?

	func fetch(completion: @escaping (Result<SaveData, SaveError>) -> Void) {
		invokedFetch = true
		invokedFetchCount += 1
		if let result = stubbedFetchCompletionResult {
			completion(result.0)
		}
	}

	var invokedCancel = false
	var invokedCancelCount = 0

	func cancel() {
		invokedCancel = true
		invokedCancelCount += 1
	}
}
