//
//  DrinkMixerTableViewController.m
//  DrinkMixer
//
//  Created by NewputMac04 on 04/12/12.
//  Copyright (c) 2012 NewputMac04. All rights reserved.
//

#import "DrinkMixerTableViewController.h"
#import "Drinks.h"
#import "AppDelegate.h"
#import "DrinkInfoViewController.h"

@interface DrinkMixerTableViewController ()

//@property (strong, nonatomic) NSMutableDictionary* drinkDictionary;
@property (strong, nonatomic) NSArray* drinkArray;
//@property (strong, nonatomic) NSArray* sections;

@end

@implementation DrinkMixerTableViewController
@synthesize drinkArray;

/*
-(void)fillDrinkDictionary:(NSArray* )drinkArray{
    if(!self.drinkDictionary)
        self.drinkDictionary = [[NSMutableDictionary alloc] init];
    
    for(int i =0;i<drinkArray.count;++i){
        Drinks* obj = [drinkArray objectAtIndex:i];
        [self.drinkDictionary setObject:obj forKey:obj.drinkName ];
    }
}
 
 */

-(void)addDrinks {
    
    UINavigationController * navDrinkInfo = [[UINavigationController alloc] init];
    
    DrinkInfoViewController * drinkInfo = [[DrinkInfoViewController alloc]   init];
    drinkInfo.thisDrink = nil;
    drinkInfo.delegate = self;
    [navDrinkInfo pushViewController:drinkInfo animated:YES];
    //[navDrinkInfo setModalInPopover:YES];
    [navDrinkInfo setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:navDrinkInfo animated:YES completion:nil];
    //[self.navigationController pushViewController:drinkInfo animated:YES];

}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!self.drinkArray){
        
        self.drinkArray = [Drinks getAllDrinksInManagedObjectContext:[(AppDelegate*)[[UIApplication sharedApplication] delegate]  managedObjectContext] ];
        
        self.title =@"Drink Mixer";
        //[self fillDrinkDictionary:drinkArray];
    }
    
    /*
    if(!self.sections){
        self.sections = sections =[[self.drinkDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    }
     */

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
   
    UIBarButtonItem* addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDrinks)];
    //[[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addDrinks)] ;
    self.navigationItem.rightBarButtonItem = addBarButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return self.drinkArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Drink_Queue";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    Drinks* objDrink = [self.drinkArray objectAtIndex:indexPath.row];
    cell.textLabel.text =objDrink.drinkName;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(BOOL)shouldAutorotate
{
    NSLog(@"Coming here to auto rorate-----");
    return YES;
}

-(void)rebindTableView{
    self.drinkArray = [Drinks getAllDrinksInManagedObjectContext:[(AppDelegate*)[[UIApplication sharedApplication] delegate]  managedObjectContext] ];
    [self.tableView reloadData];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DrinkInfoViewController * drinkInfo = [[DrinkInfoViewController alloc]   init];
    drinkInfo.thisDrink = [self.drinkArray objectAtIndex:indexPath.row];
    drinkInfo.delegate = self;
    [self.navigationController  pushViewController:drinkInfo animated:YES];

}

@end
