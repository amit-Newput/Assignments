//
//  Drinks.h
//  DrinkMixer
//
//  Created by NewputMac04 on 04/12/12.
//  Copyright (c) 2012 NewputMac04. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Drinks : NSManagedObject

@property (nonatomic, retain) NSString * drinkName;
@property (nonatomic, retain) NSString * drinkIngredients;
@property (nonatomic, retain) NSString * drinkMakingSteps;
// creates the object in db if it does not exist else returns the already existing object
+ (Drinks *)drinkWithData:(NSDictionary *)drinkData inManagedObjectContext:(NSManagedObjectContext *)context;
//get all the drinks
+ (NSArray*) getAllDrinksInManagedObjectContext:(NSManagedObjectContext*)context;
@end
