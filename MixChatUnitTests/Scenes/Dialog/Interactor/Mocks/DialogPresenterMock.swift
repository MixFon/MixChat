//
//  DialogPresenterMock.swift
//  MixChatUnitTests
//
//  Created by Михаил Фокин on 10.05.2023.
//

import XCTest
import Combine
import TFSChatTransport
@testable import MixChat

final class DialogPresenterMock: DialogPresentationLogic {

	var invokedBuildState = false
	var invokedBuildStateCount = 0
	var invokedBuildStateParameters: (response: DialogModel.Response, Void)?
	var invokedBuildStateParametersList = [(response: DialogModel.Response, Void)]()

	func buildState(response: DialogModel.Response) {
		invokedBuildState = true
		invokedBuildStateCount += 1
		invokedBuildStateParameters = (response, ())
		invokedBuildStateParametersList.append((response, ()))
	}
}
