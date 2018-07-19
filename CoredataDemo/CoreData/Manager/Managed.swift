//
//  Managed.swift
//  CoredataDemo
//
//  Created by yfm on 2018/7/11.
//  Copyright © 2018年 yfm. All rights reserved.
//

import Foundation
import CoreData
protocol Managed: class, NSFetchRequestResult {
    static var customEntityName: String { get }
}

extension Managed where Self: NSManagedObject {
    static var customEntityName: String {
        return self.entity().name!
    }
}
