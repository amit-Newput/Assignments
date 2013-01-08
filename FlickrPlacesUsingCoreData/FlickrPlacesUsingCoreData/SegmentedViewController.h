//
//  SegmentedViewController.h
//  FlickrPlacesUsingCoreData
//
//  Created by NewputMac04 on 11/12/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentedViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentController;
@property (weak, nonatomic) IBOutlet UIView *photoSegmentView;
@property (strong, nonatomic) NSDictionary* photoPlace;

@end
