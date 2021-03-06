




//
//  CustTV.swift
//  day-43-microblog
//
//  Created by apple on 15/12/14.
//  Copyright © 2015年 yf. All rights reserved.
//

import UIKit



@IBDesignable class CustTV: UITextView {
    
    
    
   private lazy var phlab:UILabel={
        let l=UILabel( color: UIColor.lightGray, font: self.font, align: NSTextAlignment.left, line: 0)
        return l
    }()
    @IBInspectable var placeholder:String?{
        didSet{
            phlab.text=placeholder
        }
    }
    override var text:String!{
        didSet{
            onChange()
        }
    }
    
    override var font:UIFont?{
        didSet{
            self.phlab.font=font
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.addSubview(phlab)
        phlab.translatesAutoresizingMaskIntoConstraints=false
        addConstraint( NSLayoutConstraint(item: phlab, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 6))
        addConstraint( NSLayoutConstraint(item: phlab, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 6))
        addConstraint( NSLayoutConstraint(item: phlab, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual, toItem: self, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: -16))
//        phlab.preferredMaxLayoutWidth=self.w-16
        
        
        iNotiCenter.addObserver(self, selector: #selector(CustTV.onChange), name: UITextView.textDidChangeNotification, object: self)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onChange(){

        phlab.isHidden=hasText
    }
    
    
       deinit{
        iNotiCenter.removeObserver(self)
    }

}


//
//extension  CustTV{
//    func insertEmo(emo:Emoticon){
//        if emo.isEmoji{
//            self.insertText(emo.path ?? "")
//        }else{
//           
//            let range=self.selectedRange
//            let matr = NSMutableAttributedString(attributedString: self.attributedText)
//            matr.replaceCharactersInRange(range, withAttributedString: EmoAttach.attStrWithEmo(emo))
//            matr.addAttribute(NSAttributedString.Key.fon, value: self.font!, range: NSMakeRange(0,matr.length))
//            self.attributedText=matr
//            self.selectedRange=NSMakeRange(range.location+1, 0)
//            self.onChange()
//            self.delegate?.textViewDidChange?(self)
//        }
//    }
//    
//    var emoTxt:String{
//        return CustTV.strFromAstr(attributedText)
//    }
//    
//
//    class func strFromAstr(astr:NSAttributedString)->String{
//        let str=NSMutableString(string: astr.string)
//        astr.enumerateAttribute("NSAttachment", inRange: NSMakeRange(0,astr.length), options: NSAttributedStringEnumerationOptions.Reverse) { (value, range, stop) -> Void in
//            if let value = value as? EmoAttach{
//                str.replaceCharactersInRange(range, withString: value.emo?.chs ?? "")
//            }
//        }
//        return str as String
//    }
//    
//
//}
//
//
//
//
//class EmoAttach: NSTextAttachment {
//    var emo:Emoticon?{
//        didSet{
//            image=emo?.emoImg
//        }
//    }
//    
//    
//    class func attStrWithEmo(emo:Emoticon?)->NSAttributedString{
//        let ata  = EmoAttach()
//        ata.emo=emo
//           //            ata.bounds=CGRectMake(0, -3.5, tv.font!.lineHeight, tv.font!.lineHeight)
//        return NSAttributedString(attachment: ata)
//    }
//    
//    override init(data contentData: NSData?, ofType uti: String?) {
//        super.init(data: contentData, ofType: uti)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    
//    
//    override func attachmentBoundsForTextContainer(textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
//        return CGRectMake(0, -3.5, lineFrag.size.height, lineFrag.size.height)
//    }
//    
//}
