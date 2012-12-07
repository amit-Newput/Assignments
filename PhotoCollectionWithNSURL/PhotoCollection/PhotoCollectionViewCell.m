//
//  PhotoCollectionViewCell.m
//  PhotoCollection
//
//  Created by NewputMac04 on 05/12/12.
//  Copyright (c) 2012 NewputMac04. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

@synthesize photoImageView,spinner;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
