//
//  LYPingThread.h
//  Pods
//
//  Created by liyuan on 2017/3/12.
//
//

#import <Foundation/Foundation.h>
#import "LYANRTracker.h"

/**
 *  用于Ping主线程的线程类
 *  通过信号量控制来Ping主线程，判断主线程是否卡顿
 */
@interface LYPingThread : NSThread

/**
 *  初始化Ping主线程的线程类
 *
 *  @param threshold 主线程卡顿阈值
 *  @param handler   监控到卡顿回调
 */
- (instancetype)initWithThreshold:(double)threshold
                          handler:(LYANRTrackerBlock)handler;

@end
