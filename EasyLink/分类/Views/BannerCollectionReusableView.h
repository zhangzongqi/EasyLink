//
//  BannerCollectionReusableView.h
//  EasyLink
//
//  Created by 琦琦 on 17/3/3.
//  Copyright © 2017年 fengdian. All rights reserved.
//  collectionView的Header

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h" // 滚动图

@interface BannerCollectionReusableView : UICollectionReusableView

@property (nonatomic ,copy) SDCycleScrollView *bannerView;

-(void)giveArrayToBanner:(NSArray *)BannerArr;

@end
