//
//  GCD.h
//  SpeeedApp
//
//  Created by 周峰 on 15/11/19.
//  Copyright © 2015年 Feng.Z. All rights reserved.
//

#import <Foundation/Foundation.h>


/** 阻塞并等待queue执行结束，和 FM_BLOCK_QUEUE_END 必须成对出现，调用FM_BLOCK_QUEUE_NOTIFY时，返回到被阻塞的线程继续执行，如果没有调用FM_BLOCK_QUEUE_NOTIFY，则被阻塞的线程会始终阻塞*/
#define FM_BLOCK_QUEUE_START  {NSThread *__fm_block_queue_thread = [NSThread currentThread];__block id __fm_block_queue_obj = nil;[[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];

#define FM_BLOCK_QUEUE_NOTIFY __fm_block_queue_obj = [NSMutableString new];[__fm_block_queue_obj performSelector:@selector(appendString:) onThread:__fm_block_queue_thread withObject:@"" waitUntilDone:NO];

#define FM_BLOCK_QUEUE_END while (!__fm_block_queue_obj) {[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];}}

@interface GCDQueue : NSObject

+ (instancetype) mainQueue;/**< 主线程（线性）  */
+ (instancetype) backgroundQueue;/**< 后台线程  */
+ (instancetype) defaultQueue;/**<  标准线程 */
+ (instancetype) highQueue;/**<  高级别线程 */
+ (instancetype) lowQueue;/**<  低级别线程 */

- (void) execute;
/**
 *  @author Feng.z, 15-11-19 17:11:17
 *
 *  @brief  dispatch_group 封装
 *
 *  @param task 其他task执行完毕后，被通知执行的任务(默认主线程回调)
 *
 *  @since 
 */
- (void) executeWithCompleted:(void(^)(void)) task;
- (void) executeWithCompleted:(void(^)(void)) task onQueue:(GCDQueue*) queue;
- (void) execute:(void(^)(void)) task;
- (void) execute:(void (^)(void))task afterDelay:(NSTimeInterval) after;

- (instancetype) addExecuteTask:(void(^)(void)) task;


@end
