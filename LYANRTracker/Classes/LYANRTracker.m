//
//  LYANRTracker.m
//  Pods
//
//  Created by liyuan on 2017/3/12.
//
//

#import "LYANRTracker.h"
#import "LYPingThread.h"
#import "sys/utsname.h"


@interface LYANRTracker()
/**
 *  用于Ping主线程的线程实例
 */
@property (nonatomic, strong) LYPingThread *pingThread;


@end

@implementation LYANRTracker
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.filterBelowiPhLY4s = YES;
    }
    return self;
}

- (void)startWithThreshold:(double)threshold
                   handler:(LYANRTrackerBlock)handler {
    //过滤4S以下机型
    if ([self belowiPhLY4s] && self.filterBelowiPhLY4s) {
        return;
    }
    
    self.pingThread = [[LYPingThread alloc] initWithThreshold:threshold
                                                       handler:^(double threshold) {
                                                           handler(threshold);
                                                       }];
    
    [self.pingThread start];
}

- (void)stop {
    if (self.pingThread != nil) {
        [self.pingThread cancel];
        self.pingThread = nil;
    }
}

- (LYANRTrackerStatus)status {
    if (self.pingThread != nil && self.pingThread.isCancelled != YES) {
        return LYANRTrackerStatusStart;
    }else {
        return LYANRTrackerStatusStop;
    }
}

- (BOOL)belowiPhLY4s {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine
                                                encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhLY1,1"]         //"iPhLY 1G"
        ||[deviceString isEqualToString:@"iPhLY1,2"]       //"iPhLY 3G"
        ||[deviceString isEqualToString:@"iPhLY2,1"]       //"iPhLY 3GS"
        ||[deviceString isEqualToString:@"iPhLY3,1"]       //"iPhLY 4"
        ||[deviceString isEqualToString:@"iPhLY4,1"]       //"iPhLY 4S"
        ) {
        return YES;
        
    }else {
        return NO;
    }
}

- (void)dealloc
{
    [self.pingThread cancel];
}
@end
