//
//  AppDelegate.m
//  Anteater
//
//  Created by Sam Madden on 1/13/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import "AppDelegate.h"
#import "SensorModel.h"
#import "AnteaterREST.h"
#import <CoreLocation/CoreLocation.h>
#import "SettingsModel.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate {
    CLLocationManager *_locMgr;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[SensorModel instance] startScanning];
    [AnteaterREST getListOfAnthills:^(NSDictionary *hills) {
        NSLog(@"Got :%@", [hills description]);
    }];
    _locMgr = [[CLLocationManager alloc] init];
    [_locMgr requestWhenInUseAuthorization];
    
    if (![[SettingsModel instance] username]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIStoryboard *authStoryboard = [UIStoryboard storyboardWithName:@"LoginView" bundle:nil];
            LoginViewController *loginViewController = [authStoryboard instantiateInitialViewController];
            loginViewController.delegate = self;
            [self.window.rootViewController presentViewController:loginViewController animated:NO completion:nil];
        });
    }
    return YES;
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

-(void) loginComplete {
}

@end
