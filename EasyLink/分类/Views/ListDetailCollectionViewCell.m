//
//  ListDetailCollectionViewCell.m
//  EasyLink
//
//  Created by 琦琦 on 16/10/17.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "ListDetailCollectionViewCell.h"

@implementation ListDetailCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headImg.layer.cornerRadius = 25;
    self.headImg.clipsToBounds = YES;
    self.headImg.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.headImg.layer.borderWidth = 2.0;
    
    self.titleLabel.textColor = FUIColorFromRGB(0x212121);
    self.guanzhuLB.textColor = FUIColorFromRGB(0x999999);
    self.liulanLB.textColor = FUIColorFromRGB(0x999999);
    
    self.liulanImg.image = [UIImage imageNamed:@"发现3"];
    self.guanzhuImg.image = [UIImage imageNamed:@"发现4"];
    
    
}

@end
