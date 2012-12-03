//
//  CityTableViewController.m
//  FlickrPlacesUsingCoreData
//
//  Created by Chetan Sanghi on 29/11/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import "RecentTableViewController.h"
#import "PhotoDescription.h"
#import "PhotoViewController.h"

@implementation RecentTableViewController
- initInManagedObjectContext:(NSManagedObjectContext *)context
{
	if (self = [super initWithStyle:UITableViewStylePlain])
	{
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		request.entity = [NSEntityDescription entityForName:@"PhotoDescription" inManagedObjectContext:context];
		request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"lastAccessTime" ascending:NO selector:@selector(compare:)]];
		request.predicate = nil;
        request.fetchBatchSize = 20;
		
		NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
                                           initWithFetchRequest:request
                                           managedObjectContext:context
                                           sectionNameKeyPath:nil
                                           cacheName:nil];
		
		self.fetchedResultsController = frc;
		self.titleKey = @"photoTitle";
        self.subtitleKey =@"photoDescription";
		self.searchKey = @"photoTitle";
	}
	return self;
}

- (void)managedObjectSelected:(NSManagedObject *)managedObject
{
	PhotoDescription  *thisPhotoDescription = (PhotoDescription *)managedObject;
	PhotoViewController *pvc = [[PhotoViewController alloc] init];
    thisPhotoDescription.lastAccessTime = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    pvc.photoDescription    = thisPhotoDescription;
    //pvc.title = thisPhotoDescription.photoTitle;
	[self.navigationController pushViewController:pvc animated:YES];
}
@end
