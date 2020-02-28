//
//  YPImageEditView.m
//  YPProject
//
//  Created by 幸福e家 on 2020/2/15.
//  Copyright © 2020 jzg. All rights reserved.
//

#import "YPImageEditView.h"
#import "LXFDrawBoard.h"
#import "UIImage+ImageSize.h"
#import "UIButton+LXMImagePosition.h"
#import "WBGTextTool.h"
#import <zhPopupController.h>
#import <UIAlertView+BlocksKit.h>

#define kDefaultTag 101

@interface YPImageEditView ()
<UIScrollViewDelegate, LXFDrawBoardDelegate>

/** 图片区域 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/** 图片滚动 */
@property (nonatomic, strong) UIScrollView *pictureScrollView;

/** 文字颜色 */
@property (weak, nonatomic) IBOutlet UIView *fontColorView;
@property (nonatomic, strong) YPFontColorView *fontColorManagerView;

/** 底部工具 */
@property (weak, nonatomic) IBOutlet UIView *bottomToolView;
/** 上一张 */
@property (nonatomic, strong) UIButton *leftButon;
/** 下一张 */
@property (nonatomic, strong) UIButton *rightButon;

/** 画笔 */
@property (nonatomic, strong) UIButton *drawPenButton;
/** 文本 */
@property (nonatomic, strong) UIButton *wordButton;
/** 撤销 */
@property (nonatomic, strong) UIButton *cancelButton;
/** 恢复 */
@property (nonatomic, strong) UIButton *reviewButton;
/** 保存 */
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) UIButton *currentButton;

@property (nonatomic, strong) LXFDrawBoard *currentImageView;
@property (nonatomic, strong) WBGTextTool *textInputTool;

@property (nonatomic, copy) NSString *inputStr;
@property (nonatomic, strong) LXFDrawBoardStyle *boardStyle;

@end

@implementation YPImageEditView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setupSubView];
    [self setupConstraints];
    [self setupOberserver];
}

- (void)setupSubView {
        
    self.fontColorStatus = YPFontColorHidden;
    [self.fontColorView setHidden:YES];
    
    [self.topView addSubview:self.pictureScrollView];
    
    [self.fontColorView addSubview:self.fontColorManagerView];
    
    [self.bottomToolView addSubview:self.leftButon];
    [self.bottomToolView addSubview:self.rightButon];
    [self.bottomToolView addSubview:self.drawPenButton];
    [self.bottomToolView addSubview:self.wordButton];
    [self.bottomToolView addSubview:self.cancelButton];
    [self.bottomToolView addSubview:self.reviewButton];
    [self.bottomToolView addSubview:self.saveButton];
}

- (void)setupConstraints {
    
    [self.fontColorManagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.fontColorView);
    }];
    
    [self.pictureScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.topView);
        make.size.mas_equalTo(self.topView.frame.size);
    }];
    
    NSArray *list = @[self.leftButon, self.drawPenButton,
                      self.wordButton, self.cancelButton,
                      self.reviewButton, self.saveButton,
                      self.rightButon
    ];
    
    [list mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:0 leadSpacing:15 tailSpacing:15];
    [list mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-25);
        make.width.mas_equalTo(45);
    }];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self.leftButon setImagePosition:(LXMImagePositionTop) spacing:8];
    [self.rightButon setImagePosition:(LXMImagePositionTop) spacing:8];
    [self.drawPenButton setImagePosition:(LXMImagePositionTop) spacing:8];
    [self.wordButton setImagePosition:(LXMImagePositionTop) spacing:8];
    [self.cancelButton setImagePosition:(LXMImagePositionTop) spacing:8];
    [self.reviewButton setImagePosition:(LXMImagePositionTop) spacing:8];
    [self.saveButton setImagePosition:(LXMImagePositionTop) spacing:8];
}

