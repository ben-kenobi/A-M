//
//  HomeVC.swift
//  am
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
let updateHomeVCNoti="updateHomeVCNoti"
let iStrings:[String:String] = iRes4Dic("strings.plist") as! [String:String]
let iStrary:[String:[String]] = iRes4Dic("stringary.plist") as! [String:[String]]

class HomeVC: BaseVC {
    public static var instance:HomeVC?
    let bgs=["home","home2","access"]
    let map = ["at":iConst.ACCOUNT,"filesystem":iConst.FILESYSTEM,"contacts":iConst.CONTACTS]
    
    
    
    let celliden="menutvcelliden"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(cv)
        menuInfo = iRes4Ary("menuConf.plist")         
        iNotiCenter.addObserver(self, selector: #selector(self.showVC(_:)), name: NSNotification.Name(rawValue: updateHomeVCNoti), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layer.contents=iimg(bgs[irand(UInt32(bgs.count))])?.cgImage
        HomeVC.instance=self
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        HomeVC.instance=nil
    }
    
    
    
    
    var menuInfo:[Any]?
    
    
    
    
    lazy var cv:UICollectionView = {
        let v = self.view
        var w = min(iScrW, iScrH)
        var fl:UICollectionViewFlowLayout=UICollectionViewFlowLayout()
        fl.itemSize=CGSize(width: w/3, height: w/3)
        fl.minimumInteritemSpacing=w/9
        fl.minimumLineSpacing=w/9
        let cv=UICollectionView(frame:CGRect(x: w/9, y: 150, width: w/9*7,height: w/9*7 ),collectionViewLayout: fl)
        cv.delegate=self
        cv.dataSource=self
        
        cv.register(MenuCell.self, forCellWithReuseIdentifier:self.celliden)
        
        cv.showsVerticalScrollIndicator=false
        cv.bounces=false
        cv.backgroundColor=UIColor.clear
        return cv
    }()
    
    
    
    deinit{
        iNotiCenter.removeObserver(self)
    }
    override var shouldAutorotate : Bool {
        return false
    }
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
}




extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func forwardTo(_ name:String?,pass:Bool=false){
        if CommonService.isAccessKeyEnable(name ?? "") && !pass{
            let vc:LoginVC=LoginVC()
            vc.name=name
            present(vc, animated: true, completion: nil)
        }else{
            if !pass{
                CommonUtils.setAccessKey(nil)
            }
            let vc = CommonService.getIntentByAccessName(name ?? "")
            present(vc, animated: true, completion: nil)

        }
        
    }
    func checkForward(){
        if let _ = AccountVC.SEARCH_ID {
            forwardTo(map["at"])
        }
    }
    
    func getByIdx(_ indexPath:IndexPath)->[String:Any]?{
        return ((menuInfo?[(indexPath as NSIndexPath).section] as! [String:Any])["items"] as? [Any])?[indexPath.row] as? [String:Any]
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let str = getByIdx(indexPath)?["icon"] as? String{
            if str=="logoff"{
                exit(0)
            }else{
                forwardTo(map[str])
            }
        }else{
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return ((menuInfo?[section] as![String:Any])["items"] as? [Any])?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell:MenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: celliden, for: indexPath) as! MenuCell
        //        cell.backgroundColor=UIColor.clearColor()
        if let mod = getByIdx(indexPath){
            cell.mod=mod as? [String : String]
        }

        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return menuInfo?.count ?? 0
        
    }
    
    
    
    
    
    
}


extension HomeVC{
    
    
    @objc func showVC(_ noti:Notification){
        
        guard let win = iAppDele.window else{
            return
        }
        let img=UIImage.imgFromLayer(win.layer)
        
        
        dismiss(animated: false, completion: nil)
        forwardTo((noti.object as? String) ?? "",pass:true)

        
        let iv:UIImageView=UIImageView(image: img)
        win.addSubview(iv)
        UIView.animate(withDuration: 1, animations: { () -> Void in
            iv.alpha=0.1
            iv.transform=CGAffineTransform(scaleX: 2, y: 2)
            }, completion: { (b) -> Void in
                iv.removeFromSuperview()
        })
        
        
    }
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}




class Aoo:UIView{
    required override init(frame:CGRect){
        super.init(frame:frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func initwith()->Self{
        return self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    func aoo()->Self{
        boo()
        return self
    }
    func boo(){
        print("aoo->boo")
    }
}

class Boo:Aoo{
    required init(frame:CGRect){
        super.init(frame:frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func boo(){
        print("boo->boo")
    }
}

