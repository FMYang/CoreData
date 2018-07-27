//
//  MainViewController.swift
//  CoredataDemo
//
//  Created by yfm on 2018/7/24.
//  Copyright © 2018年 yfm. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    var data = [ContactMO]()

    lazy var fetchedResultsController: NSFetchedResultsController<ContactMO> = {
        let request = NSFetchRequest<ContactMO>(entityName: "Contact")
        let sort = NSSortDescriptor(key: "createTime", ascending: true)
        request.sortDescriptors = [sort]
        let vc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.share.mainThreadContext, sectionNameKeyPath: nil, cacheName: nil)
        vc.delegate = self
        do {
            try vc.performFetch()
        } catch {
            fatalError("NSFetchedResultsController fetch error")
        }
        return vc
    }()

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
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()

//        self.data = CoreDataManager.share.mainThreadContext.fetchObjects(entityName: "Contact")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func delAll() {
        let context = CoreDataManager.share.mainThreadContext
//        context.deleteAll(entityName: "Contact")
//        NSFetchedResultsController<ContactMO>.deleteCache(withName: "")
        self.fetchedResultsController.fetchRequest.predicate = NSPredicate(value: false)
        do {
            try self.fetchedResultsController.performFetch()
        } catch {}

        self.tableView.reloadData()
    }

    // 添加联系人
    @objc func addContact() {
        let vc = ContactDetailVC()
        vc.atype = .add
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        guard let datas = self.fetchedResultsController.fetchedObjects else { return cell }
        cell.textLabel?.text = datas[indexPath.row].firstName ?? ""
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = data[indexPath.row]
        let vc = ContactDetailVC.init(contact: contact)
        vc.atype = .edit
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}

extension MainViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        self.tableView.reloadData()
        print("controllerDidChangeContent")
        self.tableView.reloadData()
    }
}
