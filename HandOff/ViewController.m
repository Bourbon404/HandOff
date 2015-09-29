//
//  ViewController.m
//  HandOff
//
//  Created by BourbonZ on 15/9/29.
//  Copyright © 2015年 BourbonZ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSUserActivityDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createActivity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createActivity
{
    NSUserActivity *activity = [[NSUserActivity alloc] initWithActivityType:@"cn.bourbonz.handoff"];
    activity.title = @"title";
    activity.userInfo = @{@"user":@"123"};
    activity.supportsContinuationStreams = YES;
    [activity setDelegate:self];
    [activity becomeCurrent];
}
#pragma delegate
-(void)userActivity:(NSUserActivity *)userActivity didReceiveInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream
{
    NSLog(@"didReceiveInputStream");
}
-(void)userActivityWasContinued:(NSUserActivity *)userActivity
{
    NSLog(@"userActivityWasContinued");
}
-(void)userActivityWillSave:(NSUserActivity *)userActivity
{
    NSLog(@"userActivityWillSave");
}
-(void)updateUserActivityState:(NSUserActivity *)activity
{
    NSLog(@"updateUserActivityState");
    [activity addUserInfoEntriesFromDictionary:@{@"user":@"123"}];
    [activity needsSave];
}
@end
