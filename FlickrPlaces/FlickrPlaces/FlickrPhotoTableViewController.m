//
//  FlickrPhotoTableViewController.m
//  FlickrPlaces
//
//  Created by Chetan Sanghi on 26/11/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import "FlickrPhotoTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotoViewController.h"
#import "AppDelegate.h"



@implementation FlickrPhotoTableViewController

@synthesize placeID,listOfPhotos;

-(NSArray*) listOfPhotos{
    if(!listOfPhotos){ 
        AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate setNetworkActivityIndicatorVisible:[NSNumber numberWithBool:YES]];
        listOfPhotos = [FlickrFetcher photosAtPlace:self.placeID];
        [appDelegate performSelector:@selector(setNetworkActivityIndicatorVisible:) withObject:[NSNumber numberWithBool:NO] afterDelay:1.0];
        //[appDelegate setNetworkActivityIndicatorVisible:NO];
    }
    return listOfPhotos;
}

-(void)putOffIndicator{
    AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate setNetworkActivityIndicatorVisible:[NSNumber numberWithBool:NO]];
}

-(NSDictionary*) photoAtIndexPath:(NSIndexPath*) indexPath{
    
    NSDictionary* thisPhoto = [self.listOfPhotos objectAtIndex:indexPath.row];
    return thisPhoto;
}

// Return the title of the photo at the given indexPath
-(NSString*) photoTitle:(NSIndexPath *) indexPath
{
    NSDictionary* thisPhoto = [self photoAtIndexPath:indexPath];
    NSString* title = [thisPhoto valueForKey:@"title"];
    if(!title.length){
        
        NSDictionary* thisPhotoDescription = [thisPhoto valueForKey:@"description"];
        title   = [thisPhotoDescription valueForKey:@"_content"];
        if(!title.length){
            title=@"Unknown";
        }
    }
    
    return  title;
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
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
    return self.listOfPhotos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary* thisPhoto = [self photoAtIndexPath:indexPath];
    
    NSDictionary* thisPhotoDescription = [thisPhoto valueForKey:@"description"];
    
    cell.textLabel.text = [self photoTitle:indexPath];
    cell.detailTextLabel.text = [thisPhotoDescription valueForKey:@"_content"];
 

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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    PhotoViewController* pvc = [[PhotoViewController alloc] init];
    NSDictionary* thisPhoto = [self photoAtIndexPath:indexPath];
    pvc.photoDictionary = thisPhoto;
    pvc.title = [self photoTitle:indexPath];
	[self.navigationController pushViewController:pvc animated:YES];
    
}

@end
