//
//  BtnView.m
//  热门标签的自动换行
//
//  Created by shrek on 16/3/23.
//  Copyright © 2016年 shrek. All rights reserved.
//

#import "BtnView.h"

@implementation BtnView

+(UIView *)creatBtn{
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 64 + 32, [UIScreen mainScreen].bounds.size.width, 50)];
    view.backgroundColor = [UIColor redColor];
    
    int width = 0;
    int height = 0;
    int number = 0;
    int han = 0;
    
    NSArray *titleArr = @[@"爽肤水",@"彩妆套装",@"古龙水",@"眼部护理",@"洁面乳",@"高光棒",@"隔离霜",@"眼霜",@"精华",@"剃须膏",@"彩妆盘",@"清洁面膜",@"淡香水",@"劲能醒肤"];
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
