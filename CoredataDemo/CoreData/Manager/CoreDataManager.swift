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
    private static let instance: CoreDataManager = CoreDataManager()
    static let share: CoreDataManager = {
        let instance = CoreDataManager()
        return instance
    }()

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        // 创建持久化存储容器（即创建Core Data数据库）
        let container = NSPersistentContainer(name: "CoredataDemo")
        // 打开数据库文件，如果不存在Core Data会根据模型里定义的大纲(schema)来生成
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // 获取上下文对象
    lazy var mainThreadContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    // MARK: - 保存
    func saveContext () {
        let context = mainThreadContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
