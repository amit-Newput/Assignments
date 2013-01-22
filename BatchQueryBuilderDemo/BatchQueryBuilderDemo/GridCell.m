//
//  GridCell.m
//  Cetas Analytics
//
//  Copyright (c) 2011 - 2012 Cetas Software, Inc. All rights reserved.
//  This is Cetas proprietary and confidential material and its use
//  is subject to license terms.
//

/**
 * This class creates line separators between columns in a cell
 * An array of CGFloats (i.e. column widths) can be set to columns property of this class. It implements IOS drawRect method to add separator between the columns. IOS calls drawRect method autmoatically
 * It can be used as the cell of the table view, please refer UploadsTable.m, used on Management tab
 */

#import "GridCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "SingletonClass.h"

@implementation GridCell

@synthesize columns;
@synthesize cellType;

//default initializer for initializing TableViewCell
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    //inititialize columns with empty array
    self.columns = [[NSMutableArray alloc] init];
    return self;
}

/**
 * Called to add a column position to the columns array
 */
- (void)addColumn:(CGFloat)width {
    [self.columns addObject:[NSNumber numberWithFloat:width]];
}

/**
 * drawRect method is called by IOS automatically when setNeedsDislay is required. We should not call this method directly, IOS calls it automatically whenever this class is instantiated
 *
 */
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if(kEnableNewTheme){
        switch (cellType) {
            case kCellTypeHeader:
            {
                [SingletonClass drawLinearGradient:ctx rect:rect startColor:[UIColor colorWithRed:46/255.0 green:56/255.0 blue:62/255.0 alpha:1.0].CGColor endColor:[UIColor colorWithRed:1/255.0 green:22/255.0 blue:29/255.0 alpha:1.0].CGColor];
            }
                break;
            case kCellTypeRowTypeOne :{
                [SingletonClass drawLinearGradient:ctx rect:rect startColor:[UIColor colorWithRed:25/255.0 green:25/255.0 blue:25/255.0 alpha:0.8].CGColor endColor:[UIColor colorWithRed:27/255.0 green:27/255.0 blue:27/255.0 alpha:0.8].CGColor];
            }
            case kCellTypeRowTypeTwo :{
                [SingletonClass drawLinearGradient:ctx rect:rect startColor:[UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:0.8].CGColor endColor:[UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:0.8].CGColor];
            }
                break;
            default:{
            }
                break;
        }
    }
    // Use the same color and width as the default cell separator for now
    CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(ctx, 0.25);
    
    CGFloat position = 0.0;
    for (int i = 0; i < [self.columns count]; i++) {
        CGFloat f = position + [((NSNumber*) [self.columns objectAtIndex:i]) floatValue];
        position = f;
        CGContextMoveToPoint(ctx, f, 0);
        CGContextAddLineToPoint(ctx, f, self.bounds.size.height);
    }
    
    CGContextStrokePath(ctx);
    [super drawRect:rect];
}


@end
