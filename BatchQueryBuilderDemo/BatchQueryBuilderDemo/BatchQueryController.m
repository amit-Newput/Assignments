//
//  DemoAppViewController.m
//  BatchQueryBuilderDemo
//
//  Created by Prateek Pradhan on 08/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import "BatchQueryController.h"
#import "canvasView.h"
#import "BQBConnectionVO.h"
#import "BQBFieldVO.h"
#import "BQBSourceVO.h"
#import "DataCell.h"
#import <QuartzCore/QuartzCore.h>

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define BaseTagForCanvasTable 1000
//used  in dictionary as keys to store all tables and Connections
#define kQueryBuilderSourceTablesKey @"TABLES"
#define kQueryBuilderSourceConnectionsKey @"CONNECTIONS"
@interface BatchQueryController (){
    int numberOfTablesExistInCanvasView;
    int lastUsedConnectionColorIndex;
}
- (void)handleFacetPanning:(UIPanGestureRecognizer *)gesture;
- (void)validateAndStartDragging:(UIPanGestureRecognizer *)gesture;
- (void) stopDragging:(UIPanGestureRecognizer *)gesture;
- (void) dragObject:(UIPanGestureRecognizer *)gesture;
-(void) handlePanningCanvasTable:(UIPanGestureRecognizer *) gesture;
-(void) clearDraggingObjects;
@property (strong) NSMutableDictionary *tagByTableNameMapping;
//@property (strong, nonatomic) NSMutableArray *connectionVOs;
@end

@implementation BatchQueryController

@synthesize canvasBackView;
@synthesize sourcesTableBackView;
@synthesize sourcesTable,sourcesTableNav;
@synthesize canvasView;
@synthesize canvasViewTablesDic;
@synthesize tagByTableNameMapping;
@synthesize connectionListView;
@synthesize dataVO;


// set Mode NO to load Data to mimic the adding functionality of Batch Query
// else  YES to mimic the editing functionality
-(BQBDataVO *) getNewBQBDataVOWithEditMode: (BOOL) EditMode{
    
    BQBDataVO * thisDataVO = [[BQBDataVO alloc] init];
    
    for ( int i =1 ;i<=3;++i){
        NSMutableArray *fieldVOs = [[NSMutableArray alloc] init ];
        BQBSourceVO * sourceVO = [[BQBSourceVO alloc] init];
        if(EditMode && i %2){
        sourceVO.isSelected = YES;
        }
        else{
            sourceVO.isSelected = NO;
        }
        sourceVO.name =[@"table" stringByAppendingString: [NSString stringWithFormat:@"%d",i]];
        sourceVO.sourceID = sourceVO.name;
        for( int j= 1;j<=12; ++j){
            BQBFieldVO * fieldVO = [[BQBFieldVO alloc] init];
            fieldVO.sourceVO = sourceVO ;
            fieldVO.type = FieldTypeString;
            if(EditMode && j %2){
                fieldVO.isSelected = YES;
            }
            else{
                fieldVO.isSelected = NO;
            }
            
            fieldVO.name =  [@"Field" stringByAppendingString: [NSString stringWithFormat:@"%d",j]];
            fieldVO.fieldID = fieldVO.name;
            [fieldVOs addObject:fieldVO];
        }
        sourceVO.fieldVOs = fieldVOs;
        //[self.sourceVOs addObject:sourceVO];
        [thisDataVO.sourceVOs addObject:sourceVO];
        
    }
    
    //Fill connection VO if needed here
    NSMutableArray * selectedSourceVO = [[NSMutableArray alloc] init];
    for(BQBSourceVO *objSOurceVO in thisDataVO.sourceVOs){
        
        if(objSOurceVO.isSelected){
            [selectedSourceVO addObject:objSOurceVO];
        }   
    }
    
    if(selectedSourceVO.count >1){
        
        BQBSourceVO * source1 = [selectedSourceVO objectAtIndex:0];
        BQBSourceVO * source2 = [selectedSourceVO objectAtIndex:1];
        BQBConnectionVO *connectionVO1 = [[BQBConnectionVO alloc] init];
        //Later following two fields will be replaced by VO's
        connectionVO1.fieldVO1 = [source1.fieldVOs objectAtIndex: 7];
        connectionVO1.fieldVO2 = [source2.fieldVOs objectAtIndex: 8];
        [thisDataVO.connectionVOs addObject:connectionVO1];
        
        BQBConnectionVO *connectionVO2 = [[BQBConnectionVO alloc] init];
        connectionVO2.fieldVO1 = [source1.fieldVOs objectAtIndex: 1];
        connectionVO2.fieldVO2 = [source2.fieldVOs objectAtIndex: 2];
        [thisDataVO.connectionVOs addObject:connectionVO2];
    }
    
    return thisDataVO;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    canvasView = [[CanvasView alloc] initWithFrame:CGRectMake(0, 0, self.canvasBackView.frame.size.width -60, self.canvasBackView.frame.size.height)];
    canvasView.backgroundColor = [UIColor colorWithWhite:.95 alpha:1.0];
    canvasView.target =self;
    canvasView.layer.borderColor = [UIColor grayColor].CGColor;
    canvasView.layer.borderWidth = 1.0;
    
    // Add gradiant
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = canvasView.bounds;
//    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor darkGrayColor] CGColor],(id)[[UIColor colorWithWhite:0.9 alpha:0.5] CGColor], (id)[[UIColor colorWithWhite:0.4 alpha:0.5] CGColor], nil];
//    [canvasView.layer insertSublayer:gradient atIndex:0];
    

    [self.canvasBackView addSubview:canvasView];
    self.connectionListView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.canvasBackView.frame.size.width -60, 0, 60, self.canvasBackView.frame.size.height)];
    self.connectionListView.backgroundColor = [UIColor colorWithWhite:.73 alpha:1.0];//[UIColor darkGrayColor];
    connectionListView.layer.borderColor = [UIColor grayColor].CGColor;
    connectionListView.layer.borderWidth = 1.0;
    [self.canvasBackView addSubview:self.connectionListView];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleFacetPanning:)];
    [self.sourcesTableBackView addGestureRecognizer:panGesture];
    
    canvasViewTablesDic = [[NSMutableDictionary alloc] init];
    tagByTableNameMapping = [[NSMutableDictionary alloc] init];
    numberOfTablesExistInCanvasView = 0;
    
    //[sourcesDic setObject:self.connectionVOs forKey:kQueryBuilderSourceConnectionsKey];
    
    lastUsedConnectionColorIndex = 0;
    
    //array for saving the tables.
    self.dataVO = nil;
    
    //[sourcesDic setObject:tables forKey:kQueryBuilderSourceTablesKey];
    
    self.sourcesTable = [[SourcesTable alloc] initWithSources:self.dataVO.sourceVOs];
    sourcesTableNav = [[UINavigationController alloc] initWithRootViewController:sourcesTable];
    sourcesTableNav.view.frame = CGRectMake(0, 0, sourcesTableBackView.frame.size.width, sourcesTableBackView.frame.size.height);
    [self.sourcesTableBackView addSubview:sourcesTableNav.view];
    
    self.dataVO =[self getNewBQBDataVOWithEditMode:YES];
}

