//
//  Drinks.m
//  DrinkMixer
//
//  Created by NewputMac04 on 04/12/12.
//  Copyright (c) 2012 NewputMac04. All rights reserved.
//

#import "Drinks.h"


@implementation Drinks

+ (Drinks *)drinkWithData:(NSDictionary *)drinkData inManagedObjectContext:(NSManagedObjectContext *)context
{
	Drinks *drink= nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Drinks" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"drinkName = %@", [drinkData objectForKey:@"drink_name"]];
	
	NSError *error = nil;
	drink = [[context executeFetchRequest:request error:&error] lastObject];
    //Check for duplicate drink name.
	if (!error && !drink) {
		drink = [NSEntityDescription insertNewObjectForEntityForName:@"Drinks" inManagedObjectContext:context];
        drink.drinkName = [drinkData objectForKey:@"drink_name"];
        drink.drinkIngredients = [drinkData objectForKey:@"drink_ingredients"];
        drink.drinkMakingSteps = [drinkData objectForKey:@"drink_steps"];
	}
    
	return drink;
}


+ (NSArray*) getAllDrinksInManagedObjectContext:(NSManagedObjectContext*)context{
    
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Drinks" inManagedObjectContext:context];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"drinkName" ascending:YES selector:@selector(compare:)]];
	request.predicate = nil;
	
	NSError *error = nil;
    NSArray* drinkArray= [context executeFetchRequest:request error:&error] ;
    
    return drinkArray;
}


@dynamic drinkName;
@dynamic drinkIngredients;
@dynamic drinkMakingSteps;

@end
