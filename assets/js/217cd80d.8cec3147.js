"use strict";(self.webpackChunkwebsite=self.webpackChunkwebsite||[]).push([[2186],{5739:(e,n,t)=>{t.r(n),t.d(n,{assets:()=>c,contentTitle:()=>r,default:()=>h,frontMatter:()=>l,metadata:()=>i,toc:()=>o});const i=JSON.parse('{"id":"basic/lk-tab-view","title":"LKTabView","description":"LKTabView \u662f\u4e00\u4e2a\u9009\u9879\u5361\u7ec4\u4ef6\uff0c\u5b83\u663e\u793a\u4e0e\u5f53\u524d\u9009\u4e2d\u7684\u6807\u7b7e\u76f8\u5bf9\u5e94\u7684\u9009\u9879\u5361\u89c6\u56fe\u3002","source":"@site/docs/basic/lk-tab-view.md","sourceDirName":"basic","slug":"/basic/lk-tab-view","permalink":"/ListKit/docs/basic/lk-tab-view","draft":false,"unlisted":false,"editUrl":"https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/docs/basic/lk-tab-view.md","tags":[],"version":"current","sidebarPosition":3,"frontMatter":{"id":"lk-tab-view","title":"LKTabView","sidebar_label":"LKTabView","sidebar_position":3},"sidebar":"tutorialSidebar","previous":{"title":"LKSectionListView","permalink":"/ListKit/docs/basic/lk-section-list-view"},"next":{"title":"\u8fdb\u9636","permalink":"/ListKit/docs/category/\u8fdb\u9636"}}');var a=t(4848),s=t(8453);const l={id:"lk-tab-view",title:"LKTabView",sidebar_label:"LKTabView",sidebar_position:3},r=void 0,c={},o=[{value:"\u4f55\u65f6\u4f7f\u7528",id:"\u4f55\u65f6\u4f7f\u7528",level:2},{value:"\u5982\u4f55\u4f7f\u7528",id:"\u5982\u4f55\u4f7f\u7528",level:2},{value:"\u4ee3\u7801\u6f14\u793a",id:"\u4ee3\u7801\u6f14\u793a",level:2},{value:"\u6570\u636e\u6e90\u7ba1\u7406",id:"\u6570\u636e\u6e90\u7ba1\u7406",level:3},{value:"\u9875\u7b7e\u680f\u89c6\u56fe",id:"\u9875\u7b7e\u680f\u89c6\u56fe",level:3},{value:"\u9009\u9879\u5361\u89c6\u56fe",id:"\u9009\u9879\u5361\u89c6\u56fe",level:3},{value:"\u63a5\u53e3\u6587\u6863",id:"\u63a5\u53e3\u6587\u6863",level:2}];function d(e){const n={a:"a",code:"code",h2:"h2",h3:"h3",li:"li",ol:"ol",p:"p",pre:"pre",ul:"ul",...(0,s.R)(),...e.components};return(0,a.jsxs)(a.Fragment,{children:[(0,a.jsx)(n.p,{children:"LKTabView \u662f\u4e00\u4e2a\u9009\u9879\u5361\u7ec4\u4ef6\uff0c\u5b83\u663e\u793a\u4e0e\u5f53\u524d\u9009\u4e2d\u7684\u6807\u7b7e\u76f8\u5bf9\u5e94\u7684\u9009\u9879\u5361\u89c6\u56fe\u3002"}),"\n",(0,a.jsx)(n.h2,{id:"\u4f55\u65f6\u4f7f\u7528",children:"\u4f55\u65f6\u4f7f\u7528"}),"\n",(0,a.jsx)(n.p,{children:"\u63d0\u4f9b\u5e73\u7ea7\u7684\u533a\u57df\u5c06\u5927\u5757\u5185\u5bb9\u8fdb\u884c\u6536\u7eb3\u548c\u5c55\u73b0\uff0c\u4fdd\u6301\u754c\u9762\u6574\u6d01\u3002"}),"\n",(0,a.jsx)(n.h2,{id:"\u5982\u4f55\u4f7f\u7528",children:"\u5982\u4f55\u4f7f\u7528"}),"\n",(0,a.jsxs)(n.ol,{children:["\n",(0,a.jsx)(n.li,{children:"\u5b9a\u4e49\u6570\u636e\u6a21\u578b"}),"\n"]}),"\n",(0,a.jsx)(n.pre,{children:(0,a.jsx)(n.code,{className:"language-swift",children:"class Section: Hashable {\n    let id: UUID\n    let title: String\n    let items: [Item]\n    init(\n        id: UUID,\n        title: String,\n        items: [Item]\n    ) {\n        self.id = id\n        self.title = title\n        self.items = items\n    }\n    func hash(into hasher: inout Hasher) {\n        hasher.combine(id)\n    }\n    static func == (lhs: Section, rhs: Section) -> Bool {\n        return lhs.id == rhs.id\n    }\n}\nclass Item: Hashable {\n    let id: UUID\n    let title: String\n    let color: UIColor\n    let height: CGFloat\n    init(id: UUID, title: String) {\n        self.id = id\n        self.title = title\n        self.color = UIColor(\n            red: CGFloat.random(in: 0...1),\n            green: CGFloat.random(in: 0...1),\n            blue: CGFloat.random(in: 0...1),\n            alpha: 1.0\n        )\n        self.height = CGFloat(Int.random(in: 50...300))\n    }\n    func hash(into hasher: inout Hasher) {\n        hasher.combine(id)\n    }\n    static func == (lhs: Item, rhs: Item) -> Bool {\n        return lhs.id == rhs.id\n    }\n}\n"})}),"\n",(0,a.jsxs)(n.ol,{start:"2",children:["\n",(0,a.jsx)(n.li,{children:"\u521b\u5efa\u6570\u636e\u6e90"}),"\n"]}),"\n",(0,a.jsx)(n.pre,{children:(0,a.jsx)(n.code,{className:"language-swift",children:'let tabDataSource: LKTabDataSource<Section> = LKTabDataSource<Section>(initialIndex: 0)\nvar tabViewDataSources: [UUID: LKFlatListDataSource<Item>] = [:]\nvar snapshot = tabDataSource.snapshot()\n(0...14).forEach { sectionIndex in\n    let items = (1...30).map { itemIndex in\n        Item(\n            id: UUID(),\n            title: "\\(sectionIndex)-\\(itemIndex)"\n        )\n  \n    let section = Section(\n        id: UUID(),\n        title: "\\(sectionIndex)-\\(Int.random(in: 0...10000))",\n        items: items\n    )\n    snapshot.appendItems([section])\n\n    let tabViewDataSource = LKFlatListDataSource<Item>()\n    var tabViewSnapshot = tabViewDataSource.snapshot()\n    tabViewSnapshot.appendItems(items)\n    tabViewDataSource.apply(tabViewSnapshot, mode: .reload)\n    tabViewDataSources[section.id] = tabViewDataSource\n}\ntabDataSource.apply(snapshot, mode: .reload)\n'})}),"\n",(0,a.jsxs)(n.ol,{start:"3",children:["\n",(0,a.jsx)(n.li,{children:"\u521b\u5efa\u6807\u7b7e\u680f\u89c6\u56fe"}),"\n"]}),"\n",(0,a.jsx)(n.pre,{children:(0,a.jsx)(n.code,{className:"language-swift",children:"let tabBar = LKTabBar<Section>(\n    dataSource: tabDataSource,\n    // \u6bcf\u4e2a\u6807\u7b7e\u7684\u5bbd\u5ea6\uff0c\u8fd9\u91cc\u8bbe\u7f6e\u9ed8\u8ba4 30\uff0c\u5e76\u6839\u636e\u5b9e\u9645\u5bbd\u5ea6\u81ea\u52a8\u7f29\u653e\n    size: .estimated(30),\n    render: { (cell: CustomTab, index, item, selected) in\n        cell.configure(item, selected: selected)\n    }\n)\n"})}),"\n",(0,a.jsxs)(n.ol,{start:"4",children:["\n",(0,a.jsx)(n.li,{children:"\u521b\u5efa\u9009\u9879\u5361\u89c6\u56fe"}),"\n"]}),"\n",(0,a.jsx)(n.pre,{children:(0,a.jsx)(n.code,{className:"language-swift",children:"let tabView = LKTabView<Section>(\n    dataSource: tabDataSource,\n    // \u6700\u5927\u53ef\u91cd\u7528\u7684\u9009\u9879\u5361\u89c6\u56fe\u6570\u91cf\uff08\u8d85\u51fa\u540e\u4f1a\u56de\u6536\uff09\n    reuseLimit: 3,\n    create: { [weak self] index, section in\n        guard let self,\n            let dataSource = tabViewDataSources[section.id]\n        else {\n            return nil\n        }\n        // \u6bcf\u4e2a\u9009\u9879\u5361\u5185\u5bb9\u90fd\u662f\u4e00\u4e2a\u7b80\u5355\u5217\u8868\n        return LKFlatListView<Item>.flow(\n            frame: .zero,\n            dataSource: dataSource,\n            inset: .fixed(top: 12, leading: 16, bottom: 12, trailing: 16),\n            item: LKListFlowItem<Item>(\n                size: .dynamic({ (listView, indexPath, item: Item) in\n                    return CGSize(\n                        width: Double(UIScreen.main.bounds.width) / 1 - 32,\n                        height: item.height\n                    )\n                }),\n                render: { (cell: CustomCell, indexPath, item) in\n                    cell.configure(item)\n                }\n            )\n        )\n    }\n)\n"})}),"\n",(0,a.jsx)(n.h2,{id:"\u4ee3\u7801\u6f14\u793a",children:"\u4ee3\u7801\u6f14\u793a"}),"\n",(0,a.jsx)(n.h3,{id:"\u6570\u636e\u6e90\u7ba1\u7406",children:"\u6570\u636e\u6e90\u7ba1\u7406"}),"\n",(0,a.jsx)(n.pre,{children:(0,a.jsx)(n.code,{className:"language-swift",metastring:"showLineNumbers",children:"// \u8bbf\u95ee\u5f53\u524d\u9009\u4e2d\u7684\u9009\u9879\ntabDataSource.activeIndex\n\n// \u4fee\u6539\u5f53\u524d\u9009\u4e2d\u7684\u9009\u9879\uff08\u5e26\u52a8\u753b\uff09\ntabDataSource.activeIndex = 0\n\n// \u4f7f\u7528\u65b9\u6cd5\u4fee\u6539\u5f53\u524d\u9009\u4e2d\u7684\u9009\u9879\ntabDataSource.slide(0, animation: false) // animation \u7528\u6765\u63a7\u5236\u52a8\u753b\n\n// \u76d1\u542c\u53d8\u5316\ndataSource.animationIndex\n    .receive(on: DispatchQueue.main)\n    .sink { [weak self] (newIndex, animated) in\n        // ...\n    }.store(in: &cancellables)\n"})}),"\n",(0,a.jsx)(n.h3,{id:"\u9875\u7b7e\u680f\u89c6\u56fe",children:"\u9875\u7b7e\u680f\u89c6\u56fe"}),"\n",(0,a.jsxs)(n.p,{children:[(0,a.jsx)(n.code,{children:"LKTabBar<Tab>"})," \u662f\u9875\u7b7e\u680f\u89c6\u56fe\uff0c\u901a\u5e38\u653e\u5728\u9009\u9879\u5361\u4e0a\u65b9"]}),"\n",(0,a.jsx)(n.pre,{children:(0,a.jsx)(n.code,{className:"language-swift",children:"let tabBar = LKTabBar<Section>(\n    dataSource: tabDataSource,\n    // \u9875\u7b7e\u9879\u95f4\u8ddd\n    spacing: 10,\n    // \u9875\u7b7e\u9879\u5bbd\u5ea6\n    size: .estimated(30),\n    // \u6e32\u67d3\n    render: { (cell: CustomTab, index, item, selected) in\n        cell.configure(item, selected: selected)\n    }\n)\n"})}),"\n",(0,a.jsx)(n.h3,{id:"\u9009\u9879\u5361\u89c6\u56fe",children:"\u9009\u9879\u5361\u89c6\u56fe"}),"\n",(0,a.jsxs)(n.p,{children:[(0,a.jsx)(n.code,{children:"LKTabBar<Tab>"})," \u662f\u9875\u7b7e\u680f\u89c6\u56fe\uff0c\u901a\u5e38\u653e\u5728\u9009\u9879\u5361\u4e0a\u65b9"]}),"\n",(0,a.jsx)(n.pre,{children:(0,a.jsx)(n.code,{className:"language-swift",children:"let tabView = LKTabView<Section>(\n    dataSource: tabDataSource,\n    // \u6700\u5927\u53ef\u91cd\u7528\u7684\u9009\u9879\u5361\u89c6\u56fe\u6570\u91cf\uff08\u8d85\u51fa\u540e\u4f1a\u56de\u6536\uff09\n    reuseLimit: 3,\n    // \u9009\u9879\u5361\u5185\u5bb9\u89c6\u56fe\u521b\u5efa\uff0c\u5982\u679c\u6709\u7f13\u5b58\u7684\u8bdd\u4e0d\u8c03\u7528\n    create: { [weak self] index, section in\n        guard let self,\n            let dataSource = tabViewDataSources[section.id]\n        else {\n            return nil\n        }\n        // \u5728\u8fd9\u91cc\uff0c\u6bcf\u4e2a\u9009\u9879\u5361\u5185\u5bb9\u90fd\u662f\u4e00\u4e2a\u7b80\u5355\u5217\u8868\n        return LKFlatListView<Item>.flow(\n            frame: .zero,\n            dataSource: dataSource,\n            inset: .fixed(top: 12, leading: 16, bottom: 12, trailing: 16),\n            item: LKListFlowItem<Item>(\n                size: .dynamic({ (listView, indexPath, item: Item) in\n                    return CGSize(\n                        width: Double(UIScreen.main.bounds.width) / 1 - 32,\n                        height: item.height\n                    )\n                }),\n                render: { (cell: CustomCell, indexPath, item) in\n                    cell.configure(item)\n                }\n            )\n        )\n    }\n)\n"})}),"\n",(0,a.jsx)(n.h2,{id:"\u63a5\u53e3\u6587\u6863",children:"\u63a5\u53e3\u6587\u6863"}),"\n",(0,a.jsxs)(n.ul,{children:["\n",(0,a.jsx)(n.li,{children:(0,a.jsx)(n.a,{href:"https://listkit.pages.dev/documentation/listkit/lktabdatasource",children:"LKTabDataSource"})}),"\n",(0,a.jsx)(n.li,{children:(0,a.jsx)(n.a,{href:"https://listkit.pages.dev/documentation/listkit/lktabbar",children:"LKTabBar"})}),"\n",(0,a.jsx)(n.li,{children:(0,a.jsx)(n.a,{href:"https://listkit.pages.dev/documentation/listkit/lktabview",children:"LKTabView"})}),"\n"]})]})}function h(e={}){const{wrapper:n}={...(0,s.R)(),...e.components};return n?(0,a.jsx)(n,{...e,children:(0,a.jsx)(d,{...e})}):d(e)}},8453:(e,n,t)=>{t.d(n,{R:()=>l,x:()=>r});var i=t(6540);const a={},s=i.createContext(a);function l(e){const n=i.useContext(s);return i.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function r(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(a):e.components||a:l(e.components),i.createElement(s.Provider,{value:n},e.children)}}}]);