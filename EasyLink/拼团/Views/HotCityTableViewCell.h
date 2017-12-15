//
//  HotCityTableViewCell.h
//  EasyLink
//
//  Created by 琦琦 on 17/3/2.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotCityTableViewCell : UITableViewCell

@property (nonatomic,strong) UIView *hotCityView;

// 重写init方法
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
