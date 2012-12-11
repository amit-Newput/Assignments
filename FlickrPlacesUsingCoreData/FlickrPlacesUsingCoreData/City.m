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

//this method creates PhotoDictionary based on time it was uploaded from the the given list of photos;

-(NSMutableDictionary *) createPhotoDictionary:(NSArray *) listOfPhotos{

     NSMutableDictionary*  dictionaryOfPhotos = [[NSMutableDictionary alloc] init];
    int photoCount = listOfPhotos.count;
    NSMutableArray* photoArray = [[NSMutableArray alloc] init];
    int currentHour = 0;
    for(int i=0;i<photoCount;++i)
    {
        NSDictionary* photoDictionary = [listOfPhotos objectAtIndex:i];
        double timeInterval = [ [photoDictionary valueForKey:@"dateupload"] doubleValue] ;
        NSDate* thisPhotoDate = [[NSDate alloc] initWithTimeIntervalSince1970:timeInterval];
        int thisPhotoHour = [thisPhotoDate timeIntervalSinceNow] /3600 ;
        thisPhotoHour *=-1;
        
        if(currentHour == thisPhotoHour){
            [photoArray addObject:photoDictionary];
        }
        else
        {
            if(photoArray.count >0 ){
                [dictionaryOfPhotos setObject:photoArray forKey: [[NSString stringWithFormat:@"%d",currentHour]stringByAppendingString:@" Hours Ago"]];
                photoArray = [[NSMutableArray alloc] init];
            }
            currentHour = thisPhotoHour;
        }
    }
    
    if(photoArray.count >0){
        [dictionaryOfPhotos setObject:photoArray forKey: [[NSString stringWithFormat:@"%d",currentHour]stringByAppendingString:@" Hours Ago"]];
    }
    return dictionaryOfPhotos;
}

@dynamic cityDescription;
@dynamic cityID;
@dynamic cityTitle;
@dynamic lastAccessTime;
@dynamic photos;

@end
