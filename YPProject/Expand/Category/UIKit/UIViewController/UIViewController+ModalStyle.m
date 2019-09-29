//
//  UIViewController+ModalStyle.m
//  YPProject
//
//  Created by Jtg_yao on 2019/9/29.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "UIViewController+ModalStyle.h"
#import <objc/runtime.h>

static const char *yp_automaticallySetModalPresentationStyleKey;

@implementation UIViewController (ModalStyle)

+ (void)load {
    
    Method originPresentMethod  = class_getInstanceMethod(self, @selector(presentViewController:animated:completion:));
    Method swizzedPresentMethod = class_getInstanceMethod(self, @selector(yp_presentViewController:animated:completion:));
    
    method_exchangeImplementations(originPresentMethod, swizzedPresentMethod);
}

-(void)setYp_automaticallySetModalPresentationStyle:(BOOL)yp_automaticallySetModalPresentationStyle {
    objc_setAssociatedObject(self, yp_automaticallySetModalPresentationStyleKey, @(yp_automaticallySetModalPresentationStyle), OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)yp_automaticallySetModalPresentationStyle {
    
    id obj = objc_getAssociatedObject(self, yp_automaticallySetModalPresentationStyleKey);
    if (obj) {
        return [obj boolValue];
    }
    return [self.class yp_automaticallySetModalPresentationStyle];
}

+(BOOL)yp_automaticallySetModalPresentationStyle {
    
    if ([self isKindOfClass:[UIImagePickerController class]] || [self isKindOfClass:[UIAlertController class]]) {
        return NO;
    }
    return YES;
}

-(void)yp_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    if (@available(iOS 13, *)) {
        if (viewControllerToPresent.yp_automaticallySetModalPresentationStyle) {
            viewControllerToPresent.modalTransitionStyle = UIModalPresentationFullScreen;
        }
        [self yp_presentViewController:viewControllerToPresent animated:flag completion:completion];
    } else {
        [self yp_presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}

@end
