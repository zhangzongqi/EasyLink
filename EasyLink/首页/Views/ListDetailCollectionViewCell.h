//
//  ListDetailCollectionViewCell.h
//  EasyLink
//
//  Created by 琦琦 on 16/10/17.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListDetailCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *adImgView;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *guanzhuLB;

@property (weak, nonatomic) IBOutlet UILabel *liulanLB;

@property (weak, nonatomic) IBOutlet UIImageView *liulanImg;
@property (weak, nonatomic) IBOutlet UIImageView *guanzhuImg;

@end
