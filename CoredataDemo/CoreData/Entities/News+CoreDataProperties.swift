//
//  News+CoreDataProperties.swift
//  CoredataDemo
//
//  Created by yfm on 2018/7/27.
//  Copyright © 2018年 yfm. All rights reserved.
//
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var title: String?
    @NSManaged public var source: String?

}
