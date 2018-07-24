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

    var taskBlock: (() -> ())?

    override func main() {
        if let block = taskBlock {
            block()
        }
//        let privateContext = CoreDataManager.share.newPrivateContext()
//        privateContext.perform() {
//            if let block = self.taskBlock {
//                block(privateContext)
//            }
//            self.save(context: privateContext)
//        }
    }

    deinit {
        print("\(self) operation deinit")
    }
}
