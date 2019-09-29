

//
//  TGSafeInfoView.m
//  YPProject
//
//  Created by Jtg_yao on 2019/9/9.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "TGSafeInfoView.h"

// 未计算 安全包到期提示高度 和 安全包说明提示高度
#define Show_Height   (43 + (43 + (10*2) + 15 + 43 * 5) + (15*2))
#define Hidden_height 43

#define MinDefaultValue 1
#define MaxDefaultValue 1
#define AddDefaultValue 0.5

#define MAX_INPUT_NAME_NUM  10
#define MAX_INPUT_CARD_NUM  18

@interface TGSafeInfoView ()
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView   *topView;         // 头部
@property (weak, nonatomic) IBOutlet UIImageView *helpImage;    // 头部 -- 问号 图标
@property (weak, nonatomic) IBOutlet UILabel  *titleLabel;      // 头部 -- 标题
@property (weak, nonatomic) IBOutlet UILabel  *priceLabel;      // 头部 -- 价格
@property (weak, nonatomic) IBOutlet UIButton *selectButton;    // 头部 -- 选择按钮
@property (weak, nonatomic) IBOutlet UILabel  *topTipLabel;     // 头部 -- 已购买提示

@property (weak, nonatomic) IBOutlet UIView *middleView;        // 中间

@property (weak, nonatomic) IBOutlet UIButton *minusButton;     // 中间 -- 选择 -- 减号按钮
@property (weak, nonatomic) IBOutlet UITextField *numField;     // 中间 -- 选择 -- 数量
@property (weak, nonatomic) IBOutlet UIButton *addButton;       // 中间 -- 选择 -- 加号按钮

@property (weak, nonatomic) IBOutlet UILabel *safeTipLabel;     // 中间 -- 购买日期提示

@property (weak, nonatomic) IBOutlet UIView *certView;              // 中间 -- 证件类型
@property (weak, nonatomic) IBOutlet UITextField *certTypeField;    // 中间 -- 证件类型 -- 证件类型

@property (weak, nonatomic) IBOutlet UIView *nameView;          // 中间 -- 姓名
@property (weak, nonatomic) IBOutlet UITextField *nameField;    // 中间 -- 姓名 -- 输入框

@property (weak, nonatomic) IBOutlet UIView *certNumView;       // 中间 -- 证件号
@property (weak, nonatomic) IBOutlet UITextField *certNumField; // 中间 -- 证件号 -- 输入框

@property (weak, nonatomic) IBOutlet UIView *dateView;          // 中间 -- 出生日期
@property (weak, nonatomic) IBOutlet UITextField *dateField;    // 中间 -- 出生日期 -- 输入框

@property (weak, nonatomic) IBOutlet UITextField *genderField;  // 中间 -- 性别
@property (weak, nonatomic) IBOutlet UIView *genderView;        // 中间 -- 性别 -- 输入框

@property (weak, nonatomic) IBOutlet UIView *bottomView;        // 底部 -- 安全包说明
@property (weak, nonatomic) IBOutlet UILabel *safeExlainLabel;  // 底部 -- 安全包说明 -- label

@end

@implementation TGSafeInfoView

-(void)awakeFromNib {
    [super awakeFromNib];
    
    ViewRadius(self.minusButton, 3);
    ViewRadius(self.addButton, 3);
    ViewRadius(self.numField, 6.0f);
    
    _minNum = MinDefaultValue;
    _maxNum = MaxDefaultValue;
    
    self.numField.enabled       = NO;
    self.certTypeField.enabled  = NO;
    self.dateField.enabled      = NO;
    self.genderField.enabled    = NO;
    
    self.topTipLabel.hidden    = YES;
    
    self.numField.delegate      = self;
    self.certTypeField.delegate = self;
    self.nameField.delegate     = self;
    self.certNumField.delegate  = self;
    self.dateField.delegate     = self;
    self.genderField.delegate   = self;

    [self.minusButton setImage:IMAGENANED(@"apply_minus_noallow") forState:(UIControlStateNormal)];
    
    [self.helpImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(helpClick)]];
    [self.certView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCertTypeClick)]];
    [self.dateView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDateClick)]];
    [self.genderView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGenderClick)]];
    [self.safeExlainLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapExplainClick)]];
}

#pragma mark -- Delegage
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return (textField == self.nameField || textField == self.certNumField);
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == self.nameField || textField == self.certNumField) {
        NSInteger maxLength = textField == self.nameField ? MAX_INPUT_NAME_NUM : MAX_INPUT_CARD_NUM;
        
        if(string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        NSInteger finalLength = (existedLength-selectedLength+replaceLength);
        
        if(finalLength > maxLength) return NO;
        return YES;
    }
    return YES;
}

#pragma mark -- method
-(void)setNumChangeBlock:(NumChange)numChangeBlock chooseBlock:(ChooseBlock)chooseBlock tapExplainBlock:(TapBlock)tapExplainBlock numWarmBlock:(NumWarmBlock _Nonnull)numWarmBlock updateHeight:(UpdateHeight _Nonnull)updateHeight{
    
    self.numChangeBlock  = numChangeBlock;
    self.chooseBlock     = chooseBlock;
    self.tapExplainBlock = tapExplainBlock;
    self.numWarmBlock    = numWarmBlock;
    self.updateHeight    = updateHeight;
}

#pragma mark -- Setter
-(void)setMinNum:(double)minNum {
    _minNum = minNum;
    if ([self.numField.text doubleValue] < _minNum) {
        self.numField.text = [NSString stringWithFormat:@"%0.1lf",_minNum];
    }
}

