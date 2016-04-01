//
//  AppDelegate.m
//  scholarGo
//
//  Created by 姚家庆 on 16/3/28.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "AppDelegate.h"

@class YJWebViewController;
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //3D Touch按压程序图标的快捷项
    //快捷菜单的图标
    UIApplicationShortcutIcon *icon1=[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
    UIApplicationShortcutIcon *icon2=[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeBookmark];
    //设置标签
    UIApplicationShortcutItem *item1=[[UIApplicationShortcutItem alloc]initWithType:@"1" localizedTitle:@"搜索" localizedSubtitle:nil icon:icon1 userInfo:nil];
    UIApplicationShortcutItem *item2=[[UIApplicationShortcutItem alloc]initWithType:@"2" localizedTitle:@"书签" localizedSubtitle:nil icon:icon2 userInfo:nil];
    //设置app的快捷菜单
    [[UIApplication sharedApplication] setShortcutItems:@[item1,item2]];

    
    return YES;
}
-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    if([shortcutItem.localizedTitle isEqualToString:@"搜索"]){
        [self.window.rootViewController performSegueWithIdentifier:@"toWebView" sender:@"m.baidu.com" ];
    }else if([shortcutItem.localizedTitle isEqualToString:@"书签"]){
        if([self.window.rootViewController isKindOfClass:[UIViewController class]]){
            [self.window.rootViewController performSegueWithIdentifier:@"toBookmarkSegue1" sender:nil ];
        }else{
            [self.window.rootViewController performSegueWithIdentifier:@"toBookmarkSegue2" sender:nil ];
            
        }
        
    }
    
    
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

@end
