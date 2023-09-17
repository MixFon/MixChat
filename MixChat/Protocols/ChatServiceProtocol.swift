//
//  ChatServiceProtocol.swift
//  MixChat
//
//  Created by Михаил Фокин on 16.04.2023.
//

import Combine
import TFSChatTransport

protocol ChatServiceProtocol {
	/// Создает новый канал и возвращает его модель
	/// - Parameters:
	///     - name: Имя отправителя
	///     - logoUrl: Ссылка на логотип
	func createChannel(name: String, logoUrl: String?) -> AnyPublisher<Channel, Error>
	/// Загружает все каналы
	func loadChannels() -> AnyPublisher<[Channel], Error>
	/// Загружает информацию о канале
	/// - Parameter id: id канала
	func loadChannel(id: String) -> AnyPublisher<Channel, Error>
	/// Удаляет канал
	/// - Parameters:
	///     - id: id канала
	func deleteChannel(id: String) -> AnyPublisher<Void, Error>
	/// Загружает сообщения из канала
	/// - Parameters:
	///     - channelId: id канала
	func loadMessages(channelId: String) -> AnyPublisher<[Message], Error>
	/// Создает новое сообщение и возвращает его модель
	/// - Parameters:
	///     - text: текст сообщения
	///     - channelId: id канала
	///     - userId: id отправителя
	///     - userName: имя отправителя
	func sendMessage(text: String, channelId: String, userId: String, userName: String) -> AnyPublisher<Message, Error>
}
