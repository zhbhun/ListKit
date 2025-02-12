---
id: lk-section-list-view
title: LKSectionListView
description: A view that represents a flat list of items.
sidebar_label: 'LKSectionListView'
sidebar_position: 2
---

LKSectionListView 是一个高性能的分组(section)列表组件。

## 何时使用

- 当有大量结构化的数据需要分组展现时；
- 当需要对数据进行选择、排序和自定义操作等复杂行为时。

## 如何使用

1. 定义数据模型

  数据模型必须实现 Hashable 协议。

  ```swift
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
  ```

2. 创建数据源

  ```swift
  let dataSource = LKSectionListDataSource<Section, Item>
  var snapshot = dataSource.snapshot()
  (1...2).forEach { sectionColumn in
      let section = Section(
          id: UUID(),
          title: "\(sectionColumn)",
          column: sectionColumn
      )
      snapshot.appendSections([section])
      (1...30).forEach { item in
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
  ```

3. 创建列表项视图

  ```swift
  class ItemView: LKListItemView {
    // ...
      func configure(_ item: Item) {
          label.text = item.title
          contentView.backgroundColor = item.color
      }
  }
  ```

4. 创建列表视图

  ```swift
  let listView = LKSectionListView<Section, Item>.flow(
      frame: view.frame,
      dataSource: dataSource,
      resolve: { index, section in
          return "\(section.column)"
      },
      sections:[
          // 一行一列
          "1": .init(
              inset: .fixed(horizontal: 20, vertical: 0),
              mainAxisSpacing: .fixed(10),
              item: .init(
                  size: .dynamic { (listView, indexPath, item: Item) in
                      return CGSize(
                          width: CGFloat(UIScreen.main.bounds.width / 1 - 40),
                          height: item.height
                      )
                  },
                  render: { (cell: CustomCell, indexPath, item) in
                      cell.configure(item)
                  }
              )
          ),
          // 一行两列
          "2": .init(
              inset: .fixed(horizontal: 20, vertical: 0),
              mainAxisSpacing: .fixed(10),
              crossAxisSpacing: .fixed(10),
              item: .init(
                  size: .dynamic { (listView, indexPath, item: Item) in
                      return CGSize(
                          width: CGFloat((UIScreen.main.bounds.width / 1 - 40 - 10) / 2),
                          height: item.height
                      )
                  },
                  render: { (cell: CustomCell, indexPath, item) in
                      cell.configure(item)
                  }
              )
          )
      ]
  )
  ```

## 代码示例

### 数据源管理

```swift showLineNumbers
// 初始化
let dataSource = LKFlatListDataSource<Item>()
var snapshot = dataSource.snapshot()
(1...2).forEach { sectionColumn in
    let section = Section(
        id: UUID(),
        title: "\(sectionColumn)",
        column: sectionColumn
    )
    snapshot.appendSections([section])
    (1...30).forEach { item in
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

// 新增
var snapshot = dataSource.snapshot()
let newSection = Section(
    id: UUID(),
    title: "3",
    column: 3
)
snapshot.appendSections([newSection])
snapshot.appendItems(
    (1...30).map {
        Item(
            id: UUID(),
            title: "\(3)-\($0)",
            height: CGFloat(Int.random(in: 50...300))
        )
    },
    newSection
)
dataSource.apply(snapshot, mode: .normal)

// 修改
var snapshot = dataSource.snapshot()
if var firstItem = snapshot.itemIdentifiers.first {
    firstItem.title += "."
    snapshot.reloadItems([firstItem])
}
dataSource.apply(snapshot, mode: .normal)

// 删除
var snapshot = dataSource.snapshot()
if let firstItem = snapshot.itemIdentifiers.first {
    // 删除第一个列表项
    snapshot.deleteItems([firstItem])
}
if let lastSection = snapshot.sectionIdentifiers.last {
    // 删除最后一个分组
    snapshot.deleteSections(lastSection)
}
dataSource.apply(snapshot, mode: .normal)

// 移动
var snapshot = dataSource.snapshot()
if let firstItem = snapshot.itemIdentifiers.first,
    let lastItem = snapshot.itemIdentifiers.last  {
    snapshot.moveItem(firstItem, afterItem: lastItem)
}
if let firstSection = snapshot.sectionIdentifiers.first,
    let lastSection = snapshot.sectionIdentifiers.last  {
    snapshot.moveSection(firstSection, afterItem: lastSection)
}
dataSource.apply(snapshot, mode: .normal)
```

### 流式布局

使用方式类似 `LKFlatList`，只是多了一个层级，通过 resolve 来决定分组标识，sections 配置对应分组的显示项。

