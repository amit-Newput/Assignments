//
//  SegmentedViewController.m
//  FlickrPlacesUsingCoreData
//
//  Created by NewputMac04 on 11/12/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import "SegmentedViewController.h"
#import "PhotoCollectionViewController.h"
#import "FlickrPhotoTableViewController.h"
#import "AppDelegate.h"

@interface SegmentedViewController ()
@property (strong, nonatomic) PhotoCollectionViewController  *photoCVC;
@property (strong, nonatomic) FlickrPhotoTableViewController * photoTVC;
@property (weak) UIViewController* currentChildController;
@end

@implementation SegmentedViewController
@synthesize photoPlace, segmentController,photoSegmentView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.photoSegmentView.autoresizesSubviews =YES;
    self.photoSegmentView.autoresizingMask =UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //[self.view setAutoresizesSubviews:YES];
    self.view.backgroundColor = [UIColor blackColor];
    

		self.segmentController.segmentedControlStyle = UISegmentedControlStyleBar;
		self.segmentController.selectedSegmentIndex = 0;
    	self.segmentController.tintColor = [UIColor darkGrayColor];
	[	self.segmentController addTarget:self
	                     action:@selector(segmentedControlIndexChanged:)
	           forControlEvents:UIControlEventValueChanged];
    	//self.segmentController.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    
    
    City* thisCity = [City cityWithFlickrData:self.photoPlace inManagedObjectContext:[(AppDelegate*)[[UIApplication sharedApplication] delegate]  managedObjectContext]];
    // create first controller
    self.photoTVC = [[FlickrPhotoTableViewController alloc] init];
    self.photoTVC.city = thisCity;
    self.photoTVC.title = [self.photoPlace valueForKey:@"woe_name"];
    self.photoTVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.photoTVC.view.frame = CGRectMake(0,45,320,420);
    
    // create second controller
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]  init];
    flowLayout.itemSize = CGSizeMake(100, 100);
    flowLayout.headerReferenceSize = CGSizeMake(50 , 30);
    flowLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    
    //flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.photoCVC = [[PhotoCollectionViewController alloc] initWithCollectionViewLayout:flowLayout];
    self.photoCVC.title = [self.photoPlace valueForKey:@"woe_name"];
    self.photoCVC.city = thisCity;
    self.photoCVC.view.frame = CGRectMake(0,45,320,320);
    self.photoCVC.view.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
    
    [self addChildToThisContainerViewController:self.photoTVC];
    [self addChildToThisContainerViewController:self.photoCVC];
    
    self.currentChildController = [self.childViewControllers objectAtIndex:	self.segmentController.selectedSegmentIndex];
    
    [self.view addSubview:self.currentChildController.view];
	// Do any additional setup after loading the view.
}

-(void)segmentedControlIndexChanged:(UISegmentedControl *) sender{
    
    UIViewController *oldChildController = self.currentChildController;
    UIViewController *newChildController = [self.childViewControllers objectAtIndex:sender.selectedSegmentIndex];
    UIViewAnimationOptions options;
    
    // let's change the animation based upon which segmented control you select ... you may change this as fits your desired UI
    
    
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            options = UIViewAnimationOptionTransitionFlipFromLeft;
            break;
        }
        case 1:
        {        options = UIViewAnimationOptionTransitionFlipFromRight;
            break;
        }
            
    }
    
    
    [self transitionFromViewController:oldChildController
                      toViewController:newChildController
                              duration:0.5
                               options:options
                            animations:nil
                            completion:^(BOOL finished){
                                [newChildController didMoveToParentViewController:self];
                            }];
    self.currentChildController = newChildController;
    self.currentChildController.view.frame = self.photoSegmentView.frame;
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
        //self.currentChildController.view.frame = CGRectMake(0,45,320 ,320);
    }
    else{
        //self.currentChildController.view.frame = CGRectMake(0,45,465,170);
    }
    
    
}
- (void)addChildToThisContainerViewController:(UIViewController *)childController
{
    [self addChildViewController:childController];
    [childController didMoveToParentViewController:self];
    //childController.view.frame = CGRectMake(0,45,520,520);
    childController.view.frame = self.photoSegmentView.frame;
}

- (BOOL)shouldAutomaticallyForwardRotationMethods  NS_AVAILABLE_IOS(6_0){
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSegmentController:nil];
    [self setPhotoSegmentView:nil];
    [super viewDidUnload];
}
@end


