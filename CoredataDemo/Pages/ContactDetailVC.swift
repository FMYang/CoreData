//
//  ContactDetailVC.swift
//  CoredataDemo
//
//  Created by yfm on 2018/7/10.
//  Copyright © 2018年 yfm. All rights reserved.
//

import UIKit
import CoreData

enum OperationType {
    case add
    case edit
}

class ContactDetailVC: UIViewController {

    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var companyTextfield: UITextField!
    @IBOutlet weak var telTextfield: UITextField!

    var acontact: ContactMO?

    var atype: OperationType = .add

    convenience init(contact: ContactMO) {
        self.init()
        acontact = contact
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameTextfield.text = acontact?.firstName
        lastNameTextfield.text = acontact?.lastName
        companyTextfield.text = acontact?.company
        telTextfield.text = acontact?.tel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func finish(_ sender: UIButton) {

        if telTextfield.text?.count == 0 {
            telTextfield.layer.borderWidth = 0.5
            telTextfield.layer.borderColor = UIColor.red.cgColor
            return
        }

        telTextfield.layer.borderWidth = 0
        telTextfield.layer.borderColor = UIColor.clear.cgColor

        // 插入
        let firstName = firstNameTextfield.text
        let lastName = lastNameTextfield.text
        let company = companyTextfield.text
        let tel = telTextfield.text

        switch atype {
        case .add:
                let task = TaskOperation()
                task.taskBlock = { context in
                    for _ in 0...10000 {
                        let object: ContactMO = context.insertObject()
                        object.firstName = firstName
                        object.lastName = lastName
                        object.company = company
                        object.tel = tel
                    }
                }
                CoreDataManager.queue.addOperation(task)

//            DispatchQueue.global().async {
//                let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
////                context.persistentStoreCoordinator = CoreDataManager.share.mainPersistentStoreCoordinator
//                let object: ContactMO = context.insertObject()
//                object.firstName = firstName
//                object.lastName = lastName
//                object.company = company
//                object.tel = tel
//                context.saveOrRollback()
//            }
        case .edit:
            DispatchQueue.global().async {
                let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                self.acontact!.firstName = firstName
                self.acontact!.lastName = lastName
                self.acontact!.company = company
                self.acontact!.tel = tel
                context.saveOrRollback()
                CoreDataManager.share.mainThreadContext.saveOrRollback()
            }
        }


        self.dismiss(animated: true, completion: nil)
    }
}
