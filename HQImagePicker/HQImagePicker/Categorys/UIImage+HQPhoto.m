//
//  UIImage+HQPhoto.m
//  Photos
//
//  Created by huangqiang on 2017/5/19.
//  Copyright © 2017年 huangqiang. All rights reserved.
//

#import "UIImage+HQPhoto.h"

@implementation UIImage (HQPhoto)
//把图片切成正方形
- (UIImage *)cutSpuarePhoto
{
    UIImage * fullPhoto = self;
    CGSize newSize;
    CGImageRef imageRef = nil;
    if ((fullPhoto.size.width / fullPhoto.size.height) < 1) {
        newSize.width = fullPhoto.size.width;
        newSize.height = fullPhoto.size.width * 1;
        imageRef = CGImageCreateWithImageInRect([fullPhoto CGImage], CGRectMake(0, fabs(fullPhoto.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = fullPhoto.size.height;
        newSize.width = fullPhoto.size.height * 1;
        imageRef = CGImageCreateWithImageInRect([fullPhoto CGImage], CGRectMake(fabs(fullPhoto.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
    }
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

@end
