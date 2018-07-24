//
//  ContactMO+CoreDataProperties.swift
//  CoredataDemo
//
//  Created by yfm on 2018/7/24.
//  Copyright © 2018年 yfm. All rights reserved.
//
//

import Foundation
import CoreData


extension ContactMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactMO> {
        return NSFetchRequest<ContactMO>(entityName: "Contact")
    }

    @NSManaged public var company: String?
    @NSManaged public var createTime: Int64
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var tel: String?

}
