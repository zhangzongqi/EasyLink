//
//  SelectGuiGeCollectionViewCell.h
//  EasyLink
//
//  Created by 琦琦 on 17/3/7.
//  Copyright © 2017年 fengdian. All rights reserved.
//  选择规格视图

#import <UIKit/UIKit.h>

@interface SelectGuiGeView : UIView {
    
    NSArray *_priceArr; // 价格组合数组
    NSMutableArray *_guigeArr; // 规格数组
    NSMutableArray *_btnIdArr; // 按钮的id (tag)
    
    NSMutableArray *_arrZuhe; // 所有的组合
    
    NSMutableArray *_arrForView; // 记录下已选择的View
    
    NSMutableArray *_arrForSelectId; // 记录下已选择的id
    
//    NSInteger beforeClickView;  //上次选的规格 
    NSInteger beforeClickId; // 上次点击的id
    
    // 小拼购
    UILabel *lbXiaoPinGou;
    
    // 保存小拼购组合的数组
    NSArray *_xiaoPinGouZuheArr;
}


@property (nonatomic, strong) UIView *topView; // 顶部视图
@property (nonatomic, strong) UIImageView *goodsImgView;
@property (nonatomic, strong) UILabel *priceLb; // 价格
@property (nonatomic, strong) UILabel *goodsNum; // 编号
@property (nonatomic, strong) UIButton *closeBtn; // 关闭按钮
@property (nonatomic, strong) UIView *bottomView; // 底部视图
@property (nonatomic, strong) UIButton *xiaopingouBtn; // 小拼购
@property (nonatomic, strong) UIButton *quanpingouBtn; // 全拼购
@property (nonatomic, strong) UIScrollView *centerView; // 中间滚动视图
@property (nonatomic, strong) UIButton *NumSubBtn; // 减号按钮
@property (nonatomic, strong) UIButton *NumAddBtn; // 加号按钮
@property (nonatomic, strong) UILabel *BuyNumberLb; // 购买数量
@property (nonatomic, strong) UIView *xiaopingouBtnView; // 小拼购按钮视图

// 初始化筛选视图
- (id) initWithFrame:(CGRect)frame WithFenLeiArr:(NSArray *)FenleiArr andPriceArr:(NSArray *)priceArr;


@end
