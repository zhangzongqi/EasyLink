//
//  ListCollectionViewCell.m
//  EasyLink
//
//  Created by 琦琦 on 16/9/18.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "ListCollectionViewCell.h"

@implementation ListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.goodsName.font = [UIFont systemFontOfSize:15];
    self.goodsName.textColor = [UIColor blackColor];
    
    self.detailLb.font = [UIFont systemFontOfSize:12];
    self.detailLb.textColor = [UIColor grayColor];
    
    self.liulanLb.textColor = [UIColor grayColor];
    self.liulanLb.font = [UIFont systemFontOfSize:13];
    
    self.guanzhuLb.textColor = [UIColor grayColor];
    self.guanzhuLb.font = [UIFont systemFontOfSize:13];
    
    self.fengeLb.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:239/255.0 alpha:1.0];
    self.fengeLb.text = @"";
    
    self.liulanImg.image = [UIImage imageNamed:@"发现3"];
    self.guanzhuImg.image = [UIImage imageNamed:@"发现4"];
}

@end
