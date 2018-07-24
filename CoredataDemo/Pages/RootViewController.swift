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

    lazy var delButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("清空", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.addTarget(self, action: #selector(delAll), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "联系人"

        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: delButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addContact))

        self.view.addSubview(tableView)

//        NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextDidSave,
//                                               object: nil,
//                                               queue: nil) { (info) in
//                                                print(Thread.current, Thread.isMainThread)
//                                                DispatchQueue.main.async {
//                                                    // 在主线程上下文查询对象
//                                                    let datas = CoreDataManager.share.mainThreadContext.fetchObjects(entityName: "Contact")
//                                                    self.data = datas
//                                                    self.tableView.reloadData()
//                                                }
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let context = CoreDataManager.share.mainThreadContext
//        let datas = context.fetchObjects(entityName: "Contact")
        let reqest: NSFetchRequest = NSFetchRequest<ContactMO>(entityName: "Contact")
        let sort = NSSortDescriptor(key: "createTime", ascending: true)
        reqest.sortDescriptors = [sort]
        do {
            let datas = try context.fetch(reqest)
            self.data = datas
            self.tableView.reloadData()
        } catch {

        }
//        context.deleteAll(entityName: "Contact")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func delAll() {
        let context = CoreDataManager.share.mainThreadContext
        context.deleteAll(entityName: "Contact")
        let datas = CoreDataManager.share.mainThreadContext.fetchObjects(entityName: "Contact")
        self.data = datas
        self.tableView.reloadData()
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
