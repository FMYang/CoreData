//
//  ContactDetailVC.swift
//  CoredataDemo
//
//  Created by yfm on 2018/7/10.
//  Copyright © 2018年 yfm. All rights reserved.
//

import UIKit
import CoreData
class ContactDetailVC: UIViewController {

    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var companyTextfield: UITextField!
    @IBOutlet weak var telTextfield: UITextField!

    var acontact: ContactMO?

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
        let context = CoreDataManager.share.mainThreadContext
        let object: ContactMO = context.insertObject()
        object.firstName = firstNameTextfield.text
        object.lastName = lastNameTextfield.text
        object.company = companyTextfield.text
        object.tel = telTextfield.text
        context.saveOrRollback()

        self.dismiss(animated: true, completion: nil)
    }
}
