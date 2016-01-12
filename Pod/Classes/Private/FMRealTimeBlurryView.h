//
//  FMRealTimeBlurryView.h
//  Pods
//
//  Created by 周峰 on 16/1/12.
//
//

#import <UIKit/UIKit.h>

@interface FMRealTimeBlurryView : UIView

/*** YES to have a blurred view that is not updated realtime */
@property (nonatomic, assign) BOOL renderStatic;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
// iOS 7+ code here
#else
// Pre iOS 6 code here
/*** The tint color to apply to the button item. */
@property (nonatomic, strong) UIColor *tintColor;

#endif
@end
