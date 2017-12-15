//
//  testViewController.m
//  EasyLink
//
//  Created by 琦琦 on 2017/5/11.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "testViewController.h"

@interface testViewController ()

@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    NSString *key = [NSString set32bitString:16];
//    NSLog(@"key:%@",key);
    
    
//    NSDate *senddate = [NSDate date];
//    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    
//    NSLog(@"shijiancuo:%@",date2);
//    
//    NSDictionary *dic = @{@"requestTime":date2};
//    
//    NSString *jsonStr = [MakeJson createJson:dic];
//    NSLog(@"jsonStr:%@",jsonStr);
    
//    jsonStr = @"requestTime1494468389";
//    jsonStr = @"requestTime149";
////    jsonStr = @"haha";
//    
//    NSString *cgStr = [jsonStr AES128EncryptWithKey:@"d718y67w21s56u1i"];
//    NSLog(@"cgMiwen:%@",cgStr);
    
    
    NSString *mingwen = @"{\"requestTime\":1494485419}";
    NSString *key = @"hZnpQ4mWH3OR3tIJ";
    
    NSString *jiamihou = [mingwen AES128EncryptWithKey:key];
    NSString *jiemihou = [@"3bxk%2FR5daRKgBH5BUxt0DKNUSBARbnHrJZG6MQSEmpQ8Nt%2BjsM0SfD0H2FfjwyekzaEKhL1H5KfkHaiIr4CyNcJipsWKcIr%2BFzjKnUZY6oGZLjDH%2FttOvaOcg%2BJxfUL%2B" AES128DecryptWithKey:key];
    
    NSLog(@"明文：%@",mingwen);
    NSLog(@"key:%@",key);
    NSLog(@"加密后:%@",jiamihou);
    NSLog(@"解密后:%@",jiemihou);
    
    
    // 再用本地保留的私钥进行rsa解密获取服务器的key
    NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];
    NSString *keyForSever = [RSAEncryptor decryptString:@"FTy0IVCc572krMsjYm9b8JGnj5iJrSYDasxPrksjtmOaC36aLMs%2BnKc1GQOYJGnKRILZQ7TlXJi%2Bd3%2BIN1Y2GMlxcSV3bjVZFXquh3D3ZTazM2X4%2BZk6RN%2BBW9f9QmBBOfXAor1HKRaQtdWgn3DNJb0JyIm%2BsEA%2BqdUAqMcD%2Bxs%3D" privateKeyWithContentsOfFile:private_key_path password:@"123456easylink"];
    NSLog(@"测试解密后:%@",keyForSever);
    
    
    NSString *strdata = [@"TG%2BHAr2CcNxdxGbQW1wVJQ3vOe9gb%2FrW0bjI20lqX90KfACW2%2FSXn%2B32Wm9vf0EALw3CqI%2FuuelD1LJY36Ofj2k1OVj9M22HXvZQj1z8h7JTZAO1JeSBUSHF%2BliE3P2PtpWezGjtJodrUE%2FWyIRNxQ%2FEBbmd0egrr7pSpcxV%2FGRBnPSBFf8GRV%2FuuT%2BlCIbeZSk2U%2FCGSoC76DcUAzj%2BMlVIgrs3XabtEvz0liR%2FGl6FVzWuQaqLx%2FX%2BMvnpL277bGOYwo0wt9v3Tqrn8fhh0BZbtfbkJW6vFdxEfWkukGDTdxaUUI7DhvzIf1vPJWY3NClZtsTTJsbi1BdCVmYhGz1phIg%2FyuFnM6yCpcw0DrR8%2F0vkJXvebg7VUAzd1F0WRyiLdmkrDyuxzM8GNLyqDw%3D%3D" AES128DecryptWithKey:keyForSever];
    NSLog(@"strData:%@",strdata);
    
    
    
    
    
//    NSLog(@"jiehuiqu :%@",[cgStr AES128DecryptWithKey:key]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
