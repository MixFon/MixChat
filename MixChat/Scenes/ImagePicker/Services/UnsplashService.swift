//
//  NetworkService.swift
//  MixChat
//
//  Created by Михаил Фокин on 23.04.2023.
//

import Foundation

protocol UnsplashServiceProtocol {
	func fetchRandomImage(_ count: Int) async throws -> [UnsplashModel]
}

enum NetworkError: Error {
	case url
	case clientID
	case parsingJSON(Data)
}

final class UnsplashService: UnsplashServiceProtocol {
	
	private let host: String
	private let port: Int?
	private let urlSesstion: URLSession
	
	init(host: String, port: Int? = nil, urlSesstion: URLSession = URLSession.shared) {
		self.host = host
		self.port = port
		self.urlSesstion = urlSesstion
	}
	
	func fetchRandomImage(_ count: Int = 30) async throws -> [UnsplashModel] {
		let query = [
			"count": "\(count)"
		]
		let url = try makeUrl(path: "/photos/random", query: query)
		let request = try makeGetRequest(url: url)
		
		let (data, _) = try await URLSession.shared.data(for: request)
		guard let unsplash = try? JSONDecoder().decode([UnsplashModel].self, from: data) else {
			throw NetworkError.parsingJSON(data)
		}
		return unsplash
	}
}

private extension UnsplashService {
	
	private func makeUrl(path: String, query: [String: String]? = nil) throws -> URL {
		var urlComponents = URLComponents()
		urlComponents.scheme = "https"
		urlComponents.host = host
		urlComponents.path = path
		urlComponents.port = port
		if let query {
			urlComponents.queryItems = query.map(URLQueryItem.init)
		}
		guard let url = urlComponents.url else {
			throw NetworkError.url
		}
		return url
	}
	
	private func makeGetRequest(url: URL) throws -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		guard let clientId = Bundle.main.object(forInfoDictionaryKey: "UNSPLASH_CLIENT_ID") as? String else {
			throw NetworkError.clientID
		}
		request.addValue("Client-ID \(clientId)", forHTTPHeaderField: "Authorization")
		return request
	}
}
