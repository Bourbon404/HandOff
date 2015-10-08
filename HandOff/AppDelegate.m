//
//  AppDelegate.m
//  HandOff
//
//  Created by BourbonZ on 15/9/29.
//  Copyright © 2015年 BourbonZ. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()
{
    UIApplicationShortcutItem *launchedShortcutItem;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    BOOL shouldPerformAdditionalDelegateHandling = YES;
    
    UIApplicationShortcutItem *shortcutItem = [launchOptions objectForKey:UIApplicationLaunchOptionsShortcutItemKey];
    NSLog(@"启动事件%@",launchOptions);
    if (shortcutItem == nil) {
        launchedShortcutItem = shortcutItem;
        
        // This will block "performActionForShortcutItem:completionHandler" from being called.

        shouldPerformAdditionalDelegateHandling = NO;
    }
    
    
    NSMutableArray *shortcutItems = [application.shortcutItems mutableCopy];
    for (int i = 0; i < 4; i++)
    {
        UIMutableApplicationShortcutItem *shoutItem = [[UIMutableApplicationShortcutItem alloc] initWithType:[[NSBundle mainBundle] bundleIdentifier] localizedTitle:@"title" localizedSubtitle:@"subtitle" icon:[UIApplicationShortcutIcon iconWithType:(UIApplicationShortcutIconTypePlay)] userInfo:@{@"123":@"key"}];
        
        [shortcutItems addObject:shoutItem];
    }
    
    application.shortcutItems = shortcutItems.copy;
    
    return shouldPerformAdditionalDelegateHandling;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark delegate
-(BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    NSString *firendID = [userActivity.userInfo objectForKey:@"kCSSearchableItemActivityIdentifier"];

    UINavigationController *navigationController = (UINavigationController *)[self.window rootViewController];
    [navigationController popToRootViewControllerAnimated:NO];
    
    ViewController *controller = (ViewController *)navigationController.viewControllers.firstObject;
    [controller showDetailWithName:firendID];
    
    return YES;
}
#pragma mark 3D touch
-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    NSDictionary *dict = [shortcutItem userInfo];
    NSLog(@"点击事件%@",dict);
    completionHandler(shortcutItem);
}
@end
