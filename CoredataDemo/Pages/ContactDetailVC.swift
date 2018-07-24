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
//            CoreDataManager.queue.async {
                let object: ContactMO = CoredataActions.createObjectOnCurrentThread()
                object.firstName = firstName
                object.lastName = lastName
                object.company = company
                object.tel = tel
                CoredataActions.insertObjectOnCurrentThread(object: object)
                CoredataActions.saveOnCurrentThread()
//            }
        case .edit:

//            let task1 = TaskOperation()
//            task1.taskBlock = {
//                print("=====task1: \(Thread.current)")
//                let context = CoredataActions.currentContext()
//                let object = context.fetchObjects(entityName: "Contact")[0]
//                object.firstName = "private1"
//                CoredataActions.saveOnCurrentThread()
//            }
//
//            let task2 = TaskOperation()
//            task2.taskBlock = {
//                print("=====task2: \(Thread.current)")
//                let context = CoredataActions.currentContext()
//                let object = context.fetchObjects(entityName: "Contact")[0]
//                object.firstName = "private2"
//                CoredataActions.saveOnCurrentThread()
//            }
//
//            task2.addDependency(task1)
//
//            CoreDataManager.share.taskQueue.addOperation(task1)
//            CoreDataManager.share.taskQueue.addOperation(task2)

            // 主线程上下文修改对象为的firstname为liu
//            let context = CoreDataManager.share.mainThreadContext
//            let datas = context.fetchObjects(entityName: "Contact")
//            if datas.count > 0 {
//                let contact1 = datas[0]
//                contact1.firstName = "liu"
//            } else {
//                print("main context not found contact")
//            }

//            let task1 = TaskOperation()
//            task1.taskBlock = {
//                for i in 0...15 {
//                    let object: ContactMO = CoredataActions.createObjectOnCurrentThread()
//                    object.firstName = "private1-\(i)"
//                    object.tel = "1"
//                    object.createTime = self.currentTime()
//                    CoredataActions.insertObjectOnCurrentThread(object: object)
//                }
//
//                // 保存子线程上下文的变更
//                CoredataActions.saveOnCurrentThread()
//            }
//
//            let task2 = TaskOperation()
//            task2.taskBlock = {
//                for i in 0...10 {
//                    let object: ContactMO = CoredataActions.createObjectOnCurrentThread()
//                    object.firstName = "private2-\(i)"
//                    object.tel = "2"
//                    object.createTime = self.currentTime()
//                    CoredataActions.insertObjectOnCurrentThread(object: object)
//                }
//
//                // 保存子线程上下文的变更
//                CoredataActions.saveOnCurrentThread()
//            }
//
//            let task3 = TaskOperation()
//            task3.taskBlock = {
//                CoredataActions.currentContext().perform {
//                    for i in 0...10 {
//                        let object: ContactMO = CoredataActions.createObjectOnCurrentThread()
//                        object.firstName = "private3-\(i)"
//                        object.tel = "3"
//                        object.createTime = self.currentTime()
//                        CoredataActions.insertObjectOnCurrentThread(object: object)
//                    }
//                    CoredataActions.saveOnCurrentThread()
//                }
//            }
//
//            CoreDataManager.share.taskQueue.addOperation(task1)
//            CoreDataManager.share.taskQueue.addOperation(task2)
//            CoreDataManager.share.taskQueue.addOperation(task3)

            let task = TaskOperation()
            task.taskBlock = {
                for i in 0...100 {
                    let object: ContactMO = CoredataActions.createObjectOnCurrentThread()
                    object.firstName = "private4-\(i)"
                    object.tel = "4"
                    object.createTime = self.currentTime()
                    CoredataActions.insertObjectOnCurrentThread(object: object)
                }
                CoredataActions.saveOnCurrentThread()
            }
            CoreDataManager.share.taskQueue.addOperation(task)
        }

        self.dismiss(animated: true, completion: nil)
    }

    func currentTime() -> Int64 {
        let time = Date()
        let timeStamp = Int64(time.timeIntervalSince1970*1000)
        return timeStamp
    }
}
