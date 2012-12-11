//
//  PhotoCollectionViewController.h
//  FlickrPlacesUsingCoreData
//
//  Created by NewputMac04 on 06/12/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"

@interface PhotoCollectionViewController : UICollectionViewController
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong ) City* city;



@end
