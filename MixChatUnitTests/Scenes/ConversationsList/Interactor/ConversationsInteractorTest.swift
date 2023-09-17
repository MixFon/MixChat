//
//  ConversationsInteractorTest.swift
//  MixChatUnitTests
//
//  Created by Михаил Фокин on 08.05.2023.
//

import XCTest
import Combine
import TFSChatTransport
@testable import MixChat

final class ConversationsInteractorTest: XCTestCase {
	
	var interactor: (ConversationsBusinessLogic & ConversationsDataStore)?
	var presenter: ConversationsPresenterMock?
	var chatDataSource: ChatDataSourceMock?
	var chatService: ChatServiceMock?
	
	override func setUp() {
		super.setUp()
		self.chatService = ChatServiceMock()
		self.presenter = ConversationsPresenterMock()
		self.chatDataSource = ChatDataSourceMock()
		let dependencies = ConversationsInteractor.Dependencies(
			presenter: self.presenter,
			sseService: nil,
			chatService: self.chatService,
			chatDataSource: self.chatDataSource
		)
		self.interactor = ConversationsInteractor(dependencies: dependencies)
	}
	
	override func tearDown() {
		super.tearDown()
		self.interactor = nil
		self.presenter = nil
		self.chatService = nil
		self.chatDataSource = nil
	}
	
	func testGetChannels() {
		// Arrange
		let coreDataChannels = [
			ChannelModel(id: "one_id", name: "one_name"),
			ChannelModel(id: "two_id", name: "two_name"),
			ChannelModel(id: "three_id", name: "three_name")
		]
		self.chatDataSource?.stubbedGetAllChannelsResult = coreDataChannels
		let channelPublisher = PassthroughSubject<[Channel], Error>()
		// У Channel нет публичного инициализатора
		let serverChannels: [Channel] = []
		
		self.chatService?.stubbedLoadChannelsResult = channelPublisher.eraseToAnyPublisher()
		
		// Act
		// Происходит чтение данных из кордаты и отображение.
		// Затем происходит запрос в сеть и отображение
		self.interactor?.makeState(requst: .refresh)
		
		// Assert
		// Проверка данных из CoreData
		XCTAssertTrue(self.presenter?.invokedBuildState == true)
		XCTAssertEqual(self.presenter?.invokedBuildStateCount, 1)
		if case .channals(let channels) = self.presenter?.invokedBuildStateParameters?.response {
			for (left, right) in zip(channels ?? [], coreDataChannels) {
				XCTAssertEqual(left.id, right.id)
				XCTAssertEqual(left.name, right.name)
			}
			XCTAssertEqual(channels?.count, coreDataChannels.count)
		}
		
		// Отправляем "скаченные" каналы
		channelPublisher.send(serverChannels)
		
		// Проверка данных с Сервера
		XCTAssertEqual(self.presenter?.invokedBuildStateCount, 2)
		if case .channals(let channels) = self.presenter?.invokedBuildStateParameters?.response {
			for (left, right) in zip(channels ?? [], serverChannels) {
				XCTAssertEqual(left.id, right.id)
				XCTAssertEqual(left.name, right.name)
			}
			XCTAssertEqual(channels?.count, serverChannels.count)
		}
		
		XCTAssertTrue(self.chatService?.invokedLoadChannels == true)
		XCTAssertEqual(self.chatService?.invokedLoadChannelsCount, 1)
		
		// Проверка сохранения каналов скаченных с сервера
		if serverChannels.isEmpty {
			XCTAssertTrue(self.chatDataSource?.invokedSaveChannel == false)
			XCTAssertEqual(self.chatDataSource?.invokedSaveChannelCount, 0)
		} else {
			XCTAssertTrue(self.chatDataSource?.invokedSaveChannel == true)
			XCTAssertEqual(self.chatDataSource?.invokedSaveChannelCount, serverChannels.count)
		}
		
		// Проверка на удаление каналов, которых нет на сервере, но есть в CoreData
		if let countDiff = countDiff(one: coreDataChannels, two: serverChannels) {
			if countDiff == 0 {
				XCTAssertTrue(self.chatDataSource?.invokedDeleteChannelId == false)
				XCTAssertEqual(self.chatDataSource?.invokedDeleteChannelIdCount, 0)
			} else {
				XCTAssertTrue(self.chatDataSource?.invokedDeleteChannelId == true)
				XCTAssertEqual(self.chatDataSource?.invokedDeleteChannelIdCount, countDiff)
			}
		}
	}
	
