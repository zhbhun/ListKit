---
id: lk-tab-view
title: LKTabView
sidebar_label: 'LKTabView'
sidebar_position: 3
---

LKTabView 是一个选项卡组件，它显示与当前选中的标签相对应的选项卡视图。

## 何时使用

提供平级的区域将大块内容进行收纳和展现，保持界面整洁。

## 如何使用

1. 定义数据模型

  ```swift
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
  ```

2. 创建数据源

  ```swift
  let tabDataSource: LKTabDataSource<Section> = LKTabDataSource<Section>(initialIndex: 0)
  var tabViewDataSources: [UUID: LKFlatListDataSource<Item>] = [:]
  var snapshot = tabDataSource.snapshot()
  (0...14).forEach { sectionIndex in
      let items = (1...30).map { itemIndex in
          Item(
              id: UUID(),
              title: "\(sectionIndex)-\(itemIndex)"
          )
    
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
  tabDataSource.apply(snapshot, mode: .reload)
  ```

3. 创建标签栏视图

  ```swift
  let tabBar = LKTabBar<Section>(
      dataSource: tabDataSource,
      // 每个标签的宽度，这里设置默认 30，并根据实际宽度自动缩放
      size: .estimated(30),
      render: { (cell: CustomTab, index, item, selected) in
          cell.configure(item, selected: selected)
      }
  )
  ```

4. 创建选项卡视图

  ```swift
  let tabView = LKTabView<Section>(
      dataSource: tabDataSource,
      // 最大可重用的选项卡视图数量（超出后会回收）
      reuseLimit: 3,
      create: { [weak self] index, section in
          guard let self,
              let dataSource = tabViewDataSources[section.id]
          else {
              return nil
          }
          // 每个选项卡内容都是一个简单列表
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
  ```

## 代码演示

### 数据源管理

```swift showLineNumbers
// 访问当前选中的选项
tabDataSource.activeIndex

// 修改当前选中的选项（带动画）
tabDataSource.activeIndex = 0

// 使用方法修改当前选中的选项
tabDataSource.slide(0, animation: false) // animation 用来控制动画

// 监听变化
dataSource.animationIndex
    .receive(on: DispatchQueue.main)
    .sink { [weak self] (newIndex, animated) in
        // ...
    }.store(in: &cancellables)
```

### 页签栏视图

`LKTabBar<Tab>` 是页签栏视图，通常放在选项卡上方

```swift
let tabBar = LKTabBar<Section>(
    dataSource: tabDataSource,
    // 页签项间距
    spacing: 10,
    // 页签项宽度
    size: .estimated(30),
    // 渲染
    render: { (cell: CustomTab, index, item, selected) in
        cell.configure(item, selected: selected)
    }
)
```

### 选项卡视图

`LKTabBar<Tab>` 是页签栏视图，通常放在选项卡上方

```swift
let tabView = LKTabView<Section>(
    dataSource: tabDataSource,
    // 最大可重用的选项卡视图数量（超出后会回收）
    reuseLimit: 3,
    // 选项卡内容视图创建，如果有缓存的话不调用
    create: { [weak self] index, section in
        guard let self,
            let dataSource = tabViewDataSources[section.id]
        else {
            return nil
        }
        // 在这里，每个选项卡内容都是一个简单列表
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
```

## 接口文档

- [LKTabDataSource](https://listkit.pages.dev/documentation/listkit/lktabdatasource)
- [LKTabBar](https://listkit.pages.dev/documentation/listkit/lktabbar)
- [LKTabView](https://listkit.pages.dev/documentation/listkit/lktabview)
