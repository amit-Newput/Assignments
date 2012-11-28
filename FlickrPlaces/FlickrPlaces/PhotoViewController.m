//
//  PhotoViewController.m
//  FlickrPlaces
//
//  Created by Chetan Sanghi on 26/11/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"
#import "AppDelegate.h"

#define recentPhotoCapacity 7
@implementation PhotoViewController
@synthesize photoDictionary;


- (void) SetContentMode
{
    //self.contentMode = UIViewContentModeRedraw;
    self.view.contentMode= UIViewContentModeRedraw;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[self SetContentMode];
    }
    return self;
}

-(void)awakeFromNib{
    //[self SetContentMode];
    
}


//Check whether we already have an entry in the array for current photo
//if there is an entry returns the index of that photo in the array
-(int) checkForDuplicatePhoto:(NSMutableArray *) recentPhotoArray
{
    int photoIndex = -1;
   NSString* currentPhotoName = [self.photoDictionary valueForKey:@"id"];
    for(int i=0;i<recentPhotoArray.count;++i){
        NSDictionary * thisDictionary = [recentPhotoArray objectAtIndex:i];
        NSString* thisPhotoName = [(NSDictionary*)thisDictionary valueForKey:@"id"];
        
        if([currentPhotoName isEqualToString:thisPhotoName]){
            photoIndex = i;
            break;
        }
    }
    
    return photoIndex;
}
-(void) saveRecentPhoto
{
    
    NSMutableArray * recentPhotoArray = [[AppDelegate getObjectFromNSUserDefaultForKey:@"recentPhotoArray"] mutableCopy];
    
    if(!recentPhotoArray){
        recentPhotoArray = [NSMutableArray arrayWithCapacity:recentPhotoCapacity];
    }
    
    int duplicatePhotoIndex = [self checkForDuplicatePhoto:recentPhotoArray];
    if(duplicatePhotoIndex >=0)
    {//here we have to move the photo to the top.
        [recentPhotoArray removeObjectAtIndex:duplicatePhotoIndex];
        
    }
    else if(recentPhotoArray.count == recentPhotoCapacity ){
                [recentPhotoArray removeObjectAtIndex:recentPhotoArray.count -1];
        }
    [recentPhotoArray insertObject:self.photoDictionary atIndex:0];
    [AppDelegate setObjectToNSUserDefault:recentPhotoArray forKey:@"recentPhotoArray"];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)viewDidLoad
{
 UIScrollView *scrollView =[[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //[appDelegate setNetworkActivityIndicatorVisible:YES];
    [appDelegate setNetworkActivityIndicatorVisible:[NSNumber numberWithBool:YES]];
    UIImage* image = [UIImage imageWithData:[  FlickrFetcher imageDataForPhotoWithFlickrInfo:self.photoDictionary format: FlickrFetcherPhotoFormatLarge]];
    //[appDelegate setNetworkActivityIndicatorVisible:NO];
        [appDelegate performSelector:@selector(setNetworkActivityIndicatorVisible:) withObject:[NSNumber numberWithBool:NO] afterDelay:1.0];
    imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = scrollView.bounds;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //image.size = scrollView.bounds.size;
    [scrollView addSubview:imageView];
    scrollView.contentMode = UIViewContentModeScaleToFill;
    scrollView.delegate = self;
    scrollView.scrollEnabled = YES;
    scrollView.maximumZoomScale = 3;
    scrollView.minimumZoomScale = 0.3;
    self.view = scrollView;
    
    //add this photo to recently visited photos 
    [self saveRecentPhoto];
}

-(UIView*)  viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}
/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //[self SetContentMode];
    return YES;
}

@end
