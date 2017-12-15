//
//  ListCollectionViewCell.h
//  EasyLink
//
//  Created by 琦琦 on 16/9/18.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *detailLb;
@property (weak, nonatomic) IBOutlet UILabel *fengeLb;
@property (weak, nonatomic) IBOutlet UILabel *liulanLb;
@property (weak, nonatomic) IBOutlet UILabel *guanzhuLb;
@property (weak, nonatomic) IBOutlet UIImageView *liulanImg;
@property (weak, nonatomic) IBOutlet UIImageView *guanzhuImg;

@end
