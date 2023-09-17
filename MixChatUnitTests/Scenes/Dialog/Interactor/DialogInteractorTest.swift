//
//  DialogInteractorTest.swift
//  MixChatUnitTests
//
//  Created by Михаил Фокин on 10.05.2023.
//

import XCTest
import Combine
import TFSChatTransport
@testable import MixChat

final class DialogInteractorTest: XCTestCase {
	
	var interactor: (DialogBusinessLogic & DialogDataStore)?
	var presenter: DialogPresenterMock?
	var chatDataSource: ChatDataSourceMock?
	var chatService: ChatServiceMock?
	var storage: StorageMock?
	
	override func setUp() {
		super.setUp()
		self.storage = StorageMock()
		self.presenter = DialogPresenterMock()
		self.chatService = ChatServiceMock()
		self.chatDataSource = ChatDataSourceMock()
		let dependencies = DialogInteractor.Dependencies(
			storage: self.storage,
			presenter: self.presenter,
			sseService: nil,
			chatService: self.chatService,
			keychainManager: nil,
			chatDataSource: self.chatDataSource
		)
		self.interactor = DialogInteractor(dependencies: dependencies)
	}
	
	override func tearDown() {
		super.tearDown()
		self.interactor = nil
		self.presenter = nil
		self.chatService = nil
		self.chatDataSource = nil
	}
	
	func testInterlocutor() {
		// Arrange
		let id = "some_id"
		let name = "some_name"
		let image = "some_image"
		let dependencies = DialogInteractor.Dependencies(
			storage: nil,
			presenter: self.presenter,
			sseService: nil,
			chatService: nil,
			keychainManager: nil,
			chatDataSource: nil
		)
		let interactor = DialogInteractor(dependencies: dependencies)
		interactor.interlocutor = Interlocutor(id: id, name: name, imageURL: image)
		
		// Act
		interactor.makeState(requst: .start)
		
		// Assert
		if case .interlocutor(let interlocator) = self.presenter?.invokedBuildStateParametersList.first?.response {
			XCTAssertEqual(interlocator?.id, id)
			XCTAssertEqual(interlocator?.name, name)
			XCTAssertEqual(interlocator?.imageURL, image)
		} else {
			XCTFail("Ошибка стейта презентера")
		}
	}
	
	func testFetchChannalMessagesFromDB() {
		// Arrange
		let id = "some_id"
		let name = "some_name"
		let image = "some_image"
		let messagesPublisher = PassthroughSubject<[Message], Error>()
		guard let coreDataMessages: [Message] = try? decodeJSON(from: getMessagesJSON()) else {
			XCTFail("Неверное декодирование JSON структуры Channel")
			return
		}
		self.chatService?.stubbedLoadMessagesResult = messagesPublisher.eraseToAnyPublisher()
		self.chatDataSource?.stubbedGetAllMessegesResult = coreDataMessages
		
		self.interactor?.interlocutor = Interlocutor(id: id, name: name, imageURL: image)
		
		// Act
		self.interactor?.makeState(requst: .start)
		
		// Assert
		XCTAssertEqual(self.chatDataSource?.invokedGetAllMesseges, true)
		XCTAssertEqual(self.chatDataSource?.invokedGetAllMessegesCount, 1)
		XCTAssertEqual(self.chatDataSource?.invokedGetAllMessegesParameters?.channelID, id)
		
		XCTAssertEqual(self.presenter?.invokedBuildState, true)
		XCTAssertEqual(self.presenter?.invokedBuildStateCount, 2)
		
		if case .messages(let messages) = self.presenter?.invokedBuildStateParametersList[1].response {
			for (left, right) in zip(messages ?? [], coreDataMessages) {
				XCTAssertEqual(left.id, right.id)
				XCTAssertEqual(left.text, right.text)
				XCTAssertEqual(left.userID, right.userID)
				XCTAssertEqual(left.userName, right.userName)
				XCTAssertEqual(left.date, right.date)
			}
			XCTAssertEqual(messages?.count, coreDataMessages.count)
		} else {
			XCTFail("Ошибка стейта презентора")
		}
	}
	