	private func countDiff(one: [ChannelProtocol]?, two: [ChannelProtocol]?) -> Int? {
		guard
			let one = one,
			let two = two
		else { return nil }
		var i = 0
		for channel in one {
			if !two.contains(where: { $0.id == channel.id }) {
				i += 1
			} else { continue }
		}
		return i
	}
	
	func testAddNewChannelError() {
		// Arrange
		let messageError = "The channel name should not be empty."
		
		// Act
		self.interactor?.addNewChannel(channalName: nil)
		
		// Assert
		XCTAssertTrue(self.presenter?.invokedBuildState == true)
		XCTAssertEqual(self.presenter?.invokedBuildStateCount, 1)
		if case .alertError(let error) = self.presenter?.invokedBuildStateParameters?.response {
			XCTAssertEqual(error, messageError)
		} else {
			XCTFail("Не отработала ошибка, возникающая при создании нового канала.")
		}
		
		// Arrange
		self.presenter?.invokedBuildState = false
		
		// Act
		self.interactor?.addNewChannel(channalName: "")
		
		// Assert
		XCTAssertTrue(self.presenter?.invokedBuildState == true)
		XCTAssertEqual(self.presenter?.invokedBuildStateCount, 2)
		if case .alertError(let error) = self.presenter?.invokedBuildStateParameters?.response {
			XCTAssertEqual(error, messageError)
		} else {
			XCTFail("Не отработала ошибка, возникающая при создании нового канала.")
		}
	}
	
	func testAddChannel() {
		// Arrange
		let channelName = "New name"
		let channelPublisher = PassthroughSubject<Channel, Error>()
		// У Channel нет публичного инициализатора
		guard let serverChannel: Channel = try? decodeJSON(from: getChannelJSON()) else {
			XCTFail("Неверное декодирование JSON структуры Channel")
			return
		}
		
		self.chatService?.stubbedCreateChannelResult = channelPublisher.eraseToAnyPublisher()
		
		// Act
		self.interactor?.addNewChannelWithoutLogo(channalName: channelName)
		
		// Assert
		XCTAssertTrue(self.chatService?.invokedCreateChannel == true)
		XCTAssertEqual(self.chatService?.invokedCreateChannelCount, 1)
		XCTAssertEqual(self.chatService?.invokedCreateChannelParameters?.name, channelName)
		
		// Тестируем создание нового канала
		// Arrange
		
		// Act
		// Имитируем получение только что созданного канала
		channelPublisher.send(serverChannel)
		
		// Assert
		XCTAssertEqual(self.chatService?.invokedCreateChannelParameters?.name, channelName)
		if case .channals(let channels) = self.presenter?.invokedBuildStateParameters?.response {
			for (left, right) in zip(channels ?? [], [serverChannel]) {
				XCTAssertEqual(left.id, right.id)
				XCTAssertEqual(left.name, right.name)
			}
			XCTAssertEqual(channels?.count, 1)
		}
		
		// Тестируем создание нового канала, в котором произошла ошибка
		// Arrange
		
		// Act
		// Имитируем получаение ошибки
		let errorString = "Какая-то ошибка"
		channelPublisher.send(completion: .failure(errorString))
		
		// Assert
		XCTAssertTrue(self.presenter?.invokedBuildState == true)
		XCTAssertEqual(self.presenter?.invokedBuildStateCount, 2)
		if case .alertError(let error) = self.presenter?.invokedBuildStateParameters?.response {
			XCTAssertEqual(error, "The operation couldn’t be completed. (Swift.String error 1.)")
		} else {
			XCTFail("Не отработала ошибка, возникающая при создании нового канала.")
		}
		
	}
	
