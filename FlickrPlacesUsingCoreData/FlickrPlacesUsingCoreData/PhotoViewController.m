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
@synthesize  photoDescription;    


- (void) SetContentMode
{
    //self.contentMode = UIViewContentModeRedraw;
    self.view.contentMode= UIViewContentModeRedraw;
}


-(void) markPhotoFavorite{
    
    if([self.photoDescription.favorite boolValue]){ 
        self.photoDescription.favorite = [NSNumber numberWithBool:NO];
        self.navigationItem.rightBarButtonItem.title = @"Mark Favorite";
    }
    else{
        self.photoDescription.favorite = [NSNumber numberWithBool:YES];
        self.navigationItem.rightBarButtonItem.title = @"Mark Unfavorite";
    }
        
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
    scrollView =[[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    scrollView.contentMode = UIViewContentModeScaleToFill;
    scrollView.delegate = self;
    scrollView.scrollEnabled = YES;
    scrollView.maximumZoomScale = 3;
    scrollView.minimumZoomScale = 0.3;
    self.view = scrollView;
    
    self.title = self.photoDescription.photoTitle;
    UIBarButtonItem* favoriteBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Mark favorite" style:UIBarButtonItemStylePlain target:self action:@selector(markPhotoFavorite)] ;
    if([self.photoDescription.favorite boolValue]){
        favoriteBarButtonItem.title =@"Mark Unfavorite";
    }
    self.navigationItem.rightBarButtonItem = favoriteBarButtonItem;
    
    
    [self .photoDescription processImageDataWithBlock: ^ (NSData * imageData){
        
        UIImage* image = [UIImage imageWithData:imageData];
        imageView = [[UIImageView alloc] initWithImage:image];
        
        imageView.frame = scrollView.bounds;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //image.size = scrollView.bounds.size;
        [scrollView addSubview:imageView];

    }
     ];

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


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if([self.photoDescription.favorite boolValue]){
        [self  saveImage:imageView.image withName:self.photoDescription.photoTitle];
    }
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] saveContext];
}
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


-(void)saveImage:(UIImage*)image withName:(NSString*)imageName {
    
    NSString  *imagePath = [NSHomeDirectory() stringByAppendingPathComponent:[@"Documents/" stringByAppendingString:imageName]];
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
    if(!fileExist){
        [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];    
    }
}


-(UIImage*)loadImageWithImageName:(NSString *)imageName {
    
    UIImage *image  = nil;
    NSString  *imagePath = [NSHomeDirectory() stringByAppendingPathComponent:[@"Documents/" stringByAppendingString:imageName]];

    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
    if(fileExist){
        
       image = [UIImage imageWithContentsOfFile:imagePath];
    }
    return image;
}

@end
