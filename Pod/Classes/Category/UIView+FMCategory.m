//
//  UIView+FZCategory.m
//  Pods
//
//  Created by 周峰 on 16/1/12.
//
//

#import "UIView+FMCategory.h"
#import "NSObject+FMCategory.h"
#import "FMRealTimeBlurryView.h"
#import "UIImage+FMCategory.h"


static char *kBlurryViewKey;


NSString * toKeyString(char *);


@implementation UIView (FZCategory)

#pragma mark UIImage methods
- (void) enableBlurry:(BOOL)enable{
    NSString *key = toKeyString(kBlurryViewKey);
    UIView *blurryView = [self propertyForKey:key];
    if (!enable) {
        [blurryView removeFromSuperview];
        [self setProperty:nil forKey:key];
        return;
    }
    
    CGFloat systemVer = [UIDevice currentDevice].systemVersion.floatValue;
    if (systemVer >= 8) {
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        blurryView = effectView;
    }else{
        FMRealTimeBlurryView *fmblurryView = [[FMRealTimeBlurryView alloc] initWithFrame:self.bounds];
        blurryView = fmblurryView;
    }
    blurryView.frame = self.bounds;
    [blurryView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self addSubview:blurryView];
    [self setProperty:blurryView forKey:key];
}

- (UIImage *) snapshotImage{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *) snapshotBlurImage{
    return [[self snapshotImage] fmui_boxblurImageWithBlur:1];
}

#pragma mark override



#pragma mark private method 
@end

NSString * toKeyString(char * _char){
    return [NSString stringWithFormat:@"%x",(unsigned int)&_char];
}

