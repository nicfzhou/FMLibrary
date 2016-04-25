//
//  FZExtensions.h
//  Pods
//
//  Created by 周峰 on 16/4/25.
//
//

#import <Foundation/Foundation.h>


#pragma mark - UI
@interface UIColor (HEX)
+ (UIColor *) colorWithHex:(long long) hex;/**<  将16进制色值转换为UIColor */
@end


#pragma mark - UIView
#pragma mark bar
@interface UINavigationBar (FMExtensions)
@property (nonatomic,strong) UIColor *fm_BackgroundColor;/**< 设置导航栏背景颜色  */
- (void) setFm_BackgroundColor:(UIColor *)backgroundColor animate:(BOOL) animate;
@end

@interface UISearchBar (FMExtensions)
- (void)fm_setBackgroundColor:(UIColor *)color;
@end


#pragma mark UIImage

@interface UIView (FMExtensions)
- (UIImage *)fm_snapshot;/**< UIView截图  */
- (UIImage *)fm_imageWithCornerRadius:(CGFloat) radius corner:(UIRectCorner) corner;
@end

@interface UIImage (FMExtensions)
/**
 *  @author Feng.z, 16-04-25 10:04:09
 *
 *  @brief 生成文字前景的图片
 *
 *  @param name  图片前景文字内容（最大2个中午字符，一大一小，3个英文字符）
 *  @param color 图片背景颜色，为空时，系统随机生成一种颜色
 *  @param size  图片大小,会截取中间最大的正方形
 */
+ (UIImage *) fm_imageWithNameString:(NSString *) name
                     backgroundColor:(UIColor * _Nullable ) color
                                size:(CGSize) size;

/*** 输出高斯模糊的图片 */
- (UIImage*)fm_blurImageWithBlur:(CGFloat)blur;
- (UIImage *)fm_imageWithCornerRadius:(CGFloat) radius corner:(UIRectCorner) corner;

@end


#pragma mark - NSObject
@interface NSObject (FMExtensions)
- (void) fm_setProperty:(id) value forKey:(NSString *) key;/**< runtime添加属性  */
- (id) fm_propertyForKey:(NSString *) key;/**< runtime获取属性  */
@end




