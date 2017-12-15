//
//  AllPingJiaTableViewCell.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/12.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "AllPingJiaTableViewCell.h"
#import "PingjiaTupianCollectionViewCell.h" // 评价图片
#import "ZLShowBigImage.h" // 查看大图

#define Width self.frame.size.width
#define Height self.frame.size.height


@implementation AllPingJiaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        // 头像
        _touxiangImgView = [[UIImageView alloc] init];
        [self addSubview:_touxiangImgView];
        [_touxiangImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(Width * 0.03125);
            make.left.equalTo(self).with.offset(Width * 0.03125);
            make.height.equalTo(@(Width * 0.103125));
            make.width.equalTo(@(Width * 0.103125));
        }];
        _touxiangImgView.layer.cornerRadius = Width * 0.103125 / 2;
        _touxiangImgView.clipsToBounds = YES;
        
        // 昵称
        _nicknameLb = [[UILabel alloc] init];
        [self addSubview:_nicknameLb];
        [_nicknameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self).with.offset(0.046875 * Width);
            make.left.equalTo(_touxiangImgView.mas_right).with.offset(Width * 0.0203125);
            if (iPhone6SP) {
                make.height.equalTo(@(15));
                _nicknameLb.font = [UIFont systemFontOfSize:15];
            }else if (iPhone6S) {
                make.height.equalTo(@(14));
                _nicknameLb.font = [UIFont systemFontOfSize:14];
            }else {
                make.height.equalTo(@(13));
                _nicknameLb.font = [UIFont systemFontOfSize:13];
            }
        }];
        _nicknameLb.textColor = FUIColorFromRGB(0x212121);
        
        // 日期
        _dateLb = [[UILabel alloc] init];
        [self addSubview:_dateLb];
        [_dateLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(- Width * 0.03125);
            make.bottom.equalTo(_nicknameLb);
            if (iPhone6SP) {
                make.height.equalTo(@(13));
                _dateLb.font = [UIFont systemFontOfSize:13];
            }else if (iPhone6S) {
                make.height.equalTo(@(12));
                _dateLb.font = [UIFont systemFontOfSize:12];
            }else {
                make.height.equalTo(@(11));
                _dateLb.font = [UIFont systemFontOfSize:11];
            }
        }];
        _dateLb.textColor = FUIColorFromRGB(0x999999);
        
        // 评价
        _pingjiaLb = [[UILabel alloc] init];
        [self addSubview:_pingjiaLb];
        [_pingjiaLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nicknameLb.mas_bottom).with.offset(0.034375 * Width);
            make.left.equalTo(_nicknameLb);
            make.right.equalTo(_dateLb);
        }];
        _pingjiaLb.textColor = FUIColorFromRGB(0x999999);
        _pingjiaLb.font = [UIFont systemFontOfSize:12];
        _pingjiaLb.numberOfLines = 0;
        
        // 星级视图
        _bar = [[RatingBar alloc] initWithFrame:CGRectMake(0, 0, 84, 12)];
        [self addSubview:_bar];
        [_bar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_nicknameLb);
            make.left.equalTo(_nicknameLb.mas_right);
            make.width.equalTo(@(84));
            make.height.equalTo(@(12));
        }];
        
        
        // 图片collectionview
        // 先给表格创建它的布局对象
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        // 设置间距为0
        flow.minimumInteritemSpacing = 10;
        flow.minimumLineSpacing = 10;
        // 设置该布局的滚动方向
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal; // 横向
        // 新建_collectionView
        _tupianCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(_pingjiaLb.frame.origin.x, _pingjiaLb.frame.origin.y + _pingjiaLb.frame.size.height, Width, Width * 0.26875) collectionViewLayout:flow];
        // 背景色
        _tupianCollection.backgroundColor = FUIColorFromRGB(0xffffff);
        // 设置滚动条隐藏
        _tupianCollection.showsVerticalScrollIndicator = NO;
        _tupianCollection.showsHorizontalScrollIndicator = NO;

        _tupianCollection.delegate = self;
        _tupianCollection.dataSource = self;

        [_tupianCollection registerClass:[PingjiaTupianCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

        // 添加到当前页面
        [self addSubview:_tupianCollection];
        [_tupianCollection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_pingjiaLb.mas_bottom);
            make.left.equalTo(_pingjiaLb);
            make.right.equalTo(_pingjiaLb);
            make.height.equalTo(@(Width * 0.26875));
        }];
    }
    
    return self;
}

- (void) giveArrForTupian:(NSArray *)arr {

    [_tupianArr removeAllObjects];
    
    _tupianArr = [NSMutableArray arrayWithArray:arr];
    
    [_tupianCollection reloadData];
}

#pragma mark -----UICollectionViewDelegate/UICollectionViewDataSource
// 每个分区的cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    // 返回的个数
    if (_tupianArr.count == 0) {
        _tupianCollection.hidden = YES;
    }else {
        _tupianCollection.hidden = NO;
    }
    
    return _tupianArr.count;
}

// 绑定数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PingjiaTupianCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
//    cell.pingjiaTupianImgView.image = [UIImage imageNamed:_tupianArr[indexPath.row]];
    [cell.pingjiaTupianImgView sd_setImageWithURL:[NSURL URLWithString:_tupianArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.pingjiaTupianImgView.clipsToBounds = YES;
    cell.pingjiaTupianImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    return cell;
}

// 每个cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(Width * 0.26875 * 0.68, Width * 0.26875 * 0.68);
    // Width * 0.26875 此collectionviewCell的高度 *0.68图片高度所占比例
}

// 上左下右距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// collectionview 的选中事件
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    PingjiaTupianCollectionViewCell *cell = (PingjiaTupianCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [ZLShowBigImage showBigImage:cell.pingjiaTupianImgView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
