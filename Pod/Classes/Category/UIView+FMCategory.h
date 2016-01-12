//
//  UIView+FZCategory.h
//  Pods
//
//  Created by 周峰 on 16/1/12.
//
//

#import <UIKit/UIKit.h>


@interface UIView (FZCategory)

/**
 *  @author Feng.z, 16-01-12 11:01:12
 *
 *  @brief 设置UIView 实时高斯模糊（ios5、6 CPU消耗较高）
 *
 *  @param enable 是否高斯模糊
 *
 *  @since tag 1.1
 */
- (void) enableBlurry:(BOOL) enable;

/**
 *  @author Feng.z, 16-01-12 13:01:38
 *
 *  @brief 获取当前View的快照图片
 *
 *  @return
 *
 *  @since tag 1.1
 */
- (UIImage *) snapshotImage;
/**
 *  @author Feng.z, 16-01-12 15:01:39
 *
 *  @brief 以当前View为基础获取高斯图像
 *
 *  @return
 *
 *  @since tag 1.1
 */
- (UIImage *) snapshotBlurImage;


@end
