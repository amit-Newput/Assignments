//
//  PhotoCollectionViewCell.h
//  FlickrPlacesUsingCoreData
//
//  Created by NewputMac04 on 06/12/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView* thisPhotoImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* thisSpinner;

@end
