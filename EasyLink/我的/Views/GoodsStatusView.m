//
//  GoodsStatusView.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/3.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "GoodsStatusView.h"

#define Width self.frame.size.width
#define Height self.frame.size.height

@implementation GoodsStatusView

// 创建frame
- (id)initWithFrame:(CGRect)frame andImgArr:(NSArray *)imgArr andTitleArr:(NSArray *)titleArr{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 按钮宽度
        CGFloat btnWidth = (Width - (imgArr.count-1)*0.5) / imgArr.count;
        
        for (int i = 0; i < imgArr.count; i++) {
            
            // 创建按钮
            UIButton *btn = [[UIButton alloc] init];
            [self addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
                make.left.equalTo(self).with.offset(btnWidth * i + i*0.5);
                make.height.equalTo(self);
                make.width.equalTo(@(btnWidth));
            }];
            btn.imageView.sd_layout
            .topSpaceToView(btn, btn.frame.size.height*0.1375)
            .centerXEqualToView(btn)
            .widthRatioToView(btn,0.265625)
            .heightEqualToWidth();
            if (iPhone6SP) {
                btn.titleLabel.sd_layout
                .centerXEqualToView(btn)
                .topSpaceToView(btn.imageView,0.075*btn.frame.size.height)
                .heightIs(12)
                .widthRatioToView(btn,1);
                btn.titleLabel.font = [UIFont systemFontOfSize:12];
            }else if (iPhone6S) {
                btn.titleLabel.sd_layout
                .centerXEqualToView(btn)
                .topSpaceToView(btn.imageView,0.075*btn.frame.size.height)
                .heightIs(11)
                .widthRatioToView(btn,1);
                btn.titleLabel.font = [UIFont systemFontOfSize:11];
            }else {
                btn.titleLabel.sd_layout
                .centerXEqualToView(btn)
                .topSpaceToView(btn.imageView,0.075*btn.frame.size.height)
                .heightIs(10)
                .widthRatioToView(btn,1);
                btn.titleLabel.font = [UIFont systemFontOfSize:10];
            }
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitleColor:FUIColorFromRGB(0xb6acff) forState:UIControlStateNormal];
            
            // 设置图片和文字
            [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            
            if (i < imgArr.count-1) {
                // 分割线
                UIButton *FengeBtn = [[UIButton alloc] init];
                [self addSubview:FengeBtn];
                [FengeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self);
                    make.left.equalTo(btn.mas_right);
                    make.height.equalTo(self).multipliedBy(0.35);
                    make.width.equalTo(@(0.5));
                }];
                FengeBtn.backgroundColor = [UIColor colorWithRed:132/255.0 green:123/255.0 blue:252/255.0 alpha:1.0];
            }
        }
    }
    
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
