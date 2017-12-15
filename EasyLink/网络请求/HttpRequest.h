//
//  HttpRequest.h
//  EasyLink
//
//  Created by 琦琦 on 2017/5/2.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AddressModel.h" // 地址模型
#import "HomeDataModel.h" // 首页拼团数据模型
#import "PingJiaModel.h" // 评价模型
#import "CategoryListModel.h" // 分类的类型模型
#import "UserAddressModel.h" // 用户收货地址模型

#define STRPATH @"http://app.huopinb.com"

@interface HttpRequest : NSObject

// 数据请求
+ (void)postWithURL:(NSString *)str andDic:(NSDictionary *)dic success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

// 获取公共rsa公钥
- (void) GetRSAPublicKeySuccess:(void(^)(id strPublickey))success failure:(void (^)(NSError *error))failure;

// 获取验证码
- (void) PostPhoneCodeWithDic:(NSDictionary *)datedic Success:(void(^)(id status))success failure:(void (^)(NSError *error))failure;

// 注册
- (void) PostRegisterWithDic:(NSDictionary *)datedic Success:(void(^)(id userDataJsonStr))success failure:(void (^)(NSError *error))failure;

// 登录
- (void) PostLoginWithDic:(NSDictionary *)datedic Success:(void(^)(id userDataJsonStr))success failure:(void (^)(NSError *error))failure;

// 核对验证码
- (void) PostCheckCodeWithDic:(NSDictionary *)datedic Success:(void(^)(id confirmCode))success failure:(void (^)(NSError *error))failure;

// 重置密码
- (void) PostResetPassWordWithDic:(NSDictionary *)datadic Success:(void(^)(id resetMessage))success failure:(void (^)(NSError *error))failure;

// 修改密码
- (void) PostRevisePassWordWithDic:(NSDictionary *)datadic Success:(void(^)(id resetMessage))success failure:(void (^)(NSError *error))failure;

// 获取城市
- (void) GetAddressWithPid:(NSString *)strPid Success:(void(^)(id addressMessage))success failure:(void (^)(NSError *error))failure;

// 获取用户资料
- (void) PostUserInfoWithDic:(NSDictionary *)userInfoDic Success:(void(^)(id userInfo))success failure:(void (^)(NSError *error))failure;

// 修改用户头像
//- (void) PostReviseUserIconWithDic:(NSDictionary *)userInfoData Success:(void(^)(id userInfo))success failure:(void (^)(NSError *error))failure;

// 修改用户头像
- (void)testUploadImageWithPost:(NSDictionary *)dic andImg:(UIImage *)image Success:(void(^)(id arrForDetail))success failure:(void (^)(NSError *error))failure;

// 修改用户资料
- (void) PostReviseUserInfoWithDic:(NSDictionary *)userInfoData Success:(void(^)(id userInfo))success failure:(void (^)(NSError *error))failure;


// 上传图片
- (void) PostImgToServerWithUserInfo:(NSDictionary *)dic andImg:(UIImage *)image Success:(void(^)(id arrForDetail))success failure:(void (^)(NSError *error))failure;

// 上传评价
- (void) PostAddPingjiaWithDic:(NSDictionary *)userInfoDic Success:(void(^)(id arrForDetail))success failure:(void (^)(NSError *error))failure;


// 添加浏览历史
- (void) PostAddHisWithDic:(NSDictionary *)userInfoData Success:(void(^)(id userInfo))success failure:(void (^)(NSError *error))failure;

// 添加收藏
- (void) PostAddFavWithDic:(NSDictionary *)userInfoData Success:(void(^)(id userInfo))success failure:(void (^)(NSError *error))failure;


// 删除历史浏览
- (void) PostDelHisWithDic:(NSDictionary *)userInfoData Success:(void(^)(id userInfo))success failure:(void (^)(NSError *error))failure;

// 删除收藏
- (void) PostDelFavWithDic:(NSDictionary *)userInfoData Success:(void(^)(id userInfo))success failure:(void (^)(NSError *error))failure;

// 获取用户浏览历史
- (void) PostUserHisWithDic:(NSDictionary *)userInfoData Success:(void(^)(id GetData))success failure:(void (^)(NSError *error))failure;

// 获取用户所有收藏
- (void) PostUserAllFavDic:(NSDictionary *)userInfoData Success:(void(^)(id GetData))success failure:(void (^)(NSError *error))failure;