- (void)setupOberserver {
    
    WeakSelf();
    [RACObserve(self, currentImageView) subscribeNext:^(id  _Nullable x) {
        
        for (NSInteger i = 0; i < weakself.photos.count; i++) {
            LXFDrawBoard *drawImageView = (LXFDrawBoard *)[weakself.pictureScrollView viewWithTag:kDefaultTag + i];
            if (drawImageView != nil &&
                drawImageView != weakself.currentImageView) {
                drawImageView.hidden = YES;
            }
        }
        
        if (x != nil) {
            [UIView animateWithDuration:0.25 animations:^{
                weakself.currentImageView.hidden = NO;
            }];
        }
    }];
}

- (void)setFontColorStatus:(YPFontColorStatus)fontColorStatus {
    
    _fontColorStatus = fontColorStatus;
    
    self.fontColorView.hidden = _fontColorStatus == YPFontColorHidden;
    self.fontColorManagerView.fontColorStatus = _fontColorStatus;
}

- (void)setPhotos:(NSMutableArray *)photos {
    
    _photos = photos;
    
    [self.pictureScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [_photos enumerateObjectsUsingBlock:^(NSString *urlStr, NSUInteger idx, BOOL * _Nonnull stop) {
        
        LXFDrawBoard *drawImageView = [[LXFDrawBoard alloc] init];
        drawImageView.tag       = kDefaultTag + idx;
        drawImageView.hidden    = YES;
        drawImageView.delegate  = self;
        [drawImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
        drawImageView.canRevoke = YES;
        drawImageView.canRedo   = YES;
        drawImageView.contentMode = UIViewContentModeScaleAspectFit;

        if (idx == 0) {
            self.currentImageView = drawImageView;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pictureScrollView addSubview:drawImageView];
//            CGSize size = [self getSizeWithURL:[NSURL URLWithString:urlStr]];
            [drawImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.right.mas_equalTo(self.pictureScrollView);
                make.center.mas_equalTo(self.pictureScrollView);
//                if (size.height > self.topView.frame.size.height) {
//                    make.top.left.mas_equalTo(self.pictureScrollView);
//                }
//                make.size.mas_equalTo(size);
            }];
        });
    }];
}

- (CGSize)getSizeWithURL:(NSURL *)url {
    
    CGSize size = [UIImage getImageSizeWithURL:url];
    
    CGSize topSize = self.topView.frame.size;
    if (size.width > topSize.width) {
        
        CGFloat newHeight = size.height * topSize.width / size.width;
        size.width  = topSize.width;
        size.height = newHeight;
    } else if (size.height > topSize.height) {
        CGFloat newWidth = size.width * topSize.height / size.height;
        size.width  = newWidth;
        size.height = topSize.height;
    }
    
    return size;
}

#pragma mark- ScrollView
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    if (self.currentImageView) {
        return self.currentImageView;
    }
    return nil;
}

#pragma mark -- 放大缩小
- (void)singleGestureClicked {
    
    if (self.pictureScrollView) {
        CGFloat scale = self.pictureScrollView.zoomScale;
        if (scale == 2.0f) {
            self.pictureScrollView.zoomScale = 1.0;
        } else {
            self.pictureScrollView.zoomScale = 2.0f;
        }
    }
}

- (void)setCurrentButton:(UIButton *)currentButton {
    
    if (_currentButton == currentButton) {
        return;
    }
    
    if (_currentButton != nil) {
        _currentButton.selected = NO;
    }
    
    _currentButton = currentButton;
    _currentButton.selected = YES;
}

#pragma mark -- Click
- (void)leftClick:(UIButton *)sender {
    
    self.currentButton = sender;
    self.fontColorStatus = YPFontColorHidden;
    
    if (self.photos.count && self.currentImageView != nil) {
        if (self.currentImageView.tag == kDefaultTag) {
            [SVProgressHUD showImage:nil status:@"已经是第一张了"];
        } else {
            if (self.currentImageView.isEdit) {
                [UIAlertView bk_showAlertViewWithTitle:@"当前图片未保存" message:@"是否保存" cancelButtonTitle:@"否" otherButtonTitles:@[@"是"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 0) {
                        [self resetCurrentImage];
                        self.currentImageView = (LXFDrawBoard *)[self.pictureScrollView viewWithTag:self.currentImageView.tag - 1];
                    } else {
                        self.currentImageView = (LXFDrawBoard *)[self.pictureScrollView viewWithTag:self.currentImageView.tag - 1];
                    }
                }];
            } else {
                self.currentImageView = (LXFDrawBoard *)[self.pictureScrollView viewWithTag:self.currentImageView.tag - 1];
            }
        }
    }
}

