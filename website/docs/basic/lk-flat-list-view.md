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
## 代码示例

### 数据源管理

### 流式布局

#### 头/尾配置

#### 列表项配置

### 组合布局

#### 头/尾设置

#### “区块“列表项配置

#### “单元格“列表项配置

#### ”瀑布流“列表项配置

#### ”自定义“列表项配置


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