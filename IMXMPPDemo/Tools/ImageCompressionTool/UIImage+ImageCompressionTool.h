//
//  UIImage+ImageCompressionTool.h
//  IMXMPPDemo
//
//  Created by Civet on 2020/6/17.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ImageCompressionTool)

/*
 *  压缩图片方法(先压缩质量再压缩尺寸)
 */
-(NSData *)compressWithLengthLimit:(NSUInteger)maxLength;
/*
 *  压缩图片方法(压缩质量)
 */
-(NSData *)compressQualityWithLengthLimit:(NSInteger)maxLength;
/*
 *  压缩图片方法(压缩质量二分法)
 */
-(NSData *)compressMidQualityWithLengthLimit:(NSInteger)maxLength;
/*
 *  压缩图片方法(压缩尺寸)
 */
-(NSData *)compressBySizeWithLengthLimit:(NSUInteger)maxLength;
/*
 *
 压缩到指定像素px
 */
- (UIImage *)compressQualityWithPixelLimit:(CGFloat)targetPx;
/*
 *
 改变图片方向
 */
+(UIImage *)changeImageOrientation:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