- (void)drawPenClick:(UIButton *)sender {
    
    self.currentButton = sender;
    self.fontColorStatus = YPFontColorShowNormal;
    
    self.currentImageView.brush = [LXFPencilBrush new];
    self.currentImageView.style = self.boardStyle;
}

- (void)wordClick:(UIButton *)sender {
    
    self.currentButton = sender;
    self.fontColorStatus = YPFontColorShowNormal;
    
    self.currentImageView.brush = [LXFTextBrush new];
    self.currentImageView.style = self.boardStyle;
    
    self.inputStr = nil;
    self.textInputTool.textView.boardStyle = self.boardStyle;
    self.textInputTool.textView.textView.text = self.inputStr;
    [self.textInputTool showTextBorder];
}

- (void)cancelClick:(UIButton *)sender {
    
    self.currentButton = sender;
    self.fontColorStatus = YPFontColorHidden;
    [self.currentImageView revoke];
}

- (void)reviewClick:(UIButton *)sender {
    
    self.currentButton = sender;
    self.fontColorStatus = YPFontColorHidden;
    [self.currentImageView redo];
}

- (void)saveClick:(UIButton *)sender {
    
    self.currentButton = sender;
    self.fontColorStatus = YPFontColorHidden;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.currentImageView.bounds];
    imgView.image = self.currentImageView.editImage;
    
    [AppDelegate shareDelegate].topViewController.zh_popupController = [zhPopupController new];
    zhPopupController *popupController = [AppDelegate shareDelegate].topViewController.zh_popupController;
    popupController.layoutType = zhPopupLayoutTypeCenter;
    [popupController presentContentView:imgView];
}

- (void)nextClick:(UIButton *)sender {
    
    self.currentButton = sender;
    self.fontColorStatus = YPFontColorHidden;
    
    if (self.photos.count && self.currentImageView != nil) {
        if (self.currentImageView.tag == kDefaultTag + self.photos.count - 1) {
            [SVProgressHUD showImage:nil status:@"已经是最后一张了"];
        } else {
            
            if (self.currentImageView.isEdit) {
                
                [UIAlertView bk_showAlertViewWithTitle:@"当前图片未保存" message:@"是否保存" cancelButtonTitle:@"否" otherButtonTitles:@[@"是"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 0) {
                        [self resetCurrentImage];
                        self.currentImageView = (LXFDrawBoard *)[self.pictureScrollView viewWithTag:self.currentImageView.tag + 1];
                    } else {
                        self.currentImageView = (LXFDrawBoard *)[self.pictureScrollView viewWithTag:self.currentImageView.tag + 1];
                    }
                }];
            } else {
                self.currentImageView = (LXFDrawBoard *)[self.pictureScrollView viewWithTag:self.currentImageView.tag + 1];
            }
        }
    }
}

- (void)resetCurrentImage {
    
    LXFDrawBoard *drawImageView = [[LXFDrawBoard alloc] init];
    drawImageView.tag       = self.currentImageView.tag;
    drawImageView.hidden    = YES;
    drawImageView.delegate  = self;
    drawImageView.canRevoke = YES;
    drawImageView.canRedo   = YES;
    
    [self.pictureScrollView addSubview:drawImageView];
    
    NSString *url = [self.photos objectAtIndex:self.currentImageView.tag - kDefaultTag];
    [drawImageView sd_setImageWithURL:[NSURL URLWithString:url]];

    [drawImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.pictureScrollView);
        make.top.left.bottom.right.mas_equalTo(self.pictureScrollView);
    }];
    
    [self.currentImageView removeFromSuperview];
}