	func testDeleteChannel() {
		// Arrange
		var coreDataChannels = [
			ChannelModel(id: "one_id", name: "one_name"),
			ChannelModel(id: "two_id", name: "two_name"),
			ChannelModel(id: "three_id", name: "three_name"),
			ChannelModel(id: "some_id", name: "some_name")
		]
		self.chatDataSource?.stubbedGetAllChannelsResult = coreDataChannels
		let channelPublisher = PassthroughSubject<[Channel], Error>()
		// У Channel нет публичного инициализатора
		
		self.chatService?.stubbedLoadChannelsResult = channelPublisher.eraseToAnyPublisher()
		let deleteChannelId = "some_id"
		let channelPublisherDelete = PassthroughSubject<Void, Error>()
		self.chatService?.stubbedDeleteChannelResult = channelPublisherDelete.eraseToAnyPublisher()

		// Act
		self.interactor?.makeState(requst: .refresh)
		self.interactor?.makeState(requst: .deleteChannel(deleteChannelId))
		channelPublisher.send([])
		channelPublisherDelete.send(completion: .failure("Some error"))
		
		// Assert
		// Проверка метода сервиса
		XCTAssertTrue(self.chatService?.invokedDeleteChannel == true)
		XCTAssertEqual(self.chatService?.invokedDeleteChannelCount, 1)
		XCTAssertEqual(self.chatService?.invokedDeleteChannelParameters?.id, deleteChannelId)
		// Проверка презентора
		XCTAssertTrue(self.presenter?.invokedBuildState == true)
		XCTAssertEqual(self.presenter?.invokedBuildStateCount, 3)
		if case .alertError(let error) = self.presenter?.invokedBuildStateParameters?.response {
			XCTAssertEqual(error, "An error occurred when deleting the channel.")
		} else {
			XCTFail("Не отработала ошибка, возникающая при создании нового канала.")
		}
		
		// Тестируем успешное удаление канала
		
		// Act
		channelPublisherDelete.send()
		_ = coreDataChannels.popLast()
		
		// Assert
		if case .channals(let channels) = self.presenter?.invokedBuildStateParameters?.response {
			for (left, right) in zip(channels ?? [], coreDataChannels) {
				XCTAssertEqual(left.id, right.id)
				XCTAssertEqual(left.name, right.name)
			}
			XCTAssertEqual(channels?.count, coreDataChannels.count)
		}
		
	}
	
	func testSubscribeOnEventsAdd() {
		// Arrange
		let sseService = SSEServiceMock()
		let publisher = PassthroughSubject<ChatEvent, Error>()
		sseService.stubbedSubscribeOnEventsResult = publisher.eraseToAnyPublisher()
		let dependencies = ConversationsInteractor.Dependencies(
			presenter: self.presenter,
			sseService: sseService,
			chatService: nil,
			chatDataSource: nil
		)
		guard let addEvent: ChatEvent = try? decodeJSON(from: getAddChatEventJSON()) else {
			XCTFail("Неверное декодирование JSON структуры ChatEvent")
			return
		}
		guard let deleteEvent: ChatEvent = try? decodeJSON(from: getDeleteChatEventJSON()) else {
			XCTFail("Неверное декодирование JSON структуры ChatEvent")
			return
		}
		
		// Act
		// В инициализаторе происходит подписка
		self.interactor = ConversationsInteractor(dependencies: dependencies)
		publisher.send(addEvent)

		// Assert
		XCTAssertTrue(sseService.invokedSubscribeOnEvents == true)
		XCTAssertEqual(sseService.invokedSubscribeOnEventsCount, 1)
		
		if case .channals(let channels) = self.presenter?.invokedBuildStateParameters?.response {
			XCTAssertTrue(channels?.isEmpty == true)
		} else {
			XCTFail("Ошибка стейта презентора")
		}
		XCTAssertTrue(self.presenter?.invokedBuildState == true)
		XCTAssertEqual(self.presenter?.invokedBuildStateCount, 1)
		
		// Act
		publisher.send(deleteEvent)
		
		// Assert
		if case .channals(let channels) = self.presenter?.invokedBuildStateParameters?.response {
			XCTAssertTrue(channels?.isEmpty == true)
		} else {
			XCTFail("Ошибка стейта презентора")
		}
		XCTAssertTrue(self.presenter?.invokedBuildState == true)
		XCTAssertEqual(self.presenter?.invokedBuildStateCount, 2)
	}
	
	private func getChannelJSON() -> String {
		return """
  {
   "id" : "123",
   "name" : "Test Channel",
   "logoURL" : "https://example.com/logo.png",
   "lastMessage" : "Hello, world!",
   "lastActivity" : "2023-05-09T10:30:00Z"
  }
"""
	}
	
	private func getAddChatEventJSON() -> String {
		return """
{
	"eventType": "add",
	"resourceID": "12345"
}
"""
	}
	
	private func getDeleteChatEventJSON() -> String {
		return """
{
	"eventType": "delete",
	"resourceID": "12345"
}
"""
	}
	
	private func decodeJSON<T: Decodable>(from jsonString: String) throws -> T {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601

		guard let jsonData = jsonString.data(using: .utf8) else {
			throw "Ошибка"
		}
		
		let decodeElement = try decoder.decode(T.self, from: jsonData)

		return decodeElement
	}
}
