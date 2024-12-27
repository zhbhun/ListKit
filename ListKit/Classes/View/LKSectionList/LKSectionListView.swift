//
//  LKSectionListView.swift
//  ListKit
//
//  Created by zhbhun on 2024/11/14.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import Combine
import UIKit

@available(iOS 14.0, *)
public class LKSectionListView<SectionIdentifier, ItemIdentifier>: LKListBaseView<
    SectionIdentifier, ItemIdentifier
>
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable,
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    private var diffableDataSource: UICollectionViewDataSource!
    private var listDelegate:
        LKListViewDelegate<
            SectionIdentifier, ItemIdentifier
        >!
    private var cancellables = Set<AnyCancellable>()

    private init(
        frame: CGRect,
        dataSource: LKSectionListDataSource<SectionIdentifier, ItemIdentifier>,
        scrollDirection: LKListScrollDirection = LKListScrollDirection.vertical,
        resolve: @escaping (_ index: Int, _ section: SectionIdentifier) -> String,
        sections: [String: LKListFlowSection<SectionIdentifier, ItemIdentifier>]
    ) {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = scrollDirection
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)

        initDataSource(dataSource: dataSource, resolve: resolve, sections: sections)

        let delegate = LKSectionListViewFlowDelegate<SectionIdentifier, ItemIdentifier>(
            dataSource: dataSource,
            resolve: resolve,
            sections: sections
        )
        delegate.listView = self
        self.listDelegate = delegate
        self.delegate = delegate
    }

    private init(
        frame: CGRect,
        dataSource: LKSectionListDataSource<SectionIdentifier, ItemIdentifier>,
        scrollDirection: LKListScrollDirection = LKListScrollDirection.vertical,
        resolve: @escaping (_ index: Int, _ section: SectionIdentifier) -> String,
        sections: [String: LKListCompositionalSection<SectionIdentifier, ItemIdentifier>]
    ) {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = scrollDirection
        let collectionViewLayout = UICollectionViewCompositionalLayout(
            sectionProvider: {
                (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                guard let sectionIdentifier = dataSource.sectionIdentifier(for: sectionIndex),
                    let section = sections[resolve(sectionIndex, sectionIdentifier)]
                else {
                    return nil
                }
                let sectionInset = section.inset ?? .zero
                let (group, spacing) = section.item.layout(
                    scrollDirection: scrollDirection,
                    sectionInset: sectionInset,
                    itemIdentifiers: dataSource.snapshot().itemIdentifiers
                )
                let sectionLayout = NSCollectionLayoutSection(group: group)
                sectionLayout.contentInsets = sectionInset
                sectionLayout.interGroupSpacing = spacing
                var boundarySupplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
                if let header = section.header?.resolve() {
                    boundarySupplementaryItems.append(header)
                }
                if let footer = section.footer?.resolve() {
                    boundarySupplementaryItems.append(footer)
                }
                sectionLayout.boundarySupplementaryItems = boundarySupplementaryItems
                return sectionLayout
            },
            configuration: configuration
        )
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)

        initDataSource(dataSource: dataSource, resolve: resolve, sections: sections)

        let delegate = LKSectionListViewDelegate<SectionIdentifier, ItemIdentifier>(
            dataSource: dataSource
        )
        delegate.listView = self
        self.listDelegate = delegate
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initDataSource(
        dataSource: LKSectionListDataSource<SectionIdentifier, ItemIdentifier>,
        resolve: @escaping (_ index: Int, _ section: SectionIdentifier) -> String,
        sections: [String: LKListSection<SectionIdentifier, ItemIdentifier>]
    ) {
        let diffableDataSource = UICollectionViewDiffableDataSource<
            SectionIdentifier, ItemIdentifier
        >(
            collectionView: self
        ) {
            (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            guard
                let identify = dataSource.sectionIdentifier(for: indexPath.section),
                let section = sections[resolve(indexPath.section, identify)]
            else { return .init() }
            return section.renderItem(collectionView, indexPath, itemIdentifier)
        }
        if sections.values.contains(where: { $0.hasSupplementary() }) {
            diffableDataSource.supplementaryViewProvider = {
                (collectionView, kind, indexPath) in
                guard
                    let identify = dataSource.sectionIdentifier(for: indexPath.section),
                    let section = sections[resolve(indexPath.section, identify)]
                else { return .init() }
                return section.renderSupplementary(collectionView, kind, indexPath, identify)
                    ?? .init()
            }
        }
        dataSource.change.receive(on: DispatchQueue.main)
            .sink { [weak diffableDataSource] (snapshot, mode) in
                guard let diffableDataSource = diffableDataSource else { return }
                switch mode {
                case .normal:
                    diffableDataSource.apply(
                        snapshot.diffableDataSourceSnapshot, animatingDifferences: false)
                case .animate:
                    diffableDataSource.apply(
                        snapshot.diffableDataSourceSnapshot,
                        animatingDifferences: true
                    )
                case .reload:
                    if #available(iOS 15.0, *) {
                        diffableDataSource.applySnapshotUsingReloadData(
                            snapshot.diffableDataSourceSnapshot
                        )
                    } else {
                        diffableDataSource.apply(
                            snapshot.diffableDataSourceSnapshot,
                            animatingDifferences: false
                        )
                    }
                }
            }.store(in: &cancellables)

        if #available(iOS 15.0, *) {
            diffableDataSource.applySnapshotUsingReloadData(
                dataSource.snapshot().diffableDataSourceSnapshot
            )
        } else {
            diffableDataSource.apply(
                dataSource.snapshot().diffableDataSourceSnapshot,
                animatingDifferences: false
            )
        }
        self.dataSource = diffableDataSource
        self.diffableDataSource = diffableDataSource
    }

    public static func flow(
        frame: CGRect,
        dataSource: LKSectionListDataSource<SectionIdentifier, ItemIdentifier>,
        scrollDirection: LKListScrollDirection = LKListScrollDirection.vertical,
        resolve: @escaping (_ index: Int, _ section: SectionIdentifier) -> String,
        sections: [String: LKListFlowSection<SectionIdentifier, ItemIdentifier>]
    ) -> LKSectionListView<SectionIdentifier, ItemIdentifier> {
        return LKSectionListView<SectionIdentifier, ItemIdentifier>(
            frame: frame,
            dataSource: dataSource,
            scrollDirection: scrollDirection,
            resolve: resolve,
            sections: sections
        )
    }

    public static func compositional(
        frame: CGRect,
        dataSource: LKSectionListDataSource<SectionIdentifier, ItemIdentifier>,
        scrollDirection: LKListScrollDirection = LKListScrollDirection.vertical,
        resolve: @escaping (_ index: Int, _ section: SectionIdentifier) -> String,
        sections: [String: LKListCompositionalSection<SectionIdentifier, ItemIdentifier>]
    ) -> LKSectionListView<SectionIdentifier, ItemIdentifier> {
        return LKSectionListView<SectionIdentifier, ItemIdentifier>(
            frame: frame,
            dataSource: dataSource,
            scrollDirection: scrollDirection,
            resolve: resolve,
            sections: sections
        )
    }

    deinit {
        cancellables.removeAll()
    }
}