	func testFetchChannalMessagesFromServer() {
		// Arrange
		let id = "some_id"
		let name = "some_name"
		let image = "some_image"
		let messagesPublisher = PassthroughSubject<[Message], Error>()
		guard let coreDataMessages: [Message] = try? decodeJSON(from: getMessagesJSON()) else {
			XCTFail("Неверное декодирование JSON структуры Message")
			return
		}
		guard let serviveMessages: [Message] = try? decodeJSON(from: getMessagesJSON()) else {
			XCTFail("Неверное декодирование JSON структуры Message")
			return
		}
		self.chatService?.stubbedLoadMessagesResult = messagesPublisher.eraseToAnyPublisher()
		self.chatDataSource?.stubbedGetAllMessegesResult = coreDataMessages
		
		self.interactor?.interlocutor = Interlocutor(id: id, name: name, imageURL: image)
		
		// Act
		self.interactor?.makeState(requst: .start)
		messagesPublisher.send(serviveMessages)
		
		// Assert
		XCTAssertEqual(self.chatDataSource?.invokedGetAllMesseges, true)
		XCTAssertEqual(self.chatDataSource?.invokedGetAllMessegesCount, 1)
		XCTAssertEqual(self.chatDataSource?.invokedGetAllMessegesParameters?.channelID, id)
		
		XCTAssertEqual(self.presenter?.invokedBuildState, true)
		XCTAssertEqual(self.presenter?.invokedBuildStateCount, 3)
		
		if case .messages(let messages) = self.presenter?.invokedBuildStateParametersList[2].response {
			for (left, right) in zip(messages ?? [], serviveMessages) {
				XCTAssertEqual(left.id, right.id)
				XCTAssertEqual(left.text, right.text)
				XCTAssertEqual(left.userID, right.userID)
				XCTAssertEqual(left.userName, right.userName)
				XCTAssertEqual(left.date, right.date)
			}
			XCTAssertEqual(messages?.count, coreDataMessages.count)
		} else {
			XCTFail("Ошибка стейта презентора")
		}
	}
	
	func testSendMessageWithError() {
		// Arrange
		let message = ""
		
		// Act
		self.interactor?.makeState(requst: .sendMessage(message))
		
		// Assert
		if case .errorCheckMessage = self.presenter?.invokedBuildStateParameters?.response {
			
		} else {
			XCTFail("Ошибка не обработана")
		}
		
		XCTAssertEqual(self.presenter?.invokedBuildState, true)
		XCTAssertEqual(self.presenter?.invokedBuildStateCount, 1)
	}
	
	func testSendMessageSuccess() {
		// Arrange
		let id = "some_id"
		let name = "some_name"
		let image = "some_image"
		let message = "Some message"
		let messagesPublisher = PassthroughSubject<Message, Error>()
		guard let recieveMessage: Message = try? decodeJSON(from: getOneMessageJSON()) else {
			XCTFail("Неверное декодирование JSON структуры Message")
			return
		}
		self.chatService?.stubbedSendMessageResult = messagesPublisher.eraseToAnyPublisher()
		
		self.interactor?.interlocutor = Interlocutor(id: id, name: name, imageURL: image)
		
		// Act
		self.interactor?.makeState(requst: .sendMessage(message))
		messagesPublisher.send(recieveMessage)
		
		// Assert
		XCTAssertEqual(self.presenter?.invokedBuildState, false)
		XCTAssertEqual(self.presenter?.invokedBuildStateCount, 0)
		
		XCTAssertEqual(self.chatService?.invokedSendMessage, true)
		XCTAssertEqual(self.chatService?.invokedSendMessageCount, 1)
		
		XCTAssertEqual(self.chatDataSource?.invokedSaveMessage, true)
		XCTAssertEqual(self.chatDataSource?.invokedSaveMessageCount, 1)
		XCTAssertEqual(self.chatDataSource?.invokedSaveMessageParameters?.channelID, id)
		XCTAssertEqual(self.chatDataSource?.invokedSaveMessageParameters?.message.id, recieveMessage.id)
		
		XCTAssertEqual(self.chatDataSource?.invokedUpdateChannel, true)
		XCTAssertEqual(self.chatDataSource?.invokedUpdateChannelCount, 1)
		XCTAssertEqual(self.chatDataSource?.invokedUpdateChannelParameters?.channelID, id)
		XCTAssertEqual(self.chatDataSource?.invokedUpdateChannelParameters?.message.id, recieveMessage.id)
	}
	
