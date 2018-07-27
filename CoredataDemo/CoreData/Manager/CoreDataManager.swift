//
//  CoreDataManager.swift
//  CoredataDemo
//
//  Created by yfm on 2018/7/9.
//  Copyright © 2018年 yfm. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {

    // MARK: - 单例
    static let share: CoreDataManager = CoreDataManager()
    static let queue: DispatchQueue = DispatchQueue(label: "CoreDataQueue")
    lazy var taskQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "db Operation"
        queue.maxConcurrentOperationCount = 3
        return queue
    }()
    private init() {}

    func applicationDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }

    lazy var mangedObjectModel: NSManagedObjectModel = {
        var urlPath = Bundle.main.url(forResource: "CoredataDemo", withExtension: "momd")
        guard let url = urlPath, let object = NSManagedObjectModel(contentsOf: url) else {
            fatalError("create object model fail")
        }
        return object
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: mangedObjectModel)
        let storeUrl = self.applicationDocumentsDirectory().appendingPathComponent("db.sqlite")
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: nil)
        } catch {
            print(error)
            abort()
        }
        return coordinator
    }()

    lazy var mainThreadContext: NSManagedObjectContext = {
        let context = TDManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.undoManager = nil
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()

    // 创建私有上下文
    func newPrivateContext() -> NSManagedObjectContext {
        let privateContext = TDManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        privateContext.mergePolicy = NSOverwriteMergePolicy
        return privateContext
    }
}
