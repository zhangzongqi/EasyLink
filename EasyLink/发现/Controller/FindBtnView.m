//
//  FindBtnView.m
//  EasyLink
//

/*  自动换行按钮 */

//  Created by 琦琦 on 16/10/20.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "FindBtnView.h"

@implementation FindBtnView

+(UIView *)creatBtn{
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 64 + 32, [UIScreen mainScreen].bounds.size.width, 50)];
    view.backgroundColor = [UIColor redColor];
    
    int width = 0;
    int height = 0;
    int number = 0;
    int han = 0;
    
    NSArray *titleArr = @[@"父亲节",@"情人节",@"儿童",@"出游踏春",@"读书",@"旅游",@"服装",@"限时购",@"一抹新鲜",@"创意生活",@"美食节"];
    //创建button
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 300 + i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        CGSize titleSize = [titleArr[i] boundingRectWithSize:CGSizeMake(999, 25) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        titleSize.width += 15;
        
        
        //自动的折行
        han = han +titleSize.width+15;
        if (han > [[UIScreen mainScreen]bounds].size.width) {
            han = 0;
            han = han + titleSize.width;
            height++;
            width = 0;
            width = width+titleSize.width;
            number = 0;
            button.frame = CGRectMake(15, 16 +40*height, titleSize.width, 30);
        }else{
            button.frame = CGRectMake(width+15+(number*10), 16 +40*height, titleSize.width, 30);
            width = width+titleSize.width;
        }
        number++;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 15;
        button.layer.borderColor = [[UIColor colorWithRed:238/255.0 green:239/255.0 blue:239/255.0 alpha:1.0] CGColor];
        button.layer.borderWidth = 1.0;
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [view addSubview:button];
        
        view.frame = CGRectMake(0, 64 + 32, [UIScreen mainScreen].bounds.size.width, 16 +40*height + 30 + 16);
    }
    
    return view;
    
}

@end
