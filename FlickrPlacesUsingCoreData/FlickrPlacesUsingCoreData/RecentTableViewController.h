//
//  RecentTableViewController.h
//  FlickrPlacesUsingCoreData
//
//  Created by Chetan Sanghi on 29/11/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataTableViewController.h"

@interface RecentTableViewController : CoreDataTableViewController

- initInManagedObjectContext:(NSManagedObjectContext *)context;

- (void)managedObjectSelected:(NSManagedObject *)managedObject;

@end
