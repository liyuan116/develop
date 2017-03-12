//
//  LYPingThread.m
//  Pods
//
//  Created by liyuan on 2017/3/12.
//
//

#import "LYPingThread.h"

@interface LYPingThread()

/**
 *  控制ping主线程的信号量
 */
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

/**
 *  卡顿阈值
 */
@property (nonatomic, assign) double threshold;

/**
 *  卡顿回调
 */
@property (nonatomic, copy) LYANRTrackerBlock handler;

/**
 *  主线程是否阻塞
 */
@property (nonatomic, assign,getter=isMainThreadBlock) BOOL mainThreadBlock;


@end


@implementation LYPingThread
- (instancetype)initWithThreshold:(double)threshold
                          handler:(LYANRTrackerBlock)handler {
    self = [super init];
    if (self) {
        self.semaphore = dispatch_semaphore_create(0);
        
        self.threshold = threshold;
        self.handler = handler;
    }
    return self;
}

- (void)main {
    
    while (!self.cancelled) {
        //初始化主线程卡顿
        self.mainThreadBlock = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.mainThreadBlock = NO;
            dispatch_semaphore_signal(self.semaphore);
        });
        
        [NSThread sleepForTimeInterval:self.threshold];
        //ping线程在阈值时间过后如果还没被执行说明卡顿
        if (self.isMainThreadBlock) {
            self.handler(self.threshold);
        }
        
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    }
}

@end
