---
sidebar_position: 1
---

ListKit 是一个轻量级、高度灵活的列表组件封装库，基于 UICollectionView 提供数据驱动、声明式的 API，轻松实现多种布局和动态交互。

## 特性

- 数据驱动：通过快照（snapshot）轻松实现数据的动态更新和动画刷新。
- 声明式 API：提供直观、简洁的声明式接口，支持更快速地创建复杂列表布局。
- 提供了多种列表，满足不同使用场景的需求

  - LKFlatListView：简单列表组件，
  - LKSectionListView：分组列表组件
  - LKTabBar：选项卡页签栏组件
  - LKTabView：选项卡视图组件，允许通过滑动或切换选项卡来显示不同的内容视图。

- 提供了多种布局模式：

  - Flow：对应 UICollectionViewLayout
  - Compositional：对应 UICollectionViewCompositionalLayout
  - Waterfall：自定义的瀑布流布局

## 要求

iOS 13.*

## 安装

ListKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ListKit'
```

## 使用
1. 定义数据模型

  ```swift
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