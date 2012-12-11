//
//  PhotoDescription.h
//  FlickrPlacesUsingCoreData
//
//  Created by Chetan Sanghi on 30/11/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City;

@interface PhotoDescription : NSManagedObject

@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSNumber * lastAccessTime;
@property (nonatomic, retain) NSString * photoDescription;
@property (nonatomic, retain) NSString * photoTitle;
@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) City *whereTook;
+ (PhotoDescription *)PhotoDescriptionWithFlickrData:(NSDictionary *)flickrData withCity:(City*)city inManagedObjectContext:(NSManagedObjectContext *)context;
-(void) processImageDataWithBlock:(void (^) (NSData * imageData)) processImage;
@end
