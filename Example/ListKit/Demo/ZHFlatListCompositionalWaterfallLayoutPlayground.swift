//
//  ZHFlatListPlayground.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/19.
//  Copyright © 2024 CocoaPods. All rights reserved.
//


import UIKit

class ZHFlatListCompositionalWaterfallLayoutPlayground: UIViewController {
    class Item: Hashable {
        let id: UUID
        let title: String
        let color: UIColor
        let ratio: CGFloat
        
        init(id: UUID, title: String, ratio: CGFloat? = nil) {
            self.id = id
            self.title = title
            self.color = UIColor(
                red: CGFloat.random(in: 0...1),
                green: CGFloat.random(in: 0...1),
                blue: CGFloat.random(in: 0...1),
                alpha: 1.0
            )
            self.ratio = ratio ?? CGFloat.random(in: 0.5...1.5)
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
        
        dataSource = ZHFlatListDataSource<Item>()
        var snapshot = dataSource.snapshot()
        (1...100).forEach {
            snapshot.appendItems([Item(
                id: UUID(),
                title: "\($0)"
            )])
        }
        dataSource.apply(snapshot, mode: .reload)
        listView = ZHFlatListView(
            frame: view.frame,
            dataSource: dataSource,
            layout: ZHCompositionalLayout.waterfall(
                dataSource: dataSource,
                insets: NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15),
                header: ZHCompositionalBoundarySupplementary(
                    kind: UICollectionView.elementKindSectionHeader,
                    size: ZHDimension(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(50)
                    ),
                    render: { (supplementary: CustomSupplementary, indexPath) in
                        supplementary.label.text = "Header"
                    }
                ),
                footer: ZHCompositionalBoundarySupplementary(
                    kind: UICollectionView.elementKindSectionFooter,
                    size: ZHDimension(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(50)
                    ),
                    render: { (supplementary: CustomSupplementary, indexPath) in
                        supplementary.label.text = "Footer"
                    }
                ),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 10,
                item: ZHCompositionalWaterfallItem<Item>(
                    ratio: { item in
                        return item.ratio
                    },
                    render:{ (cell: CustomCell, indexPath, item) in
                        cell.configure(item)
                    }
                )
            )
        )
        view.addSubview(listView)
    }
}

fileprivate class CustomSupplementary: UICollectionReusableView {
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
            label.trailingAnchor.constraint(equalTo: label.superview!.trailingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

fileprivate class CustomCell: UICollectionViewCell {
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
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(_ item: ZHFlatListCompositionalWaterfallLayoutPlayground.Item) {
        label.text = item.title
        contentView.backgroundColor = item.color
    }
}
