//
//  FavoriteTabelViewController.m
//  FlickrPlacesUsingCoreData
//
//  Created by Chetan Sanghi on 30/11/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import "FavoriteTabelViewController.h"
#import "PhotoViewController.h"
#import "AppDelegate.h"


@implementation FavoriteTabelViewController



-(void) showFavoriteCities{
            NSManagedObjectContext* context = [(AppDelegate*)[[UIApplication sharedApplication] delegate]  managedObjectContext];
    if(self.navigationItem.rightBarButtonItem.title == @"All Places"){

        self.navigationItem.rightBarButtonItem.title = @"Favorite Places";
        self.fetchedResultsController = [self getAllCitiesAccessed:context];
        
    }else{
        self.navigationItem.rightBarButtonItem.title = @"All Places";
        self.fetchedResultsController = [self getFavoriteCities:context];

    }

    [self.tableView reloadData];
    
}
- initCityInManagedObjectContext:(NSManagedObjectContext *)context 
{
	if (self = [super initWithStyle:UITableViewStylePlain])
	{
        
        UIBarButtonItem* placesBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Only Favorites" style:UIBarButtonItemStylePlain target:self action:@selector(showFavoriteCities)] ;
        NSFetchedResultsController*frc = [self getAllCitiesAccessed:context];
        self.navigationItem.rightBarButtonItem = placesBarButtonItem;
		self.fetchedResultsController = frc;
		self.titleKey = @"cityTitle";
        self.subtitleKey =@"cityDescription";
		self.searchKey = @"cityTitle";
	}
	return self;
}

- initInManagedObjectContext:(NSManagedObjectContext *)context withCity:(City*) city
{
	if (self = [super initWithStyle:UITableViewStylePlain])
	{
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		request.entity = [NSEntityDescription entityForName:@"PhotoDescription" inManagedObjectContext:context];
		request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"lastAccessTime" ascending:NO selector:@selector(compare:)]];
        
        //This will show favorite photos in the given city
		request.predicate = [NSPredicate predicateWithFormat:@"whereTook= %@  AND favorite = %@ ",city,[NSNumber numberWithBool:YES]];
		
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
    if([managedObject isMemberOfClass:[PhotoDescription class]]){
        PhotoDescription  *thisPhotoDescription = (PhotoDescription *)managedObject;
        PhotoViewController *pvc = [[PhotoViewController alloc] init];
        pvc.photoDescription    = thisPhotoDescription;
        //pvc.title = thisPhotoDescription.photoTitle;
        [self.navigationController pushViewController:pvc animated:YES];
    }
    else if([managedObject isMemberOfClass:[City class]]){
        City  *thisCity = (City *)managedObject;
        FavoriteTabelViewController *favoriteTVC = [[FavoriteTabelViewController alloc] initInManagedObjectContext:thisCity.managedObjectContext withCity:thisCity];
        favoriteTVC.title =@"Favorite Photos";
        [self.navigationController pushViewController:favoriteTVC animated:YES];
        
    }
    
    
}

-(NSFetchedResultsController *) getAllCitiesAccessed:(NSManagedObjectContext *)context{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"City" inManagedObjectContext:context];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"lastAccessTime" ascending:NO selector:@selector(compare:)]];
    
    //This will get us places having favorite photos
    //request.predicate = [NSPredicate predicateWithFormat:@"photos.favorite =%@",[NSNumber numberWithBool:YES]];;
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
                                       initWithFetchRequest:request
                                       managedObjectContext:context
                                       sectionNameKeyPath:nil
                                       cacheName:nil];
    return frc;
    
}

-(NSFetchedResultsController *) getFavoriteCities:(NSManagedObjectContext *)context{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"City" inManagedObjectContext:context];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"lastAccessTime" ascending:NO selector:@selector(compare:)]];
    
    //This will get us places having favorite photos
    request.predicate = [NSPredicate predicateWithFormat:@" ANY photos.favorite =%@",[NSNumber numberWithBool:YES]];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
                                       initWithFetchRequest:request
                                       managedObjectContext:context
                                       sectionNameKeyPath:nil
                                       cacheName:nil];
    return frc;
    
}


@end