-(void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(reloadConnectionVO) withObject:nil afterDelay:.00];
    //[self reloadConnectionVO];
   
    
    
}
-(void) addTableToCanvas:(BQBSourceVO*) paramSourceVO atPoint:(CGPoint) dropAtPoint{
    //Determine whether to create a new table on canvas or not.
    if( ![canvasViewTablesDic objectForKey:paramSourceVO.sourceID]){
        paramSourceVO.isSelected = YES;
        FieldsTable *fieldTable = [[FieldsTable alloc] initWithSourceVO:paramSourceVO];
        fieldTable.delegate = self;
        fieldTable.view.frame = CGRectMake(0, 44,200, 200);
        
        
        UINavigationController *sourceValueTableNav = [[UINavigationController alloc] initWithRootViewController:fieldTable];
        // Create Delete Button for Field Table
        //                 UIButton *button = [UIButton  buttonWithType:UIButtonTypeCustom];
        //                 [button setTitle:@"X" forState:UIControlStateNormal];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"round_delete"] forState:UIControlStateNormal];
        //button.titleLabel.textColor = [UIColor blackColor];
        [button setFrame:CGRectMake(0, 0, 20, 20)];
        
        UIBarButtonItem *deleteTableButton = [[UIBarButtonItem  alloc] initWithCustomView:button];
        
        fieldTable.navigationItem.leftBarButtonItem = deleteTableButton;
        
        sourceValueTableNav.view.frame =CGRectMake(dropAtPoint.x, dropAtPoint.y,200, 200);
        
        //Apply Gestures
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanningCanvasTable:)];
        //UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTappingCanvasTable:)];
        int tag = BaseTagForCanvasTable + numberOfTablesExistInCanvasView ;
        sourceValueTableNav.view.tag = tag;
        [sourceValueTableNav.view addGestureRecognizer:panGesture];
        sourceValueTableNav.navigationBar.tag =tag;
        sourceValueTableNav.view.layer.shadowColor = [UIColor grayColor].CGColor;
        sourceValueTableNav.view.layer.shadowOpacity = .5;
        sourceValueTableNav.view.layer.shadowOffset = CGSizeMake(5, 5);
        // [sourceValueTableNav.navigationBar addGestureRecognizer:tapGesture];
        [self.canvasView addSubview:sourceValueTableNav.view];
        
        [canvasViewTablesDic setObject:sourceValueTableNav forKey:paramSourceVO.sourceID];
        [tagByTableNameMapping setObject:paramSourceVO.sourceID forKey:[NSString stringWithFormat:@"%d",tag]];
        numberOfTablesExistInCanvasView++;
    }
}
//code related to dragging Facets
//called when pan gesture starts
- (void)handleFacetPanning:(UIPanGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
			[self validateAndStartDragging:gesture];
			break;
		case UIGestureRecognizerStateChanged:
			[self dragObject:gesture];
			break;
		case UIGestureRecognizerStateEnded:
			[self stopDragging:gesture];
			break;
        case UIGestureRecognizerStatePossible:
            NSLog(@"UIGestureRecognizerStatePossible");
            break;
        case UIGestureRecognizerStateFailed:
            NSLog(@"UIGestureRecognizerStateFailed");
            break;
        case UIGestureRecognizerStateCancelled:
            NSLog(@"UIGestureRecognizerStateCancelled");
            break;
    }
}
- (void)initDraggedFacetWithCell:(DataCell *)cell atPoint:(CGPoint)point
{
	if (draggedCell != nil) {
		[draggedCell removeFromSuperview];
		draggedCell = nil;
	}
	CGRect frame = CGRectMake(point.x, point.y, cell.frame.size.width, cell.frame.size.height);
	draggedCell = [[DataCell alloc] init];
	draggedCell.textLabel.text = cell.textLabel.text;
	draggedCell.alpha = 0.8;
	draggedCell.frame = frame;
	//draggedCell.highlighted = YES;
    draggedCell.backgroundColor = [UIColor darkGrayColor];
    draggedCell.textLabel.textColor = [UIColor whiteColor];
    draggedCell.textLabel.font = [UIFont systemFontOfSize:14.0];
	draggedCell.selectionStyle = UITableViewCellSelectionStyleGray;
    draggedCell.data = cell.data;
	[self.view addSubview:draggedCell];
}
- (void)validateAndStartDragging:(UIPanGestureRecognizer *)gesture{

    UITableViewController *draggedTable =nil;
    if(!sourcesTable.isDetailedViewVisible){
        draggedTable = sourcesTable;
    }else{
        draggedTable = sourcesTable.selectedFieldsTable;
    }
    CGPoint startingPoint = [gesture locationInView:draggedTable.tableView];
    NSIndexPath *indexPath = [draggedTable.tableView indexPathForRowAtPoint:startingPoint];
    DataCell *cell = (DataCell *)[draggedTable.tableView cellForRowAtIndexPath:indexPath];
    if (cell != nil) {
        CGPoint origin = cell.frame.origin;
        CGPoint locInMainView = [gesture locationInView:self.view];
        //this cell should be placed at point on which dragging initiated
        origin.x = locInMainView.x - 5;
        origin.y = locInMainView.y - 5;
        [self initDraggedFacetWithCell:cell atPoint:origin];
        cell.highlighted = NO;
        
    }
}

