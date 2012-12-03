//
//  City.m
//  FlickrPlacesUsingCoreData
//
//  Created by Chetan Sanghi on 30/11/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import "City.h"
#import "PhotoDescription.h"
#import "FlickrFetcher.h"
#import "AppDelegate.h"

@implementation City


+ (City *)cityWithFlickrData:(NSDictionary *)flickrData inManagedObjectContext:(NSManagedObjectContext *)context
{
	City *city = nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"City" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"cityID = %@", [flickrData objectForKey:@"place_id"]];
	
	NSError *error = nil;
	city = [[context executeFetchRequest:request error:&error] lastObject];
    
	if (!error && !city) {
		city = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:context];
        city.cityID = [flickrData objectForKey:@"place_id"];
		city.cityTitle = [flickrData objectForKey:@"woe_name"];
		city.cityDescription = [flickrData objectForKey:@"_content"];
	}
    city.lastAccessTime =[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
	return city;
}


- (NSString *)firstLetterOfName
{
	return [[self.cityTitle substringToIndex:1] capitalizedString];
}

-(NSArray*) getListOfPhotosWithBlock{
    

    // Using Descriptor for sorting
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateupload" ascending:YES];
    AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //[appDelegate setNetworkActivityIndicatorVisible:YES];
    [appDelegate setNetworkActivityIndicatorVisible:[NSNumber numberWithBool:YES]];
    NSArray * listOfPhotos = [[FlickrFetcher photosAtPlace:self.cityID] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
   [appDelegate setNetworkActivityIndicatorVisible:[NSNumber numberWithBool:NO]];
    
    return listOfPhotos;
}

@dynamic cityDescription;
@dynamic cityID;
@dynamic cityTitle;
@dynamic lastAccessTime;
@dynamic photos;

@end
