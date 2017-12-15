//
//  AllPingJiaTableViewCell.h
//  EasyLink
//
//  Created by 琦琦 on 17/3/12.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingBar.h" // 星级

@interface AllPingJiaTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource> 

@property (nonatomic, strong) UIImageView *touxiangImgView; // 头像
@property (nonatomic, strong) UILabel *nicknameLb; // 昵称
@property (nonatomic, strong) UILabel *dateLb; // 日期
@property (nonatomic, strong) UILabel *pingjiaLb; // 评价
@property (nonatomic, strong) RatingBar *bar; // 星级
@property (nonatomic, strong) UICollectionView *tupianCollection; // 图片collectionview
@property (nonatomic, strong) NSMutableArray *tupianArr;

// 创建frame
// 重写init方法
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void) giveArrForTupian:(NSArray *)arr;

@end
