//
//  MultiColumnTableView.m
//  BatchQueryBuilderDemo
//
//  Created by Vipin Joshi on 18/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//



#import "MultiColumnTableView.h"
#import "GridCell.h"



#define kTableHeaderHeight 100.0  
#define kTableViewCellHeight 40.0

@interface MultiColumnTableView(){
    BOOL needsReload;
    NSArray *columnWidthRatios;
    int columnCount;
}
@end

@implementation MultiColumnTableView


@synthesize multiColumnTableViewDelegate;


-(void) setUp{
    
    self.delegate = self;
    self.dataSource = self;
    //UIEdgeInsets insets = UIEdgeInsetsMake(22.0, 0.0, 0.0, 0.0);
    //self.scrollIndicatorInsets = insets;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setUp];
        
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        
         [self setUp];
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

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    self.delegate tab
//
//
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int sections =  [self.multiColumnTableViewDelegate numberOfSectionsInMultiColumnTableView:self];
    return sections;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows =   [self.multiColumnTableViewDelegate multiColumnTableView:self numberOfRowsInSection:section];
    return rows;
}

- (void) addLabels: (GridCell *) cell withColumns: (NSArray *)columns withColor:(UIColor *)paramColor  withFontSize:(float) fontSize withBGColor:(UIColor *) bgColor
{
    float position = 0.0;
    for (int i=0; i<[columns count]; i++)
    {
        CGFloat width = [((NSNumber*) [columns objectAtIndex:i]) floatValue];
        UILabel *label = [[UILabel alloc]   initWithFrame:CGRectMake(position+5, 0.0, width-20,cell.bounds.size.height)];
        [cell addColumn:width];
        label.tag = i+1; // don't use tag=0 because it's used by cell itself.
        label.font = [UIFont systemFontOfSize:fontSize];
        label.textColor = paramColor;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentLeft;
        label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:label];
        position = position + width;
        [label setUserInteractionEnabled:YES];
    }
}

- (void) addSeparations: (GridCell *) cell withColumns: (NSArray *)columns
{
    for (int i=0; i<[columns count]; i++)
    {
        CGFloat width = [((NSNumber*) [columns objectAtIndex:i]) floatValue];
        [cell addColumn:width];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *orderedColumnWidths = [self getOrderedColumnWidths];
    NSArray *titleArray = [self.multiColumnTableViewDelegate headerTitlesForColumnInMultiColumnTableView:self];
    GridCell *cell = [[GridCell alloc] init];
    
    
    float gridWidth = self.frame.size.width;
    [cell setFrame:CGRectMake(0, 0, gridWidth,50)]; // 50 = height taken for now
    
    [self addLabels:cell withColumns:orderedColumnWidths withColor:[UIColor blackColor]  withFontSize:12.0 withBGColor:[UIColor colorWithRed:51 green:51 blue:51 alpha:1]];
    
    cell.backgroundColor = [UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1.0];
    
    //now populate the cell's labels with the data items
    for(int i=0; i < columnCount; i++)
    {
        UILabel *colLabel = (UILabel *)[cell viewWithTag:i+1];
        colLabel.text = [titleArray objectAtIndex:i];
    }
    return cell;
    
}

-(NSArray *)getOrderedColumnWidths
{
    NSArray *orderedColumnRatios = columnWidthRatios;
    float columnRatio;
    CGFloat width;
    NSMutableArray *orderedColumnWidths = [[NSMutableArray alloc] initWithCapacity:columnCount];
    CGFloat tableWidth = self.frame.size.width;
    
    for(int i = 0; i < columnCount; i++)
    {
        columnRatio = [[orderedColumnRatios objectAtIndex:i] floatValue];
        width = tableWidth * columnRatio;
        [orderedColumnWidths addObject:[[NSNumber alloc] initWithFloat:width]];
    }
    
    return orderedColumnWidths;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat gridWidth = self.frame.size.width;
    NSString *CellIdentifier = [NSString stringWithFormat:@"MultiColumnTableView%f",gridWidth];
    NSArray *orderedColumnWidths = [self getOrderedColumnWidths];
    NSLog(@"cellForRowAtIndexPath");
    GridCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[GridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setFrame:CGRectMake(0, 0, gridWidth, kTableViewCellHeight)]; // hard coded for now
        [self addSeparations:cell withColumns:orderedColumnWidths];
        
    }
    else // remove all existing views from the de-queued cell
    {
        for(UIView *cellSubView in cell.contentView.subviews)
        {
            [cellSubView removeFromSuperview];
        
        }
    }
    
   // [cell setFrame:CGRectMake(0, 0, gridWidth, 40)];
    
    float position = 0.0;
    
    for(int i=0; i < columnCount; i++) // addition of views
    {
        
        CGFloat width = [((NSNumber*) [orderedColumnWidths objectAtIndex:i]) floatValue];
        UIView *viewForColumn = [self.multiColumnTableViewDelegate multiColumnTableView:self viewForColumn:i atRow:indexPath.row]; // will be returned by the delegate
        CGRect columnFrame = CGRectMake(position+14, 6.0, viewForColumn.frame.size.width, viewForColumn.frame.size.height);
        viewForColumn.frame = columnFrame;

        [cell.contentView addSubview:viewForColumn];
        position = position + width;
        
    }
    
    return cell;
    
}
-(void)layoutSubviews{
    
    if (needsReload) {
        needsReload = NO;
        [self reloadData];
    }else
        needsReload = YES;
    [super layoutSubviews];

}
-(void)reloadData{
    columnCount = [self.multiColumnTableViewDelegate numberOfColumnsForMultiColumnTableView:self];
    columnWidthRatios = [self.multiColumnTableViewDelegate columnWidthRatiosForMultiColumnTableView:self];
    [super reloadData];
}
@end