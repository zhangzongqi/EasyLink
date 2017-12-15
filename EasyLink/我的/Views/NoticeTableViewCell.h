//
//  NoticeTableViewCell.h
//  EasyLink
//
//  Created by 琦琦 on 16/11/25.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *cellMainView; // cell上的视图（小空间加在这上面，解决复用，解决）
@property (nonatomic, strong) UILabel *titleLb; // 标题label
@property (nonatomic, strong) UILabel *detailLb; // 内容Label
@property (nonatomic, strong) UIButton *btnRight; // 右侧按钮
@property (nonatomic, strong) UILabel *lbWeiDu; // 未读时小圆点
@property (nonatomic, strong) UIView *selectUv; // 选择视图
@property (nonatomic, strong) UIButton *selectBtn; // 选择按钮

// 重写init方法
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
