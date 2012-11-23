//
//  ViewController.m
//  ImageDragSingleView
//
//  Created by Chetan Sanghi on 22/11/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize mySubView, imageViewMutableArray;
@synthesize panImage, initialPanPositionX, initialPanPositionY, backGroundColor;

#define ResourcePath(path)[[NSBundle mainBundle] pathForResource:path ofType:nil]

-(NSMutableArray*)imageViewMutableArray
{
    if(imageViewMutableArray == nil){
        imageViewMutableArray = [[NSMutableArray alloc] init ];
    }
    return imageViewMutableArray;
}

                                
-(UIColor*)backGroundColor
{
    return self.mySubView.backgroundColor;
}

-(void) setBackGroundColor:(UIColor *)newBackGroundColor
{
    if(newBackGroundColor!=self.mySubView.backgroundColor){
        backGroundColor = newBackGroundColor;
        
        [self.mySubView setNeedsDisplay];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    //UIImage* greenImage = [UIImage imageWithContentsOfFile:@"Box_Green.png"];
    UIImage* greenImage = [UIImage imageNamed:@"Box_Green.png"];
    UIImageView* greenImageView =[[UIImageView alloc] initWithFrame:CGRectMake(12, 400, 56, 46)];
    greenImageView.image  = greenImage;
    greenImageView.tag = 1;
    greenImageView.userInteractionEnabled = YES;
    //add it in parent view
    [self.view addSubview:greenImageView];
    //add it in image view array
    [self.imageViewMutableArray addObject:greenImageView];
    
    
    //UIImage* redImage = [UIImage imageWithContentsOfFile:@"Box_Red.png"];
    UIImage* redImage = [UIImage imageNamed:@"Box_Red.png"];
    UIImageView* redImageView =[[UIImageView alloc] initWithFrame:CGRectMake(134, 400, 56, 46)];
    redImageView.image  = redImage;
    redImageView.tag = 2;
    redImageView.userInteractionEnabled = YES;
    //add it in parent view
    [self.view addSubview:redImageView];
    //add it in image view array
    [self.imageViewMutableArray addObject:redImageView];
    
  
    UIImage* blueImage = [UIImage imageWithContentsOfFile:ResourcePath(@"Box_Blue.png")];
    //UIImage* blueImage = [UIImage imageNamed:@"Box_Blue.png"];
    UIImageView* blueImageView =[[UIImageView alloc] initWithFrame:CGRectMake(254, 400, 56, 46)];
    blueImageView.image  = blueImage;
    blueImageView.tag =3;
    blueImageView.userInteractionEnabled = YES;
    //add it in parent view
    [self.view addSubview:blueImageView];
    //add it in image view array
    [self.imageViewMutableArray addObject:blueImageView];
    
    
    //Add the pan gesture  to the main view
    UIPanGestureRecognizer* panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panBgColor:)];
    [self.view addGestureRecognizer:panGR];
    
    [self.view setNeedsDisplay];
    
}

//If gesture is initiated on image view then returns that imageview else nil
-(UIImageView *) getValidPanGestureView:(UIPanGestureRecognizer*) gesture{
    
    UIImageView * validImageView = nil;
    CGPoint gestureLocation = [gesture locationInView:self.view];
     UIView * gestureView = [self.view hitTest:gestureLocation withEvent:nil];

    if([gestureView isMemberOfClass:[UIImageView class]] 
       && (gestureView.tag ==1 ||gestureView.tag==2 || gestureView.tag ==3) 
       )
    {
        validImageView = (UIImageView*)gestureView;
    }
    
    return validImageView;
}

-(UIColor *) getBgColor:(UIImageView*) imageView
{
    UIColor * bgColor = nil;
    switch (imageView.tag) {
        case 1:
            bgColor = [UIColor greenColor];
            break;
        case 2:
            bgColor =[UIColor redColor];
            break;
        case 3:
            bgColor =[UIColor blueColor];
            break;
        default:
            bgColor =[UIColor brownColor];
            break;
    }
    return bgColor;
    
}
-(void) panBgColor:(UIPanGestureRecognizer*) gesture
{
    //[self HandlePan:gesture ImageToPan:self.greenImageView WithBgColor:[UIColor greenColor]];
    
    CGPoint translation =[gesture translationInView:self.view];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            UIImageView * validImageView =  [self getValidPanGestureView:gesture];
            if(validImageView){
                
                // the initial position
                self.initialPanPositionX = translation.x;
                self.initialPanPositionY = translation.y;
                
                // create a copy of the imageview
                panImage = [[UIImageView alloc] initWithImage:validImageView.image ];
                panImage.frame = validImageView.frame;
                panImage.tag = validImageView.tag;
                
                [self.view addSubview:panImage];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if(panImage){
               if (translation.x ==self.initialPanPositionX && translation.y == self.initialPanPositionY) {
                 [UIView beginAnimations:nil context:NULL]; 
                 
                 [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                 [UIView setAnimationDuration:0.2f];
                 
                 // an effect to increase a copy a little bit when start dragging
                 CGAffineTransform zt = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                 
                 panImage.bounds = CGRectApplyAffineTransform(panImage.bounds, zt);
                 
                 }
                 [UIView commitAnimations];
                // translation
                panImage.transform = CGAffineTransformMakeTranslation(self.initialPanPositionX + translation.x, self.initialPanPositionY + translation.y);
            } 
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if(panImage){
                NSLog(@" Image bound: x= %f  ,y = %f "  ,panImage.frame.origin.x ,panImage.frame.origin.y);
                CGPoint otherPoint = [self.view convertPoint:panImage.bounds.origin fromView:panImage];
                NSLog(@" other point: x= %f  ,y = %f "  ,otherPoint.x ,otherPoint.y);
                
                BOOL imageIsInSubView = CGRectContainsPoint(self.mySubView.frame, panImage.frame.origin);
                if(imageIsInSubView)
                    self.mySubView.backgroundColor =[self  getBgColor:panImage];
                
                [panImage removeFromSuperview];
                panImage = nil;
            }
        }
            break;
            
    }
    
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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
