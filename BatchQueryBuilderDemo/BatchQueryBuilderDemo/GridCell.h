//
//  GridCell.h
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

#import <UIKit/UIKit.h>


@interface GridCell : UITableViewCell {
    NSMutableArray *columns;
    NSInteger cellType;
}
/**
 * Called to add a column position to the columns array
 */
- (void)addColumn:(CGFloat)position;

@property (strong) NSMutableArray *columns;
@property  NSInteger cellType;

@end
