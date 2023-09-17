//
//  CoreDataService.swift
//  MixChat
//
//  Created by Михаил Фокин on 09.04.2023.
//

import CoreData
import Foundation

protocol CoreDataServiceProtocol: AnyObject {
    func save(block: @escaping (NSManagedObjectContext) throws -> Void)
    func delete(block: @escaping (NSManagedObjectContext) throws -> Void)
    func fetchDBChannels() throws -> [DBChannel]
    func fetchDBMessages(for channelID: String) throws -> [DBMessage]
}

final class CoreDataService {

	private lazy var logger = Logger(isLogging: false)
	
    private lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "Chat")
        persistentContainer.loadPersistentStores { _, error in
            guard let error else { return }
			self.logger.log(error.localizedDescription)
        }
        return persistentContainer
    }()

    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}

extension CoreDataService: CoreDataServiceProtocol {
    
    func fetchDBMessages(for channelID: String) throws -> [DBMessage] {
        let fetchRequest = DBChannel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", channelID as CVarArg)
        let dbChannel = try viewContext.fetch(fetchRequest).first
        guard
            let dbChannel,
            let dbMessages = dbChannel.messages?.array as? [DBMessage]
		else {
			return []
		}
		self.logger.log("Fetch dbMessages for channel \(channelID)")
        return dbMessages
    }
    
    func fetchDBChannels() throws -> [DBChannel] {
        let fetchRequest = DBChannel.fetchRequest()
		self.logger.log("Fetch all dbChannels")
        return try viewContext.fetch(fetchRequest)
    }
    
    func save(block: @escaping (NSManagedObjectContext) throws -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            do {
                try block(backgroundContext)
                if backgroundContext.hasChanges {
                    try backgroundContext.save()
					self.logger.log("Saved in newBackgroundContext")
                }
            } catch {
				self.logger.log(error.localizedDescription)
            }
        }
    }
    
    func delete(block: @escaping (NSManagedObjectContext) throws -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            do {
                try block(backgroundContext)
                if backgroundContext.hasChanges {
                    try backgroundContext.save()
					self.logger.log("Delete in newBackgroundContext")
                }
            } catch {
				self.logger.log(error.localizedDescription)
            }
        }
    }
}
