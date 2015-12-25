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
+ (void) makeToast:(NSString *)toast duration:(NSTimeInterval)duration onView:(UIView *) view;

@end
