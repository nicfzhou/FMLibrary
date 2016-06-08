//
//  FZExtensions.m
//  Pods
//
//  Created by 周峰 on 16/4/25.
//
//

#import "FMExtensions.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

#pragma mark - UI
@implementation UIColor (HEX)
+ (UIColor *)colorWithHex:(long long)hex{
    NSString *str   = [NSString stringWithFormat:@"%llx",hex];
    CGFloat alpha   = str.length>6?((hex & 0xFF000000 ) >> 24) / 255.0F : 1.0;
    CGFloat red     = (( hex & 0xFF0000 ) >> 16 ) / 255.0F;
    CGFloat green   = (( hex & 0xFF00 ) >> 8 ) / 255.0F;
    CGFloat blue    = (( hex & 0xFF ) >> 0 ) / 255.0F;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end



#pragma mark UIView
#pragma mark Bar
static char *overlayKey;

@implementation UINavigationBar (FMExtensions)

- (UIView *)overlay{
    return objc_getAssociatedObject(self, &overlayKey);
}


- (void)setOverlay:(UIView *)overlay{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void) setFm_BackgroundColor:(UIColor *)fm_BackgroundColor{
    [self setFm_BackgroundColor:fm_BackgroundColor animate:NO];
}

- (void) setFm_BackgroundColor:(UIColor *)backgroundColor animate:(BOOL)animate{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *overlay = self.overlay;
        if (!overlay) {
            [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            [self setShadowImage:[UIImage new]];
            // insert an overlay into the view hierarchy
            overlay = [[UIView alloc] init];
            UIView *view = self.subviews[0];
            [self.subviews[0] addSubview:overlay];
            //add constraint to resize auto
            overlay.translatesAutoresizingMaskIntoConstraints = NO;//uiview created by code this property is default YES
            [view addConstraint:[NSLayoutConstraint constraintWithItem:overlay attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:-20]];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:overlay attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:overlay attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:overlay attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
            [view layoutIfNeeded];
            [overlay sizeToFit];
            [self setOverlay:overlay];
        }
        [UIView animateWithDuration:animate?.2:.0 animations:^{
            overlay.layer.backgroundColor = backgroundColor.CGColor;
        }];
    });
}

- (UIColor *) fm_BackgroundColor{
    return self.overlay.backgroundColor;
}
@end

@implementation UISearchBar (FMExtensions)
- (void)fm_setBackgroundColor:(UIColor *)color{
    self.backgroundColor = color;
    for (UIView *subview in self.subviews[0].subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;
        }
    }
}

@end





#pragma mark UIImage
typedef enum {
    kColor_0 = 0x1CBDF2,
    kColor_1 = 0x5392EF,
    kColor_2 = 0x33CC33,
    kColor_3 = 0xEBC506,
    kColor_4 = 0xF8A900,
    kColor_5 = 0xF68A42,
    kColor_6 = 0xF04C75,
    kColor_7 = 0xC773E3,
    kColor_8 = 0xF78B26,
    kColor_9 = 0x3CBB98
}ContactLogoBgColor;


@implementation UIView (FMExtensions)

