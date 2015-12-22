//
//  GCD.m
//  SpeeedApp
//
//  Created by 周峰 on 15/11/19.
//  Copyright © 2015年 ivtime. All rights reserved.
//

#import "GCDQueue.h"

@interface GCDQueue ()
@property(nonatomic,strong) NSMutableArray* tasks;
@property(nonatomic,strong) dispatch_queue_t gdcQueue;
@end
@implementation GCDQueue

- (instancetype) initWithLevel:(int) level{
    self = [super init];
    self.tasks = [NSMutableArray array];
    switch (level) {
        case 0:
            self.gdcQueue = dispatch_get_main_queue();
            break;
        case 1:
            self.gdcQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
            break;
        case 2:
            self.gdcQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            break;
        case 3:
            self.gdcQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
            break;
        case 4:
            self.gdcQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
            break;
    }
    return self;
}

+ (instancetype) mainQueue{
    return [[GCDQueue alloc] initWithLevel:0];
}
+ (instancetype) backgroundQueue{
    return [[GCDQueue alloc] initWithLevel:1];
}
+ (instancetype) defaultQueue{
    return [[GCDQueue alloc] initWithLevel:2];
}
+ (instancetype) highQueue{
    return [[GCDQueue alloc] initWithLevel:3];
}
+ (instancetype) lowQueue{
    return [[GCDQueue alloc] initWithLevel:4];
}

- (void) execute{
    for (void(^task)() in self.tasks) {
        dispatch_async(self.gdcQueue, task);
    }
    [self.tasks removeAllObjects];
}
- (void) executeWithCompleted:(void(^)(void)) task{
    return [self executeWithCompleted:task onQueue:[GCDQueue mainQueue]];
}
- (void) executeWithCompleted:(void(^)(void)) task onQueue:(GCDQueue*) queue{
    dispatch_group_t group = dispatch_group_create();
    for (void(^task)() in self.tasks) {
        dispatch_group_async(group, self.gdcQueue, task);
    }
    [self.tasks removeAllObjects];
    if (task) {
        if (!queue) {
            queue = [GCDQueue mainQueue];
        }
        dispatch_group_notify(group, queue.gdcQueue, [task copy]);
    }
}
- (void) execute:(void(^)(void)) task{
    dispatch_async(self.gdcQueue, task);
}
- (void) execute:(void (^)(void))task afterDelay:(NSTimeInterval) after{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after * NSEC_PER_SEC)), self.gdcQueue, task);
}

- (instancetype) addExecuteTask:(void(^)(void)) task{
    [self.tasks addObject:[task copy]];
    return self;
}

- (void) dealloc{
#if DEBUG
//    NSLog(@"dealloc of %@<%@>",NSStringFromClass([self class]),self);
#endif
}


@end
