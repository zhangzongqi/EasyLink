//
//  KindBtnView.m
//  EasyLink
//
//  Created by 琦琦 on 16/11/18.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "KindBtnViewForDetail.h"

@implementation KindBtnViewForDetail

//添加一个类方法
+(UIView *)creatBtn:(NSArray *)titleArr andTag:(NSArray *)tagArr andId:(NSArray *)arrId{
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 64 + 32, [UIScreen mainScreen].bounds.size.width, 50)];
    view.backgroundColor = [UIColor whiteColor];
    
    int width = 0;
    int height = 0;
    int number = 0;
    int hang = 0;
    
    //创建button
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 300 + i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        CGSize titleSize = [titleArr[i] boundingRectWithSize:CGSizeMake(999, 25) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        titleSize.width += 15;
        
        
        //自动的折行
        hang = hang +titleSize.width+15;
        if (hang > [[UIScreen mainScreen]bounds].size.width) {
            hang = 0;
            hang = hang + titleSize.width;
            height++;
            width = 0;
            width = width+titleSize.width;
            number = 0;
            button.frame = CGRectMake(15, 16 + 40*height, titleSize.width, 30);
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
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        // 选中，紫色；未选择，黑色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button setTitleColor:FUIColorFromRGB(0x8979ff) forState:UIControlStateSelected];
        
        
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        
        
        
        button.tag = [tagArr[i] integerValue]; // 设置tag
        button.restorationIdentifier = arrId[i]; // 设置Id
        [view addSubview:button];
        
        view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 16 +40*height + 30 + 16);
    }
    
    return view;
}

@end
