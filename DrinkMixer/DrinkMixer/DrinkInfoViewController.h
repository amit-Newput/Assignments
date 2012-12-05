//
//  DrinkInfoViewController.h
//  DrinkMixer
//
//  Created by NewputMac04 on 04/12/12.
//  Copyright (c) 2012 NewputMac04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Drinks.h"

@protocol DrinkInfoDelegate <NSObject>

-(void)rebindTableView;
-(void)newDrinkSaved;

@end
@interface DrinkInfoViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView* stepsToMake;
@property (strong, nonatomic) IBOutlet UITextView* ingredients;
@property (strong, nonatomic) IBOutlet UITextField* name;
@property (strong, nonatomic) IBOutlet UIScrollView* scrollView;
@property (strong, nonatomic) Drinks * thisDrink;

@property (assign)  id <DrinkInfoDelegate> delegate;

@end
