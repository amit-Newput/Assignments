//
//  PhotoCollectionViewCell.h
//  PhotoCollection
//
//  Created by NewputMac04 on 05/12/12.
//  Copyright (c) 2012 NewputMac04. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView* spinner;


@end
