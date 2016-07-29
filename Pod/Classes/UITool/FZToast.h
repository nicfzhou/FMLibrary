//
//  FZToast.h
//  SpeeedApp
//
//  Created by 周峰 on 15/12/15.
//  Copyright © 2015年 Feng.Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZToast : NSObject

+ (void) makeToast:(NSString *) toast;
+ (void) makeToast:(NSString *)toast duration:(NSTimeInterval) duration;


+ (instancetype)make:(NSString *)text;
- (FZToast *)bottom;
- (FZToast *)top;
- (FZToast *)center;
- (FZToast *(^)(CGFloat))yOffset;
- (FZToast *(^)(NSTimeInterval))duration;
- (void)toast;

@end
