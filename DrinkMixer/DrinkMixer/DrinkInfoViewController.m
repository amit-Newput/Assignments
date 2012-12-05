//
//  DrinkInfoViewController.m
//  DrinkMixer
//
//  Created by NewputMac04 on 04/12/12.
//  Copyright (c) 2012 NewputMac04. All rights reserved.
//

#import "DrinkInfoViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface DrinkInfoViewController () 

@end

@implementation DrinkInfoViewController 
@synthesize name, stepsToMake, ingredients, scrollView;
@synthesize thisDrink, delegate;

BOOL isKeyBoardVisible = NO;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.thisDrink ==nil)
            self.title =@"Add a Drink" ;
    else
        self.title = @"Drink Info";
    
    self.name.text = self.thisDrink.drinkName;
    self.ingredients.text = self.thisDrink.drinkIngredients;
    self.stepsToMake.text = self.thisDrink.drinkMakingSteps;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Key board delegate.
- (void)keyboardDidHide:(NSNotification *)notif {

    if( !isKeyBoardVisible){
        return;
    }
    scrollView.frame = self.view.frame;
    isKeyBoardVisible = NO;
    
}
#pragma mark text view delegate methods
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //taking the origin point of this view
    CGPoint thisTextViewPoint = textView.frame.origin;
    //set the height of the scrollview
    thisTextViewPoint.y -=40;
    //set the width to zero
    thisTextViewPoint.x =0;
    self.scrollView.contentOffset = thisTextViewPoint;
    return YES;
}
- (void)keyboardDidShow:(NSNotification *)notif {
    
    if( isKeyBoardVisible){
        return;
    }
    
    NSDictionary * userInfo =[notif userInfo];
        // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the noteView
    CGRect viewFrame = self.scrollView.frame;
    viewFrame.size.height -= keyboardSize.height;

    [self.scrollView setFrame:viewFrame];
    isKeyBoardVisible = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.ingredients.layer setBorderWidth:1];
    [self.ingredients.layer setBorderColor:[[UIColor grayColor] CGColor] ];
    UIBarButtonItem* cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAdding)];
    
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    UIBarButtonItem* doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneAdding)] ;
    self.navigationItem.rightBarButtonItem = doneBarButtonItem;
    // Do any additional setup after loading the view from its nib.
}


-(void) goToParentView{
 
    if(self.thisDrink == nil){
        //Case for Model View controller while adding new drink.
       [self dismissViewControllerAnimated:YES completion:nil];
        if([self.delegate respondsToSelector:@selector(rebindTableView)]){
           [self.delegate rebindTableView];
        }
    
    }
    else{
        
        //Case for editing existing drink.

        [self.navigationController popViewControllerAnimated:YES];
    }

}
-(void)cancelAdding{
 
    [self goToParentView ];
}

-(void)doneAdding{
    if(!self.name.text ||self.name.text.length ==0){
       //alert user about the name field is empty;
    }
    else{
        NSMutableDictionary* drinkDictionary = [[NSMutableDictionary alloc] init];
        [drinkDictionary setObject:self.name.text forKey:@"drink_name"];
        [drinkDictionary setObject:self.ingredients.text forKey:@"drink_ingredients"];
        [drinkDictionary setObject:self.stepsToMake.text forKey:@"drink_steps"];
        
        AppDelegate * appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        if(self.thisDrink ==nil){
                [Drinks drinkWithData:drinkDictionary inManagedObjectContext:[ appdelegate managedObjectContext]];
        }
        else{
            self.thisDrink.drinkName = self.name.text;
            self.thisDrink.drinkIngredients = self.ingredients.text ;
            self.thisDrink.drinkMakingSteps = self.stepsToMake.text;
        }
        [appdelegate saveContext];
        
    }
    [self goToParentView ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate{
    return YES;
}

// Shows the Message because of the invalid operation
-(void)showDrinkNameAlreadyExist:(NSString*) message;
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Drink Exist!!"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles: nil];
    [alert show];
}
@end
