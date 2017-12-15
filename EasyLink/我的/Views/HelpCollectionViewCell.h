//
//  HelpCollectionViewCell.h
//  EasyLink
//
//  Created by 琦琦 on 16/11/24.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIView *cellMainView; // cell上的视图（小空间加在这上面，解决复用，解决）
@property (nonatomic, strong) UILabel *titleLb; // 标题label
@property (nonatomic, strong) UILabel *detailLb; // 内容Label

// 创建frame
- (id)initWithFrame:(CGRect)frame;

@end
