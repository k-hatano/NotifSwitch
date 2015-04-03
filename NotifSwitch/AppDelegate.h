//
//  AppDelegate.h
//  NotifSwitch
//
//  Created by HatanoKenta on 2015/04/03.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) BOOL isThreadRunning;
@property (retain) NSArray *lastRunningApplications;
@property (retain) NSMutableDictionary *notifiedApplications;

@end
