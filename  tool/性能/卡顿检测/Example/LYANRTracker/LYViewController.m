//
//  LYViewController.m
//  LYANRTracker
//
//  Created by liyuan on 03/12/2017.
//  Copyright (c) 2017 liyuan. All rights reserved.
//

#import "LYViewController.h"
#import <LYANRTracker/LYANRTracker.h>
#import <CrashReporter/CrashReporter.h>

@interface LYViewController ()

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) NSString *report;

@property (nonatomic, strong) LYANRTracker *tracker1;

@property (nonatomic, strong) LYANRTracker *tracker2;
@end

@implementation LYViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    
    {
        self.tracker1 = [[LYANRTracker alloc] init];
        [self.tracker1 startWithThreshold:1 handler:^(double threshold) {
            [weakSelf _generateLiveReport];
            
            [weakSelf _showAlert];
        }];
    }

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.textView.frame = self.view.frame;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        self.textView.text = self.report;
    }
    
}

- (void)_showAlert {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:@"检测到卡顿"
                                    message:@"已为你解析好卡顿堆栈"
                                   delegate:self
                          cancelButtonTitle:@"取消"
                          otherButtonTitles:@"查看", nil] show];
    });
}

- (void)_generateLiveReport {
    PLCrashReporterSignalHandlerType type = PLCrashReporterSignalHandlerTypeBSD;
    PLCrashReporterSymbolicationStrategy strategy = PLCrashReporterSymbolicationStrategySymbolTable;
    
    PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType:type
                                                                       symbolicationStrategy:strategy];
    
    PLCrashReporter *crashReporter = [[PLCrashReporter alloc] initWithConfiguration:config];
    
    
    NSData *data = [crashReporter generateLiveReport];
    PLCrashReport *reporter = [[PLCrashReport alloc] initWithData:data error:NULL];
    self.report = [PLCrashReportTextFormatter stringValueForCrashReport:reporter
                                                         withTextFormat:PLCrashReportTextFormatiOS];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