#pragma mark - LXFDrawBoardDelegate
- (NSString *)LXFDrawBoard:(LXFDrawBoard *)drawBoard textForDescLabel:(UILabel *)descLabel {
    
    return self.inputStr;
}

- (void)LXFDrawBoard:(LXFDrawBoard *)drawBoard clickDescLabel:(UILabel *)descLabel {
    
    self.inputStr = descLabel ? descLabel.text : nil;
    self.textInputTool.textView.textView.text = self.inputStr;
    self.textInputTool.textView.boardStyle = self.boardStyle;
    [self.textInputTool showTextBorder];
}

#pragma mark -- Getter
-(UIScrollView *)pictureScrollView {
    
    if (_pictureScrollView == nil) {
        _pictureScrollView = [[UIScrollView alloc] init];
        _pictureScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _pictureScrollView.delegate = self;
        _pictureScrollView.multipleTouchEnabled = YES;
        _pictureScrollView.showsHorizontalScrollIndicator = NO;
        _pictureScrollView.showsVerticalScrollIndicator = NO;
        _pictureScrollView.delaysContentTouches = NO;
        _pictureScrollView.scrollsToTop = NO;
        _pictureScrollView.clipsToBounds = NO;
        _pictureScrollView.scrollEnabled = YES;
        _pictureScrollView.minimumZoomScale = 1.f;    // 最小缩放
        _pictureScrollView.maximumZoomScale = 3.f;    // 最大缩放
        
        if(@available(iOS 11.0, *)) {
            _pictureScrollView.contentInsetAdjustmentBehavior =
            UIScrollViewContentInsetAdjustmentNever;
        }
        UITapGestureRecognizer *singleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleGestureClicked)];
        singleGesture.numberOfTapsRequired=2;//避免单击与双击冲突
        [_pictureScrollView addGestureRecognizer:singleGesture];
    }
    return _pictureScrollView;
}

-(YPFontColorView *)fontColorManagerView {
    
    if (_fontColorManagerView == nil) {
        _fontColorManagerView = [[YPFontColorView alloc] init];
    }
    return _fontColorManagerView;
}

