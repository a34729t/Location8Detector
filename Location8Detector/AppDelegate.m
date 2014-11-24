//
//  AppDelegate.m
//  Location8Detector
//
//  Created by Nicolas Flacco on 11/24/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import "AppDelegate.h"
@import CoreLocation;

// Define some constants
#define BEACON_SERVICE_NAME     @"demo"
#define BEACON_PROXIMITY_UUID   [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57F666"]

@interface AppDelegate () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLRegion *myRegion;

@end

@implementation AppDelegate

// <Notification-based region monitoring>

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    // Check status to see if the app is authorized
    BOOL canUseLocationNotifications = (status == kCLAuthorizationStatusAuthorizedWhenInUse);
    
    if (canUseLocationNotifications) {
        [self startShowingLocationNotifications]; // Custom method defined below
    }
}

- (void)startShowingLocationNotifications {
    
    UILocalNotification *locNotification = [[UILocalNotification alloc] init];
    locNotification.alertBody = @"Your buddy is nearby";
    locNotification.regionTriggersOnce = YES;
    
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:BEACON_PROXIMITY_UUID major:100 minor:400 identifier:BEACON_SERVICE_NAME];
    
    locNotification.region = beaconRegion;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:locNotification];
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification: (UILocalNotification *)notification {
    
    CLRegion *region = notification.region;
    
    if (region) {
        NSLog(@"XYZ");
    }
}

// <\Notification-based region monitoring>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status != kCLAuthorizationStatusAuthorizedAlways) {
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        } else {
            // NOTE: Handle iOS7 deprecated stuff - NSLocationUsageDescription (see 2014 WWDC video)
        }
    }
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    // NOTE: We can always push the user to the iOS settings
    
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

@end
