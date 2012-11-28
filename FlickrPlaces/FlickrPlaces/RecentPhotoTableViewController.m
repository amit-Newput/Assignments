//
//  RecentPhotoTableViewController.m
//  FlickrPlaces
//
//  Created by Chetan Sanghi on 26/11/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import "RecentPhotoTableViewController.h"
#import "PhotoViewController.h"
#import "AppDelegate.h"
#define recentPhotoCapacity 7

@implementation RecentPhotoTableViewController

@synthesize recentPhotoArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(NSDictionary*) photoAtIndexPath:(NSIndexPath*) indexPath{
    
    NSDictionary* thisPhoto = [self.recentPhotoArray objectAtIndex:indexPath.row];
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


-(void) retrieveRecentPhotos
{
    //[AppDelegate clearAllNSUserDefaultValues];
    self.recentPhotoArray = [ AppDelegate getObjectFromNSUserDefaultForKey:@"recentPhotoArray"];
    
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
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

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
    [self retrieveRecentPhotos];
    [self.tableView reloadData];
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
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return self.recentPhotoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    NSDictionary* thisPhoto = [self photoAtIndexPath:indexPath];
    
    NSDictionary* thisPhotoDescription = [thisPhoto valueForKey:@"description"];
    
    cell.textLabel.text = [self photoTitle:indexPath];
    cell.detailTextLabel.text = [thisPhotoDescription valueForKey:@"_content"];
    
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSMutableArray* mutableCopy = [self.recentPhotoArray mutableCopy] ;
        [ mutableCopy removeObjectAtIndex:indexPath.row];
        self.recentPhotoArray = mutableCopy;
        [AppDelegate setObjectToNSUserDefault:self.recentPhotoArray forKey:@"recentPhotoArray"];
        
        // Delete the row from the tableView
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSMutableArray* photoArray = [self.recentPhotoArray mutableCopy];
    NSDictionary* dictionaryToMove = [photoArray objectAtIndex:fromIndexPath.row];
    [photoArray removeObjectAtIndex:fromIndexPath.row];
    [photoArray insertObject:dictionaryToMove atIndex:toIndexPath.row];
    self.recentPhotoArray = photoArray;
    [AppDelegate setObjectToNSUserDefault:photoArray forKey:@"recentPhotoArray"];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    if(self.recentPhotoArray.count ==1){
        return NO;
    }
    return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoViewController* pvc = [[PhotoViewController alloc] init];
    NSDictionary* thisPhoto = [self photoAtIndexPath:indexPath];
    pvc.photoDictionary = thisPhoto;
    pvc.title = [self photoTitle:indexPath];
	[self.navigationController pushViewController:pvc animated:YES];
}
@end
