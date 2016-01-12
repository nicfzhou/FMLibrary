//
//  FZToast.m
//  SpeeedApp
//
//  Created by 周峰 on 15/12/15.
//  Copyright © 2015年 Feng.Z. All rights reserved.
//

#import "FZToast.h"

@implementation FZToast

+ (void) makeToast:(NSString *) toast{
    [self makeToast:toast duration:2];
}
+ (void) makeToast:(NSString *)toast duration:(NSTimeInterval) duration{
    [self makeToast:toast duration:duration onView:nil];
}
+ (void) makeToast:(NSString *)toast duration:(NSTimeInterval)duration onView:(UIView *) view{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *targetView = view?:[UIApplication sharedApplication].keyWindow;
        
        NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:16],
                               NSForegroundColorAttributeName:[UIColor whiteColor]};
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.text            = toast;
        label.font            = attr[NSFontAttributeName];
        label.textColor       = attr[NSForegroundColorAttributeName];
        label.backgroundColor = [UIColor colorWithRed:0.21 green:0.23 blue:0.24 alpha:1];
        label.textAlignment   = NSTextAlignmentCenter;
        label.numberOfLines   = 0;
        
        label.layer.cornerRadius  = 5;
        label.layer.masksToBounds = YES;
        label.layer.opacity       = 0.;
        
        CGSize size = [label sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width*.8, 50)];
        size.width += 30;
        size.height += 10;
        
        [targetView addSubview:label];
        [targetView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:targetView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [targetView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:targetView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-30]];
        
        [label addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size.width]];
        
        [label addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size.height]];
        
        [UIView animateWithDuration:0.25 animations:^{
            label.layer.opacity = 1.;
        }];
        
        
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
        label.userInteractionEnabled = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideView:label];
        });
    });
    
    
    
}

+ (void) handleTap:(UITapGestureRecognizer*) gr{
    [self hideView:gr.view];
}

+ (void) hideView:(UIView*) view{
    [UIView animateWithDuration:.25 animations:^{
        view.layer.opacity = .0;
    } completion:^(BOOL finish){
        [view removeFromSuperview];
    }];
}

@end
