//
//  ViewController.swift
//  ListKit
//
//  Created by zhbhun on 11/21/2024.
//  Copyright (c) 2024 zhbhun. All rights reserved.
//

import UIKit

//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//}
//


class ViewController: UIViewController {
    class Item: Hashable {
        let id: UUID
        let title: String
        let factory: () -> UIViewController
        
        init(id: UUID, title: String, factory: @escaping () -> UIViewController) {
            self.id = id
            self.title = title
            self.factory = factory
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: Item, rhs: Item) -> Bool {
            return lhs.id == rhs.id
        }
    }
    
    var dataSource: ZHFlatListDataSource<Item>! = nil
    var listView: ZHFlatListView<Item>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "ZHListKit"
        
        dataSource = ZHFlatListDataSource<Item>()
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([
            Item(
                id: UUID(),
                title: "ZHFlatListCompositionalLayout",
                factory: { ZHFlatListCompositionalPlayground() }
            ),
            Item(
                id: UUID(),
                title: "ZHFlatListCompositionalWaterfallLayout",
                factory: { LKFlatListCompositionalWaterfallLayoutPlayground() }
            )
        ])
        dataSource.apply(snapshot, mode: .reload)
        let item = LKFlowItem<Item>(
            size: .fixed(width: UIScreen.main.bounds.width / 1 - 40, height: 50),
            didSelectAt: { [weak self] listView, indexPath in
                guard let self = self, let item = self.dataSource.snapshot().itemIdentifier(indexPath) else { return }
                self.navigationController?.pushViewController(item.factory(), animated: true)
            },
            render: { (cell: UICollectionViewListCell, indexPath, item) in
                var content = cell.defaultContentConfiguration()
                content.text = item.title
                cell.contentConfiguration = content
            }
        )
        let header = LKFlowSupplementary.header(
            size: .fixed(width: UIScreen.main.bounds.width, height: 50),
            render: { (supplementaryView: CustomSupplementary, indexPath) in
                supplementaryView.label.text = "Header"
            }
        )
        let footer = LKFlowSupplementary.footer(
            size: .fixed(width: UIScreen.main.bounds.width, height: 50),
            render: { (supplementaryView: CustomSupplementary, indexPath) in
                supplementaryView.label.text = "Footer"
            }
        )
        let layout = LKFlowLayout<Item>(
            inset: .fixed(top: 0, leading: 20, bottom: 0, trailing: 20),
            header: header,
            footer: footer,
            item: item
        )
        listView = ZHFlatListView(
            frame: view.frame,
            dataSource: dataSource,
            layout: layout
        )
        view.addSubview(listView)
    }
}

fileprivate class CustomSupplementary: UICollectionReusableView {
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: label.superview!.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: label.superview!.bottomAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: label.superview!.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: label.superview!.trailingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
