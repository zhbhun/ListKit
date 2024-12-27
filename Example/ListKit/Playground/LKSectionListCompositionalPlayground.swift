//
//  LKSectionListCompositionalPlayground.swift
//  ListKit
//
//  Created by zhanghuabin on 2024/12/14.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import ListKit
import UIKit

class LKSectionListCompositionalPlayground: UIViewController {
    class Section: Hashable {
        let id: UUID
        let title: String
        let column: Int

        init(
            id: UUID,
            title: String,
            column: Int
        ) {
            self.id = id
            self.title = title
            self.column = column
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
        let ratio: CGFloat

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
            self.ratio = CGFloat.random(in: 0.5...1.5)
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: Item, rhs: Item) -> Bool {
            return lhs.id == rhs.id
        }
    }

    var dataSource: LKSectionListDataSource<Section, Item>! = nil
    var listView: LKSectionListView<Section, Item>! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        dataSource = LKSectionListDataSource<Section, Item>()
        var snapshot = dataSource.snapshot()
        (1...3).forEach { sectionColumn in
            let section = Section(
                id: UUID(),
                title: "\(sectionColumn)",
                column: sectionColumn
            )
            snapshot.appendSections([section])
            (1...10).forEach { item in
                snapshot.appendItems(
                    [
                        Item(
                            id: UUID(),
                            title: "\(sectionColumn)-\(item)",
                            height: CGFloat(Int.random(in: 50...300))
                        )
                    ],
                    section
                )
            }

        }
        dataSource.apply(snapshot, mode: .reload)

        listView = .compositional(
            frame: view.frame,
            dataSource: dataSource,
            resolve: { index, section in
                return "\(section.column)"
            },
            sections: [
                "1": .init(
                    inset: .init(top: 0, leading: 20, bottom: 0, trailing: 20),
                    header: .init(
                        size: .init(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(50)
                        ),
                        render: { (supplementary: CustomSupplementary, indexPath, section) in
                            supplementary.label.text = "Header \(section.title)"
                        }
                    ),
                    footer: .init(
                        size: .init(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(50)
                        ),
                        render: { (supplementary: CustomSupplementary, indexPath, section) in
                            supplementary.label.text = "Footer \(section.title)"
                        }
                    ),
                    item: LKListCompositionalBlock<Item>(
                        size: .estimated(100),
                        spacing: 10,
                        render: { (cell: CompositionalBlock, indexPath, item) in
                            cell.configure(item)
                        }
                    )
                ),
                "2": .init(
                    inset: .init(top: 0, leading: 20, bottom: 0, trailing: 20),
                    header: .init(
                        size: .init(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(50)
                        ),
                        render: { (supplementary: CustomSupplementary, indexPath, section) in
                            supplementary.label.text = "Header \(section.title)"
                        }
                    ),
                    footer: .init(
                        size: .init(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(50)
                        ),
                        render: { (supplementary: CustomSupplementary, indexPath, section) in
                            supplementary.label.text = "Footer \(section.title)"
                        }
                    ),
                    item: LKListCompositionalCell<Item>(
                        mainAxisSize: .estimated(150),
                        mainAxisSpacing: 10,
                        crossAxisSpacing: .fixed(10),
                        cellSize: .init(
                            widthDimension: .fractionalWidth(0.5),
                            heightDimension: .fractionalWidth(0.5)
                        ),
                        render: { (cell: CompositionalCell, indexPath, item) in
                            cell.configure(item)
                        }
                    )
                ),
                "3": .init(
                    inset: .init(top: 0, leading: 20, bottom: 0, trailing: 20),
                    header: .init(
                        size: .init(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(50)
                        ),
                        render: { (supplementary: CustomSupplementary, indexPath, section) in
                            supplementary.label.text = "Header \(section.title)"
                        }
                    ),
                    footer: .init(
                        size: .init(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(50)
                        ),
                        render: { (supplementary: CustomSupplementary, indexPath, section) in
                            supplementary.label.text = "Footer \(section.title)"
                        }
                    ),
                    item: LKListCompositionalWaterfall<Item>(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        ratio: { $0.ratio },
                        render: { (cell: CompositionalWaterfall, indexPath, item) in
                            cell.configure(item)
                        }
                    )
                ),
            ]
        ).onDidSelectItemAt {
            listView,
            indexPath,
            itemIdentifier in
            print(
                ">> \(indexPath.section)-\(indexPath.item) \(itemIdentifier.id) \(itemIdentifier.title) \(itemIdentifier.height)"
            )
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
        backgroundColor = .gray
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private class CompositionalBlock: UICollectionViewCell {
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

    func configure(_ item: LKSectionListCompositionalPlayground.Item) {
        label.text = item.title
        heightConstraint?.constant = item.height
        contentView.backgroundColor = item.color
    }
}

private class CompositionalCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

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
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(_ item: LKSectionListCompositionalPlayground.Item) {
        label.text = item.title
        contentView.backgroundColor = item.color
    }
}

private class CompositionalWaterfall: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)

        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(_ item: LKSectionListCompositionalPlayground.Item) {
        label.text = item.title
        contentView.backgroundColor = item.color
    }
}
