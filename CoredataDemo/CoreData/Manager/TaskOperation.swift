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
        CoredataActions.currentContext().performAndWait {
            if let block = taskBlock {
                block()
            }
        }
    }

    deinit {
        print("\(self) operation deinit")
    }
}
