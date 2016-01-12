//
//  UIImage+FMCategory.h
//  Pods
//
//  Created by 周峰 on 16/1/12.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (BoxBlurry)

/*** 输出高斯模糊的图片 */
- (UIImage*)fmui_boxblurImageWithBlur:(CGFloat)blur;

@end
