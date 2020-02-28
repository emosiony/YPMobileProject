

//
//  YPHomeViewController.m
//  YPProject
//
//  Created by Jtg_yao on 2019/8/12.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "YPHomeViewController.h"
#import "YPImageEditController.h"

#import "PLVLiveViewController.h"
#import <PolyvCloudClassSDK/PLVLiveVideoAPI.h>
#import <PolyvCloudClassSDK/PLVLiveVideoConfig.h>

@interface YPHomeViewController ()

@end

@implementation YPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 200, 54)];
    btn.backgroundColor = HEXColor(0x123456);
    [btn addTarget:self action:@selector(tapClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:btn];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, 200, 54)];
    btn1.backgroundColor = HEXColor(0x123456);
    [btn1 addTarget:self action:@selector(tapClick1) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:btn1];
}

- (void)tapClick {
    
    YPImageEditController *editVC = [[YPImageEditController alloc] init];
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)tapClick1 {
    
    __weak typeof(self) weakSelf = self;
    
    PLVLiveVideoConfig *liveConfig = [PLVLiveVideoConfig sharedInstance];
    liveConfig.channelId = @"776616";

    [PLVLiveVideoAPI verifyPermissionWithChannelId:liveConfig.channelId.integerValue vid:nil appId:liveConfig.appId userId:liveConfig.userId appSecret:liveConfig.appSecret completion:^(NSDictionary * info) {
        
        [PLVLiveVideoAPI liveStatus:liveConfig.channelId completion:^(BOOL liveing, NSString *liveType) {
            // 弹出直播页面
            // 回调参数 liveType 将会表明该频道，是什么类型的直播间(普通直播 / 三分屏直播)
            [weakSelf presentToLiveViewControllerFromViewController:weakSelf liveing:liveing lievType:liveType];
        } failure:^(NSError *error) {
            // error.localizedDescription 包含错误描述
            // 建议在此弹窗提示用户
        }];
        
    } failure:^(NSError *error) {
        // 配置验证失败
    }];
}

- (void)presentToLiveViewControllerFromViewController:(UIViewController *)vc liveing:(BOOL)liveing lievType:(NSString *)liveType {
    PLVLiveViewController *liveVC = [PLVLiveViewController new];
    liveVC.liveType = [@"ppt" isEqualToString:liveType] ? PLVLiveViewControllerTypeCloudClass : PLVLiveViewControllerTypeLive;
    liveVC.playAD = !liveing;
    [vc presentViewController:liveVC animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

@end