-(UIButton *)leftButon {
    
    if (_leftButon == nil) {
        _leftButon = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_leftButon setTitle:@"上一张" forState:(UIControlStateNormal)];
        [_leftButon setTitleColor:HEXColor(0x5D5D5D) forState:(UIControlStateNormal)];
        [_leftButon setTitleColor:HEXColor(0x446BFD) forState:(UIControlStateSelected)];
        [_leftButon setImage:[UIImage imageNamed:@"icon_jtz"] forState:(UIControlStateNormal)];
        [_leftButon setImage:[UIImage imageNamed:@"icon_jtz"] forState:(UIControlStateSelected)];
        [_leftButon addTarget:self action:@selector(leftClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _leftButon.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _leftButon;
}

-(UIButton *)drawPenButton {
    
    if (_drawPenButton == nil) {
        _drawPenButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_drawPenButton setTitle:@"批注" forState:(UIControlStateNormal)];
        [_drawPenButton setTitleColor:HEXColor(0x5D5D5D) forState:(UIControlStateNormal)];
        [_drawPenButton setTitleColor:HEXColor(0x446BFD) forState:(UIControlStateSelected)];
        [_drawPenButton setImage:[UIImage imageNamed:@"icon_bz"] forState:(UIControlStateNormal)];
        [_drawPenButton setImage:[UIImage imageNamed:@"icon_bz_s"] forState:(UIControlStateSelected)];
        [_drawPenButton addTarget:self action:@selector(drawPenClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _drawPenButton.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _drawPenButton;
}

-(UIButton *)wordButton {
    
    if (_wordButton == nil) {
        _wordButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_wordButton setTitle:@"文字" forState:(UIControlStateNormal)];
        [_wordButton setTitleColor:HEXColor(0x5D5D5D) forState:(UIControlStateNormal)];
        [_wordButton setTitleColor:HEXColor(0x446BFD) forState:(UIControlStateSelected)];
        [_wordButton setImage:[UIImage imageNamed:@"icon_tt"] forState:(UIControlStateNormal)];
        [_wordButton setImage:[UIImage imageNamed:@"icon_tt_s"] forState:(UIControlStateSelected)];
        [_wordButton addTarget:self action:@selector(wordClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _wordButton.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _wordButton;
}

-(UIButton *)cancelButton {
    
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_cancelButton setTitle:@"撤销" forState:(UIControlStateNormal)];
        [_cancelButton setTitleColor:HEXColor(0x5D5D5D) forState:(UIControlStateNormal)];
        [_cancelButton setTitleColor:HEXColor(0x5D5D5D) forState:(UIControlStateSelected)];
        [_cancelButton setImage:[UIImage imageNamed:@"icon_cx"] forState:(UIControlStateNormal)];
        [_cancelButton setImage:[UIImage imageNamed:@"icon_cx"] forState:(UIControlStateSelected)];
        [_cancelButton addTarget:self action:@selector(cancelClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _cancelButton;
}

-(UIButton *)reviewButton {
    
    if (_reviewButton == nil) {
        _reviewButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_reviewButton setTitle:@"恢复" forState:(UIControlStateNormal)];
        [_reviewButton setTitleColor:HEXColor(0x5D5D5D) forState:(UIControlStateNormal)];
        [_reviewButton setTitleColor:HEXColor(0x5D5D5D) forState:(UIControlStateSelected)];
        [_reviewButton setImage:[UIImage imageNamed:@"icon_hf"] forState:(UIControlStateNormal)];
        [_reviewButton setImage:[UIImage imageNamed:@"icon_hf"] forState:(UIControlStateSelected)];
        [_reviewButton addTarget:self action:@selector(reviewClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _reviewButton.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _reviewButton;
}

-(UIButton *)saveButton {
    
    if (_saveButton == nil) {
        _saveButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_saveButton setTitle:@"保存" forState:(UIControlStateNormal)];
        [_saveButton setTitleColor:HEXColor(0x5D5D5D) forState:(UIControlStateNormal)];
        [_saveButton setTitleColor:HEXColor(0x5D5D5D) forState:(UIControlStateSelected)];
        [_saveButton setImage:[UIImage imageNamed:@"icon_bc"] forState:(UIControlStateNormal)];
        [_saveButton setImage:[UIImage imageNamed:@"icon_bc"] forState:(UIControlStateSelected)];
        [_saveButton addTarget:self action:@selector(saveClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _saveButton;
}

-(UIButton *)rightButon {
    
    if (_rightButon == nil) {
        _rightButon = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_rightButon setTitle:@"下一张" forState:(UIControlStateNormal)];
        [_rightButon setTitleColor:HEXColor(0x5D5D5D) forState:(UIControlStateNormal)];
        [_rightButon setTitleColor:HEXColor(0x446BFD) forState:(UIControlStateSelected)];
        [_rightButon setImage:[UIImage imageNamed:@"icon_jty"] forState:(UIControlStateNormal)];
        [_rightButon setImage:[UIImage imageNamed:@"icon_jty"] forState:(UIControlStateSelected)];
        [_rightButon addTarget:self action:@selector(nextClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _rightButon.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _rightButon;
}

-(WBGTextTool *)textInputTool {
    
    if (_textInputTool == nil) {
        _textInputTool = [[WBGTextTool alloc] init];
        
        WeakSelf();
        [_textInputTool setAddNewTextCallback:^(NSString *text) {
            StrongSelf();
            if (text == nil || text.length <= 0) {
                return;
            }
            strongself.inputStr = text;
            [strongself.currentImageView alterDescLabel];
        }];
        [_textInputTool setEditAgainCallback:^(NSString *text) {
            StrongSelf();
            if (text == nil || text.length <= 0) {
                return;
            }
            strongself.inputStr = text;
            [strongself.currentImageView alterDescLabel];
        }];
    }
    return _textInputTool;
}

-(LXFDrawBoardStyle *)boardStyle {
    
    if (_boardStyle == nil) {
        _boardStyle = [LXFDrawBoardStyle shareManager];
    }
    return _boardStyle;
}

@end
