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

    // 获取当前上下文
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

    // MARK: - 主线程
    static func createObjectOnMainThread(entityName: String) -> NSManagedObject {
        assert(Thread.isMainThread, "must call on main thread")
        return NSEntityDescription.insertNewObject(forEntityName: entityName,
                                                       into: self.currentContext())
    }

    static func insertObjectOnMainThread(object: NSManagedObject) {
        assert(Thread.isMainThread, "must call on main thread")
        self.currentContext().insert(object)
    }

    static func saveOnMainThread() {
        // If condition evaluates to false, stop program execution in a debuggable state after printing message.
        assert(Thread.isMainThread, "must call on main thread")
        self.saveOnCurrentThread()
    }

    // MARK: - 当前线程
    static func createObjectOnCurrentThread<T: NSManagedObject>() -> T {
        let obj = T.init(context: self.currentContext())
        return obj
    }

    static func insertObjectOnCurrentThread(object: NSManagedObject) {
        print("insertObjectOnCurrentThread：\(Thread.current)")
        self.currentContext().insert(object)
    }

    // 上下文save会触发NSManagedObjectContextObjectsDidChange通知
    // 主线程上下文注册通知来合并子线程的变更
    static func saveOnCurrentThread() {
        print("saveOnCurrentThread: \(Thread.current)")
        if self.currentContext().hasChanges {
            self.currentContext().performAndWait {
                do {
                    try self.currentContext().save()
                    if Thread.isMainThread {
                        print("main thread save success!")
                    } else {
                        print("private thread save success!")
                    }
                } catch {
                    let err = error as NSError
                    print(err.userInfo)
                    fatalError("save \(Thread.current) context exception, error: \(error)")

                }
            }
        } else {
            print("current context wihtout change")
        }
    }
}
