---
id: lk-flat-list-view
title: LKFlatListView
description: A view that represents a flat list of items.
sidebar_label: 'LKFlatListView'
sidebar_position: 1
---

LKFlatListView 是一个高性能的简单列表组件。

如果需要分组/类/区（section），请使用 [LKSectionListView](./lk-section-list-view)

## 何时使用

- 当有大量结构化的数据需要展现时；
- 当需要对数据进行选择、排序和自定义操作等复杂行为时。

## 如何使用

1. 定义数据模型

  数据模型必须实现 Hashable 协议。

  ```swift
  class Item: Hashable {
      let id: UUID
      var title: String
      var color: UIColor
      var height: CGFloat

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
  let dataSource = LKFlatListDataSource<Item>()
  var snapshot = dataSource.snapshot()
  snapshot.appendItems(
      (1...100).map {
          Item(
              id: UUID(),
              title: "\($0)",
              height: CGFloat(Int.random(in: 50...300))
          )
      }
  )
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
  let listView = LKFlatListView<Item>.flow(
      frame: view.frame,
      dataSource: dataSource,
      inset: .fixed(top: 0, leading: 20, bottom: 0, trailing: 20),
      item: LKListFlowItem<Item>(
          size: .dynamic { (listView, indexPath, item: Item) in
              return CGSize(
                  width: UIScreen.main.bounds.width / 1 - 40,
                  height: item.height
              )
          },,
          render: { (itemView: ItemView, indexPath, item) in
              itemView.configure(item)
          }
      )
  ).onDidSelectItemAt { listView, indexPath, item in
      print(">> \(item.id)")
  }
  ```
## 代码示例

### 数据源管理

```swift showLineNumbers
// 初始化
let dataSource = LKFlatListDataSource<Item>()
var snapshot = dataSource.snapshot()
snapshot.appendItems(
    (1...100).map {
        Item(
            id: UUID(),
            title: "\($0)",
            height: CGFloat(Int.random(in: 50...300))
        )
    }
)
dataSource.apply(snapshot, mode: .reload)

// 新增
var snapshot = dataSource.snapshot()
let newIem = Item(
    id: UUID(),
    title: "\($0)",
    height: CGFloat(Int.random(in: 50...300))
)
snapshot.appendItems([newItem])
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
    snapshot.deleteItems([firstItem])
}
dataSource.apply(snapshot, mode: .normal)

// 移动
var snapshot = dataSource.snapshot()
if let firstItem = snapshot.itemIdentifiers.first,
    let lastItem = snapshot.itemIdentifiers.last  {
    snapshot.moveItem(firstItem, afterItem: lastItem)
}
dataSource.apply(snapshot, mode: .normal)
```

### 流式布局

流式布局会沿着主轴方向排列元素，如果每个元素占不满一行/列，那么会优先填充满改行/列。

下面是一个纵向排列的的流式布局列表：

```swift showLineNumbers
let listView = LKFlatListView<Item>.flow(
    frame: view.frame,
    // 数据源
    dataSource: dataSource,
    // 主轴方向
    scrollDirection: .vertical,
    // 内边距
    inset: .fixed(top: 0, leading: 20, bottom: 0, trailing: 20),
    // 主轴方向的间距，使用 `.dynamic` 可以动态设置间距大小
    mainAxisSpacing: .fixed(10),
    // 交叉轴方向的间距，使用 `.dynamic` 可以动态设置间距大小
    crossAxisSpacing: .fixed(0),
    // 头
    header: LKListFlowHeader(
        // 使用 `.dynamic` 可以动态设置头部大小
        size: .fixed(view.frame.width, 100),
        render: { (supplementaryView: HeaderView, indexPath) in
            // ...
        }
    ),
    // 尾
    header: LKListFlowFooter(
        // 使用 `.dynamic` 可以动态设置头部大小
        size: .fixed(view.frame.width, 100),
        render: { (supplementaryView: FooterView, indexPath) in
            // ...
        }
    ),
    // 列表项
    item: LKListFlowItem<Item>(
        // 使用 `.fixed` 可以固定设置头部大小
        size: .dynamic { (listView, indexPath, item: Item) in
            return CGSize(
                // 将宽度改为 `(view.frame.width / 1 - 40) / 2`，列表会显示一行两列
                width: view.frame.width / 1 - 40,
                height: item.height
            )
        },,
        render: { (itemView: ItemView, indexPath, item) in
            itemView.configure(item)
        }
    )
)
```

