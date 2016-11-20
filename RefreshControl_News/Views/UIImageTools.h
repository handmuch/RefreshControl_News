//
//  UIImageTools.h
//  KGMusic4
//
//  Created by ellzu on 13-11-26.
//  Copyright (c) 2013年 kugou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageTools : NSObject

+(UIImage*)imageWithColor:(UIColor*)color andSize:(CGSize)size;

+(UIImage *)colorizeImage2:(UIImage *)baseImage withColor:(UIColor *)theColor;

+(UIImage *)ellipseImage:(UIImage *)image withInset:(CGFloat)inset withBorderWidth:(CGFloat)width withBorderColor:(UIColor*)color;

//设置图片透明度
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image;

//使用自定义的kCGBlendMode模式（解决唱模块作品简介背景渲染不清晰）
+(UIImage *)colorizeImage:(UIImage *)baseImage withColor:(UIColor *)theColor forBlendModel:(CGBlendMode)blendMode;

/**
 *  调整图片尺寸和大小
 *
 *  @param sourceImage  原始图片
 *  @param maxImageSize 新图片最大尺寸
 *  @param maxSize      新图片最大存储大小
 *
 *  @return 新图片imageData
 */
+ (NSData *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat) maxSize;



@end
