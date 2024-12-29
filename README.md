# ListKit

[![Version](https://img.shields.io/cocoapods/v/ListKit.svg?style=flat)](https://cocoapods.org/pods/ListKit)
[![License](https://img.shields.io/cocoapods/l/ListKit.svg?style=flat)](https://cocoapods.org/pods/ListKit)
[![Platform](https://img.shields.io/cocoapods/p/ListKit.svg?style=flat)](https://cocoapods.org/pods/ListKit)

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

## 文档

- [API](https://listkit.pages.dev/documentation/listkit)
- [Guides](./docs/guides/zh/README.md)

## 快速上手

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

## 最佳实践

- [News Feeds](./Example/ListKit/Application/NewsHomeController.swift)：一个带分类页签切换的资讯信息流
- ...

## 计划（背景）

> 我本是一名前端开发，最近因业务需要在使用 Swift 和 UIKit 开发 iOS 应用，期间遇到现有项目中大量使用了协议或代理的方式来实现一些扩展逻辑，让我在开发初期增加了不少代码理解成本。虽然现在我已经渐渐适应这套开发方式，但我还是想尝试下参照前端的编程方式。尽量地优先使用闭包，并以数据驱动和声明式的方式来实现功能，试验看看是否能让代码变得更清晰些。

目前这个项目还在试验中，API 可能会有较为频繁的变动，如果要在生产中使用请谨慎考虑。

UICollectionView 通过代理扩展，可以非常灵活地满足各类场景需求。但是 UICollectionView API 实在过于底层，它繁琐的代理实现，让开发者要实现多个代理方法，导致代码冗长且分散。下面是个人在使用 UICollectionView 觉得不顺手的地方，这也是 ListKit 未来需要包装 UICollectionView 后要解决的问题。

1. UICollectionView cell 的视图构造和大小设置是分散在 UICollectionViewDataSource 和 UICollectionViewDelegateFlowLayout 这两个代理下的，而不是直接通过一个配置化的 Cell 让视图构造和样式配置聚合在一起维护。
2. UICollectionViewFlowLayout 既能在自身上设置固定的值，又可以在 UICollectionViewDelegateFlowLayout 代理上动态设置，而不是直接在 UICollectionViewFlowLayout 上配置一个闭包直接实现动态值，增加开发者代码理解和维护成本。
3. UICollectionViewDataSource 是一个非常底层的协议，需要用户自行实现一套数据管理方式。虽然现在有提供 UICollectionViewDiffableDataSource，但是由于需要负责 CellView 等视图的构造，无法将数据管理逻辑从视图中抽离出来，实现数据驱动的开发方式（把 UICollectionView 数据源管理作为 ViewModel 来维护）。
4. ...

目前，ListKit 对于刚接触的人来说熟悉成本并不会比 UICollectionView 低，其中主要的原因是为了实现声明式的开发方式，引入了许多配置类。但上手后，个人觉得代码可读性和可维护性会比 UICollectionView 好很多。

唠叨完背景后，说说接下来待完成的工作计划。

- [ ] 参照前端的组件库文档（[Ant Design](https://ant.design/components/table-cn) ）编写 ListKit 的使用说明文档

    ps：😭前端这块文档真的比 iOS 生态好太多了，之前还因为这个问题想基于 AI 生成 Cheatsheet 文档 —— https://cheatsheet-2i7.pages.dev/swift/

- [ ] 内置提供无限滚动列表的实现（开发者只需要提供好数据请求函数即可）
- [ ] 满足一些特殊场景的嵌套滚动功能，例如：多页签顶部还有可滚动内容的交互
- [ ] 实践一个能用并收集反馈意见，持续优化 API，以及修复相关 bug

## License

ListKit is available under the MIT license. See the LICENSE file for more info.