### 组合布局

对比流式布局，组合布局支持更灵活的元素大小设置（支持百分比和动态宽高）和更复杂的布局模式（多层组合嵌套）。

组合布局非常的灵活，ListKit 根据常见的使用场景预设了几种列表项：

- `LKListCompositionalBlock`：块，每行/列只有一个元素。
- `LKListCompositionalCell`：网格，每行/列有多个元素。
- `LKListCompositionalWaterfall`：瀑布流，类似网格但是不同元素的大小不一致
- `LKListCompositionalGroup`：自定义，支持自定义各种各样的布局形式。

#### 块列表

```swift showLineNumbers
let listView = LKFlatListView<Item>.compositional(
    frame: view.frame,
    // 数据源
    dataSource: dataSource,
    // 主轴方向
    scrollDirection: .vertical,
    // 内边距
    inset: NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20),
    // 头
    header: LKListCompositionalHeader(
        size: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        ),
        render: { (supplementary: CustomSupplementary, indexPath) in
            supplementary.label.text = "Header"
        }
    ),
    // 尾
    footer: LKListCompositionalFooter(
        size: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        ),
        render: { (supplementary: CustomSupplementary, indexPath) in
            supplementary.label.text = "Footer"
        }
    ),
    // 列表项
    item: LKListCompositionalBlock<Item>(
        // 主轴方向的大小，次轴方向会占满列表
        size: .estimated(100),
        // 主轴方向的间距
        spacing: 10,
        render: { (cell: CustomCell, indexPath, item) in
            cell.configure(item)
        }
    )
)
```

#### 网格列表

```swift showLineNumbers
let listView = LKFlatListView<Item>.compositional(
    frame: view.frame,
    // 数据源
    dataSource: dataSource,
    // 主轴方向
    scrollDirection: .vertical,
    // 内边距
    inset: NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20),
    // 头
    header: LKListCompositionalHeader(
        size: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        ),
        render: { (supplementary: CustomSupplementary, indexPath) in
            supplementary.label.text = "Header"
        }
    ),
    // 尾
    footer: LKListCompositionalFooter(
        size: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        ),
        render: { (supplementary: CustomSupplementary, indexPath) in
            supplementary.label.text = "Footer"
        }
    ),
    // 列表项
    item: LKListCompositionalCell(
        // 每行/列在主轴方向的大小（这里纵向列表对应每行的高度）
        mainAxisSize: .estimated(70),
        // 元素在主轴方向的间距（这里纵向列表对应网格行间距）
        mainAxisSpacing: 10,
        // 元素在磁轴方向的大小（这里纵向列表对应网格列间距）
        crossAxisSpacing: .fixed(10),
        // 元素大小
        cellSize: .init(
            // 宽度为 0.2(列表五分之一)，代表每行有五列
            widthDimension: .fractionalWidth(0.2),
            // 高度和宽度一致（列表宽度的五分之一）
            heightDimension: .fractionalWidth(0.2)
        ),
        render: { (cell: CustomCell, indexPath, item) in
            cell.configure(item)
        }
    )
)
```

#### 瀑布流列表

