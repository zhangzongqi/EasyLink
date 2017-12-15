//
//  BannerCollectionReusableView.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/3.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "BannerCollectionReusableView.h"

@implementation BannerCollectionReusableView

-(id)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor=FUIColorFromRGB(0xffffff);
        [self createBasicView];
    }
    return self;
}

// 创建视图
- (void) createBasicView {
    
    // 滚动图
    _bannerView = [[SDCycleScrollView alloc] init];
    [self addSubview:_bannerView];
    [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(self);
    }];
}

- (void) giveArrayToBanner:(NSArray *)BannerArr {
    
    _bannerView.imageURLStringsGroup = BannerArr;
    _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _bannerView.currentPageDotColor = FUIColorFromRGB(0xffffff); // 自定义分页控件小圆标颜色
    //    bannerView.pageDotColor = FUIColorFromRGB(0xeeeeee);
    _bannerView.placeholderImage = [UIImage imageNamed:@"placeholder"];
}

@end
