//
//  Values.m
//  BatchQueryBuilderDemo
//
//  Created by Prateek Pradhan on 08/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import "Values.h"

@interface Values ()

//  field name as key and selected or not as value (BOOL YES NO)
@property (strong, nonatomic) NSMutableDictionary *selectedValues;
@end

@implementation Values

@synthesize values,tableName;
@synthesize selectedValues;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithValues:(NSMutableArray *)paramValues withTableName:(NSString *)paramTableName
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.values = paramValues ;
        self.tableName = paramTableName;
        self.title = tableName;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedValues = [[NSMutableDictionary alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void) valueSelected: (NSString*)valueName{
    [self.selectedValues setObject:@"YES" forKey:valueName];
    [self.tableView reloadData];
    
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
    return [self.values count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.values objectAtIndex:indexPath.row];
    
    //NSLog(@" Field Selected:%@", [self.selectedValues objectForKey: cell.textLabel.text]);
    BOOL isSelected =[[self.selectedValues objectForKey: cell.textLabel.text] boolValue];
    
    //Add the check mark to show the field is selected or not
    if(isSelected){
        cell.accessoryType = UITableViewCellAccessoryCheckmark ;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    // Configure the cell...
    cell.contentView.alpha = .5;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
        cell.accessoryType = UITableViewCellAccessoryNone;
       [self.selectedValues setObject:@"NO" forKey:cell.textLabel.text];
    }
    else{
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self.selectedValues setObject:@"YES" forKey:cell.textLabel.text];

    }
    [self.navigationController.view.superview bringSubviewToFront:self.navigationController.view];
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"Coming in scroll view");
    if ([self.delegate respondsToSelector:@selector(valuesTableDidScroll:)]) {
        [self.delegate valuesTableDidScroll:self];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //NSLog(@"Coming in scroll view scrollViewDidEndDragging");
}

@end
