//
//  UIScrollView+UITouch.m
//  EasyLink
//
//  Created by 琦琦 on 16/11/15.
//  Copyright © 2016年 fengdian. All rights reserved.
//  添加滚动视图的扩展（解决 touchesBegan: withEvent: 不执行）

#import "UIScrollView+UITouch.h"

@implementation UIScrollView (UITouch)

// 让touchesBegan传递下去
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 选其一即可
    [super touchesBegan:touches withEvent:event];
    //    [[self nextResponder] touchesBegan:touches withEvent:event];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
