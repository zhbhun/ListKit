//
//  Untitled.swift
//  ListKit
//
//  Created by zhanghuabin on 2024/12/28.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import Combine
import ListKit

class NewsList: LKFlatListView<News> {
    private var vm: NewsListViewModel!
    private var stateView: NewsStateView = .init()
    private var cancellables = Set<AnyCancellable>()

    init(_ vm: NewsListViewModel) {
        self.vm = vm

        let itemWidth: CGFloat = UIScreen.main.bounds.size.width - 20
        let itemHeight: CGFloat = 100
        super.init(
            frame: .zero,
            dataSource: vm,
            inset: .fixed(
                top: 0,
                leading: 10,
                bottom: 10,
                trailing: 10
            ),
            mainAxisSpacing: .fixed(10),
            crossAxisSpacing: .fixed(10),
            footer: .init(
                size: .fixed(
                    width: UIScreen.main.bounds.size.width,
                    height: NewsListFooter.height
                ),
                render: { (footer: NewsListFooter, indexPath) in
                    // TODO: ...
                }
            ),
            item: .init(
                size: .fixed(width: itemWidth, height: itemHeight),
                render: { (item: NewsListItem, indexPath, news) in
                    item.configure(news: news)
                }
            )
        )

        let _ = onWillDisplaySupplementaryAt { listView, view, kind, indexPath, sectionIdentifier in
            if kind == UICollectionView.elementKindSectionFooter {
                Task {
                    // load more
                    await vm.load()
                }
            }
        }
        let _ = onDidSelectItemAt { listView, indexPath, itemIdentifier in
            // TODO: ...
        }
        
        build()
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateStateViewFrame()
    }

    func build() {
        // state view
        addSubview(stateView)
        updateStateViewFrame()
        vm.$status.receive(on: DispatchQueue.main)
            .sink { [weak self] newStatus in
                guard let self else { return }
                stateView.update(status: newStatus)
            }.store(in: &cancellables)
    }

    func updateStateViewFrame() {
        if stateView.frame.size != frame.size {
            stateView.frame = CGRect(
                x: 0,
                y: 0,
                width: frame.width,
                height: frame.height
            )
        }
    }

    deinit {
        cancellables.removeAll()
    }
}
