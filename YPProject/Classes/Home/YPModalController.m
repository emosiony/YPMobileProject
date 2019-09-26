



//
//  YPModalController.m
//  YPProject
//
//  Created by 姚敦鹏 on 2019/9/26.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "YPModalController.h"

@interface YPModalController ()

@end

@implementation YPModalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            
            UIColor *color = HEXColor(0x123456);
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                color = HEXColor(0x567890);
            }
            return color;
        }];
    } else {
        self.view.backgroundColor = HEXColor(0x123456);
    }
    
    UIButton *back = [UIButton new];
    [self.view addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(50);
    }];
    
    back.backgroundColor = HEXColor(0x654321);
    [back setTitle:@"back" forState:(UIControlStateNormal)];
    [back setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [back addTarget:self action:@selector(backClick) forControlEvents:(UIControlEventTouchUpInside)];

}

-(void)backClick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
