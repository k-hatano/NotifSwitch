//
//  AppDelegate.m
//  NotifSwitch
//
//  Created by HatanoKenta on 2015/04/03.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)watchApplications:(NSTimer*)timer{
    if (!self.isThreadRunning){
        NSArray *currentRunningApplications = [[NSWorkspace sharedWorkspace] runningApplications];
        
        self.isThreadRunning = YES;
        if (self.lastRunningApplications){
            NSArray *lastApplications = self.lastRunningApplications;
            
            for(NSRunningApplication *app in currentRunningApplications){
                if (app.activationPolicy != NSApplicationActivationPolicyRegular) {
                    continue;
                }
                if (![lastApplications containsObject:app]){
                    NSUserNotification *notif = [[NSUserNotification alloc] init];
                    notif.title = app.localizedName;
                    //notif.informativeText = [[app.bundleURL.absoluteString lastPathComponent]stringByReplacingPercentEscapesUsingEncoding:NSShiftJISStringEncoding];
                    notif.userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:app.bundleIdentifier, @"identifier", nil, nil];
                    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notif];
                    
                    [self.notifiedApplications setValue:notif forKey:app.localizedName];
                }
            }
            
            for(NSRunningApplication *app in lastApplications){
                if (app.activationPolicy != NSApplicationActivationPolicyRegular) {
                    continue;
                }
                if (![currentRunningApplications containsObject:app]){
                    @try {
                        NSUserNotification *notif=[self.notifiedApplications valueForKey:app.localizedName];
                        [[NSUserNotificationCenter defaultUserNotificationCenter] removeDeliveredNotification:notif];
                    }
                    @catch (NSException *exception) {
                        @throw exception;
                    }
                    
                    [self.notifiedApplications setNilValueForKey:app.bundleURL.absoluteString];
                }
            }
        }
        self.lastRunningApplications = currentRunningApplications;
        
        self.isThreadRunning = NO;
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [NSUserNotificationCenter defaultUserNotificationCenter].delegate = self;
    
    NSArray *currentRunningApplications = [[NSWorkspace sharedWorkspace] runningApplications];
    self.notifiedApplications = [[NSMutableDictionary alloc] init];
    
    for(NSRunningApplication *app in currentRunningApplications){
        if (app.activationPolicy != NSApplicationActivationPolicyRegular) {
            continue;
        }
        NSUserNotification *notif = [[NSUserNotification alloc] init];
        notif.title = app.localizedName;
        //notif.informativeText = [[app.bundleURL.absoluteString lastPathComponent]stringByReplacingPercentEscapesUsingEncoding:NSShiftJISStringEncoding];
        notif.userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:app.bundleIdentifier, @"identifier", nil, nil];
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notif];
        
        [self.notifiedApplications setValue:notif forKey:app.bundleURL.absoluteString];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(watchApplications:) userInfo:nil repeats:YES];
}

- (void)applicationWillTerminate:(NSNotification *)notification{
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
    
    NSString *identifier = [notification.userInfo valueForKey:@"identifier"];
    
    NSArray *currentRunningApplications = [[NSWorkspace sharedWorkspace] runningApplications];
    for(NSRunningApplication *app in currentRunningApplications){
        if ([app.bundleIdentifier isEqualToString:identifier]){
            [app activateWithOptions:NSApplicationActivateAllWindows];
            break;
        }
    }
}

@end