-(void)stopCanvasDragging:(UIPanGestureRecognizer *)gesture{
    highlightedCell.highlighted = NO;
    if (draggedCell && highlightedCell && initialDraggedCell.data != highlightedCell.data) {
        BQBConnectionVO *connectionVo = [[BQBConnectionVO alloc] init];
        connectionVo.cell1 = initialDraggedCell;
        connectionVo.cell2 = highlightedCell;
        //Later following two fields will be replaced by VO's
        
        connectionVo.fieldVO1 = (BQBFieldVO *)initialDraggedCell.data;
        connectionVo.fieldVO2 = (BQBFieldVO *)highlightedCell.data;
        lastUsedConnectionColorIndex -= 2;
        
        
        [self addConnection:connectionVo];

    }
    //[self redrawCanvasView];
    [self clearDraggingObjects];
    
}



- (void) stopDragging:(UIPanGestureRecognizer *)gesture{
     if(draggedCell != nil){
         
         CGPoint droppedAtPoint = [gesture locationInView:self.canvasView];
         if ([self.canvasView pointInside:droppedAtPoint withEvent:nil]) {
             BQBSourceVO  *sourceVO = nil;
 
             
             // Determine whether user has dragged the table or a field of the table.
            // if([draggedTable isKindOfClass:[SourcesTable class]]){
             if([draggedCell.data isKindOfClass:[BQBSourceVO class]]){
     
                 sourceVO = (BQBSourceVO *) draggedCell.data ;
                 
                
             }else{
                 BQBFieldVO *tempFieldVO = (BQBFieldVO *)draggedCell.data;
                 sourceVO = tempFieldVO.sourceVO;
             }
             
             
             [self addTableToCanvas:sourceVO atPoint:droppedAtPoint];
             
             if([draggedCell.data isKindOfClass:[BQBFieldVO class]]){
              //Get the value table to be updated
                 
                 BQBFieldVO *tempFieldVO = (BQBFieldVO *) draggedCell.data;
                 FieldsTable *existingFieldsTable = (FieldsTable *)[[canvasViewTablesDic objectForKey:sourceVO.sourceID] topViewController];
                 // mark dragged field as checked in the table
                 [existingFieldsTable valueSelected:tempFieldVO];
                 
             }
             
         }
     }
    
    //remove dragged cell from super view, we don't need it anymore
	[self clearDraggingObjects];
    
}


