//
//  WBGTextTool.h
//  CLImageEditorDemo
//
//  Created by Jason on 2017/3/1.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXFDrawBoardStyle.h"

@class WBGTextView;

@interface WBGTextTool : NSObject
@property (nonatomic, copy) void(^dissmissTextTool)(NSString *currentText);//, BOOL isEditAgain);
@property (nonatomic, strong) WBGTextView *textView;
@property (nonatomic, assign) BOOL isEditAgain;
@property (nonatomic, copy)   void(^editAgainCallback)(NSString *text);
@property (nonatomic, copy)   void(^addNewTextCallback)(NSString *text);

- (void)hideTextBorder;
- (void)showTextBorder;
@end


@interface WBGTextView : UIView

@property (nonatomic, strong) UIView *effectView;
@property (nonatomic, copy) void(^dissmissTextTool)(NSString *currentText, BOOL isUse);//, BOOL isEditAgain);
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) LXFDrawBoardStyle *boardStyle;


- (void)hideTextBorder;
- (void)showTextBorder;

@end
