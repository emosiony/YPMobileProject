

//
//  YPHomeViewController.m
//  YPProject
//
//  Created by Jtg_yao on 2019/8/12.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "YPHomeViewController.h"
#import "BaseWKWebViewController.h"

@interface YPHomeViewController ()

@end

@implementation YPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self changeModalTransStyle];
//    BaseWKWebViewController *webView = [[BaseWKWebViewController alloc] init];
//    webView.url = @"https://www.runoob.com/try/try.php?filename=tryhtml5_input_type_file";
//    [self.navigationController pushViewController:webView animated:YES];
}

- (void)changeModalTransStyle {
    
    [YPProgressHUD yp_showHUDMessage:@"hello kitty"];
}

@end
