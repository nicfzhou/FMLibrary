//
//  NSObject+FMKVO.m
//  Pods
//
//  Created by 周峰 on 15/12/22.
//
//

#import "NSObject+FMCategory.h"
#import <objc/runtime.h>

@implementation NSObject (FMKVO)

@end

@implementation NSObject (Property4Category)

- (void) setProperty:(id)value forKey:(NSString *)key{
    @try {
        [self setValue:value forUndefinedKey:key];
    }
    @catch (NSException *exception) {
        objc_setAssociatedObject(self, (__bridge const void *)(key), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (id) propertyForKey:(NSString *)key{
    @try {
        return [self valueForKey:key];
    }
    @catch (NSException *exception) {
        return objc_getAssociatedObject(self, (__bridge const void *)(key));
    }
}

@end