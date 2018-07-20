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
    private init() {
        // 上下文调用save的时候触发NSManagedObjectContextObjectsDidChange这个通知
        // 合并其他线程上下文的改变到当前上下文
        NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextDidSave,
                                               object: nil,
                                               queue: nil) { (notification) in
                                                print("private contexts: \(CoredataActions.share.contexts)")
                                                print("had received save notification from \(Thread.current), current context: \(CoredataActions.currentContext())")
                                                print(notification.userInfo!)
                                                let currentSaveContext = notification.object as? NSManagedObjectContext
//                                                if !Thread.isMainThread {
                                                    print("=================mergeChanges==============\(Thread.current)")
                                                    currentSaveContext?.mergeChanges(fromContextDidSave: notification)
//                                                }
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
        container.viewContext.mergePolicy = NSOverwriteMergePolicy//NSMergeByPropertyObjectTrumpMergePolicy // 内存优先
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
        privateContext.mergePolicy = NSOverwriteMergePolicy // 内存优先
        return privateContext
    }
}
