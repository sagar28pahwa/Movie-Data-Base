//
//  ViewController+ScrollView.swift
//  FlickrImages
//
//  Created by Sagar Pahwa on 16/07/18.
//  Copyright © 2018 Sagar Pahwa. All rights reserved.
//

import Foundation
import UIKit

extension ViewController{
    //compute the scroll value and play witht the threshold to get desired effect
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        let threshold         = 100.0
//        
//        let contentOffset     = scrollView.contentOffset.y
//        
//        let contentHeight     = scrollView.contentSize.height
//        
//        let diffHeight        = contentHeight - contentOffset
//        
//        let frameHeight       = scrollView.bounds.size.height
//        
//        var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold)
//        
//        triggerThreshold      =  min(triggerThreshold, 0.0)
//        
//        let pullRatio         = min(fabs(triggerThreshold),1.0)
//        
//        self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
//        
//        if pullRatio >= 1 { self.footerView?.animateFinal() }
//    }
//    
//    //    //compute the offset and call the load method
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        
//        let contentOffset = scrollView.contentOffset.y
//        
//        let contentHeight = scrollView.contentSize.height
//        
//        let diffHeight    = contentHeight - contentOffset
//        
//        let frameHeight   = scrollView.bounds.size.height
//        
//        let pullHeight    = fabs(diffHeight - frameHeight)
//        
//        guard pullHeight == 0.0,
//            (self.footerView?.isAnimatingFinal)!
//            
//            else { return }
//        
//        self.isLoading = true
//        self.footerView?.startAnimate()
//        self.performSearch(mode: self.activeMode, page: self.currentPage)
//    }
}
