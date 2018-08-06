//
//  ViewController+CollectionView.swift
//  FlickrImages
//
//  Created by Sagar Pahwa on 16/07/18.
//  Copyright © 2018 Sagar Pahwa. All rights reserved.
//

import Foundation
import UIKit

extension ViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        let num = self.numberOfCells.number()
        
        return (self.array.count/num) + (self.array.count%num > 0 ? 1: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "DetailViewController", sender: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! MovieImageCell
        
        let num = self.numberOfCells.number()
        
        let index = (indexPath.section * num) + indexPath.item
        
        let movie = array[index]
        
        cell.movieTitle.text = movie.title
        
        cell.movieImageView.sd_setImage(with: movie.imageUrl())
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let num = self.numberOfCells.number()
        
        let index = (indexPath.section * num) + indexPath.item
        
        guard index == self.array.count - num,
              self.pagingInfo.canPage()
            
        else { return }
        
        self.pagingInfo.currentPage += 1
        
        self.performSearch(mode: self.activeMode, page: self.pagingInfo.currentPage)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let num = self.numberOfCells.number()
        
        guard section <= (self.array.count/num) - 1
            
        else{ return self.array.count%num }
        
        return num
    }
}

extension ViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        guard !isLoading else { return .zero }
        
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, self.minimumLineSpacing, 0, self.minimumLineSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: footerViewReuseIdentifier, for: indexPath) as! CustomFooterView
            
            self.footerView = aFooterView
            
            self.footerView?.backgroundColor = UIColor.clear
            
            return aFooterView
        } else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
        guard elementKind == UICollectionElementKindSectionFooter else {return }
        
        self.footerView?.prepareInitialAnimation()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        
        guard elementKind == UICollectionElementKindSectionFooter
            
        else { return }
        
        self.footerView?.stopAnimate()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let width = collectionView.frame.width
        
        let availWidth = width
            -
            (CGFloat(2) * self.minimumLineSpacing)
            - ((CGFloat(self.numberOfCells.number()) - CGFloat(1)) * self.minimumInteritemSpacing)
        
        let edgeForSquareShapeCell = availWidth/CGFloat(self.numberOfCells.number())
        
        return CGSize(width: edgeForSquareShapeCell, height: edgeForSquareShapeCell)
    }
}
