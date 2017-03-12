//
//  LYANRTracker.h
//  Pods
//
//  Created by liyuan on 2017/3/12.
//
//

#import <Foundation/Foundation.h>

typedef void (^LYANRTrackerBlock)(double threshold);

//ANR监控状态枚举
typedef NS_ENUM(NSUInteger, LYANRTrackerStatus) {
    LYANRTrackerStatusStart, //监控开启
    LYANRTrackerStatusStop,  //监控停止
};

/**
 *  主线程卡顿监控类
 */
@interface LYANRTracker : NSObject
/**
 *  过滤4s以下机型（默认为YES）
 *  NOTE:如您需要在4S以下设备检测卡顿监控，请在start之前将该过滤属性设置为NO
 */
@property (nonatomic, assign) BOOL filterBelowiPhLY4s;

/**
 *  开始监控
 *
 *  @param threshold 卡顿阈值
 *  @param handler   监控到卡顿回调(回调时会自动暂停卡顿监控)
 */
- (void)startWithThreshold:(double)threshold
                   handler:(LYANRTrackerBlock)handler;

/**
 *  停止监控
 */
- (void)stop;

/**
 *  ANR监控状态
 */
- (LYANRTrackerStatus)status;
@end
