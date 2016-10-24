//
//  CommonDialog.swift
//  am
//
//  Created by apple on 16/5/28.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CommonDialog: BaseDialog {
    static let celliden="celliden"
    var btns:[String]?
    var btnColor:[UIColor] = [iConst.TextBlue,iConst.TextRed]
    
    
    var cb:((_ pos:Int,_ dialog:CommonDialog)->Bool)?
    
    
    lazy var titleLab:UILabel={
        let title = UILabel(txt: "", color:iConst.orgTitCol , font: ibFont(19), align: NSTextAlignment.center, line: 1, bgColor: iConst.blueBg)
        
        return title
        
    }()
   
    //    lazy var stack:BGStackV={
    //        let stack = BGStackV(frame:CGRectMake(0, 0, 0, 0))
    //        stack.backgroundColor=iColor(0xffeeeeee)
    //
    //        return stack
    //    }()
    
    lazy var grid:UICollectionView={
        let lo = UICollectionViewFlowLayout()
        lo.minimumInteritemSpacing=1
        let grid = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: lo)
        grid.delegate = self
        grid.dataSource=self
        grid.register(TextCell.self, forCellWithReuseIdentifier: CommonDialog.celliden)
        grid.bounces=false
        grid.showsVerticalScrollIndicator=false
        grid.backgroundColor=UIColor.clear
        
        return grid
    }()
    
    lazy var midContent:UIView=UIView()
    
    required init(frame: CGRect) {
        super.init(frame:frame)
        contentView.addSubview(titleLab)
        contentView.addSubview(midContent)
        contentView.addSubview(grid)
        midContent.backgroundColor=iConst.khakiBg
        contentView.backgroundColor=iColor(0xffaaaaaa)

        titleLab.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.left.right.top.equalTo(0)
        }
        
        grid.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.left.right.bottom.equalTo(0)
        }
        
        midContent.snp.makeConstraints { (make) in
            make.top.equalTo(titleLab.snp.bottom).offset(1)
            make.bottom.equalTo(grid.snp.top).offset(-1)
            make.left.right.equalTo(0)
            make.width.equalTo(self).multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(110)
        }
        
        
        iNotiCenter.addObserver(grid, selector: #selector(grid.reloadData), name:NSNotification.Name.UIDeviceOrientationDidChange, object: nil)


    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit{
        iNotiCenter.removeObserver(grid)
    }

}





extension CommonDialog:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return btns?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonDialog.celliden, for: indexPath) as! TextCell
        cell.lab.text=btns![(indexPath as NSIndexPath).row]
        cell.lab.textColor=btnColor[(indexPath as NSIndexPath).row%btnColor.count]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if (cb?((indexPath as NSIndexPath).row,self)) == true{
            dismiss()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let hei = collectionView.h
        let wid = (collectionView.w - CGFloat(btns!.count-1))/CGFloat(btns!.count)
        return CGSize(width: wid, height: hei)
    }
}





class TextCell:UICollectionViewCell{
    
    
    lazy var lab:UILabel={
        let lab = UILabel( txt: "", color: iConst.TextBlue, font: ibFont(20), align: NSTextAlignment.center, line: 1)
        
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor=UIColor.white
        let selbg = UIView()
        selbg.backgroundColor=iColor(0xaaff8888)
        selectedBackgroundView=selbg
        contentView.addSubview(lab)
        lab.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
