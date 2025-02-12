"use strict";(self.webpackChunkwebsite=self.webpackChunkwebsite||[]).push([[8018],{7175:(n,e,i)=>{i.r(e),i.d(e,{assets:()=>r,contentTitle:()=>a,default:()=>m,frontMatter:()=>l,metadata:()=>t,toc:()=>c});const t=JSON.parse('{"id":"basic/lk-section-list-view","title":"LKSectionListView","description":"A view that represents a flat list of items.","source":"@site/docs/basic/lk-section-list-view.md","sourceDirName":"basic","slug":"/basic/lk-section-list-view","permalink":"/ListKit/docs/basic/lk-section-list-view","draft":false,"unlisted":false,"editUrl":"https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/docs/basic/lk-section-list-view.md","tags":[],"version":"current","sidebarPosition":2,"frontMatter":{"id":"lk-section-list-view","title":"LKSectionListView","description":"A view that represents a flat list of items.","sidebar_label":"LKSectionListView","sidebar_position":2},"sidebar":"tutorialSidebar","previous":{"title":"LKFlatListView","permalink":"/ListKit/docs/basic/lk-flat-list-view"},"next":{"title":"LKTabView","permalink":"/ListKit/docs/basic/lk-tab-view"}}');var s=i(4848),o=i(8453);const l={id:"lk-section-list-view",title:"LKSectionListView",description:"A view that represents a flat list of items.",sidebar_label:"LKSectionListView",sidebar_position:2},a=void 0,r={},c=[{value:"\u4f55\u65f6\u4f7f\u7528",id:"\u4f55\u65f6\u4f7f\u7528",level:2},{value:"\u5982\u4f55\u4f7f\u7528",id:"\u5982\u4f55\u4f7f\u7528",level:2},{value:"\u4ee3\u7801\u793a\u4f8b",id:"\u4ee3\u7801\u793a\u4f8b",level:2},{value:"\u6570\u636e\u6e90\u7ba1\u7406",id:"\u6570\u636e\u6e90\u7ba1\u7406",level:3},{value:"\u6d41\u5f0f\u5e03\u5c40",id:"\u6d41\u5f0f\u5e03\u5c40",level:3},{value:"\u7ec4\u5408\u5e03\u5c40",id:"\u7ec4\u5408\u5e03\u5c40",level:3},{value:"\u4e8b\u4ef6\u5904\u7406",id:"\u4e8b\u4ef6\u5904\u7406",level:3},{value:"\u63a5\u53e3\u6587\u6863",id:"\u63a5\u53e3\u6587\u6863",level:2}];function d(n){const e={a:"a",code:"code",h2:"h2",h3:"h3",li:"li",ol:"ol",p:"p",pre:"pre",ul:"ul",...(0,o.R)(),...n.components};return(0,s.jsxs)(s.Fragment,{children:[(0,s.jsx)(e.p,{children:"LKSectionListView \u662f\u4e00\u4e2a\u9ad8\u6027\u80fd\u7684\u5206\u7ec4(section)\u5217\u8868\u7ec4\u4ef6\u3002"}),"\n",(0,s.jsx)(e.h2,{id:"\u4f55\u65f6\u4f7f\u7528",children:"\u4f55\u65f6\u4f7f\u7528"}),"\n",(0,s.jsxs)(e.ul,{children:["\n",(0,s.jsx)(e.li,{children:"\u5f53\u6709\u5927\u91cf\u7ed3\u6784\u5316\u7684\u6570\u636e\u9700\u8981\u5206\u7ec4\u5c55\u73b0\u65f6\uff1b"}),"\n",(0,s.jsx)(e.li,{children:"\u5f53\u9700\u8981\u5bf9\u6570\u636e\u8fdb\u884c\u9009\u62e9\u3001\u6392\u5e8f\u548c\u81ea\u5b9a\u4e49\u64cd\u4f5c\u7b49\u590d\u6742\u884c\u4e3a\u65f6\u3002"}),"\n"]}),"\n",(0,s.jsx)(e.h2,{id:"\u5982\u4f55\u4f7f\u7528",children:"\u5982\u4f55\u4f7f\u7528"}),"\n",(0,s.jsxs)(e.ol,{children:["\n",(0,s.jsx)(e.li,{children:"\u5b9a\u4e49\u6570\u636e\u6a21\u578b"}),"\n"]}),"\n",(0,s.jsx)(e.p,{children:"\u6570\u636e\u6a21\u578b\u5fc5\u987b\u5b9e\u73b0 Hashable \u534f\u8bae\u3002"}),"\n",(0,s.jsx)(e.pre,{children:(0,s.jsx)(e.code,{className:"language-swift",children:"class Section: Hashable {\n    let id: UUID\n    let title: String\n    let column: Int\n\n    init(\n        id: UUID,\n        title: String,\n        column: Int\n    ) {\n        self.id = id\n        self.title = title\n        self.column = column\n    }\n\n    func hash(into hasher: inout Hasher) {\n        hasher.combine(id)\n    }\n\n    static func == (lhs: Section, rhs: Section) -> Bool {\n        return lhs.id == rhs.id\n    }\n}\n\nclass Item: Hashable {\n    let id: UUID\n    let title: String\n    let color: UIColor\n    let height: CGFloat\n\n    init(id: UUID, title: String, height: CGFloat) {\n        self.id = id\n        self.title = title\n        self.color = UIColor(\n            red: CGFloat.random(in: 0...1),\n            green: CGFloat.random(in: 0...1),\n            blue: CGFloat.random(in: 0...1),\n            alpha: 1.0\n        )\n        self.height = height\n    }\n\n    func hash(into hasher: inout Hasher) {\n        hasher.combine(id)\n    }\n\n    static func == (lhs: Item, rhs: Item) -> Bool {\n        return lhs.id == rhs.id\n    }\n}\n"})}),"\n",(0,s.jsxs)(e.ol,{start:"2",children:["\n",(0,s.jsx)(e.li,{children:"\u521b\u5efa\u6570\u636e\u6e90"}),"\n"]}),"\n",(0,s.jsx)(e.pre,{children:(0,s.jsx)(e.code,{className:"language-swift",children:'let dataSource = LKSectionListDataSource<Section, Item>\nvar snapshot = dataSource.snapshot()\n(1...2).forEach { sectionColumn in\n    let section = Section(\n        id: UUID(),\n        title: "\\(sectionColumn)",\n        column: sectionColumn\n    )\n    snapshot.appendSections([section])\n    (1...30).forEach { item in\n        snapshot.appendItems(\n            [\n                Item(\n                    id: UUID(),\n                    title: "\\(sectionColumn)-\\(item)",\n                    height: CGFloat(Int.random(in: 50...300))\n                )\n            ],\n            section\n        )\n    }\n}\ndataSource.apply(snapshot, mode: .reload)\n'})}),"\n",(0,s.jsxs)(e.ol,{start:"3",children:["\n",(0,s.jsx)(e.li,{children:"\u521b\u5efa\u5217\u8868\u9879\u89c6\u56fe"}),"\n"]}),"\n",(0,s.jsx)(e.pre,{children:(0,s.jsx)(e.code,{className:"language-swift",children:"class ItemView: LKListItemView {\n  // ...\n    func configure(_ item: Item) {\n        label.text = item.title\n        contentView.backgroundColor = item.color\n    }\n}\n"})}),"\n",(0,s.jsxs)(e.ol,{start:"4",children:["\n",(0,s.jsx)(e.li,{children:"\u521b\u5efa\u5217\u8868\u89c6\u56fe"}),"\n"]}),"\n",(0,s.jsx)(e.pre,{children:(0,s.jsx)(e.code,{className:"language-swift",children:'let listView = LKSectionListView<Section, Item>.flow(\n    frame: view.frame,\n    dataSource: dataSource,\n    resolve: { index, section in\n        return "\\(section.column)"\n    },\n    sections:[\n        // \u4e00\u884c\u4e00\u5217\n        "1": .init(\n            inset: .fixed(horizontal: 20, vertical: 0),\n            mainAxisSpacing: .fixed(10),\n            item: .init(\n                size: .dynamic { (listView, indexPath, item: Item) in\n                    return CGSize(\n                        width: CGFloat(UIScreen.main.bounds.width / 1 - 40),\n                        height: item.height\n                    )\n                },\n                render: { (cell: CustomCell, indexPath, item) in\n                    cell.configure(item)\n                }\n            )\n        ),\n        // \u4e00\u884c\u4e24\u5217\n        "2": .init(\n            inset: .fixed(horizontal: 20, vertical: 0),\n            mainAxisSpacing: .fixed(10),\n            crossAxisSpacing: .fixed(10),\n            item: .init(\n                size: .dynamic { (listView, indexPath, item: Item) in\n                    return CGSize(\n                        width: CGFloat((UIScreen.main.bounds.width / 1 - 40 - 10) / 2),\n                        height: item.height\n                    )\n                },\n                render: { (cell: CustomCell, indexPath, item) in\n                    cell.configure(item)\n                }\n            )\n        )\n    ]\n)\n'})}),"\n",(0,s.jsx)(e.h2,{id:"\u4ee3\u7801\u793a\u4f8b",children:"\u4ee3\u7801\u793a\u4f8b"}),"\n",(0,s.jsx)(e.h3,{id:"\u6570\u636e\u6e90\u7ba1\u7406",children:"\u6570\u636e\u6e90\u7ba1\u7406"}),"\n",(0,s.jsx)(e.pre,{children:(0,s.jsx)(e.code,{className:"language-swift",metastring:"showLineNumbers",children:'// \u521d\u59cb\u5316\nlet dataSource = LKFlatListDataSource<Item>()\nvar snapshot = dataSource.snapshot()\n(1...2).forEach { sectionColumn in\n    let section = Section(\n        id: UUID(),\n        title: "\\(sectionColumn)",\n        column: sectionColumn\n    )\n    snapshot.appendSections([section])\n    (1...30).forEach { item in\n        snapshot.appendItems(\n            [\n                Item(\n                    id: UUID(),\n                    title: "\\(sectionColumn)-\\(item)",\n                    height: CGFloat(Int.random(in: 50...300))\n                )\n            ],\n            section\n        )\n    }\n}\ndataSource.apply(snapshot, mode: .reload)\n\n// \u65b0\u589e\nvar snapshot = dataSource.snapshot()\nlet newSection = Section(\n    id: UUID(),\n    title: "3",\n    column: 3\n)\nsnapshot.appendSections([newSection])\nsnapshot.appendItems(\n    (1...30).map {\n        Item(\n            id: UUID(),\n            title: "\\(3)-\\($0)",\n            height: CGFloat(Int.random(in: 50...300))\n        )\n    },\n    newSection\n)\ndataSource.apply(snapshot, mode: .normal)\n\n// \u4fee\u6539\nvar snapshot = dataSource.snapshot()\nif var firstItem = snapshot.itemIdentifiers.first {\n    firstItem.title += "."\n    snapshot.reloadItems([firstItem])\n}\ndataSource.apply(snapshot, mode: .normal)\n\n// \u5220\u9664\nvar snapshot = dataSource.snapshot()\nif let firstItem = snapshot.itemIdentifiers.first {\n    // \u5220\u9664\u7b2c\u4e00\u4e2a\u5217\u8868\u9879\n    snapshot.deleteItems([firstItem])\n}\nif let lastSection = snapshot.sectionIdentifiers.last {\n    // \u5220\u9664\u6700\u540e\u4e00\u4e2a\u5206\u7ec4\n    snapshot.deleteSections(lastSection)\n}\ndataSource.apply(snapshot, mode: .normal)\n\n// \u79fb\u52a8\nvar snapshot = dataSource.snapshot()\nif let firstItem = snapshot.itemIdentifiers.first,\n    let lastItem = snapshot.itemIdentifiers.last  {\n    snapshot.moveItem(firstItem, afterItem: lastItem)\n}\nif let firstSection = snapshot.sectionIdentifiers.first,\n    let lastSection = snapshot.sectionIdentifiers.last  {\n    snapshot.moveSection(firstSection, afterItem: lastSection)\n}\ndataSource.apply(snapshot, mode: .normal)\n'})}),"\n",(0,s.jsx)(e.h3,{id:"\u6d41\u5f0f\u5e03\u5c40",children:"\u6d41\u5f0f\u5e03\u5c40"}),"\n",(0,s.jsxs)(e.p,{children:["\u4f7f\u7528\u65b9\u5f0f\u7c7b\u4f3c ",(0,s.jsx)(e.code,{children:"LKFlatList"}),"\uff0c\u53ea\u662f\u591a\u4e86\u4e00\u4e2a\u5c42\u7ea7\uff0c\u901a\u8fc7 resolve \u6765\u51b3\u5b9a\u5206\u7ec4\u6807\u8bc6\uff0csections \u914d\u7f6e\u5bf9\u5e94\u5206\u7ec4\u7684\u663e\u793a\u9879\u3002"]}),"\n",(0,s.jsx)(e.pre,{children:(0,s.jsx)(e.code,{className:"language-swift",metastring:"showLineNumbers",children:'let listView = LKSectionListView<Section, Item>.flow(\n    frame: view.frame,\n    dataSource: dataSource,\n    resolve: { index, section in\n        return "\\(section.column)"\n    },\n    sections:[\n        // \u4e00\u884c\u4e00\u5217\n        "1": LKListFlowSection<Section, Item>(\n            // \u7ec4\u5185\u8fb9\u8ddd\n            inset: .fixed(horizontal: 20, vertical: 0),\n            // \u7ec4\u4e3b\u8f74\u65b9\u5411\u7684\u95f4\u8ddd\uff08\u884c\u95f4\u8ddd\uff09\n            mainAxisSpacing: .fixed(10),\n            // \u7ec4\u5934\n            header: LKListFlowSectionHeader<Section>(\n                size: .fixed(width: UIScreen.main.bounds.width, height: 50),\n                render: { (supplementary: CustomSupplementary, indexPath, section) in\n                    supplementary.label.text = "Header \\(section.title)"\n                }\n            ),\n            // \u7ec4\u5c3e\n            footer: LKListFlowSectionFooter<Section>(\n                size: .fixed(width: UIScreen.main.bounds.width, height: 50),\n                render: { (supplementary: CustomSupplementary, indexPath, section) in\n                    supplementary.label.text = "Footer \\(section.title)"\n                }\n            ),\n            // \u7ec4\u5143\u7d20\n            item: LKListFlowItem<Item>(\n                size: .dynamic { (listView, indexPath, item: Item) in\n                    return CGSize(\n                        width: CGFloat(UIScreen.main.bounds.width / 1 - 40),\n                        height: item.height\n                    )\n                },\n                render: { (cell: CustomCell, indexPath, item) in\n                    cell.configure(item)\n                }\n            )\n        ),\n        // \u4e00\u884c\u4e24\u5217\n        "2": LKListFlowSection<Section, Item>(\n            inset: .fixed(horizontal: 20, vertical: 0),\n            mainAxisSpacing: .fixed(10),\n            // \u7ec4\u6b21\u8f74\u65b9\u5411\u7684\u95f4\u8ddd\uff08\u5217\u95f4\u8ddd\uff09\n            crossAxisSpacing: .fixed(10),\n            item: LKListFlowItem<Item>(\n                size: .dynamic { (listView, indexPath, item: Item) in\n                    return CGSize(\n                        width: CGFloat((UIScreen.main.bounds.width / 1 - 40 - 10) / 2),\n                        height: item.height\n                    )\n                },\n                render: { (cell: CustomCell, indexPath, item) in\n                    cell.configure(item)\n                }\n            )\n        )\n    ]\n)\n'})}),"\n",(0,s.jsx)(e.h3,{id:"\u7ec4\u5408\u5e03\u5c40",children:"\u7ec4\u5408\u5e03\u5c40"}),"\n",(0,s.jsxs)(e.p,{children:["\u4f7f\u7528\u65b9\u5f0f\u7c7b\u4f3c ",(0,s.jsx)(e.code,{children:"LKFlatList"}),"\uff0c\u53ea\u662f\u591a\u4e86\u4e00\u4e2a\u5c42\u7ea7\uff0c\u901a\u8fc7 resolve \u6765\u51b3\u5b9a\u5206\u7ec4\u6807\u8bc6\uff0csections \u914d\u7f6e\u5bf9\u5e94\u5206\u7ec4\u7684\u663e\u793a\u9879\u3002"]}),"\n",(0,s.jsx)(e.pre,{children:(0,s.jsx)(e.code,{className:"language-swift",metastring:"showLineNumbers",children:'let listView = LKSectionListView<Section, Item>.compositional(\n    frame: view.frame,\n    dataSource: dataSource,\n    resolve: { index, section in\n        return "\\(section.column)"\n    },\n    sections: [\n        // \u5757\u5e03\u5c40\u7ec4\n        "1": LKListCompositionalSection<Section, Item>(\n            inset: NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20),\n            header: LKListCompositionalSectionHeader<Section>(\n                size: NSCollectionLayoutSize(\n                    widthDimension: .fractionalWidth(1),\n                    heightDimension: .absolute(50)\n                ),\n                render: { (supplementary: CustomSupplementary, indexPath, section) in\n                    supplementary.label.text = "Header \\(section.title)"\n                }\n            ),\n            footer: LKListCompositionalSectionFooter<Section>(\n                size: NSCollectionLayoutSize(\n                    widthDimension: .fractionalWidth(1),\n                    heightDimension: .absolute(50)\n                ),\n                render: { (supplementary: CustomSupplementary, indexPath, section) in\n                    supplementary.label.text = "Footer \\(section.title)"\n                }\n            ),\n            item: LKListCompositionalBlock<Item>(\n                size: .estimated(100),\n                spacing: 10,\n                render: { (cell: CompositionalBlock, indexPath, item) in\n                    cell.configure(item)\n                }\n            )\n        ),\n        // \u7f51\u683c\u5e03\u5c40\u7ec4\n        "2": LKListCompositionalSection<Section, Item>(\n            inset: NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20),\n            item: LKListCompositionalCell<Item>(\n                mainAxisSize: .estimated(150),\n                mainAxisSpacing: 10,\n                crossAxisSpacing: .fixed(10),\n                cellSize: NSCollectionLayoutSize(\n                    widthDimension: .fractionalWidth(0.5),\n                    heightDimension: .fractionalWidth(0.5)\n                ),\n                render: { (cell: CompositionalCell, indexPath, item) in\n                    cell.configure(item)\n                }\n            )\n        ),\n        // \u7011\u5e03\u6d41\u5e03\u5c40\u7ec4\n        "3": LKListCompositionalSection<Section, Item>(\n            inset: NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20),\n            item: LKListCompositionalWaterfall<Item>(\n                crossAxisCount: 3,\n                crossAxisSpacing: 10,\n                mainAxisSpacing: 10,\n                ratio: { $0.ratio },\n                render: { (cell: CompositionalWaterfall, indexPath, item) in\n                    cell.configure(item)\n                }\n            )\n        ),\n    ]\n)\n'})}),"\n",(0,s.jsx)(e.h3,{id:"\u4e8b\u4ef6\u5904\u7406",children:"\u4e8b\u4ef6\u5904\u7406"}),"\n",(0,s.jsxs)(e.p,{children:[(0,s.jsx)(e.code,{children:"ListKit"})," \u652f\u6301\u94fe\u5f0f\u5199\u6cd5\uff0c\u5728\u5b9e\u4f8b\u5316\u5217\u8868\u540e\u53ef\u4ee5\u76f4\u63a5\u8c03\u7528\u5bf9\u5e94\u7684\u4e8b\u4ef6\u76d1\u542c\u65b9\u6cd5\u3002"]}),"\n",(0,s.jsx)(e.pre,{children:(0,s.jsx)(e.code,{className:"language-swift",metastring:"showLineNumbers",children:'let listView = LKFlatListView<Item>.compositional(\n    frame: view.frame,\n    // \u6570\u636e\u6e90\n    dataSource: dataSource,\n    // \u4e3b\u8f74\u65b9\u5411\n    scrollDirection: .vertical,\n    // resolve: ...,\n    // sections: ...\n).onDidSelectItemAt { listView, indexPath, itemIdentifier in\n    print(">> did select item at: \\(itemIdentifier.title)")\n}.onWillDisplayItemAt { listView, view, indexPath, itemIdentifier in\n    print(">> will display item at: \\(itemIdentifier.title)")\n}.onDidDisplayItemAt { listView, view, indexPath, itemIdentifier in\n    print(">> did display item at: \\(itemIdentifier.title)")\n}\n'})}),"\n",(0,s.jsx)(e.h2,{id:"\u63a5\u53e3\u6587\u6863",children:"\u63a5\u53e3\u6587\u6863"}),"\n",(0,s.jsxs)(e.ul,{children:["\n",(0,s.jsx)(e.li,{children:(0,s.jsx)(e.a,{href:"https://listkit.pages.dev/documentation/listkit/lksectionlistview",children:"LKSectionListView"})}),"\n",(0,s.jsx)(e.li,{children:(0,s.jsx)(e.a,{href:"https://listkit.pages.dev/documentation/listkit/lksectionlistdatasource",children:"LKSectionListDataSource"})}),"\n",(0,s.jsx)(e.li,{children:(0,s.jsx)(e.a,{href:"https://listkit.pages.dev/documentation/listkit/lklistflowsection",children:"LKListFlowSection"})}),"\n",(0,s.jsx)(e.li,{children:(0,s.jsx)(e.a,{href:"https://listkit.pages.dev/documentation/listkit/lklistcompositionalsection",children:"LKListCompositionalSection"})}),"\n"]})]})}function m(n={}){const{wrapper:e}={...(0,o.R)(),...n.components};return e?(0,s.jsx)(e,{...n,children:(0,s.jsx)(d,{...n})}):d(n)}},8453:(n,e,i)=>{i.d(e,{R:()=>l,x:()=>a});var t=i(6540);const s={},o=t.createContext(s);function l(n){const e=t.useContext(o);return t.useMemo((function(){return"function"==typeof n?n(e):{...e,...n}}),[e,n])}function a(n){let e;return e=n.disableParentContext?"function"==typeof n.components?n.components(s):n.components||s:l(n.components),t.createElement(o.Provider,{value:e},n.children)}}}]);