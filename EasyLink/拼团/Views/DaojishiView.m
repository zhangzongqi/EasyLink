//
//  DaojishiView.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/10.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "DaojishiView.h"

#define Width self.frame.size.width
#define Height self.frame.size.height

@implementation DaojishiView

- (id)initWithFrame:(CGRect)frame {
    
    //    640*190
    
    self =  [super initWithFrame:frame];
    
    if (self) {
        
        // 已拼
        _yipinLb = [[UILabel alloc] init];
        [self addSubview:_yipinLb];
        [_yipinLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(Width / 32);
            make.left.equalTo(self).with.offset(Width / 32);
            make.height.equalTo(@(14));
        }];
        _yipinLb.textColor = FUIColorFromRGB(0x999999);
        _yipinLb.font = [UIFont systemFontOfSize:13];
        
        
        // 左右大间距
        CGFloat bigSpace = Width * 0.1515625;
        // 中间间距
        CGFloat mediumSpace = Width * 0.05625;
        // 小间距
        CGFloat smallSpace = Width /128;
        
        // label的大小
        CGFloat labelWidth = (Width * 0.584375 - Width/128*3) / 6;
        
        
        // 秒1
        _miaoLb1 = [[UILabel alloc] init];
        [self addSubview:_miaoLb1];
        [_miaoLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_yipinLb.mas_bottom).with.offset(Height * 4/19);
            make.right.equalTo(self).with.offset(- bigSpace);
            make.width.equalTo(@(labelWidth));
            make.height.equalTo(@(labelWidth));
        }];
        _miaoLb1.textColor = FUIColorFromRGB(0xffffff);
        _miaoLb1.textAlignment = NSTextAlignmentCenter;
        _miaoLb1.layer.cornerRadius = labelWidth/2;
        _miaoLb1.clipsToBounds = YES;
        _miaoLb1.backgroundColor = FUIColorFromRGB(0x9688ff);
        // 秒2
        _miaoLb2 = [[UILabel alloc] init];
        [self addSubview:_miaoLb2];
        [_miaoLb2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_yipinLb.mas_bottom).with.offset(Height * 4/19);
            make.right.equalTo(_miaoLb1.mas_left).with.offset(- smallSpace);
            make.width.equalTo(@(labelWidth));
            make.height.equalTo(@(labelWidth));
        }];
        _miaoLb2.textColor = FUIColorFromRGB(0xffffff);
        _miaoLb2.textAlignment = NSTextAlignmentCenter;
        _miaoLb2.layer.cornerRadius = labelWidth/2;
        _miaoLb2.clipsToBounds = YES;
        _miaoLb2.backgroundColor = FUIColorFromRGB(0x9688ff);
        
        
        // 分1
        _fenLb1 = [[UILabel alloc] init];
        [self addSubview:_fenLb1];
        [_fenLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_yipinLb.mas_bottom).with.offset(Height * 4/19);
            make.right.equalTo(_miaoLb2.mas_left).with.offset(- mediumSpace);
            make.width.equalTo(@(labelWidth));
            make.height.equalTo(@(labelWidth));
        }];
        _fenLb1.textColor = FUIColorFromRGB(0xffffff);
        _fenLb1.textAlignment = NSTextAlignmentCenter;
        _fenLb1.layer.cornerRadius = labelWidth/2;
        _fenLb1.clipsToBounds = YES;
        _fenLb1.backgroundColor = FUIColorFromRGB(0x9688ff);
        // 分2
        _fenLb2 = [[UILabel alloc] init];
        [self addSubview:_fenLb2];
        [_fenLb2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_yipinLb.mas_bottom).with.offset(Height * 4/19);
            make.right.equalTo(_fenLb1.mas_left).with.offset(- smallSpace);
            make.width.equalTo(@(labelWidth));
            make.height.equalTo(@(labelWidth));
        }];
        _fenLb2.textColor = FUIColorFromRGB(0xffffff);
        _fenLb2.textAlignment = NSTextAlignmentCenter;
        _fenLb2.layer.cornerRadius = labelWidth/2;
        _fenLb2.clipsToBounds = YES;
        _fenLb2.backgroundColor = FUIColorFromRGB(0x9688ff);
        
        // 时1
        _shiLb1 = [[UILabel alloc] init];
        [self addSubview:_shiLb1];
        [_shiLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_yipinLb.mas_bottom).with.offset(Height * 4/19);
            make.right.equalTo(_fenLb2.mas_left).with.offset(- mediumSpace);
            make.width.equalTo(@(labelWidth));
            make.height.equalTo(@(labelWidth));
        }];
        _shiLb1.textColor = FUIColorFromRGB(0xffffff);
        _shiLb1.textAlignment = NSTextAlignmentCenter;
        _shiLb1.layer.cornerRadius = labelWidth/2;
        _shiLb1.clipsToBounds = YES;
        _shiLb1.backgroundColor = FUIColorFromRGB(0x9688ff);
        // 时2
        _shiLb2 = [[UILabel alloc] init];
        [self addSubview:_shiLb2];
        [_shiLb2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_yipinLb.mas_bottom).with.offset(Height * 4/19);
            make.right.equalTo(_shiLb1.mas_left).with.offset(- smallSpace);
            make.width.equalTo(@(labelWidth));
            make.height.equalTo(@(labelWidth));
        }];
        _shiLb2.textColor = FUIColorFromRGB(0xffffff);
        _shiLb2.textAlignment = NSTextAlignmentCenter;
        _shiLb2.layer.cornerRadius = labelWidth/2;
        _shiLb2.clipsToBounds = YES;
        _shiLb2.backgroundColor = FUIColorFromRGB(0x9688ff);
        
        
        if (iPhone6SP) {
            _miaoLb1.font = [UIFont systemFontOfSize:17];
            _miaoLb2.font = [UIFont systemFontOfSize:17];
            _fenLb1.font = [UIFont systemFontOfSize:17];
            _fenLb2.font = [UIFont systemFontOfSize:17];
            _shiLb2.font = [UIFont systemFontOfSize:17];
            _shiLb1.font = [UIFont systemFontOfSize:17];
        }else if (iPhone6S) {
            _miaoLb1.font = [UIFont systemFontOfSize:16];
            _miaoLb2.font = [UIFont systemFontOfSize:16];
            _fenLb1.font = [UIFont systemFontOfSize:16];
            _fenLb2.font = [UIFont systemFontOfSize:16];
            _shiLb2.font = [UIFont systemFontOfSize:16];
            _shiLb1.font = [UIFont systemFontOfSize:16];
        }else {
            _miaoLb1.font = [UIFont systemFontOfSize:15];
            _miaoLb2.font = [UIFont systemFontOfSize:15];
            _fenLb1.font = [UIFont systemFontOfSize:15];
            _fenLb2.font = [UIFont systemFontOfSize:15];
            _shiLb2.font = [UIFont systemFontOfSize:15];
            _shiLb1.font = [UIFont systemFontOfSize:15];
        }
        
        // 冒号
        UILabel *lb1 = [[UILabel alloc] init];
        [self addSubview:lb1];
        [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_miaoLb1);
            make.right.equalTo(_miaoLb2.mas_left);
            make.width.equalTo(@(mediumSpace));
            make.height.equalTo(@(labelWidth));
        }];
        lb1.font = [UIFont systemFontOfSize:16];
        lb1.textColor = FUIColorFromRGB(0x9688ff);
        lb1.textAlignment = NSTextAlignmentCenter;
        lb1.text = @":";
        // 冒号
        UILabel *lb2 = [[UILabel alloc] init];
        [self addSubview:lb2];
        [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_miaoLb1);
            make.right.equalTo(_fenLb2.mas_left);
            make.width.equalTo(@(mediumSpace));
            make.height.equalTo(@(labelWidth));
        }];
        lb2.font = [UIFont systemFontOfSize:16];
        lb2.textColor = FUIColorFromRGB(0x9688ff);
        lb2.textAlignment = NSTextAlignmentCenter;
        lb2.text = @":";
        
        
        
        _shiOrDayTip = [[UILabel alloc] init];
        [self addSubview:_shiOrDayTip];
        [_shiOrDayTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_miaoLb1.mas_bottom);
            make.centerX.equalTo(_shiLb1.mas_left).with.offset(- smallSpace/2);
            make.height.equalTo(@(13));
        }];
        _shiOrDayTip.textColor = FUIColorFromRGB(0x999999);
        _shiOrDayTip.font = [UIFont systemFontOfSize:12];
        
        
        _fenOrShiTip = [[UILabel alloc] init];
        [self addSubview:_fenOrShiTip];
        [_fenOrShiTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_shiOrDayTip);
            make.centerX.equalTo(_fenLb1.mas_left).with.offset(- smallSpace/2);
            make.height.equalTo(@(13));
        }];
        _fenOrShiTip.textColor = FUIColorFromRGB(0x999999);
        _fenOrShiTip.font = [UIFont systemFontOfSize:12];
        
        _miaoOrFenTip = [[UILabel alloc] init];
        [self addSubview:_miaoOrFenTip];
        [_miaoOrFenTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_shiOrDayTip);
            make.centerX.equalTo(_miaoLb1.mas_left).with.offset(- smallSpace/2);
            make.height.equalTo(@(13));
        }];
        _miaoOrFenTip.textColor = FUIColorFromRGB(0x999999);
        if (iPhone6SP) {
            _miaoOrFenTip.font = [UIFont systemFontOfSize:12];
        }else if (iPhone6S) {
            _miaoOrFenTip.font = [UIFont systemFontOfSize:11];
        }else {
            _miaoOrFenTip.font = [UIFont systemFontOfSize:10];
        }
        

        
    }
    
    return self;
}