-(void) handleTappingCanvasTable:(UITapGestureRecognizer *)gesture{
    //return;
    UINavigationController *tableNav = [canvasViewTablesDic objectForKey:[tagByTableNameMapping objectForKey:[NSString stringWithFormat:@"%d",gesture.view.tag]]];
    [tableNav.view.superview bringSubviewToFront:tableNav.view];
    
}

-(void) handlePanningCanvasTable:(UIPanGestureRecognizer *) gesture{
    
   // NSLog(@" Table panning View : %@ : %d", gesture.view , gesture.view.tag);
    
    //return;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
			// Do Nothing
            [self identifyDraggedView:gesture];
			break;
		case UIGestureRecognizerStateChanged:
			[self dragCanvasObject:gesture];
            
			break;
		case UIGestureRecognizerStateEnded:
			[self stopCanvasDragging:gesture];
			break;
        case UIGestureRecognizerStatePossible:
            NSLog(@"UIGestureRecognizerStatePossible");
            break;
        case UIGestureRecognizerStateFailed:
            NSLog(@"UIGestureRecognizerStateFailed");
            [self clearDraggingObjects];
            break;
        case UIGestureRecognizerStateCancelled:{
            NSLog(@"UIGestureRecognizerStateCancelled");
            [self stopCanvasDragging:gesture];
        }
            
            break;
    }
    [self redrawCanvasView];
    
}
-(void) clearDraggingObjects{
    [self removeTemporaryConnections];
    draggedTableNav = nil;
    //remove dragged cell from super view, we don't need it anymore
	[draggedCell removeFromSuperview];
	draggedCell = nil;
    highlightedCell =nil;
    initialDraggedCell = nil;
    
}
-(void) dragCanvasObject:(UIPanGestureRecognizer *)gesture{
    if(draggedTableNav){
        CGPoint translation = [gesture translationInView:[draggedTableNav.view superview]];
        CGFloat testX = translation.x + draggedTableNav.view.frame.origin.x;
        CGFloat testY = translation.y + draggedTableNav.view.frame.origin.y;
        if(testX < 0)
            translation.x = translation.x  - testX;
        if(testY <0)
            translation.y = translation.y - testY;
        [draggedTableNav.view setCenter:CGPointMake(draggedTableNav.view.center.x+translation.x , draggedTableNav.view.center.y+translation.y)];
        
		[gesture setTranslation:CGPointZero inView:[draggedTableNav.view superview]];
        
        [self updateCanvasViewContentSize];
        [self.canvasView scrollRectToVisible:draggedTableNav.view.frame animated:YES];

    }else if(draggedCell){
        
        CGPoint translation = [gesture translationInView:[draggedCell superview]];
        [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [draggedCell setCenter:CGPointMake(draggedCell.center.x+translation.x, draggedCell.center.y+translation.y)];
        } completion:^(BOOL finished){
            // if you want to do something once the animation finishes, put it here
        }];
        
        
		[gesture setTranslation:CGPointZero inView:[draggedCell superview]];
        
        CGPoint point = draggedCell.frame.origin;
        [self highlightOtherTableCellForJoinIfRequired:point];
        
        
        CGPoint draggedViewExtremePoint = CGPointMake(draggedCell.frame.origin.x + draggedCell.frame.size.width, draggedCell.frame.origin.y + draggedCell.frame.size.height);
        
        //This translation is required for this point containment check in Canvas View
        CGPoint translatedExtremePoint = [self.canvasView convertPoint:draggedViewExtremePoint fromView:self.view];
        [self updateContentSizeForCanvasView:translatedExtremePoint];
        
    }
    
    
    
    
}

