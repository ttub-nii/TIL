//
//  CustomTabbar.swift
//  TodayHouse
//
//  Created by toby.with on 2021/07/29.
//

//import Foundation

import UIKit

protocol CustomTabbarDelegate: class {
    func changePage(to index: Int)
}

class CustomTabbar: UIView {
    public let tabTitleList = ["인기", "사진", "집들이", "노하우", "전문가집들이", "질문과답변"]
    weak var delegate: CustomTabbarDelegate?
    
    @IBOutlet weak var tabBarCollectionView: UICollectionView! {
        didSet {
            setConstraint()
            tabBarCollectionView.dataSource = self
            tabBarCollectionView.delegate = self
            tabBarCollectionView.register(UINib(nibName: TabCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: TabCell.reuseIdentifier)
            tabBarCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: [])
        }
    }
    
    var indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .main
        return view
    }()
    
    //MARK: Properties
    var indicatorViewLeadingConstraint:NSLayoutConstraint!
    var indicatorViewWidthConstraint: NSLayoutConstraint!
    
    //MARK: Setup Views
    func setConstraint() {
        self.addSubview(tabBarCollectionView)
        tabBarCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tabBarCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tabBarCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tabBarCollectionView.heightAnchor.constraint(equalToConstant: 55).isActive = true

        self.addSubview(indicatorView)
        indicatorViewWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: 20)
        indicatorViewWidthConstraint.isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        indicatorViewLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        indicatorViewLeadingConstraint.isActive = true
        indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        //        indicatorViewLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        //        NSLayoutConstraint.activate([
        //            indicatorView.widthAnchor.constraint(equalToConstant: self.frame.width / 6),
        //            indicatorView.heightAnchor.constraint(equalToConstant: 2),
        //            indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        //            indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        //        ])
    }
}

//MARK:- UICollectionViewDelegate, DataSource
extension CustomTabbar: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabCell.reuseIdentifier, for: indexPath) as! TabCell
        cell.titleLabel.text = tabTitleList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabTitleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.changePage(to: indexPath.row)
    }
}
