//
//  FlickrPlacesTableViewController.h
//  FlickrPlaces
//
//  Created by Chetan Sanghi on 26/11/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FlickrPlacesTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableDictionary *dictionaryOfPlaces;
@property (strong, nonatomic) NSArray* sections;


@end