```swift showLineNumbers
let listView = LKSectionListView<Section, Item>.flow(
    frame: view.frame,
    dataSource: dataSource,
    resolve: { index, section in
        return "\(section.column)"
    },
    sections:[
        // 一行一列
        "1": LKListFlowSection<Section, Item>(
            // 组内边距
            inset: .fixed(horizontal: 20, vertical: 0),
            // 组主轴方向的间距（行间距）
            mainAxisSpacing: .fixed(10),
            // 组头
            header: LKListFlowSectionHeader<Section>(
                size: .fixed(width: UIScreen.main.bounds.width, height: 50),
                render: { (supplementary: CustomSupplementary, indexPath, section) in
                    supplementary.label.text = "Header \(section.title)"
                }
            ),
            // 组尾
            footer: LKListFlowSectionFooter<Section>(
                size: .fixed(width: UIScreen.main.bounds.width, height: 50),
                render: { (supplementary: CustomSupplementary, indexPath, section) in
                    supplementary.label.text = "Footer \(section.title)"
                }
            ),
            // 组元素
            item: LKListFlowItem<Item>(
                size: .dynamic { (listView, indexPath, item: Item) in
                    return CGSize(
                        width: CGFloat(UIScreen.main.bounds.width / 1 - 40),
                        height: item.height
                    )
                },
                render: { (cell: CustomCell, indexPath, item) in
                    cell.configure(item)
                }
            )
        ),
        // 一行两列
        "2": LKListFlowSection<Section, Item>(
            inset: .fixed(horizontal: 20, vertical: 0),
            mainAxisSpacing: .fixed(10),
            // 组次轴方向的间距（列间距）
            crossAxisSpacing: .fixed(10),
            item: LKListFlowItem<Item>(
                size: .dynamic { (listView, indexPath, item: Item) in
                    return CGSize(
                        width: CGFloat((UIScreen.main.bounds.width / 1 - 40 - 10) / 2),
                        height: item.height
                    )
                },
                render: { (cell: CustomCell, indexPath, item) in
                    cell.configure(item)
                }
            )
        )
    ]
)
```

### 组合布局

使用方式类似 `LKFlatList`，只是多了一个层级，通过 resolve 来决定分组标识，sections 配置对应分组的显示项。

```swift showLineNumbers
let listView = LKSectionListView<Section, Item>.compositional(
    frame: view.frame,
    dataSource: dataSource,
    resolve: { index, section in
        return "\(section.column)"
    },
    sections: [
        // 块布局组
        "1": LKListCompositionalSection<Section, Item>(
            inset: NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20),
            header: LKListCompositionalSectionHeader<Section>(
                size: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)
                ),
                render: { (supplementary: CustomSupplementary, indexPath, section) in
                    supplementary.label.text = "Header \(section.title)"
                }
            ),
            footer: LKListCompositionalSectionFooter<Section>(
                size: NSCollectionLayoutSize(
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
        // 网格布局组
        "2": LKListCompositionalSection<Section, Item>(
            inset: NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20),
            item: LKListCompositionalCell<Item>(
                mainAxisSize: .estimated(150),
                mainAxisSpacing: 10,
                crossAxisSpacing: .fixed(10),
                cellSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .fractionalWidth(0.5)
                ),
                render: { (cell: CompositionalCell, indexPath, item) in
                    cell.configure(item)
                }
            )
        ),
        // 瀑布流布局组
        "3": LKListCompositionalSection<Section, Item>(
            inset: NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20),
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
)
```

### 事件处理

`ListKit` 支持链式写法，在实例化列表后可以直接调用对应的事件监听方法。

```swift showLineNumbers
let listView = LKFlatListView<Item>.compositional(
    frame: view.frame,
    // 数据源
    dataSource: dataSource,
    // 主轴方向
    scrollDirection: .vertical,
    // resolve: ...,
    // sections: ...
).onDidSelectItemAt { listView, indexPath, itemIdentifier in
    print(">> did select item at: \(itemIdentifier.title)")
}.onWillDisplayItemAt { listView, view, indexPath, itemIdentifier in
    print(">> will display item at: \(itemIdentifier.title)")
}.onDidDisplayItemAt { listView, view, indexPath, itemIdentifier in
    print(">> did display item at: \(itemIdentifier.title)")
}
```

## 接口文档

- [LKSectionListView](https://listkit.pages.dev/documentation/listkit/lksectionlistview)
- [LKSectionListDataSource](https://listkit.pages.dev/documentation/listkit/lksectionlistdatasource)
- [LKListFlowSection](https://listkit.pages.dev/documentation/listkit/lklistflowsection)
- [LKListCompositionalSection](https://listkit.pages.dev/documentation/listkit/lklistcompositionalsection)
