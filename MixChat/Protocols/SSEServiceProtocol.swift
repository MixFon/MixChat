//
//  SSEServiceProtocol.swift
//  MixChat
//
//  Created by Михаил Фокин on 26.04.2023.
//

import Combine
import TFSChatTransport

protocol SSEServiceProtocol {
	/// Создает подписку на события о изменениях в списке каналов
	func subscribeOnEvents() -> AnyPublisher<ChatEvent, Error>

	/// Останавливает прием событий и разрывает цикл сильных ссылок в URLSession
	/// ВАЖНО! Необходимо вызывать перед удалением последней сильной ссылки на сервис
	func cancelSubscription()
}