- (UIImage *)fm_snapshot{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)fm_imageWithCornerRadius:(CGFloat)radius corner:(UIRectCorner)corner{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    path.lineWidth = 1;
    [path closePath];
    CGContextAddPath(ctx, path.CGPath);
    CGContextClip(ctx);
    
    [self.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end



@implementation UIImage (FMExtensions)

+ (UIImage *) fm_imageWithNameString:(NSString *) name
                     backgroundColor:(UIColor * _Nullable ) color
                                size:(CGSize) targetSize{
    static NSCache* cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[NSCache alloc] init];
        cache.countLimit = 100;
    });
    
    name = [self convertName:name];
    
    NSString* key = [NSString stringWithFormat:@"%@_%2f",name,MIN(targetSize.width,targetSize.height)];
    UIImage* cacheImage = [cache objectForKey:key];
    if (cacheImage) {
        return cacheImage;
    }
    
    CGFloat edge = MIN(targetSize.width, targetSize.height);
    BOOL ios7 = [UIDevice currentDevice].systemVersion.intValue>6;
    CGSize size = CGSizeMake(edge, edge);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);//no- 透明背景  0-自适应屏幕缩放
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //绘制外侧圆形边框
    [[UIColor whiteColor] set];
    CGFloat bigRadius = edge*0.5;
    CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI*2, 0);
    CGContextFillPath(ctx);
    
    
    //默认名字的头像背景颜色
    CGFloat board = 0.f;
    [color?:[self getColorWithName:name] set];
    CGFloat smallRadius = (edge-board*2)*0.5;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI*2, 0);
    CGContextFillPath(ctx);
    
    //写字
    CGContextSetLineWidth(ctx, 2.0);
    CGFloat fontSize1 = 20.0*(edge/50.0);
    CGFloat fontSize2 = 14.0*(edge/50.0);
    UIFont* fontBig = [UIFont fontWithName:@"STHeitiSC-Medium" size:fontSize1];
    UIFont* fontSmall = [UIFont fontWithName:@"STHeitiSC-Medium" size:fontSize2];
    
    
    
    switch (name.length) {
        case 1:
        {
            [name drawAtPoint:CGPointMake(centerX-fontSize1*0.5, centerY-fontSize1*0.5)
               withAttributes:@{NSFontAttributeName:fontBig,NSForegroundColorAttributeName:[UIColor whiteColor]}];
        }
            break;
        case 2:
        {
            NSString* char1 = [name substringToIndex:1];
            NSString* char2 = [name substringFromIndex:1];
            NSDictionary* attr1 = @{NSFontAttributeName:fontBig,NSForegroundColorAttributeName:[UIColor whiteColor]};
            NSDictionary* attr2 = @{NSFontAttributeName:fontSmall,NSForegroundColorAttributeName:[UIColor whiteColor]};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            CGSize size1 = ios7?[char1 sizeWithAttributes:attr1]:[char1 sizeWithFont:fontBig];
            CGSize size2 = ios7?[char2 sizeWithAttributes:attr2]:[char2 sizeWithFont:fontSmall];
#pragma clang diagnostic pop
            [char1 drawAtPoint:CGPointMake(centerX-(size1.width+size2.width)*0.5, (edge-size1.height)*0.5)
                withAttributes:@{
                                 NSFontAttributeName:fontBig,
                                 NSForegroundColorAttributeName:[UIColor whiteColor]}
             ];
            [char2 drawAtPoint:CGPointMake(size1.width+(edge-(size1.width+size2.width))*0.5, (edge+size1.height)*0.5 - size2.height)
                withAttributes:@{
                                 NSFontAttributeName:fontSmall,
                                 NSForegroundColorAttributeName:[UIColor whiteColor]}
             ];
        }
            break;
        default:
        {
            //utf-8 一个中文长度为0，一个英文长度为1
            //ios7
            NSDictionary* attr = @{NSFontAttributeName:fontSmall,NSForegroundColorAttributeName:[UIColor whiteColor]};
            CGSize size;
            if ([UIDevice currentDevice].systemVersion.intValue>6) {
                size = [name sizeWithAttributes:attr];
            }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                size = [name sizeWithFont:fontSmall];//ios6使用改api
#pragma clang diagnostic pop
            }
            CGFloat pointX = centerX - size.width*0.5;
            [name drawAtPoint:CGPointMake(pointX, centerY-size.height*0.5) withAttributes:attr];
        }
            break;
    }
    
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [cache setObject:img forKey:key];
    return img;
}

+(UIColor*) getColorWithName:(NSString*) name{
    
    char *data = [name dataUsingEncoding:NSASCIIStringEncoding].bytes;
    
    switch ((data[0])%10) {
        case 0:
            return [UIColor colorWithHex:kColor_0];
        case 1:
            return [UIColor colorWithHex:kColor_1];
        case 2:
            return [UIColor colorWithHex:kColor_2];
        case 3:
            return [UIColor colorWithHex:kColor_3];
        case 4:
            return [UIColor colorWithHex:kColor_4];
        case 5:
            return [UIColor colorWithHex:kColor_5];
        case 6:
            return [UIColor colorWithHex:kColor_6];
        case 7:
            return [UIColor colorWithHex:kColor_7];
        case 8:
            return [UIColor colorWithHex:kColor_8];
        case 9:
            return [UIColor colorWithHex:kColor_9];
        default:
            return [UIColor colorWithHex:kColor_9];
    }
}


