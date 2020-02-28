//
//  WBGTextTool.m
//  CLImageEditorDemo
//
//  Created by Jason on 2017/3/1.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGTextTool.h"
//#import "FrameAccessor.h"
//#import "WBGTextColorPanel.h"
//#import "WBGChatMacros.h"
#import "WBGNavigationBarView.h"
//#import "EXTobjc.h"
//#import "WBGDrawView.h"
//#import "WBGTextToolOverlapView.h"
//#import <XXNibBridge/XXNibBridge.h>


static const CGFloat kTopOffset = 50.f;
static const CGFloat kTextTopOffset = 60.f;
static const NSInteger kTextMaxLimitNumber = 100;

@interface WBGTextTool ()

@end

@implementation WBGTextTool

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.textView = [[WBGTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.textView.textView.textColor = [UIColor whiteColor];
    
    [self setupActions];
    
    UIWindow *keyWidow = [UIApplication sharedApplication].keyWindow;
    [keyWidow addSubview:self.textView];
}

- (void)setupActions
{
    WeakSelf();
    self.textView.dissmissTextTool = ^(NSString *currentText, BOOL isUse) {
        StrongSelf();
        if (strongself.isEditAgain) {
            if (strongself.editAgainCallback && isUse) {
                strongself.editAgainCallback(currentText);
            }
            strongself.isEditAgain = NO;
        } else {
            if (strongself.addNewTextCallback && isUse) {
                strongself.addNewTextCallback(currentText);
            }
        }
        
        if (strongself.dissmissTextTool) {
            strongself.dissmissTextTool(currentText);
        }
    };
    
    [RACObserve(self.textView.boardStyle, textColor) subscribeNext:^(id  _Nullable x) {
        StrongSelf();
        [strongself changeColor:strongself.textView.boardStyle.textColor];
    }];
}

#pragma mark - implementation 重写父方法
- (void)cleanup
{
    [self.textView removeFromSuperview];
}

- (UIView *)drawView
{
    return nil;
}

- (void)changeColor:(UIColor *)color
{
    if (color && self.textView)
    {
        [self.textView.textView setTextColor:color];
    }
}

- (void)hideTextBorder {
    
    [self.textView hideTextBorder];
}

- (void)showTextBorder {
    
    [self.textView showTextBorder];
}

@end

#pragma mark - WBGTextView
@interface WBGTextView () <UITextViewDelegate>

@property (nonatomic, strong) NSString *needReplaceString;
@property (nonatomic, assign) NSRange   needReplaceRange;
@property (nonatomic, strong) WBGNavigationBarView *navigationBarView;

@end

@implementation WBGTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.effectView = [[UIView alloc] init];
        self.effectView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f];
        self.effectView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self addSubview:self.effectView];
        
        self.navigationBarView = [WBGNavigationBarView viewFromXib];
        self.navigationBarView.frame = CGRectMake(0, 0, kScreenWidth, [WBGNavigationBarView fixedHeight]);
        [self addSubview:self.navigationBarView];
        
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.navigationBarView.frame), kScreenWidth - 16 * 2, kScreenHeight - kTopOffset - CGRectGetMaxY(self.navigationBarView.frame))];
        self.textView.scrollEnabled = YES;
        self.textView.returnKeyType = UIReturnKeyDone;
        self.textView.delegate = self;
        self.textView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.textView];
        
        [self setupActions];
        [self addNotify];
    }
    
    return self;
}

- (void)setBoardStyle:(LXFDrawBoardStyle *)boardStyle {
    
    _boardStyle = boardStyle;
    
//    self.textView.font = [UIFont boldSystemFontOfSize:boardStyle.textSize];
//    self.textView.textColor = boardStyle.textColor;
}

- (void)setupActions
{
    __weak __typeof(self)weakSelf = self;
    
    self.navigationBarView.onDoneButtonClickBlock = ^(UIButton *btn) {
        [weakSelf dismissTextEditing:YES];
    };
    
    self.navigationBarView.onCancelButtonClickBlock = ^(UIButton *btn) {
        [weakSelf dismissTextEditing:NO];
    };
}

