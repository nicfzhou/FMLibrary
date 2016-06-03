//
//  FZToast.m
//  SpeeedApp
//
//  Created by 周峰 on 15/12/15.
//  Copyright © 2015年 Feng.Z. All rights reserved.
//

#import "FZToast.h"

static NSMutableArray *toastWindowArray;
@implementation FZToast{
    NSString *_text;
    NSTimeInterval *_duration;
}

+ (void)initialize{
    toastWindowArray = [NSMutableArray array];
}
+ (void) makeToast:(NSString *) toast{
    [self makeToast:toast duration:2];
}
+ (void) makeToast:(NSString *)toast duration:(NSTimeInterval) duration{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
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
        
        CGRect screenRect = [UIScreen mainScreen].bounds;
        CGSize size = [label sizeThatFits:CGSizeMake(screenRect.size.width*.8, 50)];
        size.width += 30;
        size.height += 10;
        label.frame = CGRectMake(0, 0, size.width, size.height);
        CGRect windowFrame = CGRectMake((screenRect.size.width-size.width)*.5,
                                       (screenRect.size.height - size.height - 30),
                                       size.width,
                                       size.height);
        
        
        UIWindow *window = [[UIWindow alloc] initWithFrame:windowFrame];
        window.windowLevel = UIWindowLevelAlert;
        window.backgroundColor = [UIColor clearColor];
        window.hidden = NO;
        [window addSubview:label];
        [toastWindowArray addObject:window];
        
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
        UIWindow *window = view.superview;
        [view removeFromSuperview];
        [toastWindowArray removeObject:window];
    }];
}

@end
