//
//  NewsController.swift
//  ListKit
//
//  Created by zhanghuabin on 2024/12/28.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import Combine
import ListKit
import UIKit

/// 新闻首页
/// - 分类页签
/// - 素材列表
class NewsHomeController: UIViewController {
    private let vm: NewsCategoryViewModel = .init()

    private var tabBar: LKTabBar<NewsCategory>!
    private var tabView: LKTabView<NewsCategory>!
    private var stateView: NewsStateView = .init()

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        build()
        load()
    }

    deinit {
        cancellables.removeAll()
    }

    private func build() {
        view.backgroundColor = .white
        
        // tab bar
        tabBar = .init(
            dataSource: vm,
            size: .estimated(32),
            render: { (tab: NewsCategoryTab, index, item, selected) in
                tab.configure(item, selected: selected)
            }
        )
        view.addSubview(tabBar)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            tabBar.leadingAnchor.constraint(equalTo: tabBar.superview!.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: tabBar.superview!.trailingAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: 44),
        ])

        // tab view
        tabView = .init(
            dataSource: vm,
            reuseLimit: 3,
            create: { [weak self] index, category in
                guard
                    let self,
                    let materialVM = vm.materials[category.id]
                else {
                    return .init()
                }
                return NewsList(materialVM)
            }
        )
        view.addSubview(tabView)
        tabView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabView.topAnchor.constraint(equalTo: tabBar.bottomAnchor),
            tabView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        // state view
        view.addSubview(stateView)
        stateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stateView.topAnchor.constraint(equalTo: view.topAnchor),
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        vm.$status.receive(on: DispatchQueue.main)
            .sink { [weak self] newStatus in
                guard let self else { return }
                stateView.update(status: newStatus)
            }.store(in: &cancellables)

    }
    
    func load() {
        Task {
            await vm.load()
        }
    }
}
