//
//  RootViewController.swift
//  CoredataDemo
//
//  Created by yfm on 2018/7/10.
//  Copyright © 2018年 yfm. All rights reserved.
//

import UIKit
import CoreData
class RootViewController: UIViewController {

    var data = [ContactMO]()

    lazy var tableView: UITableView = {
        let view = UITableView()
        view.frame = self.view.frame
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "联系人"

        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addContact))

        self.view.addSubview(tableView)

//        NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextObjectsDidChange,
//                                               object: nil,
//                                               queue: nil) { (info) in
//                                                print("had received save notification")
//                                                let mainContext = CoreDataManager.share.mainThreadContext
//                                                let otherContext = info.object as? NSManagedObjectContext
//                                                if let context = otherContext, context != mainContext {
//                                                    mainContext.perform({
//                                                        mainContext.mergeChanges(fromContextDidSave: info)
//                                                    })
//                                                }
//                                                let datas = mainContext.fetchObjects(entityName: "Contact")
//                                                self.data = datas
//                                                self.tableView.reloadData()
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 查询
//        DispatchQueue.global().async {
//            let context = CoreDataManager.share.persistentContainer.newBackgroundContext()
//            let datas = context.fetchObjects(entityName: "Contact")
//            print("background thread " + (datas[0].firstName ?? ""))
//            // 你也可以在上 下文之间直接传递对象本身，但是要注意在其他上下文所处的队列上你只能访问和使用 这些对象的 obejctID
//            DispatchQueue.main.async {
//                print("main thread " + (datas[0].firstName ?? ""))
//                let context = CoreDataManager.share.mainThreadContext
//                for data in datas {
//                    let object = context.object(with: data.objectID) as! ContactMO
//                    self.data.append(object)
//                }
//                self.tableView.reloadData()
//            }
//        }

        let context = CoreDataManager.share.mainThreadContext
        let datas = context.fetchObjects(entityName: "Contact")
        self.data = datas
        self.tableView.reloadData()
//        context.deleteAll(entityName: "Contact")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // 添加联系人
    @objc func addContact() {
        let vc = ContactDetailVC()
        vc.atype = .add
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}

extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let contact = data[indexPath.row]
        cell.textLabel?.text = (contact.firstName ?? "") + (contact.lastName ?? "")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = data[indexPath.row]
        let vc = ContactDetailVC.init(contact: contact)
        vc.atype = .edit
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}
