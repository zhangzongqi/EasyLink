//
//  HotCityTableViewCell.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/2.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "HotCityTableViewCell.h"

@implementation HotCityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        // 热门视图
        _hotCityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:_hotCityView];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
