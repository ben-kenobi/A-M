//
//  AutoHeightTV.swift
//  am
//
//  Created by apple on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit


class AutoHeightTV: UITableView {
    var autoWid:Bool = true
    var wid:CGFloat = 1{
        didSet{
            updateSize()
        }
    }
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old, context: nil)
//        iNotiCenter.addObserver(self, selector: #selector(self.updateHight), name:UIScreenModeDidChangeNotification, object: nil)
    iNotiCenter.addObserver(self, selector: #selector(self.updateSize), name:NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath=="contentSize"{
            updateSize()

        }
    }
    func updateSize(){
        snp_updateConstraints(closure: { (make) in
            let verinset=contentInset.bottom+contentInset.top
            let height = min(contentSize.height+verinset , iScrH*0.9)
            make.height.equalTo(height)
            if autoWid{
                let width = wid>1 ? wid:iScrW*wid
                make.width.equalTo(width)
            }
        })
    }
    
    
    deinit{
        removeObserver(self, forKeyPath: "contentSize")
        iNotiCenter.removeObserver(self)
    }
}
