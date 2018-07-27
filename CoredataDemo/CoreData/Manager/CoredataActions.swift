//
//  CoredataActions.swift
//  CoredataDemo
//
//  Created by yfm on 2018/7/19.
//  Copyright © 2018年 yfm. All rights reserved.
//

import Foundation
import CoreData

let kThreadNSManagedObjectContextKey = "kThreadNSManagedObjectContextKey"

class CoredataActions {

    /// 获取当前上下文
    static func currentContext() -> NSManagedObjectContext {
        if Thread.isMainThread {
            return CoreDataManager.share.mainThreadContext
        } else {
            let dic = Thread.current.threadDictionary
            var threadContext = dic[kThreadNSManagedObjectContextKey] as? NSManagedObjectContext
            if threadContext == nil {
                threadContext = CoreDataManager.share.newPrivateContext()
                dic[kThreadNSManagedObjectContextKey] = threadContext
            }
            return threadContext!
        }
    }

    /// 插入对象到当前上下文
    static func insertOnCurrentThread<T: NSManagedObject>() -> T {
        print("insertObjectOnCurrentThread：\(Thread.current)")
        let object = T(context: self.currentContext())
        self.currentContext().insert(object)
        return object
    }

    /// 查询当前上下文的所有对象
    static func findAllOnCurrentThread<T: NSFetchRequestResult>(entityName: String) -> [T] {
        let request = NSFetchRequest<T>(entityName: entityName)
        do {
            let results = try self.currentContext().fetch(request)
            return results
        } catch {
            fatalError()
        }
    }

    /// 删除当前上下文中的object对象
    static func deleteOnCurrentThread<T: NSManagedObject>(object: T) {
        self.currentContext().delete(object)
    }

    /// 删除当前上下文中的所有对象
    static func deleteAllOnCurrentThread(entityName: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let delete = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try self.currentContext().persistentStoreCoordinator?.execute(delete, with: self.currentContext())
        } catch {
            fatalError("delete error")
        }
    }

    /// 将上下文的变更，持久化到数据库
    static func saveOnCurrentThread() {
        if self.currentContext().hasChanges {
            do {
                try self.currentContext().save()
                print("save success on \(Thread.current)")
            } catch {
                fatalError("save \(Thread.current) context exception, error: \(error)")
            }
        }
    }

    /// 保证所有操作都在当前线程执行
    static func performWithBlock(_ block: () -> ()) {
        self.currentContext().performAndWait {
            block()
        }
    }
}
