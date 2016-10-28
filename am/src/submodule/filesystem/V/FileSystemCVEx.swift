//
//  FileSystemCVEx.swift
//  am
//
//  Created by apple on 16/10/25.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

extension FileSystemCV:UICollectionViewDataSource,UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.celliden, for: indexPath) as! FileCell
        FileUtil.icon(fileList[indexPath.row], dir: curDir, cell: cell)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if longPressed{
            longPressed=false
            return
        }
        collectionView.deselectItem(at: indexPath, animated: true)
       let path = curDir + "/" + fileList[indexPath.row]
        if iFm.isReadableFile(atPath:path){
            if FileUtil.isDir(path){
                curDir=path
            }else{
                
            }
        }else{
            iPop.toast("无读取权限")
        }
    }
    
    
    
    
}




