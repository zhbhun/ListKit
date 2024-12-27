//
//  LKFlatListCompositionalPlayground.swift
//  ListKit
//
//  Created by zhanghuabin on 2024/12/13.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import ListKit
import UIKit

class LKFlatListBlockPlayground: UIViewController {
    class Item: Hashable {
        let id: UUID
        let title: String
        let color: UIColor
        let height: CGFloat

        init(id: UUID, title: String, height: CGFloat) {
            self.id = id
            self.title = title
            self.color = UIColor(
                red: CGFloat.random(in: 0...1),
                green: CGFloat.random(in: 0...1),
                blue: CGFloat.random(in: 0...1),
                alpha: 1.0
            )
            self.height = height
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
        
        view.backgroundColor = .white

        dataSource = LKFlatListDataSource<Item>()
        var snapshot = dataSource.snapshot()
        (1...100).forEach {
            snapshot.appendItems([
                Item(
                    id: UUID(),
                    title: "\($0)",
                    height: CGFloat(Int.random(in: 50...300))
                )
            ])
        }
        dataSource.apply(snapshot, mode: .reload)

        listView = .compositional(
            frame: view.frame,
            dataSource: dataSource,
            inset: NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20),
            header: LKListCompositionalHeader(
                size: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)
                ),
                render: { (supplementary: CustomSupplementary, indexPath) in
                    supplementary.label.text = "Header"
                }
            ),
            footer: LKListCompositionalFooter(
                size: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)
                ),
                render: { (supplementary: CustomSupplementary, indexPath) in
                    supplementary.label.text = "Footer"
                }
            ),
            item: LKListCompositionalBlock<Item>(
                size: .estimated(100),
                spacing: 10,
                render: { (cell: CustomCell, indexPath, item) in
                    cell.configure(item)
                }
            )
        ).onDidSelectItemAt { listView, indexPath, itemIdentifier in
            print(">> \(itemIdentifier.id) \(itemIdentifier.title) \(itemIdentifier.height)")
        }
        view.addSubview(listView)
    }
}

private class CustomSupplementary: UICollectionReusableView {
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
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

    func configure(_ item: LKFlatListBlockPlayground.Item) {
        label.text = item.title
        heightConstraint?.constant = item.height
        contentView.backgroundColor = item.color
    }
}
