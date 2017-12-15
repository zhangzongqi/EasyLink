//
//  AdressTableViewCell.h
//  EasyLink
//
//  Created by 琦琦 on 17/3/7.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdressTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLb; // 标题label
@property (nonatomic, strong) UILabel *phoneLb; // 电话Label
@property (nonatomic, strong) UILabel *addressLb; // 地址Label
@property (nonatomic, strong) UIButton *reviseBtn; // 修改按钮


// 重写init方法
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
