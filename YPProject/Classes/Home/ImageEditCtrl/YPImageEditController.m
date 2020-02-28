//
//  YPImageEditViewController.m
//  YPProject
//
//  Created by 幸福e家 on 2020/2/16.
//  Copyright © 2020 jzg. All rights reserved.
//

#import "YPImageEditController.h"
#import "YPImageEditView.h"

@interface YPImageEditController ()

@property (nonatomic, strong) YPImageEditView *imageEditView;

@end

@implementation YPImageEditController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.imageEditView];
    [self.imageEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    NSMutableArray *muList = [NSMutableArray array];
    [muList addObject:@"http://a1.att.hudong.com/05/00/01300000194285122188000535877.jpg"];
    [muList addObject:@"http://a4.att.hudong.com/47/66/01300000337727123266663353910.jpg"];
    [muList addObject:@"http://a1.att.hudong.com/05/00/01300000194285122188000535877.jpg"];
    [muList addObject:@"http://a4.att.hudong.com/47/66/01300000337727123266663353910.jpg"];
    [muList addObject:@"http://a1.att.hudong.com/05/00/01300000194285122188000535877.jpg"];

    self.imageEditView.photos = muList;
}

-(YPImageEditView *)imageEditView {
    
    if (_imageEditView == nil) {
        _imageEditView = [YPImageEditView viewFromXib];
    }
    return _imageEditView;
}

@end
