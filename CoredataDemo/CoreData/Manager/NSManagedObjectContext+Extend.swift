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
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self) as? T else {
            fatalError("insert error")
        }
        return obj
    }

    // 查询
    func fetchObjects(entityName: String) -> [ContactMO] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let objects = try self.fetch(request)
            return objects as! [ContactMO]
        } catch {
            fatalError("fetch error")
        }
    }

    // 删除所有
    @available(iOS 9.0, *)
    func deleteAll(entityName: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let delete = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try self.persistentStoreCoordinator?.execute(delete, with: self)
        } catch {
            fatalError("delete error")
        }
    }

    // 保存或者回滚
    public func saveOrRollback() {
        self.performAndWait {
            do {
                try self.save()
            } catch {
                self.rollback()
            }
        }
    }
}
