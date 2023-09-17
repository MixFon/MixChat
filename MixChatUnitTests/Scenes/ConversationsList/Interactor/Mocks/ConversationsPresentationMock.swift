//
//  ConversationsPresentationMock.swift
//  MixChatUnitTests
//
//  Created by Михаил Фокин on 08.05.2023.
//

import XCTest
@testable import MixChat

final class ConversationsPresenterMock: ConversationsPresentationLogic {

	var invokedBuildState = false
	var invokedBuildStateCount = 0
	var invokedBuildStateParameters: (response: ConversationsModel.Response, Void)?
	var invokedBuildStateParametersList = [(response: ConversationsModel.Response, Void)]()

	func buildState(response: ConversationsModel.Response) {
		invokedBuildState = true
		invokedBuildStateCount += 1
		invokedBuildStateParameters = (response, ())
		invokedBuildStateParametersList.append((response, ()))
	}
}
