//
//  LKTabPlayground.swift
//  ListKit
//
//  Created by zhanghuabin on 2024/12/20.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

class LKTabPlayground: UIViewController {
    class Section: Hashable {
        let id: UUID
        let title: String
        let items: [Item]

        init(
            id: UUID,
            title: String,
            items: [Item]
        ) {
            self.id = id
            self.title = title
            self.items = items
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: Section, rhs: Section) -> Bool {
            return lhs.id == rhs.id
        }
    }

    class Item: Hashable {
        let id: UUID
        let title: String
        let color: UIColor
        let height: CGFloat

        init(id: UUID, title: String) {
            self.id = id
            self.title = title
            self.color = UIColor(
                red: CGFloat.random(in: 0...1),
                green: CGFloat.random(in: 0...1),
                blue: CGFloat.random(in: 0...1),
                alpha: 1.0
            )
            self.height = CGFloat(Int.random(in: 50...300))
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: Item, rhs: Item) -> Bool {
            return lhs.id == rhs.id
        }
    }

    var tabs: LKTabDataSource<Section>! = nil
    var tabBar: LKTabBar<Section>! = nil
    var tabView: LKTabView<Section>! = nil
    var tabViewDataSources: [UUID: LKFlatListDataSource<Item>] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        tabs = LKTabDataSource<Section>(initialIndex: 10)
        var snapshot = tabs.snapshot()
        (0...14).forEach { sectionIndex in
            let items = (1...30).map { itemIndex in
                Item(
                    id: UUID(),
                    title: "\(sectionIndex)-\(itemIndex)"
                )
            }

            let section = Section(
                id: UUID(),
                title: "\(sectionIndex)-\(Int.random(in: 0...10000))",
                items: items
            )
            snapshot.appendItems([section])

            let tabViewDataSource = LKFlatListDataSource<Item>()
            var tabViewSnapshot = tabViewDataSource.snapshot()
            tabViewSnapshot.appendItems(items)
            tabViewDataSource.apply(tabViewSnapshot, mode: .reload)
            tabViewDataSources[section.id] = tabViewDataSource
        }
        tabs.apply(snapshot, mode: .reload)

        tabBar = .init(
            dataSource: tabs,
            size: .estimated(30),
            render: { (cell: CustomTab, index, item, selected) in
                cell.configure(item, selected: selected)
            }
        )
        tabBar.backgroundColor = .red
        view.addSubview(tabBar)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: 44),
        ])

        tabView = .init(
            dataSource: tabs,
            reuseLimit: 3,
            create: { [weak self] index, section in
                guard let self,
                    let dataSource = tabViewDataSources[section.id]
                else {
                    return nil
                }
                return LKFlatListView<Item>.flow(
                    frame: .zero,
                    dataSource: dataSource,
                    inset: .fixed(top: 12, leading: 16, bottom: 12, trailing: 16),
                    item: LKListFlowItem<Item>(
                        size: .dynamic({ (listView, indexPath, item: Item) in
                            return CGSize(
                                width: Double(UIScreen.main.bounds.width) / 1 - 32,
                                height: item.height
                            )
                        }),
                        render: { (cell: CustomCell, indexPath, item) in
                            cell.configure(item)
                        }
                    )
                )
            }
        )
        tabView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabView)
        NSLayoutConstraint.activate([
            tabView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabView.topAnchor.constraint(equalTo: tabBar.bottomAnchor),
            tabView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

private class CustomTab: LKTabLabel {
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.heightAnchor.constraint(equalTo: heightAnchor)
        ])

        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(_ item: LKTabPlayground.Section, selected: Bool) {
        label.text = item.title
        label.textColor = .white
        select(item, selected: selected)
    }

    func select(_ item: LKTabPlayground.Section, selected: Bool) {
        if selected {
            label.font = UIFont.boldSystemFont(ofSize: 16)
            contentView.backgroundColor = .black
        } else {
            label.font = UIFont.systemFont(ofSize: 16)
            contentView.backgroundColor = .gray
        }
    }
}

private class CustomCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    private var heightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)

        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
        heightConstraint = label.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.priority = .defaultHigh
        heightConstraint?.isActive = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(_ item: LKTabPlayground.Item) {
        label.text = item.title
        heightConstraint?.constant = item.height
        contentView.backgroundColor = item.color
    }
}