- (void) giveEndTime:(NSString *)timeStr {
    
    // 把时间戳转换成NSDate
    NSString *timestamp = timeStr;
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *expireDateStr = [dateFomatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timestamp intValue]]];
    // 截止时间data格式
    NSDate *expireDate = [dateFomatter dateFromString:expireDateStr];
    
    // 计算传入的时间和当前的时间差
    NSTimeInterval interval = [expireDate timeIntervalSinceDate:[NSDate date]];
    NSLog(@"hhhhhhhhhhhhhhhhhhhhhhhh%f",interval);
    if (interval > 0) {
        [self initTimeParametersWithTimeInterval:(NSInteger)interval];
    }else {
        // 秒
        _miaoLb1.text = @"0";
        _miaoLb2.text = @"0";
        
        // 分
        _fenLb1.text = @"0";
        _fenLb2.text = @"0";
        
        // 时
        _shiLb1.text = @"0";
        _shiLb2.text = @"0";
        
        _miaoOrFenTip.text = @"秒";
        _fenOrShiTip.text = @"分";
        _shiOrDayTip.text = @"时";
    }
}


// 根据传入的具体秒数，开始倒计时
- (void)beginCountDownWithTimeInterval:(NSTimeInterval)timerInterval {
    
    [self initTimeParametersWithTimeInterval:timerInterval];
}