+(NSString*) convertName:(NSString*) name{
    switch (name.length) {
        case 0:
            return @"未知";
        case 1:
        case 2:
            return name;
        default:
        {
            NSMutableString* chinese = [NSMutableString string];
            NSMutableString* english = [NSMutableString string];
            for(int i=0; i< [name length];i++){
                unichar a = [name characterAtIndex:i];
                if( a > 0x4e00 && a < 0x9fff){//中文
                    [chinese appendString:[NSString stringWithCharacters:&a length:1]];
                }
                else{
                    [english appendFormat:@"%c",a];
                }
                
            }
            if(chinese.length>0){
                return [chinese substringFromIndex:MAX(0, (NSInteger)chinese.length-2)];
            }
            if (english.length>0) {
                return [english substringFromIndex:MAX(0,(NSInteger)english.length-5)];
            }
        }
            break;
    }
    return nil;
}


- (UIImage*)fm_blurImageWithBlur:(CGFloat)blur{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    /*void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
     vImage_Buffer outBuffer2;
     outBuffer2.data = pixelBuffer2;
     outBuffer2.width = CGImageGetWidth(img);
     outBuffer2.height = CGImageGetHeight(img);
     outBuffer2.rowBytes = CGImageGetBytesPerRow(img);*/
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend)
    ?: vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend)
    ?: vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    //free(pixelBuffer2);
    
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    
    
    return returnImage;
}

- (UIImage *)fm_imageWithCornerRadius:(CGFloat) radius corner:(UIRectCorner) corner{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    path.lineWidth = 1;
    [path closePath];
    CGContextAddPath(ctx, path.CGPath);
    CGContextClip(ctx);
    
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end


#pragma mark - NSObject
@implementation NSObject (FMExtensions)
- (void) fm_setProperty:(id) value forKey:(NSString *) key{
    @try {
        [self setValue:value forUndefinedKey:key];
    }
    @catch (NSException *exception) {
        objc_setAssociatedObject(self, (__bridge const void *)(key), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
- (id) fm_propertyForKey:(NSString *) key{
    @try {
        return [self valueForKey:key];
    }
    @catch (NSException *exception) {
        return objc_getAssociatedObject(self, (__bridge const void *)(key));
    }
}
@end


@implementation NSObject (Notify)


- (void)waitNow{
    NSThread *currentThread = [NSThread currentThread];
    @synchronized (self) {
        NSMutableArray *threads = self.fmThreads;
        [threads addObject:currentThread];
    }
    [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    while ([self.fmThreads containsObject:currentThread]) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

- (BOOL)waitForTimeinterval:(NSTimeInterval) interval{
    BOOL timeOut = NO;
    NSThread *currentThread = [NSThread currentThread];
    @synchronized (self) {
        NSMutableArray *threads = self.fmThreads;
        [threads addObject:currentThread];
    }
    [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    int count = 0;
    while ([self.fmThreads containsObject:currentThread]) {
        if (count>0) {//如果被notify，则不会继续进入循环；如果是超时，则会进入循环，在此处进行排除
            timeOut = YES;
            break;
        }
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
        count++;
    }
    return timeOut;
}

- (void)notify{
    @synchronized (self) {
        NSThread *thread = [self.fmThreads firstObject];
        if (thread) {
            [self performSelector:@selector(fmRemoveWaitingThread:)
                         onThread:thread withObject:thread waitUntilDone:NO];
        }
    }
}

- (void)notifyAll{
    @synchronized (self) {
        NSArray *threads = self.fmThreads;
        dispatch_apply(threads.count, dispatch_queue_create("", DISPATCH_QUEUE_CONCURRENT), ^(size_t idx){
            NSThread *thread = threads[idx];
            [self performSelector:@selector(fmRemoveWaitingThread:)
                         onThread:thread withObject:thread waitUntilDone:NO];
        });
    }
}



#pragma private
static char *kFMThreadsKey;
- (NSMutableArray *)fmThreads{
    NSMutableArray *threads = objc_getAssociatedObject(self, &kFMThreadsKey);
    if (!threads) {
        @synchronized (self) {
            threads = objc_getAssociatedObject(self, &kFMThreadsKey);
            if (!threads) {
                threads = [NSMutableArray array];
                objc_setAssociatedObject(self, &kFMThreadsKey, threads, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
    }
    return threads;
}

- (void)fmRemoveWaitingThread:(NSThread *)thread{
    NSMutableArray *threads = self.fmThreads;
    @synchronized(threads){
        [threads removeObject:thread];
    }
}

@end





