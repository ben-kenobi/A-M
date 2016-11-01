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
        cell.isSel = selectedList.contains(FileUtil.fullPath(fileList[indexPath.row], curDir))
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if longPressed{
            longPressed=false
            return
        }
        
       let path = FileUtil.fullPath(fileList[indexPath.row], curDir)
        
        if self.multiSel{
            collectionView.deselectItem(at: indexPath, animated: false)
            let cell = collectionView.cellForItem(at: indexPath) as! FileCell
            cell.isSel=selectFile(path)
            return
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
        if iFm.isReadableFile(atPath:path){
            if FileUtil.isDir(path){
                curDir=path
            }else{
                if mode == .selFile{
                    _=chooseFile4selFile(path)
                }else{
                    
                }
            }
        }else{
            iPop.toast("无读取权限")
        }
    }
    
    func chooseFile4selFile(_ file:String){
        let b = selectedList.contains(file)
        selectedList.removeAll()
        if !b{
            selectedList.append(file)
        }
        reloadData()
        cdCB?(self)
    }
    func getChoosedFile()->String{
        if mode == .selFile{
            if selectedList.count > 0{
                return selectedList[0]
            }
        }else if mode == .selDir{
            return curDir
        }
        return ""
    }
    
    func selectFile(_ file:String)->Bool{
        let idx = selectedList.index(of: file)
        if let idx = idx {
            selectedList.remove(at: idx)
            return false
        }else{
            selectedList.append(file)
            return true
        }
    }
    func selectAll(){
        self.multiSel=false
        self.multiSel=true
        for file in fileList{
            let path = FileUtil.fullPath(file, curDir)
            selectedList.append(path)
        }
    }
    
    
    
    
    
}




