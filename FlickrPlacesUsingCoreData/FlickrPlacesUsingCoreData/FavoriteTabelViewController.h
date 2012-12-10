//
//  FavoriteTabelViewController.h
//  FlickrPlacesUsingCoreData
//
//  Created by Chetan Sanghi on 30/11/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataTableViewController.h"
#import "City.h"

@interface FavoriteTabelViewController : CoreDataTableViewController

- initCityInManagedObjectContext:(NSManagedObjectContext *)context;

- initInManagedObjectContext:(NSManagedObjectContext *)context withCity:(City*) city;
- (NSFetchedResultsController *) getAllCitiesAccessed:(NSManagedObjectContext *)context;
- (NSFetchedResultsController *) getFavoriteCities:(NSManagedObjectContext *)context;

- (void)managedObjectSelected:(NSManagedObject *)managedObject;

@end
