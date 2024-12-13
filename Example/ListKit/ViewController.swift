//
//  ViewController.swift
//  ListKit
//
//  Created by zhbhun on 11/21/2024.
//  Copyright (c) 2024 zhbhun. All rights reserved.
//

import UIKit

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

    var dataSource: LKFlatListDataSource<Item>! = nil
    var listView: LKFlatListView<Item>! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ZHListKit"

        dataSource = LKFlatListDataSource<Item>()
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([
            Item(
                id: UUID(),
                title: "LKFlatListView.compositional",
                factory: { LKFlatListCompositionalPlayground() }
            ),
            Item(
                id: UUID(),
                title: "LKFlatListView.waterfall",
                factory: { LKFlatListWaterfallPlayground() }
            ),
            Item(
                id: UUID(),
                title: "ZHFlatListCompositionalLayout",
                factory: { ZHFlatListCompositionalPlayground() }
            ),
            Item(
                id: UUID(),
                title: "ZHFlatListCompositionalWaterfallLayout",
                factory: { ZHFlatListCompositionalWaterfallLayoutPlayground() }
            ),
        ])
        dataSource.apply(snapshot, mode: .reload)

        listView = .flow(
            frame: view.frame,
            dataSource: dataSource,
            inset: .fixed(top: 0, leading: 20, bottom: 0, trailing: 20),
            header: LKListFlowHeader(
                size: .fixed(width: UIScreen.main.bounds.width, height: 50),
                render: { (supplementaryView: CustomSupplementary, indexPath) in
                    supplementaryView.label.text = "Footer"
                }
            ),
            footer: LKListFlowFooter(
                size: .fixed(width: UIScreen.main.bounds.width, height: 50),
                render: { (supplementaryView: CustomSupplementary, indexPath) in
                    supplementaryView.label.text = "Header"
                }
            ),
            item: LKListFlowItem<Item>(
                size: .fixed(width: UIScreen.main.bounds.width / 1 - 40, height: 50),
                render: { (cell: UICollectionViewListCell, indexPath, item) in
                    var content = cell.defaultContentConfiguration()
                    content.text = item.title
                    cell.contentConfiguration = content
                }
            )
        ).onDidSelectItemAt { [weak self] listView, indexPath, itemIdentifier in
            guard let self = self else { return }
            self.navigationController?.pushViewController(itemIdentifier.factory(), animated: true)
        }
        view.addSubview(listView)
    }
}

private class CustomSupplementary: UICollectionReusableView {
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
            label.trailingAnchor.constraint(
                equalTo: label.superview!.trailingAnchor, constant: -10),
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