-(void)setMaxNum:(double)maxNum {
    _maxNum = maxNum;
    if ([self.numField.text doubleValue] > _maxNum) {
        self.numField.text = [NSString stringWithFormat:@"%0.1lf",_maxNum];
    }
}

-(void)setCurrentNum:(double)currentNum {
    
    if (currentNum < self.minNum) {
        currentNum = self.minNum;
    }
    if (currentNum > self.maxNum) {
        currentNum = self.maxNum;
    }
    
    self.numField.text = [NSString stringWithFormat:@"%0.1lf", currentNum];
}

-(double)currentNum {
    return [self.numField.text doubleValue];
}

-(void)setShowType:(TGSafeShowType)showType {
    
    _showType = showType;
    CGFloat   updateHeight = Hidden_height;
    switch (showType) {
            case TGSafeShowType_showSafe: {
                
                self.topTipLabel.hidden = self.selectButton.hidden = YES;
                CGFloat timeTipHeight = [self.safeTipLabel.text textSizeIn:CGSizeMake(kScreenWidth - 30, MAXFLOAT) font:self.safeTipLabel.font].height + 5;
                CGFloat warmTipHeight = [self.safeExlainLabel.text textSizeIn:CGSizeMake(kScreenWidth - 30, MAXFLOAT) font:self.safeExlainLabel.font].height + 5;
                updateHeight = Show_Height + timeTipHeight + warmTipHeight;
                _titleLabel.text = @"安全包：";
                
                self.middleView.hidden = self.bottomView.hidden = NO;
            }   break;
            case TGSafeShowType_showCourseNor: {
                
                self.topTipLabel.hidden   = YES;
                self.selectButton.hidden   = NO;
                self.selectButton.selected = NO;
                _titleLabel.text = @"安全包：";
                
                self.middleView.hidden = self.bottomView.hidden = YES;
            }   break;
            case TGSafeShowType_showCourseBuy: {
                
                self.selectButton.hidden = YES;
                self.topTipLabel.hidden = NO;
                _titleLabel.text = @"安全包";
                self.priceLabel.hidden = YES;
                self.middleView.hidden = self.bottomView.hidden = YES;
            }   break;
            case TGSafeShowType_showCourseSel: {
                
                self.topTipLabel.hidden   = YES;
                self.selectButton.hidden   = NO;
                self.selectButton.selected = YES;
                _titleLabel.text = @"安全包：";
                CGFloat timeTipHeight = [self.safeTipLabel.text textSizeIn:CGSizeMake(kScreenWidth - 30, MAXFLOAT) font:self.safeTipLabel.font].height + 5;
                CGFloat warmTipHeight = [self.safeExlainLabel.text textSizeIn:CGSizeMake(kScreenWidth - 30, MAXFLOAT) font:self.safeExlainLabel.font].height + 5;
                updateHeight = Show_Height + timeTipHeight + warmTipHeight ;
                self.middleView.hidden = self.bottomView.hidden = NO;
            }   break;
        default:
            break;
    }
    
    self.updateHeight ? self.updateHeight(updateHeight) : nil;
}

-(NSAttributedString *)Html2AttributeString:(NSString *)string font:(UIFont *)font {
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[string  dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName:font } documentAttributes:nil error:nil];
    return attrStr;
}

#pragma mark -- Click
-(void)helpClick {
    
    [[[UIAlertView alloc] initWithTitle:@"安全包" message:@"安全包包含：学生保险、学生实时监控、签到签退提醒、每日动态等服务。保险最高保额4万人民币，仅在托管机构内发生意外时生效。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil] show];
}

-(void)tapCertTypeClick {
    
    NSLog(@"tapCertTypeClick");
}

-(void)tapDateClick {
    
    NSLog(@"tapDateClick");
}

-(void)tapGenderClick {
    
    NSLog(@"tapGenderClick");
}

-(void)tapExplainClick {
    NSLog(@"tapExplainClick");
}

- (IBAction)chooseClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.chooseBlock ? self.chooseBlock(sender.isSelected) : nil;
}

- (IBAction)minusClick:(UIButton *)sender {
    
    double num = [self.numField.text doubleValue];
    if (num <= self.minNum) {
        self.numWarmBlock ? self.numWarmBlock(NO) : nil;
        return;
    }
    
    num -= AddDefaultValue;
    if (num <= self.minNum) {
        [self.minusButton setImage:IMAGENANED(@"apply_minus_noallow") forState:(UIControlStateNormal)];
    } else {
        [self.minusButton setImage:IMAGENANED(@"apply_minus") forState:(UIControlStateNormal)];
    }
    
    self.numField.text = [NSString stringWithFormat:@"%.01lf",num];
    self.numChangeBlock ? self.numChangeBlock(num) : nil;
}

- (IBAction)addClick:(UIButton *)sender {
    
    double num = [self.numField.text doubleValue];
    if (num >= self.maxNum) {
        self.numWarmBlock ? self.numWarmBlock(YES) : nil;
        return;
    }
    
    [self.minusButton setImage:IMAGENANED(@"apply_minus") forState:(UIControlStateNormal)];
    num += AddDefaultValue;
    self.numField.text = [NSString stringWithFormat:@"%.01lf",num];
    self.numChangeBlock ? self.numChangeBlock(num) : nil;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self endEditing:YES];
}

@end
