//
//  PhotoCollectionViewCell.m
//  FlickrPlacesUsingCoreData
//
//  Created by NewputMac04 on 06/12/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell
@synthesize thisPhotoImageView,thisSpinner;

- (id)initWithFrame:(CGRect)frame
{
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"PhotoCollectionViewCell" owner:self options:nil];
    if ([arrayOfViews count] < 1) { return nil; }
    
    if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) { return nil; }
    
    self = [arrayOfViews objectAtIndex:0];
    
}

return self;


}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
