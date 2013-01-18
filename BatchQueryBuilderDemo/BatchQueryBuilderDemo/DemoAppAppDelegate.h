//
//  DemoAppAppDelegate.h
//  BatchQueryBuilderDemo
//
//  Created by Prateek Pradhan on 08/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BatchQueryController;

@interface DemoAppAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BatchQueryController *viewController;

@end