-(void)updateContentSizeForCanvasView : (CGPoint) translatedExtremePoint{
    
    //NSLog(@"Translated Extreme Point  x = %f , y=%f", translatedExtremePoint.x,translatedExtremePoint.y);
    
    if(![self.canvasView pointInside:translatedExtremePoint withEvent:nil]){
          CGPoint canvasExtremePoint = CGPointMake(canvasView.frame.origin.x +  canvasView.contentSize.width, canvasView.frame.origin.y + canvasView.contentSize.height);
       // NSLog(@"canvasView Extreme Point  x = %f , y=%f", canvasExtremePoint.x,canvasExtremePoint.y);
       // NSLog(@" canvas content size width: %f  height: %f",canvasView.contentSize.width,canvasView.contentSize.height);
        float newWidth = canvasExtremePoint.x;
        float newHeight = canvasExtremePoint.y;
        float differenceWidth =0.0,differenceHeight=0.0;
        if(canvasExtremePoint.x <= translatedExtremePoint.x){
             differenceWidth = translatedExtremePoint.x -canvasExtremePoint.x ;
            newWidth = canvasExtremePoint.x + differenceWidth +5;
        }
        
        if(canvasExtremePoint.y <= translatedExtremePoint.y){
             differenceHeight = translatedExtremePoint.y-canvasExtremePoint.y;
            newHeight = canvasExtremePoint.y + differenceHeight +5;
        }
        
        [self.canvasView setContentSize:CGSizeMake(newWidth, newHeight)];
        //CGPoint contentOffSetPoint = CGPointMake(-200, 10);
        //CGPoint contentOffSetPoint =translatedExtremePoint;
       // NSLog(@" Difference in Height = %f , Width = %f", differenceWidth, differenceHeight);
        //NSLog(@" content OffSet Point is  x = %f , y=%f", newWidth,newHeight);
        //[self.canvasView setContentOffset:contentOffSetPoint animated:YES];
    }
          
          
     
}

-(void)highlightOtherTableCellForJoinIfRequired:(CGPoint) point
{
    //Unhighlight the last cell highlighted
    highlightedCell.highlighted = NO;
    highlightedCell = nil;
    for (NSString *key in self.canvasViewTablesDic) {
        UINavigationController *tableNav = [self.canvasViewTablesDic objectForKey:key];
        CGPoint translatedPoint = [tableNav.topViewController.view convertPoint:point fromView:self.view];
        UITableView*  tableView = (UITableView *)tableNav.topViewController.view ;
        //User is trying to join with one of the row in this table
        if([tableNav.topViewController.view pointInside:translatedPoint withEvent:nil]){
            
            NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:translatedPoint];
            DataCell *cell = (DataCell *) [tableView cellForRowAtIndexPath:indexPath];
            cell.highlighted = YES;
            highlightedCell = cell;
            break;
        }
        
    }
}

