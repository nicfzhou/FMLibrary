//
//  GCD.h
//  SpeeedApp
//
//  Created by 周峰 on 15/11/19.
//  Copyright © 2015年 Feng.Z. All rights reserved.
//

#import <Foundation/Foundation.h>

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
