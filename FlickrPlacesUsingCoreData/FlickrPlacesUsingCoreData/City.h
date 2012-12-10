//
//  City.h
//  FlickrPlacesUsingCoreData
//
//  Created by Chetan Sanghi on 30/11/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PhotoDescription;

@interface City : NSManagedObject

@property (nonatomic, retain) NSNumber * cityDescription;
@property (nonatomic, retain) NSString * cityID;
@property (nonatomic, retain) NSString * cityTitle;
@property (nonatomic, retain) NSNumber * lastAccessTime;
@property (nonatomic, retain) NSSet *photos;
-(NSMutableDictionary *) createPhotoDictionary:(NSArray *) listOfPhotos;

+ (City *)cityWithFlickrData:(NSDictionary *)flickrData inManagedObjectContext:(NSManagedObjectContext *)context;
-(NSArray*) getListOfPhotosWithBlock;
@end

@interface City (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(PhotoDescription *)value;
- (void)removePhotosObject:(PhotoDescription *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
