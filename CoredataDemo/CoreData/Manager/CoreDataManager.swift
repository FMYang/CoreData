//
//  CoreDataManager.swift
//  CoredataDemo
//
//  Created by yfm on 2018/7/9.
//  Copyright © 2018年 yfm. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {

    // MARK: - 单例
    static let share: CoreDataManager = CoreDataManager()
    static let queue: DispatchQueue = DispatchQueue(label: "CoreDataQueue")
    private override init() {
        super.init()
        // 其他线程调用save的时候触发NSManagedObjectContextObjectsDidChange这个通知
        // 合并其他线程上下文的改变到主线程上下文
        NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextObjectsDidChange,
                                               object: nil,
                                               queue: nil) { (info) in
                                                print("had received save notification")
                                                let mainContext = self.mainThreadContext
                                                let otherContext = info.object as? NSManagedObjectContext
                                                if let context = otherContext, context != mainContext {
                                                    mainContext.perform({
                                                        mainContext.mergeChanges(fromContextDidSave: info)
                                                    })
                                                }
        }
    }

    // MARK: - Core Data stack
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        // 创建持久化存储容器（即创建Core Data数据库）
        let container = NSPersistentContainer(name: "CoredataDemo")
        // 打开数据库文件，如果不存在Core Data会根据模型里定义的大纲(schema)来生成
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        return container
    }()

    // 获取持久化存储协调器
    @available(iOS 10.0, *)
    lazy var mainPersistentStoreCoordinator: NSPersistentStoreCoordinator = {
        return persistentContainer.persistentStoreCoordinator
    }()

    // 获取主线程上下文对象
    @available(iOS 10.0, *)
    lazy var mainThreadContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    // MARK: - 保存
    @available(iOS 10.0, *)
    func saveContext () {
        let context = mainThreadContext
        if context.hasChanges {
            context.perform {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }

    // 创建私有上下文
    func newPrivateContext() -> NSManagedObjectContext {
        let privateContext = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
        privateContext.persistentStoreCoordinator = self.mainPersistentStoreCoordinator
        privateContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy // 内存优先
        return privateContext
    }
}
