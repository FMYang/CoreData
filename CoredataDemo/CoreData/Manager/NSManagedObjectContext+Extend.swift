//
//  NSManagedObjectContext.swift
//  CoredataDemo
//
//  Created by yfm on 2018/7/11.
//  Copyright © 2018年 yfm. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    // 插入
    final func insertObject<T: NSManagedObject>() -> T where T: Managed {
        guard let obj = (NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self) as? T) else {
            fatalError("wrong object type")
        }
        return obj
    }

    // 查询
    func fetchObjects<T: NSManagedObject>() -> [T] where T: Managed {
        let request = NSFetchRequest<T>(entityName: T.entityName)
        do {
            let objects = try self.fetch(request)
            return objects
        } catch {
            fatalError("fetch error")
        }
    }

    // 保存
    public func saveOrRollback() {
        do {
            try save()
        } catch {
            rollback()
        }
    }
}
