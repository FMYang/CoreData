//
//  PageViewController.swift
//  CoredataDemo
//
//  Created by yfm on 2018/7/27.
//  Copyright © 2018年 yfm. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

class PageViewController: UIViewController {

    var subViews = [UITableView]()
    var currentIndex = 0
    var datas = [String]()

    lazy var pageView: UIScrollView = {
        let view = UIScrollView()
        view.frame = CGRect(x: 0, y: 64, width: screenWidth , height: screenHeight-64)
        view.delegate = self
        view.isPagingEnabled = true
        view.contentSize = CGSize(width: screenWidth*5, height: screenHeight-64)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "page0"

        for i in 0...4 {
            let subView = UITableView(frame: CGRect(origin: CGPoint(x: CGFloat(i)*screenWidth, y: 0), size: pageView.frame.size))
            subView.dataSource = self
            subView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            pageView.addSubview(subView)
            subViews.append(subView)
        }

        self.view.addSubview(pageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension PageViewController {
    func loadPage(index: Int) {
        let view = subViews[index]
        currentIndex = index
        view.reloadData()
        self.title = "page\(index)"
    }
}

extension PageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = lroundf(Float(scrollView.contentOffset.x/screenWidth))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.loadPage(index: index)
        }
//        print("page\(index)")

//        CoreDataManager.queue.async {
//            for i in 0...9 {
//                var news: News = CoredataActions.createObjectOnCurrentThread()
//                CoredataActions.insertObjectOnCurrentThread(object: news)
//                news.title = "page\(index)-index\(i)"
//            }
//            CoredataActions.saveOnCurrentThread()
//        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = lroundf(Float(scrollView.contentOffset.x/screenWidth))
        print("scrollViewDidEndDecelerating page\(index)")
    }
}

extension PageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "page\(currentIndex)-index\(indexPath.row)"
        return cell
    }
}
