//
//  AppDelegate.h
//  FlickrPlacesUsingCoreData
//
//  Created by Chetan Sanghi on 29/11/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)setNetworkActivityIndicatorVisible:(NSNumber *)setVisible ;
//creates a new label having the given title text and returns it
+ (UILabel*) getTitleLabelwithTitle:(NSString*)titleText;

@end
