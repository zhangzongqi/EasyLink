//
//  SelectGuiGeCollectionViewCell.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/7.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "SelectGuiGeView.h"
#import "KindBtnViewForDetail.h"
#import "KindBtnViewForPinTuan.h"

#define Width self.frame.size.width
#define Height self.frame.size.height

@implementation SelectGuiGeView

// 创建frame
- (id) initWithFrame:(CGRect)frame WithFenLeiArr:(NSArray *)FenleiArr andPriceArr:(NSArray *)priceArr {
    
    self = [super initWithFrame:frame];
    
    // 用来保存小拼购组合
    _xiaoPinGouZuheArr = [[NSArray alloc] init];
    
    
//    beforeClickView = 1111111;
    
    
    // 记录已经选择的view的数组
    _arrForView = [NSMutableArray array];
    
    // 用于记录已选择的数据的id
    _arrForSelectId = [NSMutableArray array];
    
    for (int i = 0; i < FenleiArr.count; i++) {
        
        [_arrForSelectId addObject:@"***"];
    }
    
    
    _priceArr = priceArr;
    _guigeArr = [NSMutableArray arrayWithArray:FenleiArr];
    _btnIdArr = [NSMutableArray array];
    _arrZuhe = [NSMutableArray array];
    
    
    for (int i = 0; i < priceArr.count; i++) {
        
        [_arrZuhe addObject:[priceArr[i] objectForKey:@"spec_item_ids"]];
    }
    
    
    
    if (self) {
        
//        640*640
        
        // 顶部视图
        _topView = [[UIView alloc] init];
        [self addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(Width * 0.1625));
        }];
        
        // 商品图片
        _goodsImgView = [[UIImageView alloc] init];
        [_topView addSubview:_goodsImgView];
        [_goodsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_topView.mas_top);
            make.left.equalTo(_topView).with.offset(Width * 0.0625);
            make.height.equalTo(@(Width * 0.20625));
            make.width.equalTo(@(Width * 0.20625));
        }];
        _goodsImgView.layer.cornerRadius = Width * 0.20625/2;
        _goodsImgView.clipsToBounds = YES;
    
        // 价格
        _priceLb = [[UILabel alloc] init];
        [_topView addSubview:_priceLb];
        [_priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topView).with.offset(Width * 0.035);
            make.left.equalTo(_goodsImgView.mas_right).with.offset(Width * 0.0234375);
            if (iPhone6SP) {
                make.height.equalTo(@(16));
                _priceLb.font = [UIFont systemFontOfSize:16];
            }else if (iPhone6S){
                make.height.equalTo(@(15));
                _priceLb.font = [UIFont systemFontOfSize:15];
            }else {
                make.height.equalTo(@(14));
                _priceLb.font = [UIFont systemFontOfSize:14];
            }
        }];
        _priceLb.textColor = FUIColorFromRGB(0xff5571);
        
        // 编号
        _goodsNum = [[UILabel alloc] init];
        [_topView addSubview:_goodsNum];
        [_goodsNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_priceLb.mas_bottom).with.offset(Width * 0.02);
            make.left.equalTo(_priceLb);
            if (iPhone6SP) {
                make.height.equalTo(@(14));
                _goodsNum.font = [UIFont systemFontOfSize:14];
            }else if (iPhone6S){
                make.height.equalTo(@(13));
                _goodsNum.font = [UIFont systemFontOfSize:13];
            }else {
                make.height.equalTo(@(12));
                _goodsNum.font = [UIFont systemFontOfSize:12];
            }
        }];
        _goodsNum.textColor = FUIColorFromRGB(0x999999);
        
        // 关闭按钮
        _closeBtn = [[UIButton alloc] init];
        [_topView addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topView);
            make.right.equalTo(_topView);
            make.width.equalTo(@(Width * 0.1));
            make.height.equalTo(@(Width * 0.105));
        }];
        _closeBtn.imageView.sd_layout
        .centerXEqualToView(_closeBtn)
        .centerYEqualToView(_closeBtn)
        .widthRatioToView(_closeBtn, 0.333)
        .heightEqualToWidth();
        [_closeBtn setImage:[UIImage imageNamed:@"home_close"] forState:UIControlStateNormal];  
        
        // 分割线
        UILabel *lbFenge = [[UILabel alloc] init];
        [_topView addSubview:lbFenge];
        [lbFenge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_topView);
            make.left.equalTo(_topView).with.offset(Width * 0.046875);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(1));
        }];
        lbFenge.backgroundColor = FUIColorFromRGB(0xeeeeee);
        
        
        // 底部视图
        _bottomView = [[UIView alloc] init];
        [self addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(self);
            make.height.equalTo(@(Width * 0.128125));
            make.width.equalTo(@(Width));
        }];
        // 小拼购
        _xiaopingouBtn = [[UIButton alloc] init];
        [_bottomView addSubview:_xiaopingouBtn];
        [_xiaopingouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_bottomView);
            make.right.equalTo(_bottomView).with.offset(- Width * 0.046875);
            make.width.equalTo(@((Width - Width * 0.046875 * 3) / 2));
            make.height.equalTo(@(Width * 0.084375));
        }];
        _xiaopingouBtn.layer.cornerRadius = Width * 0.084375/2;
        _xiaopingouBtn.clipsToBounds = YES;
        _xiaopingouBtn.backgroundColor = FUIColorFromRGB(0xeeeeee);
        [_xiaopingouBtn setTitleColor:FUIColorFromRGB(0xf999999) forState:UIControlStateNormal];
        _xiaopingouBtn.userInteractionEnabled = NO;
        [_xiaopingouBtn setTitle:@"小拼购" forState:UIControlStateNormal];
        // 全拼购
        _quanpingouBtn = [[UIButton alloc] init];
        [_bottomView addSubview:_quanpingouBtn];
        [_quanpingouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bottomView).with.offset(Width * 0.046875);
            make.centerY.equalTo(_bottomView);
            make.width.equalTo(@((Width - Width * 0.046875 * 3) / 2));
            make.height.equalTo(@(Width * 0.084375));
        }];
        _quanpingouBtn.layer.cornerRadius = Width * 0.084375/2;
        _quanpingouBtn.clipsToBounds = YES;
        _quanpingouBtn.layer.borderColor = FUIColorFromRGB(0xeeeeee).CGColor;
        _quanpingouBtn.layer.borderWidth = 1.0;
        [_quanpingouBtn setTitleColor:FUIColorFromRGB(0xeeeeee) forState:UIControlStateNormal];
        _quanpingouBtn.userInteractionEnabled = NO; // 用户不可操作
        [_quanpingouBtn setTitle:@"全拼购" forState:UIControlStateNormal];
        if (iPhone6SP) {
            _xiaopingouBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            _quanpingouBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        }else if (iPhone6S) {
            _xiaopingouBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            _quanpingouBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        }else {
            _xiaopingouBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            _quanpingouBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        
        
        // 中间滚动视图
        _centerView = [[UIScrollView alloc] init];
        [self addSubview:_centerView];
        [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topView.mas_bottom);
            make.bottom.equalTo(_bottomView.mas_top);
            make.left.equalTo(self);
            make.width.equalTo(@(Width));
        }];
        
        CGFloat height = 0;
        // 规格
        for (int i = 0; i < FenleiArr.count; i++) {
            
            
            [_btnIdArr removeAllObjects];
            
            UILabel *lbGuige = [[UILabel alloc] init];
            [_centerView addSubview:lbGuige];
            [lbGuige mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lbFenge);
                make.top.equalTo(_centerView).with.offset(Width * 0.046875 + 13*i + height);
                make.height.equalTo(@(13));
                lbGuige.font = [UIFont systemFontOfSize:13];
            }];
            lbGuige.textColor = FUIColorFromRGB(0x999999);
            lbGuige.text = [FenleiArr[i] objectForKey:@"title"];
            
            
            NSArray *arrForFeileiDetail = [FenleiArr[i] objectForKey:@"spec_item_list"];
            NSMutableArray *btnTitleArr = [NSMutableArray array];
            NSMutableArray *btnId1Arr = [NSMutableArray array];
            for (int j = 0; j < arrForFeileiDetail.count; j++) {
                
                [btnTitleArr addObject:[arrForFeileiDetail[j] objectForKey:@"title"]];
                [btnId1Arr addObject:[arrForFeileiDetail[j] objectForKey:@"id"]];
                [_btnIdArr addObject:[NSString stringWithFormat:@"%ld", [[arrForFeileiDetail[j] objectForKey:@"id"] integerValue] + 100000*i]];
            }
            
            // 规格按钮视图
            UIView *guigeBtnView = [KindBtnViewForDetail creatBtn:btnTitleArr andTag:_btnIdArr andId:btnId1Arr];
            [_centerView addSubview:guigeBtnView];
            [guigeBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lbGuige.mas_bottom);
                make.left.equalTo(_centerView);
                make.width.equalTo(@(Width));
                make.height.equalTo(@(guigeBtnView.frame.size.height));
            }];
            height = guigeBtnView.frame.size.height + height;
            
            
            
            //遍历这个view，对这个view上btn添加相应的事件
            for (UIButton *btn in guigeBtnView.subviews) {
                [btn setTitleColor:FUIColorFromRGB(0x4e4e4e) forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(guigeViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                btn.userInteractionEnabled = YES;
                
                
                
            }
            
            guigeBtnView.tag = 1000+i;
            
        }
    
        
        
        UIView *guigeView = [self viewWithTag:1000 + FenleiArr.count - 1];
        
        // 数量
        UILabel * NumberLb = [[UILabel alloc] init];
        [_centerView addSubview:NumberLb];
        [NumberLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(guigeView.mas_bottom);
            make.left.equalTo(lbFenge);
            if (iPhone6SP) {
                make.height.equalTo(@(14));
                NumberLb.font = [UIFont systemFontOfSize:14];
            }else if (iPhone6S){
                make.height.equalTo(@(13));
                NumberLb.font = [UIFont systemFontOfSize:13];
            }else {
                make.height.equalTo(@(12));
                NumberLb.font = [UIFont systemFontOfSize:12];
            }
        }];
        NumberLb.textColor = FUIColorFromRGB(0x999999);
        NumberLb.text = @"数量:";
        
        // 减按钮
        _NumSubBtn = [[UIButton alloc] init];
        [_centerView addSubview:_NumSubBtn];
        [_NumSubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(NumberLb.mas_bottom).with.offset(Width / 32);
            make.left.equalTo(NumberLb);
            make.width.equalTo(@(40));
            make.height.equalTo(@(30));
        }];
        [_NumSubBtn setTitleColor:FUIColorFromRGB(0x4e4e4e) forState:UIControlStateNormal];
        [_NumSubBtn setTitle:@"-" forState:UIControlStateNormal];
        _NumSubBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        
        // 购买数量
        _BuyNumberLb = [[UILabel alloc] init];
        [_centerView addSubview:_BuyNumberLb];
        [_BuyNumberLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_NumSubBtn);
            make.left.equalTo(_NumSubBtn.mas_right);
            make.width.equalTo(@(50));
            make.height.equalTo(@(30));
        }];
        _BuyNumberLb.layer.cornerRadius = 8;
        _BuyNumberLb.clipsToBounds = YES;
        _BuyNumberLb.layer.borderColor = [FUIColorFromRGB(0xeeeeee) CGColor];
        _BuyNumberLb.layer.borderWidth = 1.0;
        _BuyNumberLb.textColor = FUIColorFromRGB(0x212121);
        _BuyNumberLb.font = [UIFont systemFontOfSize:12];
        _BuyNumberLb.textAlignment = NSTextAlignmentCenter;
        
        // 加按钮
        _NumAddBtn = [[UIButton alloc] init];
        [_centerView addSubview:_NumAddBtn];
        [_NumAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_NumSubBtn);
            make.left.equalTo(_BuyNumberLb.mas_right);
            make.width.equalTo(@(40));
            make.height.equalTo(@(30));
        }];
        [_NumAddBtn setTitleColor:FUIColorFromRGB(0x4e4e4e) forState:UIControlStateNormal];
        [_NumAddBtn setTitle:@"+" forState:UIControlStateNormal];
        _NumAddBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        
        // 小拼购
        lbXiaoPinGou = [[UILabel alloc] init];
        [_centerView addSubview:lbXiaoPinGou];
        [lbXiaoPinGou mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_NumAddBtn.mas_bottom).with.offset(Width * 3/64);
            make.left.equalTo(lbFenge);
            if (iPhone6SP) {
                make.height.equalTo(@(14));
                lbXiaoPinGou.font = [UIFont systemFontOfSize:14];
            }else if (iPhone6S){
                make.height.equalTo(@(13));
                lbXiaoPinGou.font = [UIFont systemFontOfSize:13];
            }else {
                make.height.equalTo(@(12));
                lbXiaoPinGou.font = [UIFont systemFontOfSize:12];
            }
        }];
        lbXiaoPinGou.textColor = FUIColorFromRGB(0x999999);
        lbXiaoPinGou.text = @"小拼购:";
        
        
        [self layoutIfNeeded];
        
        _centerView.contentSize = CGSizeMake(Width, lbXiaoPinGou.frame.origin.y + lbXiaoPinGou.frame.size.height + 30);
        
        
        
        
        