-(void)identifyDraggedView:(UIPanGestureRecognizer *)gesture{
    
    UINavigationController *tableNav = [canvasViewTablesDic objectForKey:[tagByTableNameMapping objectForKey:[NSString stringWithFormat:@"%d",gesture.view.tag]]];
    CGPoint startingPointInNavigationView = [gesture locationInView:tableNav.view];
    CGPoint startingPointInTableView = [gesture locationInView:tableNav.topViewController.view];
    if([tableNav.navigationBar pointInside:startingPointInNavigationView withEvent:nil]){
        draggedTableNav = tableNav;
        
        //draggedTableNav.view.frame = CGRectMake(draggedTableNav.view.frame.origin.x+5, draggedTableNav.view.frame.origin.y +5, draggedTableNav.view.frame.size.width, draggedTableNav.view.frame.size.height);
        [draggedTableNav.view.superview bringSubviewToFront:draggedTableNav.view];
        
    }else if([tableNav.topViewController.view pointInside:startingPointInTableView withEvent:nil]){
            
        FieldsTable *fieldTable = (FieldsTable *)[tableNav topViewController];
        UITableView * tableView = fieldTable.tableView;
        CGPoint cellPoint = [gesture locationInView:tableView];
        // NSLog(@"cell point %f  : % f", cellPoint.x,cellPoint.y);
        
        NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:cellPoint];
        DataCell *cell = (DataCell *) [tableView cellForRowAtIndexPath:indexPath];
        if (cell != nil) {
            initialDraggedCell = cell;
            CGPoint origin = cell.frame.origin;
            CGPoint locInMainView = [gesture locationInView:self.view];
            //this cell should be placed at point on which dragging initiated
            origin.x = locInMainView.x - 5;
            origin.y = locInMainView.y - 5;
            [self initDraggedFacetWithCell:cell atPoint:origin];
            
            //Create Temp Connection
            BQBConnectionVO *tempConnectionVO = [[BQBConnectionVO alloc] init];
            tempConnectionVO.cell1 =initialDraggedCell;
            tempConnectionVO.cell2 = draggedCell;
            tempConnectionVO.fieldVO1 = (BQBFieldVO *) initialDraggedCell.data;
            tempConnectionVO.fieldVO2 = nil;
            [self addConnection:tempConnectionVO];
            cell.highlighted = NO;
        }
         
        
    }
    
}
- (void) dragObject:(UIPanGestureRecognizer *)gesture{
    if(draggedCell != nil ){
        CGPoint translation = [gesture translationInView:draggedCell.superview];
        [draggedCell setCenter:CGPointMake(draggedCell.center.x+translation.x, draggedCell.center.y+translation.y)];
		[gesture setTranslation:CGPointZero inView:[draggedCell superview]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation   {
    return YES;
}


-(void) redrawCanvasView{
    NSMutableArray * lines = [[ NSMutableArray alloc] init];
    for (BQBConnectionVO *objConnectionVO in self.dataVO.connectionVOs) {
        [lines addObject:[objConnectionVO getLineVOForView:self.canvasView]];
    }
    
    self.canvasView.lines = [NSArray arrayWithArray:lines];
}
#pragma mark FieldsTable delegate methods
-(void)fieldsTableDidScroll:(FieldsTable *)tableVC{
    [self redrawCanvasView];
    //NSLog(@"%@",NSStringFromCGPoint([self.canvasView convertPoint:tableVC.tableView.frame.origin fromView:tableVC.tableView.superview]));
    
    
}
-(UIColor *)getConnectionColor{
    lastUsedConnectionColorIndex += 2 ;
    //NSMutableArray *colors = [[NSMutableArray alloc] init];
    //[NSMutableArray arrayWithObjects:@"0x55BF3B", @"0xDDDF0D", @"0x7798BF", @"0xDF5353", @"0xaaeeee", @"0xff0066", @"0xeeaaee",@"0x55BF3B", @"0xDF5353", @"0x7798BF", @"0xaaeeee", nil];
    
    //    [colors addObject:[UIColor colorWithRed:221/255 green:223/255 blue:13/255 alpha:1.0]];
    //    [colors addObject:[UIColor colorWithRed:85/255 green:191/255 blue:50/255 alpha:1.0]];
    //    [colors addObject:[UIColor colorWithRed:119/255 green:152/255 blue:191/255 alpha:1.0]];
    

//    NSString *colorToUse = [colors objectAtIndex:lastUsedConnectionColorIndex%colors.count] ;
//    [NSString stringWithFormat:@"%qx", [number longLongValue]];
//    UIColor *connectionColor = UIColorFromRGB();
   
    CGFloat redColorValue = (lastUsedConnectionColorIndex * 40) % 255;
    CGFloat greenColorValue = (lastUsedConnectionColorIndex * 20 + 150) % 255 ;
    CGFloat blueColorValue = (lastUsedConnectionColorIndex * 10 + 120) % 255 ;
    UIColor *connectionColor = [UIColor colorWithRed:redColorValue/255 green:greenColorValue/255 blue:blueColorValue/255 alpha:1.0];
    // NSLog(@" Red % f, Green %f , Blue : %f", redColorValue,greenColorValue,blueColorValue);
    return connectionColor;
    
}

-(void)addConnection:(BQBConnectionVO *)conn{
    BOOL shouldAdd = YES;
    for (BQBConnectionVO *objConn in self.dataVO.connectionVOs) {
        if ([objConn isEqualToConnection:conn]) {
            shouldAdd = NO;
            break;
        }
    }
    if (shouldAdd) {
        conn.connectionLineColor = [self getConnectionColor];
        [self.dataVO.connectionVOs addObject:conn];
        [self reloadConnectionListView];
    }
    
}


-(void)reloadConnectionListView{
    CGFloat xCoord= 5 ;
    CGFloat yCoord= 10 ;
    CGFloat height= 60;
    CGFloat width = 55;
    CGFloat gap = 3;
    int tag = 0;
    //Clean Previous Connections.
    for (UIView *newView in self.connectionListView.subviews) {
        [newView removeFromSuperview];
    }
    for (int i=0; i< self.dataVO.connectionVOs.count; i++) {
        BQBConnectionVO *connectionVO = [self.dataVO.connectionVOs objectAtIndex:i];
        if([connectionVO isTemporary]){
            continue;
        }
        UIView *connectionItemView= [[UIView alloc] initWithFrame:CGRectMake(xCoord, yCoord, width, height)];
        
        

        UIButton *highlightConnectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        highlightConnectionButton.backgroundColor = connectionVO.connectionLineColor;
        highlightConnectionButton.frame =  CGRectMake(13, 11, 35, 40);
        highlightConnectionButton.tag = tag;
        highlightConnectionButton.layer.borderColor = [UIColor whiteColor].CGColor;
        highlightConnectionButton.layer.borderWidth = 1.0;
        
        [highlightConnectionButton addTarget:self action:@selector(setSelectedConnection:) forControlEvents:UIControlEventTouchDown];
        [connectionItemView addSubview:highlightConnectionButton];
        
        //Add X button
        UIButton *deleteConnectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteConnectionButton setImage:[UIImage imageNamed:@"round_delete"] forState:UIControlStateNormal];
        deleteConnectionButton.frame = CGRectMake(0, 0, 22, 22);
        deleteConnectionButton.center = highlightConnectionButton.frame.origin;
        deleteConnectionButton.tag = tag;
        [deleteConnectionButton addTarget:self action:@selector(deleteConnection:) forControlEvents:UIControlEventTouchDown];
        [connectionItemView addSubview:deleteConnectionButton];
        
//        connectionItemView.layer.borderWidth = 1.0;
//        connectionItemView.layer.borderColor = [UIColor grayColor].CGColor;
        // [UIColor colorWithRed:119.0/255.0 green:116.0/255.0 blue:231.0/255.0 alpha:1.0];
        
        
        
        [self.connectionListView addSubview:connectionItemView];
        yCoord += height + gap;
        tag++;
    }
    yCoord += height;
    [self.connectionListView setContentSize:CGSizeMake(60, yCoord)];

}

-(void)setSelectedConnection:(UIButton *)button{
    for (BQBConnectionVO *newConnection in self.dataVO.connectionVOs) {
        newConnection.isLineSelected = NO;
    }
   // NSLog(@"New Connection %d",button.tag);
    BQBConnectionVO *connectionVO = [self.dataVO.connectionVOs objectAtIndex:button.tag];
    connectionVO.isLineSelected = YES;
    //connectionVO.connectionLineColor = [UIColor redColor];
    [self redrawCanvasView];
}

-(void)deleteConnection:(UIButton *)button{
    
    [self removeConnectionAtIndex:button.tag];
}
// Index of line array in Canvas View and index of corrosponding connection VOs should be same
-(void)removeConnectionAtIndex:(int)index{
    if (self.dataVO.connectionVOs.count > index) {
        [self.dataVO.connectionVOs removeObjectAtIndex:index];
    }
    [self redrawCanvasView];
    [self reloadConnectionListView];
}

-(void)removeTemporaryConnections{
    for (int i=0; i < self.dataVO.connectionVOs.count ; i++) {
        BQBConnectionVO *newConn = [self.dataVO.connectionVOs objectAtIndex:i];
        if(newConn.isTemporary){
            [self.dataVO.connectionVOs removeObject:newConn];
            i--;
        }
    }
}
-(void)canvasView:(CanvasView *)canvasView lineSelectedAtIndex:(NSInteger)index;{
    
    
    [self removeConnectionAtIndex:index];
}

-(void) handleTapOnCanvasView:(UITapGestureRecognizer *) gesture{
    
    for (UINavigationController *tableNav in canvasViewTablesDic.allValues) {
        FieldsTable *fieldsTable = (FieldsTable *)[tableNav topViewController];
        CGPoint startingPointInTableNav = [gesture locationInView:fieldsTable.navigationItem.leftBarButtonItem.customView];
        CGPoint startingPointInTableView = [gesture locationInView:tableNav.topViewController.view];
        
        
        if([tableNav.view pointInside:[gesture locationInView:tableNav.view] withEvent:nil]){
            [self handleTappingCanvasTable:gesture];
            
            if([fieldsTable.navigationItem.leftBarButtonItem.customView  pointInside:startingPointInTableNav withEvent:nil]){
                
                //Handle Deletion of table here
                fieldsTable.sourceVO.isSelected = NO;
                //Idetify all Connections of table and delete them
                [self removeAllConnectionsForSource:fieldsTable.sourceVO];
            
                //remove table from view and dictionary.x
                [self.canvasViewTablesDic removeObjectForKey:fieldsTable.sourceVO.sourceID];
                [self.tagByTableNameMapping removeObjectForKey:[NSString stringWithFormat:@"%d",tableNav.view.tag]];
                 [tableNav.view removeFromSuperview];
                [self redrawCanvasView];
                
                
            }else if([tableNav.topViewController.view pointInside:startingPointInTableView withEvent:nil]){
                
                CGPoint cellPoint = [gesture locationInView:fieldsTable.view];
                NSIndexPath *indexPath = [fieldsTable.tableView indexPathForRowAtPoint:cellPoint];
                [fieldsTable tableView:fieldsTable.tableView didSelectRowAtIndexPath:indexPath];
            }

            break;            
        }
               
        
    }
}

-(void)removeAllConnectionsForSource:(BQBSourceVO *)sourceVO{
    NSMutableArray *newConnectionVOs = [[NSMutableArray alloc] init];
    for (BQBConnectionVO *connectionVO in self.dataVO.connectionVOs) {
        if ([connectionVO.fieldVO1.sourceVO.sourceID isEqualToString:sourceVO.sourceID]  ||  [connectionVO.fieldVO2.sourceVO.sourceID isEqualToString:sourceVO.sourceID] ) {
            continue;
        }
        [newConnectionVOs addObject:connectionVO];
    }
    self.dataVO.connectionVOs = newConnectionVOs;
    [self reloadConnectionListView];
}

-(void)updateCanvasViewContentSize{
    
    CGSize size = self.canvasView.frame.size;
    NSArray *tableNavs = [self.canvasViewTablesDic allValues];
    for (UIViewController *viewController in tableNavs) {
        UIView *view = viewController.view;
        CGFloat exX = view.frame.origin.x+view.frame.size.width;
        if (exX > size.width) {
            size.width = exX;
        }
        CGFloat exY = view.frame.origin.y+view.frame.size.height;
        if (exY > size.height) {
            size.height = exY;
        }
    }
    self.canvasView.contentSize = size;
}


-(void) reloadUI{
    // Load left side tables from sourceVOs.
    self.sourcesTable.sourceVOs = self.dataVO.sourceVOs;
    //clear all existing views from Canvas View
    [[self.canvasView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [canvasViewTablesDic removeAllObjects] ;
    [tagByTableNameMapping removeAllObjects];
    numberOfTablesExistInCanvasView =0;
    lastUsedConnectionColorIndex = 0;
    // Identify the selected tables
    CGPoint dropAtPoint = CGPointMake(0, 0);
    for (BQBSourceVO *objSourceVO in self.dataVO.sourceVOs) {
        if(objSourceVO.isSelected){
            dropAtPoint.x +=250;
            dropAtPoint.y +=250;
        //Add it to canvas and update the dictionary and array needed.
            [self addTableToCanvas:objSourceVO atPoint:dropAtPoint];
            
        }
    }
           // may be some change might require on getLiveVO method in connectionVO
        //call redrawCanvasView and redrawConnectionslines.
    
        [self redrawCanvasView];
        
        //reload grid with new data.
        // update the sql in sql text field.
}

-(void) setCellInfoInConnection:(BQBConnectionVO *)paramConnectionVO  isFirstCell:(BOOL) paramIsFirstCell{
    
}
-(void) reloadConnectionVO{
    //  For each connection in connectionVO .find index path for fieldVO1 and call the cell for row at index path. update the cell1 and cell2 in connectionVO.
    for (BQBConnectionVO *objBQBConnectionVO in self.dataVO.connectionVOs) {
        //FOR CELL1
        int count = -1;
        for (BQBFieldVO * objFieldVO in objBQBConnectionVO.fieldVO1.sourceVO.fieldVOs) {
            count++;
            if([objFieldVO.fieldID isEqualToString:objBQBConnectionVO.fieldVO1.fieldID])
                break;
        }
        if(count!=-1){
            
            UINavigationController *navController = [canvasViewTablesDic objectForKey:objBQBConnectionVO.fieldVO1.sourceVO.sourceID];
            FieldsTable *fieldsTable1 = (FieldsTable *)[navController topViewController];
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:count inSection:0];
            [fieldsTable1.tableView reloadData];
            
            objBQBConnectionVO.cell1 = [fieldsTable1.tableView cellForRowAtIndexPath:indexPath];
          // If cell at this indexPath is not visible then tableView returns nil cell.
            // To overcome this problem, we need to scroll upto the indexPath in our table view. So that cellview  is added to view hierarchy and we can get correct superviews for cell1.
            if(!objBQBConnectionVO.cell1){
                  //If cell1 is not visible then scroll upto the indexPath so that cell1 can be visible.
                [fieldsTable1.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                 objBQBConnectionVO.cell1 = [fieldsTable1.tableView cellForRowAtIndexPath:indexPath];
            }
            NSLog(@" Cell 1 : %@, %d", objBQBConnectionVO.cell1,indexPath.row);
            
        }
        
        // FOR CELL2
        count = -1;
        for (BQBFieldVO * objFieldVO in objBQBConnectionVO.fieldVO2.sourceVO.fieldVOs) {
            count++;
            if([objFieldVO.fieldID isEqualToString:objBQBConnectionVO.fieldVO2.fieldID])
                break;
        }
        if(count!=-1){
            UINavigationController  *navController = [canvasViewTablesDic objectForKey:objBQBConnectionVO.fieldVO2.sourceVO.sourceID];
            FieldsTable *fieldsTable2 = (FieldsTable *)[navController topViewController];
            NSIndexPath  *indexPath = [NSIndexPath indexPathForRow:count inSection:0];
           [fieldsTable2.tableView reloadData];
           
             objBQBConnectionVO.cell2 =[fieldsTable2.tableView cellForRowAtIndexPath:indexPath];
            if(!objBQBConnectionVO.cell2){
                [fieldsTable2.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                objBQBConnectionVO.cell2 = [fieldsTable2.tableView cellForRowAtIndexPath:indexPath];
            }
            NSLog(@" Cell 2 : %@ %d", objBQBConnectionVO.cell2,indexPath.row);
            
        }
        
    }
     
    [self redrawCanvasView];
   [self reloadConnectionListView];

}

-(void)setDataVO:(BQBDataVO *)paramDataVO{
    if(paramDataVO){
        dataVO = paramDataVO;
        [self reloadUI];
    }
}

-(BQBDataVO *) dataVO{
    return dataVO;
}

@end