	func testSendMessageFail() {
		// Arrange
		let id = "some_id"
		let name = "some_name"
		let image = "some_image"
		let message = "Some message"
		let messagesPublisher = PassthroughSubject<Message, Error>()
		self.chatService?.stubbedSendMessageResult = messagesPublisher.eraseToAnyPublisher()
		
		self.interactor?.interlocutor = Interlocutor(id: id, name: name, imageURL: image)
		
		// Act
		self.interactor?.makeState(requst: .sendMessage(message))
		messagesPublisher.send(completion: .failure("Some error"))
		
		// Assert
		if case .errorAlert(let errorString) = self.presenter?.invokedBuildStateParameters?.response {
			XCTAssertEqual(errorString, "The operation couldn’t be completed. (Swift.String error 1.)")
		} else {
			XCTFail("Ошибка вызова алерта не обработана.")
		}
		
		XCTAssertEqual(self.presenter?.invokedBuildState, true)
		XCTAssertEqual(self.presenter?.invokedBuildStateCount, 1)
	}
	
	func testSubscribeOnEventsAdd() {
		// Arrange
		let id = "1"
		let name = "some_name"
		let image = "some_image"
		
		let sseService = SSEServiceMock()
		let publisher = PassthroughSubject<ChatEvent, Error>()
		sseService.stubbedSubscribeOnEventsResult = publisher.eraseToAnyPublisher()
		let dependencies = DialogInteractor.Dependencies(
			storage: nil,
			presenter: self.presenter,
			sseService: sseService,
			chatService: nil,
			keychainManager: nil,
			chatDataSource: nil
		)
		
		guard let deleteEvent: ChatEvent = try? decodeJSON(from: getDeleteChatEventJSON()) else {
			XCTFail("Неверное декодирование JSON структуры ChatEvent")
			return
		}
		
		// Act
		// В инициализаторе происходит подписка
		self.interactor = DialogInteractor(dependencies: dependencies)
		self.interactor?.interlocutor = Interlocutor(id: id, name: name, imageURL: image)
		publisher.send(deleteEvent)

		// Assert
		XCTAssertTrue(sseService.invokedSubscribeOnEvents == true)
		XCTAssertEqual(sseService.invokedSubscribeOnEventsCount, 1)
		
		XCTAssertTrue(self.presenter?.invokedBuildState == true)
		XCTAssertEqual(self.presenter?.invokedBuildStateCount, 1)
		
		if case .channelDeleted = self.presenter?.invokedBuildStateParameters?.response {
			
		} else {
			XCTFail("Ошибка при удалении канала")
		}
	}
	
	private func getMessagesJSON() -> String {
		return """
[
  {
	"id": "1",
	"text": "Hello, world!",
	"userID": "user123",
	"userName": "John Doe",
	"date": "2023-05-09T10:30:00Z"
  },
  {
	"id": "2",
	"text": "How are you doing?",
	"userID": "user456",
	"userName": "Jane Smith",
	"date": "2023-05-09T11:45:00Z"
  },
  {
	"id": "3",
	"text": "I'm fine, thanks for asking.",
	"userID": "user789",
	"userName": "Bob Johnson",
	"date": "2023-05-09T12:15:00Z"
  }
]
"""
	}
	
	private func getOneMessageJSON() -> String {
		return """
  {
	"id": "1",
	"text": "Hello, world!",
	"userID": "user123",
	"userName": "John Doe",
	"date": "2023-05-09T10:30:00Z"
  }
"""
	}
	
	private func getUpdateChatEventJSON() -> String {
		return """
{
	"eventType": "update",
	"resourceID": "12345"
}
"""
	}
	
	private func getDeleteChatEventJSON() -> String {
		return """
{
	"eventType": "delete",
	"resourceID": "1"
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