//        136_138
        
        // 用来模拟点击
        NSString *str = [_priceArr[0] objectForKey:@"spec_item_ids"];
        NSArray *arr = [str componentsSeparatedByString:@"_"];
        for (int i = 0; i < FenleiArr.count; i++) {
            
            UIView *view = [self viewWithTag:1000+i];
            for (UIButton *btn in view.subviews) {
                
                if ([arr containsObject:btn.restorationIdentifier]) {
                    
                    [self guigeViewBtnClick:btn];
                }
            }
        }

        
    }
    
    
    
    return self;
}


// 按钮点击触发事件
-(void) guigeViewBtnClick:(UIButton *)btn{
    

    // 被点击的btn的tag
    NSLog(@"btntag:%ld",btn.tag);
    
    // 被点击的view
    NSInteger clickView = btn.tag / 100000;
    NSLog(@"clickView:%ld",clickView);
    
    // 被点击的btn的id
    NSInteger btnId = btn.tag - clickView * 100000;
    NSLog(@"btnId:%ld",btnId);
    
    
    
    
    if (CGColorEqualToColor([btn titleColorForState:UIControlStateNormal].CGColor,FUIColorFromRGB(0x4e4e4e).CGColor)) {
        
        
        // 将选过的Id保存
        
        // 将选过的规格项保存
        if ([_arrForView containsObject:[NSString stringWithFormat:@"%ld",clickView]]) {
            
            [_arrForSelectId removeObjectAtIndex:clickView];
            [_arrForSelectId insertObject:[NSString stringWithFormat:@"%ld",btnId] atIndex:clickView];
            
        }else {
            
            [_arrForSelectId removeObjectAtIndex:clickView];
            [_arrForView addObject:[NSString stringWithFormat:@"%ld",clickView]];
            [_arrForSelectId insertObject:[NSString stringWithFormat:@"%ld",btnId] atIndex:clickView];
        }
        
        NSLog(@"_arrForSelectId%@",_arrForSelectId);
        NSLog(@"_arrForView%@",_arrForView);
        
        
        // 当前选择的按钮时可选状态
        
        // 改变被点击按钮的状态
        UIView *view = [self viewWithTag:1000+clickView];
        for (UIButton *btn1 in view.subviews) {
            
            if (CGColorEqualToColor([btn1 titleColorForState:UIControlStateNormal].CGColor,FUIColorFromRGB(0x8979ff).CGColor)) {
                // 把当前规格下所有按钮变为正常状态
                [self makeBtnStatus:btn1 andStatus:0];
            }
        }
        // 把点击的按钮，变为选中状态
        [self makeBtnStatus:btn andStatus:2];
        
        
        
        
        
            
            
        // 只点了一行
        if (_arrForView.count == 1) {
            
            // 当前行不用做判断，用当前已选的,去处理剩下两行
            // 22222222222222222222222222222222   用组合筛选下面的
            NSMutableArray *arrForPrice2 = [NSMutableArray array];
            
            // 获取到所有规格项组合
            for (int i = 0; i < _arrZuhe.count; i++) {
                
                
                NSArray *array1 = [_arrZuhe[i] componentsSeparatedByString:@"_"];
                
                NSSet *set1 = [NSSet setWithArray:array1];
                
                NSMutableArray *arrr = [NSMutableArray arrayWithArray:_arrForSelectId];
                [arrr removeObject:@"***"];
                
                NSSet *set2 = [NSSet setWithArray:arrr];
                
                if ([set2 isSubsetOfSet:set1]) {
                    
                    // 有匹配
                    // 有匹配价格
                    NSArray *arr = [_arrZuhe[i] componentsSeparatedByString:@"_"];
                    //            NSLog(@"arr:%@",arr);
                    for (int j = 0; j < arr.count; j++) {
                        
                        [arrForPrice2 addObject:arr[j]];
                    }
                }
                else {
                    
                    // 没有匹配
                }
            }
            
            
            for (int j = 0; j<_guigeArr.count; j++) {
                
                if (j == clickView) {
                    
                    // 不再做处理,当前选择的就是此规格的
                    
                }else {
                    
                    // 拿到view
                    UIView *view = [self viewWithTag:1000+j];
                    // 遍历view上的所有按钮
                    for (UIButton *btn2 in view.subviews) {
                        
                        if ([arrForPrice2 containsObject:[NSString stringWithFormat:@"%ld",btn2.tag - 100000*j]]) {
                            
                            
                            if (CGColorEqualToColor([btn2 titleColorForState:UIControlStateNormal].CGColor,FUIColorFromRGB(0x8979ff).CGColor)) {
                                
                            }else{
                                
                                
                                if ([_arrForView containsObject:[NSString stringWithFormat:@"%d",j]] == false) {
                                    
                                    // 这个是匹配项,变为可选状态
                                    [self makeBtnStatus:btn2 andStatus:0];
                                }else {
                                    
                                    
                                }
                            }
                            
                        }else {
                            
                            if ([_arrForView containsObject:[NSString stringWithFormat:@"%d",j]] == false) {
                                
                                // 这个不是匹配项,变为不可选状态
                                [self makeBtnStatus:btn2 andStatus:1];
                            }
                            
                        }
                    }
                }
            }

        }else {
            
            
            // 1.用上面的组合去筛选没点击的
            // 当前行不用做判断，用当前已选的,去处理剩下两行
            // 22222222222222222222222222222222   用组合筛选下面的
            NSMutableArray *arrForPrice2 = [NSMutableArray array];
            
            // 获取到所有规格项组合
            for (int i = 0; i < _arrZuhe.count; i++) {
                
                //            NSString *str = [NSString stringWithFormat:@"_%@_",_arrZuhe[i]];
                NSArray *array1 = [_arrZuhe[i] componentsSeparatedByString:@"_"];
                
                NSSet *set1 = [NSSet setWithArray:array1];
                
                NSMutableArray *arrr = [NSMutableArray arrayWithArray:_arrForSelectId];
                [arrr removeObject:@"***"];
                
                NSSet *set2 = [NSSet setWithArray:arrr];
                
                if ([set2 isSubsetOfSet:set1]) {
                    
                    // 有匹配
                    // 有匹配价格
                    NSArray *arr = [_arrZuhe[i] componentsSeparatedByString:@"_"];
                    //            NSLog(@"arr:%@",arr);
                    for (int j = 0; j < arr.count; j++) {
                        
                        [arrForPrice2 addObject:arr[j]];
                    }
                }
                else {
                    
                    // 没有匹配
                }
            }
            
            for (int j = 0; j<_guigeArr.count; j++) {
                
                if (j == clickView) {
                    
                    // 不再做处理,当前选择的就是此规格的
                    
                }else {
                    
                    // 拿到view
                    UIView *view = [self viewWithTag:1000+j];
                    // 遍历view上的所有按钮
                    for (UIButton *btn2 in view.subviews) {
                        
                        if ([arrForPrice2 containsObject:[NSString stringWithFormat:@"%ld",btn2.tag - 100000*j]]) {
                            
                            
                            if (CGColorEqualToColor([btn2 titleColorForState:UIControlStateNormal].CGColor,FUIColorFromRGB(0x8979ff).CGColor)) {
                                
                            }else{
                                
                                
                                if ([_arrForView containsObject:[NSString stringWithFormat:@"%d",j]] == false) {
                                    
                                    // 这个是匹配项,变为可选状态
                                    [self makeBtnStatus:btn2 andStatus:0];
                                }else {
                                    
                                    
                                }
                            }
                            
                        }else {
                            
                            if ([_arrForView containsObject:[NSString stringWithFormat:@"%d",j]] == false) {
                                
                                // 这个不是匹配项,变为不可选状态
                                [self makeBtnStatus:btn2 andStatus:1];
                            }
                            
                        }
                    }
                }
            }

            
            
            
            // 2.用除了当前行的组合去筛选当前行
            NSMutableArray *arrForAllPriceZuhe = [NSMutableArray array];
            
            for (int i = 0; i < _priceArr.count; i++) {
                
                [arrForAllPriceZuhe addObject:[NSString stringWithFormat:@"_%@_",[_priceArr[i] objectForKey:@"spec_item_ids"]]];
            }
            
            // 用除了当前行的规格组合去匹配可选，用来规整当前行
            for (int i = 0; i < _arrForView.count; i++) {
                
                // 取到了当前视图
                UIView *view = [self viewWithTag:1000+[_arrForView[i] integerValue]];

                for (UIButton *btn6666 in view.subviews) {
                    
                    if (CGColorEqualToColor([btn6666 titleColorForState:UIControlStateNormal].CGColor,FUIColorFromRGB(0x8979ff).CGColor)) {
                        
                        // 已选中状态
                        
                    }else {
                        
                        // 不是已选中状态
                        NSMutableArray *arr = [NSMutableArray arrayWithArray:_arrForSelectId];
                        [arr removeObjectAtIndex:[_arrForView[i] integerValue]];
                        [arr removeObject:@"***"];
                        [arr addObject:[NSString stringWithFormat:@"%ld",btn6666.tag - 100000*[_arrForView[i] integerValue]]];
                        NSSet *set1 = [NSSet setWithArray:arr];
                        
                        NSString *jilu = [[NSString alloc] init];
                        
                        for (int j = 0; j < arrForAllPriceZuhe.count; j++) {
                            
                            NSLog(@"set111111%@",set1);
                            
                            
                            NSSet *set2 = [NSSet setWithArray:[arrForAllPriceZuhe[j] componentsSeparatedByString:@"_"]];
                            
                            NSLog(@"set222222%@",set2);
                            
                            if ([set1 isSubsetOfSet:set2]) {
                                
                                // 有匹配
                                jilu = @"有匹配";
                                NSLog(@"有一次");
                                
                            }else {
                                
                                // 没有匹配
                                
                            }
                        }
                        
                        NSLog(@"jilujilujilu,%@",jilu);
                        
                        if ([jilu isEqualToString:@"有匹配"]) {
                            
                            [self makeBtnStatus:btn6666 andStatus:0];
                            
                        }else {
                            
                            [self makeBtnStatus:btn6666 andStatus:1];
                            
                        }
                        
                        
                    }
                }
                        
            }
        }
        
    }
    
                       
                       
                       
                       
    
    
    
    if (CGColorEqualToColor([btn titleColorForState:UIControlStateNormal].CGColor,FUIColorFromRGB(0xeeeeee).CGColor)) {
    
        // 将选择的清空
        [_arrForSelectId removeAllObjects];
        for (int p = 0; p < _guigeArr.count; p++) {
            
            [_arrForSelectId addObject:@"***"];
        }
        // 将选过的规格清空
        [_arrForView removeAllObjects];
        
        
        
        
        
        // 将选过的规格项保存
        if ([_arrForView containsObject:[NSString stringWithFormat:@"%ld",clickView]]) {
            
            [_arrForSelectId removeObjectAtIndex:clickView];
            [_arrForSelectId insertObject:[NSString stringWithFormat:@"%ld",btnId] atIndex:clickView];
            
        }else {
            
            [_arrForSelectId removeObjectAtIndex:clickView];
            [_arrForView addObject:[NSString stringWithFormat:@"%ld",clickView]];
            [_arrForSelectId insertObject:[NSString stringWithFormat:@"%ld",btnId] atIndex:clickView];
        }
        
        
        // 改变被点击按钮的状态
        UIView *view = [self viewWithTag:1000+clickView];
        for (UIButton *btn1 in view.subviews) {
            
            
            // 把当前规格下所有按钮变为正常状态
            [self makeBtnStatus:btn1 andStatus:0];
            
        }
        // 把点击的按钮，变为选中状态
        [self makeBtnStatus:btn andStatus:2];
        
        
        
        NSMutableArray *arrForPrice = [NSMutableArray array];
        
        // 获取到所有规格项组合
        for (int i = 0; i < _arrZuhe.count; i++) {
            
            NSString *str = [NSString stringWithFormat:@"_%@_",_arrZuhe[i]];
            if ([str rangeOfString:[NSString stringWithFormat:@"_%ld_",btnId]].location != NSNotFound) {
                
                // 有匹配价格
                NSArray *arr = [_arrZuhe[i] componentsSeparatedByString:@"_"];
                //            NSLog(@"arr:%@",arr);
                for (int j = 0; j < arr.count; j++) {
                    
                    [arrForPrice addObject:arr[j]];
                }
            }
        }
        
        
        for (int j = 0; j<_guigeArr.count; j++) {
            
            if (j == clickView) {
                
                // 不再做处理,当前选择的就是此规格的
                
            }else {
                
                // 拿到view
                UIView *view = [self viewWithTag:1000+j];
                // 遍历view上的所有按钮
                for (UIButton *btn2 in view.subviews) {
                    
                    if ([arrForPrice containsObject:[NSString stringWithFormat:@"%ld",btn2.tag - 100000*j]]) {
                        
                        // 这个是匹配项,变为可选状态
                        [self makeBtnStatus:btn2 andStatus:0];
                        
                    }else {
                        
                        // 这个不是匹配项,变为不可选状态
                        [self makeBtnStatus:btn2 andStatus:1];
                    }
                }
            }
        }
        
    }
    
    
    
    NSLog(@"_arrForId:%@",_arrForSelectId);
    
    NSString *mulStr = [[NSString alloc] init];
    
    NSInteger count = 0;
    
    for (int i = 0; i < _arrForSelectId.count; i++) {
        
        if (count == 0) {
            
            mulStr = [NSString stringWithFormat:@"%@",_arrForSelectId[i]];
            
        }else {
            
            mulStr = [NSString stringWithFormat:@"%@_%@",mulStr,_arrForSelectId[i]];
        }
        
        count ++;
        
    }
    
    NSLog(@"mulStr: %@",mulStr);
    
    
    
    
    
    
    
    
    
    if ([_arrForSelectId containsObject:@"***"] == NO) {
        
        
        // 改变按钮颜色和用户可操作状态
        _quanpingouBtn.layer.borderColor = FUIColorFromRGB(0xeeeeee).CGColor;
        _quanpingouBtn.layer.borderWidth = 1.0;
        [_quanpingouBtn setTitleColor:FUIColorFromRGB(0x999999) forState:UIControlStateNormal];
        _quanpingouBtn.userInteractionEnabled = NO;
        
        // 小拼购点击按钮状态，禁用
        _xiaopingouBtn.backgroundColor = FUIColorFromRGB(0xeeeeee);
        [_xiaopingouBtn setTitleColor:FUIColorFromRGB(0x999999) forState:UIControlStateNormal];
        _xiaopingouBtn.userInteractionEnabled = NO;
        
        
        
        
        for (int i = 0; i < _priceArr.count; i++) {
            
            // 判断两个字符串切分的数组是否相同
            NSArray *arr1 = [[_priceArr[i] objectForKey:@"spec_item_ids"] componentsSeparatedByString:@"_"];
            NSArray *arr2 = [mulStr componentsSeparatedByString:@"_"];
            NSString *strBool = [self panduanArrEqual:arr1 andArray:arr2];
            
            
            if ([mulStr isEqualToString:[NSString stringWithFormat:@"%@",[_priceArr[i] objectForKey:@"spec_item_ids"]]]) {
                
                // 改变按钮颜色和用户可操作状态
                _quanpingouBtn.layer.borderColor = FUIColorFromRGB(0x8979ff).CGColor;
                _quanpingouBtn.layer.borderWidth = 1.0;
                [_quanpingouBtn setTitleColor:FUIColorFromRGB(0x8979ff) forState:UIControlStateNormal];
                _quanpingouBtn.userInteractionEnabled = YES;
            }
            
            // 拿到当前选的规格组合的信息
            if ([strBool isEqualToString:@"1"]) {
                
                // 价格
                NSString *strPrice = [_priceArr[i] objectForKey:@"price"];
                // 分类组合编号
                NSString *fenleiZuHeStr = [_priceArr[i] objectForKey:@"spec_item_ids"];
                NSString *fenleiZuHe = [_priceArr[i] objectForKey:@"spec_item_titles"];
                NSString *goodImgUrlStr = [_priceArr[i] objectForKey:@"img"];
                
                
                _priceLb.text = [NSString stringWithFormat:@"%@",strPrice];
                _goodsNum.text = [NSString stringWithFormat:@"商品编号:%@",fenleiZuHeStr];
                [_goodsImgView sd_setImageWithURL:[NSURL URLWithString:goodImgUrlStr] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                
                // 单例保存所选
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:fenleiZuHe forKey:@"zuheName"];
                [user setObject:fenleiZuHeStr forKey:@"zuheCode"];
                [user setObject:strPrice forKey:@"price"];
                [user setObject:goodImgUrlStr forKey:@"imgUrl"];
                [user setObject:@"0" forKey:@"xiaopinId"];
                
                
                
                BOOL xiaopingbool = [[_priceArr[i] objectForKey:@"sub_order_status"] boolValue];
                
                NSLog(@"ifReadOnly value: %@" ,xiaopingbool?@"YES":@"NO");
                
                
                if (xiaopingbool == NO) {
                    
                    // 没有小拼购
                    [_xiaopingouBtnView removeFromSuperview];
                    _centerView.contentSize = CGSizeMake(Width, lbXiaoPinGou.frame.origin.y + lbXiaoPinGou.frame.size.height + 30);
                    
                }else {
                    
                    // 有小拼购
                    
                    NSArray *xiaopingouArr = [_priceArr[i] objectForKey:@"sub_order_config"];
                    
                    NSMutableArray *xiaopinArr = [NSMutableArray array];
                    
                    // 用于点击完小拼购以后修改价格
                    _xiaoPinGouZuheArr = xiaopingouArr;
                    NSLog(@"xiaopingouArr%@",xiaopingouArr);
                    
                    
                    for (int j = 0; j < xiaopingouArr.count; j++) {
                        
                        [xiaopinArr addObject:[xiaopingouArr[j] objectForKey:@"title"]];
                        
                        NSLog(@"%@",xiaopinArr);
                        
                    }
                    
                    // 先清空小拼购视图,再创建小拼购视图,避免循环重复创建后，删不完全
                    [_xiaopingouBtnView removeFromSuperview];
                    [self createXiaoPinGou:xiaopinArr];
                }
            }
        }
    }else {
        
        // 改变按钮颜色和状态
        _quanpingouBtn.layer.borderColor = FUIColorFromRGB(0xeeeeee).CGColor;
        _quanpingouBtn.layer.borderWidth = 1.0;
        [_quanpingouBtn setTitleColor:FUIColorFromRGB(0xeeeeee) forState:UIControlStateNormal];
        _quanpingouBtn.userInteractionEnabled = NO;
        
        // 小拼购
        _xiaopingouBtn.backgroundColor = FUIColorFromRGB(0xeeeeee);
        [_xiaopingouBtn setTitleColor:FUIColorFromRGB(0x999999) forState:UIControlStateNormal];
        _xiaopingouBtn.userInteractionEnabled = NO;
        
        
        
        // 删除所有已记录的组合
        // 删除单例保存所选
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user removeObjectForKey:@"zuheName"];
        [user removeObjectForKey:@"zuheCode"];
        [user removeObjectForKey:@"price"];
        [user removeObjectForKey:@"imgUrl"];
        [user removeObjectForKey:@"xiaopinId"];
        
        
        
        // 删除小拼购
        [_xiaopingouBtnView removeFromSuperview];
        _centerView.contentSize = CGSizeMake(Width, lbXiaoPinGou.frame.origin.y + lbXiaoPinGou.frame.size.height + 30);
    }
    

}

