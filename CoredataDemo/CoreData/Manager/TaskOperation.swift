//
//  DBOperation.swift
//  CoredataDemo
//
//  Created by yfm on 2018/7/18.
//  Copyright © 2018年 yfm. All rights reserved.
//

import Foundation
import CoreData

class TaskOperation: Operation {

    var taskBlock: ((NSManagedObjectContext) -> ())?

    override func main() {
        let privateContext = CoreDataManager.share.newPrivateContext()
        privateContext.perform() {
            if let block = self.taskBlock {
                block(privateContext)
            }
            self.save(context: privateContext)
        }
    }

    func save(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
                try CoreDataManager.share.mainThreadContext.save()
            } catch {
                fatalError("private context save error!")
            }
        }
        context.reset()
    }
}
