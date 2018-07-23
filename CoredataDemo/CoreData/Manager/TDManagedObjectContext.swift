//
//  TDManagedObjectContext.swift
//  CoredataDemo
//
//  Created by yfm on 2018/7/23.
//  Copyright © 2018年 yfm. All rights reserved.
//

import Foundation
import CoreData


class TDManagedObjectContext: NSManagedObjectContext {

    var isContextOnMainThread = false

    override init(concurrencyType ct: NSManagedObjectContextConcurrencyType) {
        super.init(concurrencyType: ct)

        print("context init on \(Thread.current)")

        if Thread.isMainThread {
            isContextOnMainThread = true
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(mergeChangesNotification(notification:)),
                                               name: Notification.Name.NSManagedObjectContextDidSave,
                                               object: nil)
    }

    /*
     合并其他上下文的改变到当前上下文
     */
    @objc func mergeChangesNotification(notification: Notification) {
        if let saveContext = notification.object as? NSManagedObjectContext, saveContext != self {
            print("========当前进行合并的上下文是否是主上下文: ========")
            print(self.concurrencyType == .privateQueueConcurrencyType ? "privateQueueConcurrencyType" : "mainQueueConcurrencyType")
            print(notification)
            self.mergeChanges(fromContextDidSave: notification)
        } else {
            print("======当前上下文和保存的上下文是同一个，不进行合并=====")
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
//        NotificationCenter.default.removeObserver(self, name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
        print("\(self) deinit")
    }
}
