//
//  StreetSelectView.h
//  EasyLink
//
//  Created by 琦琦 on 2017/5/13.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UIView+Frame.h"
#import "ShengShiXianTableViewCell.h" // 省市县cell
#import "AddressView.h"

@interface StreetSelectView : UIView<UITableViewDelegate,UITableViewDataSource> {
    
    NSArray *_arrForShengShiQu;
    
    NSMutableArray *_arrForStreet; // 街道
    
    NSInteger SelectIndex;
    NSInteger SelectShengIndex;
    NSInteger SelectShiIndex;
    NSInteger SelectXianIndex;
    
    BOOL FirstShengSelect;
    BOOL FirstShiSelect;
    BOOL FirstXianSelect;
}

@property (nonatomic, strong) UIButton *closeBtn; // 关闭按钮
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIScrollView *bigScrollView;


@property (nonatomic, strong) AddressView *topBarView;
@property (nonatomic,weak) UIView * underLine;
@property (nonatomic,weak) UIButton * selectedBtn;
@property (nonatomic,strong) NSMutableArray *tableViews;
@property (nonatomic,strong) NSMutableArray * topTabbarItems;

@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) void(^chooseFinish)();

- (id) initWithFrame:(CGRect)frame;


@end
