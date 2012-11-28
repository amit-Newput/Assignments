//
//  FlickrPlacesTableViewController.m
//  FlickrPlaces
//
//  Created by Chetan Sanghi on 26/11/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import "FlickrPlacesTableViewController.h"
#import "FlickrPhotoTableViewController.h"
#import "FlickrFetcher.h"
#import "AppDelegate.h"

@implementation FlickrPlacesTableViewController
@synthesize dictionaryOfPlaces,sections;



-(NSArray *)getListOfPlaces
{
        AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        //[appDelegate setNetworkActivityIndicatorVisible:YES];
        [appDelegate setNetworkActivityIndicatorVisible:[NSNumber numberWithBool:YES]];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"woe_name" ascending:YES];
        NSArray * listOfPlaces = [[FlickrFetcher topPlaces] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];

        [appDelegate performSelector:@selector(setNetworkActivityIndicatorVisible:) withObject:[NSNumber numberWithBool:NO] afterDelay:1.0];
    
    return listOfPlaces;
}

-(NSMutableDictionary*)dictionaryOfPlaces{
if(!dictionaryOfPlaces)
{
    dictionaryOfPlaces = [[NSMutableDictionary alloc] init];
    NSArray * listOfPlaces = [self getListOfPlaces];
    int placeCount = listOfPlaces.count;
    NSMutableArray* placeArray = [[NSMutableArray alloc] init];
    NSString* currentFirstLetter =@"A";
    for(int i=0;i<placeCount;++i)
    {
        NSDictionary* placeDictionary = [listOfPlaces objectAtIndex:i];
        NSString* thisFirstLetter= [[[placeDictionary valueForKey:@"woe_name"] substringToIndex:1] uppercaseString] ;
        if([thisFirstLetter isEqualToString:currentFirstLetter]){
            [placeArray addObject:placeDictionary];
        }
        else 
        { 
            if(placeArray.count >0){
                [dictionaryOfPlaces setObject:placeArray forKey:currentFirstLetter];
                placeArray = [[NSMutableArray alloc] init];
            }
        currentFirstLetter = thisFirstLetter;
        }
    }
}
    return dictionaryOfPlaces;
}


-(NSArray*)sections{
    if(!sections){
        sections =[[self.dictionaryOfPlaces allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
    }
    return sections;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.text =@"Top Rated";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font= [UIFont fontWithName:@"Verdana" size:20];
    //self.title = @"Top Rated";
    self.navigationItem.titleView = titleLabel;
    [self.navigationItem.titleView sizeToFit]; 
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


-(NSDictionary*) placeAtIndexPath:(NSIndexPath*) indexPath{
    
    //NSDictionary* thisPlace = [self.listOfPlaces objectAtIndex:indexPath.row];
    //return thisPlace;
    
    NSMutableArray* thisArrayofSection =  [self.dictionaryOfPlaces objectForKey:[self.sections objectAtIndex:indexPath.section]];
    NSDictionary* thisPlace = [thisArrayofSection objectAtIndex:indexPath.row];
    return thisPlace;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return  self.sections.count;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray * array =  [self.dictionaryOfPlaces objectForKey:[self.sections objectAtIndex:section]];
    return array.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [self.sections objectAtIndex:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FlickrPhotos";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary* thisPlace = [self placeAtIndexPath:indexPath];
    cell.textLabel.text =[thisPlace  valueForKey:@"woe_name"];
    cell.detailTextLabel.text = [thisPlace valueForKey:@"_content"];
    //cell.detailTextLab
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    FlickrPhotoTableViewController* photoTVC = [[FlickrPhotoTableViewController alloc] init];
    NSDictionary* thisPlace = [self placeAtIndexPath:indexPath];
    photoTVC.placeID = [thisPlace valueForKey:@"place_id"];
    photoTVC.title = [thisPlace valueForKey:@"woe_name"];
	[self.navigationController pushViewController:photoTVC animated:YES];
    
}

@end
