//
//  LCCardFlowLayout.swift
//  Loan
//
//  Created by lau Andy on 2017/11/8.
//  Copyright © 2017年 lau Andy. All rights reserved.
//

import UIKit

class LCCardFlowLayout: UICollectionViewFlowLayout {
    
    let ActiveDistance : CGFloat = 450 //垂直缩放除以系数
    let ScaleFactor : CGFloat = 0.35     //缩放系数  越大缩放越大
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        //滑动放大缩小  需要实时刷新layout
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //rect范围内的cell视图
        let array = super.layoutAttributesForElements(in: rect)
        var visibleRect = CGRect()
        visibleRect.origin = self.collectionView!.contentOffset
        visibleRect.size = self.collectionView!.bounds.size
        
        for attributes in array!{
            
            let distance = visibleRect.midX - attributes.center.x
            let normalizedDistance = distance/ActiveDistance
            let zoom = 1 - ScaleFactor*(abs(normalizedDistance))
            attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0)   //SX：X轴缩放   SY：Y轴缩放
            attributes.zIndex = 1
            //            let alpha = 1 - abs(normalizedDistance)
            //            attributes.alpha = alpha
            
        }
        return array
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = CGFloat(MAXFLOAT)   //当前处理器能处理的最大浮点数
        let horizontalCenter = proposedContentOffset.x + (self.collectionView!.bounds.width / 2.0)//collectionView落在屏幕中点的x坐标
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0.0, width:  self.collectionView!.bounds.size.width, height: self.collectionView!.bounds.size.height)
        let array = super.layoutAttributesForElements(in: targetRect) as [UICollectionViewLayoutAttributes]! //目标区域中包含的cell
        for layoutAttributes in array!{
            let itemHorizontalCenter = layoutAttributes.center.x
            if(abs(itemHorizontalCenter-horizontalCenter) < abs(offsetAdjustment)){   //ABS求绝对值
                offsetAdjustment = itemHorizontalCenter-horizontalCenter     //比较谁离中心点更近
            }
        }
        
        printLog("最终停留的位置 ----- \(CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y))")
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)  //返回collectionView最终停留的位置
    }
    
}
