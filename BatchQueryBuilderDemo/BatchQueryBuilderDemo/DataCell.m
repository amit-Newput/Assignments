//
//  DataCell.m
//  BatchQueryBuilderDemo
//
//  Created by NewputMac04 on 11/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import "DataCell.h"

@implementation DataCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