- (void)hideTextBorder {
    
    [self.textView resignFirstResponder];

//    [UIView animateWithDuration:0.25 animations:^{
//        [self.textView resignFirstResponder];
//        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
//    }];
}

- (void)showTextBorder {
    
    [self.textView becomeFirstResponder];
//    [UIView animateWithDuration:0.25 animations:^{
//        [self.textView becomeFirstResponder];
//        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//    }];
}

- (void)addNotify
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userinfo = notification.userInfo;
    CGRect  keyboardRect              = [[userinfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardAnimationDuration = [[userinfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions keyboardAnimationCurve = [[userinfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    
    self.hidden = YES;
    [UIView
     animateWithDuration:keyboardAnimationDuration
     delay:keyboardAnimationDuration
     options:keyboardAnimationCurve
     animations:^{
        
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    } completion:NULL];
    
    [UIView animateWithDuration:3 animations:^{
        self.hidden = NO;
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userinfo = notification.userInfo;
    CGFloat keyboardAnimationDuration = [[userinfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions keyboardAnimationCurve = [[userinfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    
    [UIView animateWithDuration:keyboardAnimationDuration delay:0.f options:keyboardAnimationCurve animations:^{
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissTextEditing:(BOOL)done
{
    [self hideTextBorder];
    
    if (self.dissmissTextTool)
    {
        self.dissmissTextTool(self.textView.text, done);
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.textView becomeFirstResponder];
            [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length-1, 0)];
        });
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    // 选中范围的标记
    UITextRange *textSelectedRange = [textView markedTextRange];
    // 获取高亮部分
    UITextPosition *textPosition = [textView positionFromPosition:textSelectedRange.start offset:0];
    // 如果在变化中是高亮部分在变, 就不要计算字符了
    if (textSelectedRange && textPosition)
    {
        return;
    }
    
    // 文本内容
    NSString *textContentStr = textView.text;
    NSInteger existTextNumber = textContentStr.length; // 所以在这里为了提高效率不在判断
    
    if (existTextNumber > kTextMaxLimitNumber)
    {
        // 截取到最大位置的字符(由于超出截取部分在should时被处理了,所以在这里为了提高效率不在判断)
        NSString *str = [textContentStr substringToIndex:kTextMaxLimitNumber];
        [textView setText:str];
        //[AlertBox showMessage:@"输入字符不能超过100\n多余部分已截断" hideAfter:3];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self dismissTextEditing:YES];
        return NO;
    }
    
    NSString *newText = [self.textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger newTextLength = [self countString:newText];
    
    if (newTextLength > kTextMaxLimitNumber)
    {
        
        __block NSInteger idx = 0;
        __block NSMutableString *trimString = [NSMutableString string]; // 截取出的字串
        
        [newText
         enumerateSubstringsInRange:NSMakeRange(0, [newText length])
         options:NSStringEnumerationByComposedCharacterSequences
         usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop)
         {
            NSInteger steplen = substring.length;
            if ([substring canBeConvertedToEncoding:NSASCIIStringEncoding])
            {
                steplen = 1;
            }
            else
            {
                steplen = steplen * 2;
            }
            
            idx = idx + steplen;
            
            if (idx > kTextMaxLimitNumber)
            {
                *stop = YES; // 取出所需要就break，提高效率
            }
            else
            {
                [trimString appendString:substring];
            }
        }];
        
        self.textView.text = trimString;
        
        return NO;
    }
    else
    {
        return YES;
    }
}

- (NSInteger)countString:(NSString *)string
{
    __block NSInteger length = 0;
    
    [string
     enumerateSubstringsInRange:NSMakeRange(0, [string length])
     options:NSStringEnumerationByComposedCharacterSequences
     usingBlock:^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop)
     {
        NSInteger steplen = substring.length;
        
        if ([substring canBeConvertedToEncoding:NSASCIIStringEncoding])
        {
            length += 1;
        }
        else
        {
            length += steplen * 2;
        }
    }];
    
    return length;
}

@end