// 获取用户页面收藏列表
- (void) PostUserFavListDic:(NSDictionary *)userInfoData Success:(void(^)(id GetData))success failure:(void (^)(NSError *error))failure;

// 获取商品分类
- (void) GetGoodsCategorySuccess:(void (^)(id arrForList))success failure:(void (^)(NSError *error))failure;

// 获取首页拼团数据
- (void) GetHomeDataForCategory:(NSInteger)category andKeyWord:(NSString *)keyWord andOrderKey:(NSInteger)orderKey andOrderBy:(NSInteger)orderby andPageStart:(NSInteger)pageStart andPageSize:(NSInteger)pageSize Success:(void (^)(id arrForList))success failure:(void (^)(NSError *error))failure;

// 获取评价数据
- (void) GetPingjiaDataFromId:(NSInteger)groupBuyId andpageStart:(NSInteger) pageStart Success:(void (^)(id arrForpingjiaList))success failure:(void (^)(NSError *error))failure;

// 获取推荐评价数据
- (void) GetTuijianPingjiaDataFromId:(NSInteger)groupBuyId Success:(void (^)(id arrForpingjiaList))success failure:(void (^)(NSError *error))failure;

// 获取团购详细数据
- (void) GetGoodsDetailDataForId:(NSString *) goodsId Success:(void (^)(id arrForGoodsData))success failure:(void (^)(NSError *error))failure;

// 获取团购详情下面的HTML数据
- (void) GetGoodsDetatilHtmlDataForId:(NSString *) id1 Success:(void (^)(id goodsHtmlData))success failure:(void (^)(NSError *error))failure;

// 获取全部订单列表
- (void) PostGetAllOrderListWithDicData:(NSDictionary *)dicData Success:(void (^)(id allOrderList))success failure:(void (^)(NSError *error))failure;

// 生成订单
- (void) PostMakeOderWithDicData:(NSDictionary *)dicData Success:(void (^)(id oderMessage))success failure:(void (^)(NSError *error))failure;


// 获取快递是否可以配送
- (void) GetGoodsCanDistributionWithId:(NSInteger) id1 andRegionId:(NSInteger) regionId Success:(void (^)(id arrForGoodsData))success failure:(void (^)(NSError *error))failure;

// 获取快递价格
- (void) PostGetfastMailWithDataDic:(NSDictionary *)dic Success:(void (^)(id arrForGoodsData))success failure:(void (^)(NSError *error))failure;


// 计算商品总价格
- (void) PostGetGoodsFinalPriceWithDataDic:(NSDictionary *)dicdata Success:(void (^)(id arrForGoodsData))success failure:(void (^)(NSError *error))failure;


// 添加用户收货地址
- (void) PostAddUserAddressWithDataDic:(NSDictionary *)dicData Success:(void (^)(id messageData))success failure:(void (^)(NSError *error))failure;

// 修改用户收货地址
- (void) PostXiugaiAddressWithDataDic:(NSDictionary *)dicData Success:(void (^)(id messageData))success failure:(void (^)(NSError *error))failure;

// 删除用户收货地址
- (void) PostDeleteAddressWithDicData:(NSDictionary *)dicData Success:(void (^)(id messageData))success failure:(void (^)(NSError *error))failure;

// 获取用户全部收货地址
- (void) PostGetUserAllAddressWithDicData:(NSDictionary *)dicData Success:(void (^)(id messageData))success failure:(void (^)(NSError *error))failure;

// 获取banner
- (void) GetBannerListWithPosition:(NSInteger) position Success:(void (^)(id bannerList))success failure:(void (^)(NSError *error))failure;

// 获取帮助列表
- (void) GetHelpListSuccess:(void (^)(id helpList))success failure:(void (^)(NSError *error))failure;

// 获取帮助详情
- (void) GetHelpListDetailWithId:(NSString *) strId Success:(void (^)(id helpDetailDic))success failure:(void (^)(NSError *error))failure;


// 获取推荐数据列表
- (void) PostGetRecommendedListWithDic:(NSDictionary *)dic Success:(void (^)(id RecommendedListDic))success failure:(void (^)(NSError *error))failure;

// 判断用户是否登录超时
- (void) PostPanduanUserTimeOutWithDic:(NSDictionary *)dic Success:(void (^)(id statusInfo))success failure:(void (^)(NSError *error))failure;


// 转换时间戳方法
- (NSString *)stringFromDate:(NSDate *)date;


// 弹出提示
- (void) GetHttpDefeatAlert:(NSString *)str;


@end
