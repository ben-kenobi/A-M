//
//  ScrolLab.swift
//  am
//
//  Created by apple on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ScrolLab: UIView {
    fileprivate var pause:Bool = false
    
    // if content wider than frame
   fileprivate  var shouldScroll:Bool=false
    // if scroll
    var scroll: Bool = true
    var repeatCount:Int = -1

    // if can scroll
    fileprivate var able:Bool{
        get{
            return shouldScroll && scroll && repeatCount != 0
        }
    }
    var speed:CGFloat=0.4
    var font:UIFont = iFont(18)
    var textColor:UIColor = iColor(30,30,30)
    var text:String=""{
        didSet{
            reset()
        }
    }
    fileprivate var textsize:CGSize = CGSize(width: 0, height: 0)
    var lastPosition:CGFloat = 0{
        didSet{
            if lastPosition == 0 {
                dislin.isPaused=true
                pause = true
                dispatchDelay(2.5,cb: {
                    self.dislin.isPaused = !self.able
                    self.pause = false
                })
            }
 
        }
    }
    fileprivate lazy var dislin:CADisplayLink=iDisLin(self,sel:#selector(self.dislinRedraw))
    
 
    
    @objc fileprivate func dislinRedraw(){
        if self.window==nil  {
            dislin.invalidate()
            return
        }
        setNeedsDisplay()
        
    }
    @objc func reset(){
        lastPosition=0
        textsize = text.sizeWithFont(font)
        setNeedsDisplay()
    }
    override func draw(_ rect: CGRect) {
        
//        let con = UIGraphicsGetCurrentContext()
        
      

        shouldScroll =  rect.width < textsize.width
        
        if lastPosition+textsize.width < (rect.width * 0.5){
            lastPosition = 0
            repeatCount -= 1
        }
        self.dislin.isPaused = !able || pause

        
        (text as NSString).draw(at: CGPoint(x: lastPosition, y: (rect.height-textsize.height)*0.5), withAttributes:[NSAttributedString.Key.foregroundColor:textColor,
                                                                                                                    NSAttributedString.Key.font:font])
        
        
        lastPosition -= speed
        
    }
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor=UIColor.white
        lastPosition=0
        iNotiCenter.addObserver(self, selector: #selector(self.reset), name: UIDevice.orientationDidChangeNotification, object: nil)

    }
 
    deinit{
//        print("deinit--------------------")
        iNotiCenter.removeObserver(self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
