//
//  UIImage+ImageCompressionTool.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/6/17.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "UIImage+ImageCompressionTool.h"

@implementation UIImage (ImageCompressionTool)

-(NSData *)compressWithLengthLimit:(NSUInteger)maxLength{
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    //NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        //NSLog(@"Compression = %.1f", compression);
        //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
    if (data.length < maxLength) return data;
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        //NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
    }
    //NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
    return data;
}

- (NSData *)compressQualityWithLengthLimit:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    while (data.length > maxLength && compression > 0) {
        compression -= 0.02;
        data = UIImageJPEGRepresentation(self, compression); // When compression less than a value, this code dose not work
    }
    return data;
}


-(NSData *)compressMidQualityWithLengthLimit:(NSInteger)maxLength{
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}

-(NSData *)compressBySizeWithLengthLimit:(NSUInteger)maxLength{
    UIImage *resultImage = self;
    NSData *data = UIImageJPEGRepresentation(resultImage, 1);
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        // Use image to draw (drawInRect:), image is larger but more compression time
        // Use result image to draw, image is smaller but less compression time
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    return data;
}

/**
 压缩到指定像素px
 */
- (UIImage *)compressQualityWithPixelLimit:(CGFloat)targetPx{
    UIImage *compressImage = nil;
    CGSize imageSize = self.size;
    CGFloat compressScale = 0; //压缩比例
    //压缩后的目标size
    CGSize targetSize = CGSizeMake(targetPx, targetPx);
    //实际宽高比例
    CGFloat factor = imageSize.width / imageSize.height;
    
    if (imageSize.width < targetSize.width && imageSize.height < targetSize.height) {
        //图片实际宽高 都小于 目标宽高，没必要压缩
        compressImage = self;
        
    }else if (imageSize.width > targetSize.width && imageSize.height > targetSize.height){
        //图片实际宽高 都大于 目标宽高
        if (factor <= 2) {
            //宽高比例小于等于2,获取大的等比压缩
            compressScale = MAX(targetSize.width/imageSize.width, targetSize.height/imageSize.height);
        }else{
            //宽高比例大于2,获取小的等比压缩
            compressScale = MIN(targetSize.width/imageSize.width, targetSize.height/imageSize.height);
        }
    }else if(imageSize.width > targetSize.width && imageSize.height < imageSize.height){
        //宽大于目标宽,高小于目标高
        if (factor <= 2) {
            compressScale = targetSize.width / imageSize.width;
        }else{
            compressImage = self;
        }
    }else if(imageSize.width < targetSize.width && imageSize.height > imageSize.height){
        //宽小于目标宽,高大于目标高
        if (factor <= 2) {
            compressScale = targetSize.height / imageSize.height;
        }else{
            compressImage = self;
        }
    }
    
    //需要压缩
    if (compressScale > 0 && !compressImage) {
        
        CGSize compressSize = CGSizeMake(self.size.width * compressScale, self.size.height * compressScale);
        UIGraphicsBeginImageContextWithOptions(compressSize, YES, 1);
        [self drawInRect:CGRectMake(0, 0, compressSize.width, compressSize.height)];
        compressImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    if (!compressImage) {
        compressImage = self;
    }
    
    return compressImage;
}

/**
 改变图片方向
 */
+(UIImage *)changeImageOrientation:(UIImage *)image
{
    UIImage* contextedImage;
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (image.imageOrientation == UIImageOrientationUp) {
        contextedImage = image;
    }
    else{
        switch (image.imageOrientation ) {
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
                transform = CGAffineTransformRotate(transform, M_PI);
                break;
                
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
                transform = CGAffineTransformTranslate(transform, image.size.width, 0);
                transform = CGAffineTransformRotate(transform, M_PI_2);
                break;
                
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, 0,image.size.height);
                transform = CGAffineTransformRotate(transform, -M_PI_2);
                break;
                
            default:
                break;
                
        }
        
        switch (image.imageOrientation) {
            case UIImageOrientationUpMirrored:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, image.size.width, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
                
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, image.size.height, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
                
            default:
                break;
        }
        
        CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height, CGImageGetBitsPerComponent(image.CGImage), 0, CGImageGetColorSpace(image.CGImage), CGImageGetBitmapInfo(image.CGImage));
        CGContextConcatCTM(ctx, transform);
        
        switch (image.imageOrientation) {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.height,image.size.width), image.CGImage);
                break;
                
            default:
                CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
                break;
        }
        
        
        CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
        contextedImage = [UIImage imageWithCGImage:cgimg];
        CGContextRelease(ctx);
        CGImageRelease(cgimg);
    }
    return contextedImage;
}

@end
