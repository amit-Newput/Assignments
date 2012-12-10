//
//  PhotoDescription.m
//  FlickrPlacesUsingCoreData
//
//  Created by Chetan Sanghi on 30/11/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import "PhotoDescription.h"
#import "City.h"
#import "FlickrFetcher.h"
#import "AppDelegate.h"

@implementation PhotoDescription


+ (PhotoDescription *)PhotoDescriptionWithFlickrData:(NSDictionary *)flickrData withCity:(City*)city inManagedObjectContext:(NSManagedObjectContext *)context
{
	PhotoDescription *photoDescription = nil;
	
    NSString* photoURL = [FlickrFetcher urlStringForPhotoWithFlickrInfo:flickrData format:FlickrFetcherPhotoFormatLarge];

	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"PhotoDescription" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"photoURL = %@", photoURL];
	
	NSError *error = nil;
	photoDescription = [[context executeFetchRequest:request error:&error] lastObject];
    
    //there should be error and photo description is nil but city is not nil then create new PhotoDescription in database 
	if (!error && !photoDescription && city) {
		photoDescription = [NSEntityDescription insertNewObjectForEntityForName:@"PhotoDescription" inManagedObjectContext:context];
        photoDescription.photoTitle = [flickrData objectForKey:@"title"];
		photoDescription.photoDescription = [(NSDictionary*)[flickrData objectForKey:@"description"] objectForKey:@"_content"];
        photoDescription.photoURL= photoURL;
        photoDescription.whereTook = city;
	}
       
    photoDescription.lastAccessTime =[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
	
	return photoDescription;
}

- (NSString *)firstLetterOfName
{
	return [[self.photoTitle substringToIndex:1] capitalizedString];
}


-(void) processImageDataWithBlock:(void (^) (NSData * imageData)) processImage{
    NSString* url = self.photoURL;
    dispatch_queue_t callerQueue =  dispatch_get_current_queue();
    dispatch_queue_t downloadQueue = dispatch_queue_create("PhotoDownloadQueue", NULL);
    dispatch_async(downloadQueue, ^{
        AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate setNetworkActivityIndicatorVisible:[NSNumber numberWithBool:YES]];
        NSData * imageData = [FlickrFetcher imageDataForPhotoWithURLString:url];
        [appDelegate setNetworkActivityIndicatorVisible:[NSNumber numberWithBool:NO]];
        dispatch_async(callerQueue, ^{
        processImage(imageData);
        });
    });
                                                           
                                                           
}
@dynamic favorite;
@dynamic lastAccessTime;
@dynamic photoDescription;
@dynamic photoTitle;
@dynamic photoURL;
@dynamic whereTook;

@end
