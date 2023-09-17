//
//  ChatDataSourceMock.swift
//  MixChatUnitTests
//
//  Created by Михаил Фокин on 08.05.2023.
//

import Foundation
@testable import MixChat

final class ChatDataSourceMock: ChatDataSourceProtocol {

	var invokedGetAllChannels = false
	var invokedGetAllChannelsCount = 0
	var stubbedGetAllChannelsResult: [ChannelProtocol]! = []

	func getAllChannels() -> [ChannelProtocol] {
		invokedGetAllChannels = true
		invokedGetAllChannelsCount += 1
		return stubbedGetAllChannelsResult
	}

	var invokedGetAllMesseges = false
	var invokedGetAllMessegesCount = 0
	var invokedGetAllMessegesParameters: (channelID: String, Void)?
	var invokedGetAllMessegesParametersList = [(channelID: String, Void)]()
	var stubbedGetAllMessegesResult: [MessageProtocol]! = []

	func getAllMesseges(with channelID: String) -> [MessageProtocol] {
		invokedGetAllMesseges = true
		invokedGetAllMessegesCount += 1
		invokedGetAllMessegesParameters = (channelID, ())
		invokedGetAllMessegesParametersList.append((channelID, ()))
		return stubbedGetAllMessegesResult
	}

	var invokedSaveChannel = false
	var invokedSaveChannelCount = 0
	var invokedSaveChannelParameters: (channel: ChannelProtocol, Void)?
	var invokedSaveChannelParametersList = [(channel: ChannelProtocol, Void)]()

	func saveChannel(with channel: ChannelProtocol) {
		invokedSaveChannel = true
		invokedSaveChannelCount += 1
		invokedSaveChannelParameters = (channel, ())
		invokedSaveChannelParametersList.append((channel, ()))
	}

	var invokedDeleteChannelWith = false
	var invokedDeleteChannelWithCount = 0
	var invokedDeleteChannelWithParameters: (channel: ChannelProtocol, Void)?
	var invokedDeleteChannelWithParametersList = [(channel: ChannelProtocol, Void)]()

	func deleteChannel(with channel: ChannelProtocol) {
		invokedDeleteChannelWith = true
		invokedDeleteChannelWithCount += 1
		invokedDeleteChannelWithParameters = (channel, ())
		invokedDeleteChannelWithParametersList.append((channel, ()))
	}

	var invokedDeleteChannelId = false
	var invokedDeleteChannelIdCount = 0
	var invokedDeleteChannelIdParameters: (id: String, Void)?
	var invokedDeleteChannelIdParametersList = [(id: String, Void)]()

	func deleteChannel(id: String) {
		invokedDeleteChannelId = true
		invokedDeleteChannelIdCount += 1
		invokedDeleteChannelIdParameters = (id, ())
		invokedDeleteChannelIdParametersList.append((id, ()))
	}

	var invokedDeleteMessage = false
	var invokedDeleteMessageCount = 0
	var invokedDeleteMessageParameters: (id: String, Void)?
	var invokedDeleteMessageParametersList = [(id: String, Void)]()

	func deleteMessage(id: String) {
		invokedDeleteMessage = true
		invokedDeleteMessageCount += 1
		invokedDeleteMessageParameters = (id, ())
		invokedDeleteMessageParametersList.append((id, ()))
	}

	var invokedUpdateChannel = false
	var invokedUpdateChannelCount = 0
	var invokedUpdateChannelParameters: (channelID: String, message: MessageProtocol)?
	var invokedUpdateChannelParametersList = [(channelID: String, message: MessageProtocol)]()

	func updateChannel(channelID: String, message: MessageProtocol) {
		invokedUpdateChannel = true
		invokedUpdateChannelCount += 1
		invokedUpdateChannelParameters = (channelID, message)
		invokedUpdateChannelParametersList.append((channelID, message))
	}

	var invokedSaveMessage = false
	var invokedSaveMessageCount = 0
	var invokedSaveMessageParameters: (channelID: String, message: MessageProtocol)?
	var invokedSaveMessageParametersList = [(channelID: String, message: MessageProtocol)]()

	func saveMessage(channelID: String, message: MessageProtocol) {
		invokedSaveMessage = true
		invokedSaveMessageCount += 1
		invokedSaveMessageParameters = (channelID, message)
		invokedSaveMessageParametersList.append((channelID, message))
	}
}
