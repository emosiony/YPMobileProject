//
//  TGPlayerView.h
//  TGParent
//
//  Created by lwc on 2018/8/23.
//  Copyright © 2018年 jzg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLPlayerView.h"

@interface TGPlayerView : UIView

@property (copy, nonatomic) NSString *videoUrl;

@property (nonatomic,assign, readonly) CLPlayerState state;

@property (nonatomic,copy) void(^playEndBlock)();

- (void)play;

- (void)stop;

- (void)destroyPlayer;

@end
