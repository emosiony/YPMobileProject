//
//  UIImage+ImageSize.m
//  TGParent
//
//  Created by lwc on 2019/1/4.
//  Copyright © 2019年 jzg. All rights reserved.
//

#import "UIImage+ImageSize.h"

@implementation UIImage (ImageSize)

+ (CGSize)getImageSizeWithURL:(NSURL *)url {
    CGImageSourceRef image = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0.0f, height = 0.0f;
    if (image){
        CFDictionaryRef imageAcc = CGImageSourceCopyPropertiesAtIndex(image, 0, NULL);
        if (imageAcc != NULL){
            CFNumberRef widthNumber = CFDictionaryGetValue(imageAcc, kCGImagePropertyPixelWidth);
            width = [(__bridge NSNumber *)widthNumber floatValue];
//            if (widthNumber != NULL) {
//                CFNumberGetValue(widthNumber, kCFNumberLongType, &width);
//            }
            CFNumberRef heightNumber = CFDictionaryGetValue(imageAcc, kCGImagePropertyPixelHeight);
            height = [(__bridge NSNumber *)heightNumber floatValue];
//            if (heightNumber != NULL) {
//                CFNumberGetValue(heightNumber, kCFNumberLongType, &height);
//            }
            CFRelease(imageAcc);
        }
        CFRelease(image);
        NSLog(@"Image dimensions: %.0f x %.0f px", width, height);
    }
    return CGSizeMake(width, height);
}

@end