/// 根据传入的两个时间差，开始倒计时
- (void)beginCountDownFromTime:(NSDate *)fromDate toTime:(NSDate *)toDate {
    
    NSTimeInterval interval = [fromDate timeIntervalSinceDate:toDate];
    [self initTimeParametersWithTimeInterval:interval];
}

/// 通过传入的时间间隔对时间参数进行初始化
- (void)initTimeParametersWithTimeInterval:(NSInteger)interval {
    
    NSUInteger secondPerDay = 24 * 60 * 60;
    NSUInteger secondPerHour = 60 * 60;
    NSUInteger secondPerMinute = 60;
    
    // 计算天数
    self.day = interval / secondPerDay;
    // 剩余小时不应该大于24小时，所以应该先除去满足一天的秒数，再计算还剩下多少小时
    self.hour = interval % secondPerDay / secondPerHour;
    // 剩余分钟数与上面同理
    self.minute = interval % secondPerHour / secondPerMinute;
    // 剩余秒数直接等于秒数对每分钟秒数所取的余数
    self.second = interval % secondPerMinute;
    
    // 更新值
    [self updateText];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/// 时间减一秒方法
- (void)updateTimer {
    
    // 减一秒
    self.second--;
    // 判断秒数
    if (self.second == -1) {
        self.second = 59;
        self.minute--;
    }
    // 判断分钟数
    if (self.minute == -1) {
        self.minute = 59;
        self.hour--;
    }
    // 判断小时数
    if (self.hour == -1) {
        self.hour = 23;
        self.day--;
    }
    // 判断是否没时间了
    if (self.day == 0 && self.hour == 0 && self.minute == 0 && self.second == 0) {
        
        [self.timer invalidate];
    }
    // 更新值
    [self updateText];
    
    NSLog(@"%s", __func__);
}

- (void)updateText {
    
//    self.text = [NSString stringWithFormat:@"%02zd天 %02zd:%02zd:%02zd", self.day, self.hour, self.minute, self.second];
    
    
    if (self.day > 4) {
        
        // 分
        NSString *strFen = [NSString stringWithFormat:@"%02zd",self.minute];
        _miaoLb1.text = [strFen substringFromIndex:1]; // 字符串从第n 位开端截取，直到最后 （substringFromIndex:n）（包含第 n 位）
        _miaoLb2.text = [strFen substringToIndex:1]; // 字符串截取到第n位  （substringToIndex: n）（第n 位不算再内）
        
        // 时
        NSString *strShi = [NSString stringWithFormat:@"%02zd",self.hour];
        _fenLb1.text = [strShi substringFromIndex:1];
        _fenLb2.text = [strShi substringToIndex:1];
        
        // 天
        NSString *strDay = [NSString stringWithFormat:@"%02zd",self.day];
        _shiLb1.text = [strDay substringFromIndex:1];
        _shiLb2.text = [strDay substringToIndex:1];
        
        
        _miaoOrFenTip.text = @"分";
        _fenOrShiTip.text = @"时";
        _shiOrDayTip.text = @"天";
        
    }else {
        
        // 秒
        NSString *strMiao = [NSString stringWithFormat:@"%02zd",self.second];
        _miaoLb1.text = [strMiao substringFromIndex:1]; // 字符串从第n 位开端截取，直到最后 （substringFromIndex:n）（包含第 n 位）
        _miaoLb2.text = [strMiao substringToIndex:1]; // 字符串截取到第n位  （substringToIndex: n）（第n 位不算再内）
        
        // 分
        NSString *strFen = [NSString stringWithFormat:@"%02zd",self.minute];
        _fenLb1.text = [strFen substringFromIndex:1];
        _fenLb2.text = [strFen substringToIndex:1];
        
        // 时
        NSString *strShi = [NSString stringWithFormat:@"%02zd",self.hour + self.day * 24];
        _shiLb1.text = [strShi substringFromIndex:1];
        _shiLb2.text = [strShi substringToIndex:1];
        
        
        _miaoOrFenTip.text = @"秒";
        _fenOrShiTip.text = @"分";
        _shiOrDayTip.text = @"时";
    }
    
    
    
}

// best solution
- (void)removeFromSuperview {
    
    [super removeFromSuperview];
    [self.timer invalidate];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