- (void) createXiaoPinGou:(NSArray *)arr {
    
    UIView *guigeView = [self viewWithTag:1000 + _guigeArr.count - 1];
    
    // 小拼购视图
    _xiaopingouBtnView = [KindBtnViewForPinTuan creatBtn:arr];
    [_centerView addSubview:_xiaopingouBtnView];
    [_xiaopingouBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbXiaoPinGou.mas_bottom);
        make.left.equalTo(_centerView);
        make.width.equalTo(@(Width));
        make.height.equalTo(@(guigeView.frame.size.height));
    }];
    
    //遍历这个view，对这个view上btn添加相应的事件
    for (UIButton *btn in _xiaopingouBtnView.subviews) {
        [btn setTitleColor:FUIColorFromRGB(0x4e4e4e) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(xiaoPinClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.userInteractionEnabled = YES;
    }
    
    
    [_xiaopingouBtnView layoutIfNeeded];
    [_centerView layoutIfNeeded];
    
    _centerView.contentSize = CGSizeMake(Width, _xiaopingouBtnView.frame.origin.y + _xiaopingouBtnView.frame.size.height);
}


// 小拼购规格选择点击事件
- (void) xiaoPinClick:(UIButton *)btn {
    
    for (UIButton *btn in _xiaopingouBtnView.subviews) {
        [self makeBtnStatus:btn andStatus:0];
    }
    [self makeBtnStatus:btn andStatus:2];
    
    
    for (int i = 0; i < _xiaoPinGouZuheArr.count; i++) {
        
        if ([[_xiaoPinGouZuheArr[i] objectForKey:@"title"] isEqualToString:[btn titleForState:UIControlStateNormal]]) {
            
            // 价格
            NSString *strPrice = [_xiaoPinGouZuheArr[i] objectForKey:@"price"];
            // 分类组合编号
            NSString *strId = [_xiaoPinGouZuheArr[i] objectForKey:@"id"];
            
            _priceLb.text = [NSString stringWithFormat:@"%@",strPrice];
            
            
            // 单例保存所选
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:strPrice forKey:@"price"];
            [user setObject:strId forKey:@"xiaopinId"];
            
            NSLog(@"price:%@",[user objectForKey:@"price"]);
        }
    }
    
    
    _quanpingouBtn.userInteractionEnabled = NO;
    _quanpingouBtn.layer.borderColor = FUIColorFromRGB(0xeeeeee).CGColor;
    _quanpingouBtn.layer.borderWidth = 1.0;
    [_quanpingouBtn setTitleColor:FUIColorFromRGB(0xeeeeee) forState:UIControlStateNormal];
    
    
    _xiaopingouBtn.backgroundColor = FUIColorFromRGB(0x8979ff);
    [_xiaopingouBtn setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    _xiaopingouBtn.userInteractionEnabled = YES;
    
}


- (void) makeBtnStatus:(UIButton *)btn andStatus:(NSInteger) status{
    
    if (status == 0) {
        // 常规状态
        [btn setTitleColor:FUIColorFromRGB(0x4e4e4e) forState:UIControlStateNormal];
        btn.layer.borderColor = [[UIColor colorWithRed:238/255.0 green:239/255.0 blue:239/255.0 alpha:1.0] CGColor];
    }
    
    if (status == 1) {
        // 不可选状态
        [btn setTitleColor:FUIColorFromRGB(0xeeeeee) forState:UIControlStateNormal];
        btn.layer.borderColor = [[UIColor colorWithRed:238/255.0 green:239/255.0 blue:239/255.0 alpha:1.0] CGColor];
    }
    if (status == 2) {
        // 选中状态
        [btn setTitleColor:FUIColorFromRGB(0x8979ff) forState:UIControlStateNormal];
        btn.layer.borderColor = FUIColorFromRGB(0x8979ff).CGColor;
    }
}





- (NSString *) panduanArrEqual:(NSArray *)arr1 andArray:(NSArray *)arr2 {
    
    NSArray *array1 = arr1;
    NSArray *array2 = arr2;
    bool bol = false;
    
    //创建俩新的数组
    NSMutableArray *oldArr = [NSMutableArray arrayWithArray:array1];
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:array2];
    
    //对数组1排序。
    [oldArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return obj1 > obj2;
    }];
    
    ////上个排序好像不起作用，应采用下面这个
    [oldArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2){return [obj1 localizedStandardCompare: obj2];}];
    
    //对数组2排序。
    [newArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return obj1 > obj2;
    }];
    ////上个排序好像不起作用，应采用下面这个
    [newArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2){return [obj1 localizedStandardCompare: obj2];}];
    
    
    if (newArr.count == oldArr.count) {
        
        bol = true;
        for (int16_t i = 0; i < oldArr.count; i++) {
            
            id c1 = [oldArr objectAtIndex:i];
            id newc = [newArr objectAtIndex:i];
            
            if (![newc isEqualToString:c1]) {
                bol = false; 
                break; 
            } 
        } 
    } 
    
    if (bol) {  
        
        // 相等
        return @"1";
    }  
    else {  
        
        // 不相等
        return @"0";
    }
}





@end
