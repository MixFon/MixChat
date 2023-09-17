//
//  SSEServiceMock.swift
//  MixChatUnitTests
//
//  Created by Михаил Фокин on 10.05.2023.
//

import Combine
import Foundation
import TFSChatTransport
@testable import MixChat

final class SSEServiceMock: SSEServiceProtocol {

	var invokedSubscribeOnEvents = false
	var invokedSubscribeOnEventsCount = 0
	var stubbedSubscribeOnEventsResult: AnyPublisher<ChatEvent, Error>!

	func subscribeOnEvents() -> AnyPublisher<ChatEvent, Error> {
		invokedSubscribeOnEvents = true
		invokedSubscribeOnEventsCount += 1
		return stubbedSubscribeOnEventsResult
	}

	var invokedCancelSubscription = false
	var invokedCancelSubscriptionCount = 0

	func cancelSubscription() {
		invokedCancelSubscription = true
		invokedCancelSubscriptionCount += 1
	}
}
