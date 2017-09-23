//
//  STCardsHeaderView.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-03.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

protocol STCardsHeaderViewType {
    var cardTitles: [String] {get set}
    
    var previousCardOffsetX: CGFloat {get}
    var currentCardOffsetX: CGFloat {get}
    var nextCardOffsetX: CGFloat {get}
    
    func animateCardOffsetX(_ x: CGFloat)
}

class STCardsHeaderView: UIView {
    
    @IBOutlet var collectionView: UICollectionView!
    
    // constants
    let cellWidth: CGFloat = UIScreen.main.bounds.width / 3.0 // custom set
    
    var cardTitles: [String] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var currentIdx: Int = 0
    
    // MARK: life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "STCardsHeaderView", bundle: bundle)
        let contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.addSubview(contentView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // add the missing contrainst between xib contentView to self
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        collectionView.setNeedsUpdateConstraints()

        // self.translatesAutoresizingMaskIntoConstraints = true
        
        // set up datasource
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "STCardHeaderCollectionViewCell", bundle: Bundle(for: type(of: self))),
                                forCellWithReuseIdentifier: "kCardHeaderCollectionCell")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds
    }
    
    // MARK: instance methods
    
    var cardOffsetX: CGFloat {
        get {
            return collectionView.contentOffset.x
        }
        set {
            var point = self.collectionView.contentOffset
            point.x = newValue
            self.collectionView.contentOffset = point
        }
    }
}

fileprivate let kAnimateDuration = 0.4

extension STCardsHeaderView: STCardsHeaderViewType {

    func animateCardOffsetX(_ x: CGFloat) {
        UIView.animate(withDuration: kAnimateDuration, delay: 0, options: .curveEaseOut, animations: {
            self.cardOffsetX = x
        }, completion: nil)
    }
    
    var previousCardOffsetX: CGFloat {
        guard currentIdx - 1 >= 0 else { return 0 }
        
        return CGFloat(currentIdx - 1) * cellWidth
    }
    
    var currentCardOffsetX: CGFloat {
        return CGFloat(currentIdx) * cellWidth
    }
    
    var nextCardOffsetX: CGFloat {
        guard currentIdx + 1 < cardTitles.count else { return self.currentCardOffsetX }
        
        return CGFloat(currentIdx + 1) * cellWidth
    }
}

extension STCardsHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        // have header wide just enough to put first cell in the middle of the screen's X
        var screenMidX = UIScreen.main.bounds.width / 2.0
        screenMidX -= self.cellWidth / 2.0
        return CGSize(width: screenMidX, height: self.bounds.size.height);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: cellWidth, height: self.bounds.size.height);
    }
}

extension STCardsHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "kCardHeaderCollectionCell", for: indexPath) as! STCardHeaderCollectionViewCell
        item.tag = indexPath.row
        item.headerTitleLabel.text = self.cardTitles[indexPath.row]
        return item
    }
}
