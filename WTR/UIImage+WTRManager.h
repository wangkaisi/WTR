//
//  UIImage+WTRManager.h
//  WTRGitCs
//
//  Created by wfz on 2017/5/24.
//  Copyright © 2017年 wfz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (WTRManager)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)imageCutWith:(CGSize)size;//改变分辨率

- (UIImage *)fixOrientation;//纠正系统相机照出来的图片方向


+ (UIImage *)imageWithWTRCIImage:(CIImage *)ciimage;

- (CIImage *)WTRCIImage;

- (UIImage *)boxblurImageWithBlur:(CGFloat)blur;//模糊

/*
 
 //常用图片模糊 也可以用 [CIFilter filterWithName:@"CIDiscBlur"]; 等
 
 UIColor *tintColor = [UIColor colorWithRed:0  green:0  blue:0 alpha:0.5];
 viewImage=[viewImage applyWBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
 
 */
- (UIImage *)applyWBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;////模糊半径、饱和度、以及可选的掩盖图片

@end