```swift showLineNumbers
let listView = LKFlatListView<Item>.compositional(
    frame: view.frame,
    // 数据源
    dataSource: dataSource,
    // 主轴方向
    scrollDirection: .vertical,
    // 内边距
    inset: NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20),
    // 头
    header: LKListCompositionalHeader(
        size: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        ),
        render: { (supplementary: CustomSupplementary, indexPath) in
            supplementary.label.text = "Header"
        }
    ),
    // 尾
    footer: LKListCompositionalFooter(
        size: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        ),
        render: { (supplementary: CustomSupplementary, indexPath) in
            supplementary.label.text = "Footer"
        }
    ),
    // 列表项
    item: LKListCompositionalWaterfall<Item>(
        // 次轴方向的元素数量（这里是两列）
        crossAxisCount: 2,
        // 次轴方向的元素间距
        crossAxisSpacing: 15,
        // 主轴方向的元素间距
        mainAxisSpacing: 10,
        // 元素的宽高比例
        ratio: { $0.ratio },
        render: { (cell: CustomCell, indexPath, item) in
            cell.configure(item)
        }
    )
)
```

### 多类型元素

在一个资讯信息流列表中，列表项视图可能不是同一个类型的。它们有些可能是一个咨询视图，有些也可能是一个广告。为了提高元素视图的复用率，`ListKit` 支持动态构造和复用不同类型的视图。

```swift showLineNumbers
let listView = LKFlatListView<Item>.compositional(
    frame: view.frame,
    // 数据源
    dataSource: dataSource,
    // 主轴方向
    scrollDirection: .vertical,
    // 内边距
    inset: NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20),
    // 列表项
    item: LKListCompositionalBlock<Item>(
        resolve: { index, item in
            // 根据列表项数据返回视图标识
            return item.type === 0 ? "news" : "ad"
        },
        items: [
            // 视图标识和对应的视图配置项
            "news": LKListCompositionalBlock<Item>(
                // 主轴方向的大小，次轴方向会占满列表
                size: .estimated(100),
                // 主轴方向的间距
                spacing: 10,
                render: { (cell: CustomCell, indexPath, item) in
                    cell.configure(item)
                }
            )
        ]
    )
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
    // 内边距
    inset: NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20),
    // 列表项
    item: LKListCompositionalBlock<Item>(
        // 主轴方向的大小，次轴方向会占满列表
        size: .estimated(100),
        // 主轴方向的间距
        spacing: 10,
        render: { (cell: CustomCell, indexPath, item) in
            cell.configure(item)
        }
    ).onDidSelectItemAt { listView, indexPath, itemIdentifier in
        print(">> did select item at: \(itemIdentifier.title)")
    }.onWillDisplayItemAt { listView, view, indexPath, itemIdentifier in
        print(">> will display item at: \(itemIdentifier.title)")
    }.onDidDisplayItemAt { listView, view, indexPath, itemIdentifier in
        print(">> did display item at: \(itemIdentifier.title)")
    }
)
```

## 接口文档

- [LKFlatListView](https://listkit.pages.dev/documentation/listkit/lkflatlistview)
- [LKFlatListDataSource](https://listkit.pages.dev/documentation/listkit/lkflatlistdatasource)
- [LKListFlowItem](https://listkit.pages.dev/documentation/listkit/lklistflowitem)
- [LKListFlowHeader](https://listkit.pages.dev/documentation/listkit/lklistflowheader)
- [LKListFlowFooter](https://listkit.pages.dev/documentation/listkit/lklistflowfooter)
- [LKListCompositionalHeader](https://listkit.pages.dev/documentation/listkit/lklistcompositionalheader)
- [LKListCompositionalFooter](https://listkit.pages.dev/documentation/listkit/lklistcompositionalfooter)
- [LKListCompositionalBlock](https://listkit.pages.dev/documentation/listkit/lklistcompositionalblock)
- [LKListCompositionalCell](https://listkit.pages.dev/documentation/listkit/lklistcompositionalcell)
- [LKListCompositionalWaterfall](https://listkit.pages.dev/documentation/listkit/lklistcompositionalwaterfall)