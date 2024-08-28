//
//  LAWishWellView.swift
//  SwiftDemo1
//
//  Created by xdf on 2024/8/27.
//

import UIKit
import SnapKit

let maxCount = 10

class LAWishWellView: UIView {

    var gcdTimer: DispatchSource?
    
    private var personas = [LAPersonaModel]()
    
    func configData(personas: [LAPersonaModel]) {

        var results = personas
        if (personas.count < maxCount) {
            let needCount = ((maxCount - personas.count)/personas.count + 1)
            for _ in 0..<needCount {
                results.append(contentsOf: personas)
            }
        }
        self.personas = results
        self.collectionView.reloadData()
        self.startTimer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configUI()
    }
    
    private func configUI() {
        addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func startTimer() {
        self.gcdTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.main) as? DispatchSource
        self.gcdTimer?.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.milliseconds(16))
        self.gcdTimer?.setEventHandler(handler: { [weak self] in
            self?.autoScroll()
        })
        self.gcdTimer?.resume()
    }
    
    private func stopTimer() {
        self.gcdTimer?.cancel()
        self.gcdTimer = nil
    }
    
    private func autoScroll() {
        let originOffSet = self.collectionView.contentOffset
        var offSetX: CGFloat = originOffSet.x + 0.5
        if (offSetX > self.collectionView.contentSize.width - 380) {
            offSetX = 0
            // 将内容偏移设置为 (0, 0)
            collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = .fade
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            transition.isRemovedOnCompletion = true
            collectionView.layer.add(transition, forKey: nil)
        } else {
            let offset = CGPoint(x: offSetX, y: originOffSet.y)
            self.collectionView.setContentOffset(offset, animated: false)
            print("当前x----\(offset.x)")
        }
        
        
    }
    
    lazy var layout: KooTfWaterFlowLayout = {
        let lay = KooTfWaterFlowLayout()
        lay.flowLayoutStyle = KooTfWaterFlowLayoutStyle(1)
        lay.delegate = self
        return lay
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.register(UINib(nibName: "LAWishWellCell", bundle: nil), forCellWithReuseIdentifier: "LAWishWellCell")
        return view
    }()
    
    deinit {
        self.stopTimer()
    }
}

extension LAWishWellView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        personas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LAWishWellCell", for: indexPath) as! LAWishWellCell
        cell.title = "++\(indexPath.row)++"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第几个\(indexPath.row)")
    }
}

extension LAWishWellView: KooTfWaterFlowLayoutDelegate {
    func waterFlowLayout(_ waterFlowLayout: KooTfWaterFlowLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = CGFloat(arc4random()%30) + 160.0
        return CGSize(width: width, height: 90)
    }
    
    func waterFlowLayout(_ waterFlowLayout: KooTfWaterFlowLayout, sizeForHeaderViewInSection section: Int) -> CGSize {
        .zero
    }
    
    func waterFlowLayout(_ waterFlowLayout: KooTfWaterFlowLayout, sizeForFooterViewInSection section: Int) -> CGSize {
        .zero
    }
    func rowCount(in waterFlowLayout: KooTfWaterFlowLayout) -> CGFloat {
        4
    }
}
