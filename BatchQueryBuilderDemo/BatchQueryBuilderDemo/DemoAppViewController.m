//
//  DemoAppViewController.m
//  BatchQueryBuilderDemo
//
//  Created by Prateek Pradhan on 08/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import "DemoAppViewController.h"
#import "canvasView.h"
#import "ConnectionVO.h"
#import "FieldVO.h"
#import "SourceVO.h"
#import "DataCell.h"

#define BaseTagForCanvasTable 1000
//used  in dictionary as keys to store all tables and Connections
#define kQueryBuilderSourceTablesKey @"TABLES"
#define kQueryBuilderSourceConnectionsKey @"CONNECTIONS"
@interface DemoAppViewController (){
    int numberOfTablesExistInCanvasView;
}
- (void)handleFacetPanning:(UIPanGestureRecognizer *)gesture;
- (void)validateAndStartDragging:(UIPanGestureRecognizer *)gesture;
- (void) stopDragging:(UIPanGestureRecognizer *)gesture;
- (void) dragObject:(UIPanGestureRecognizer *)gesture;
-(void) handlePanningCanvasTable:(UIPanGestureRecognizer *) gesture;
-(void) clearDraggingObjects;
@property (strong) NSMutableDictionary *tagByTableNameMapping;
@property (strong, nonatomic) NSMutableArray *connectionVOs;
@end

@implementation DemoAppViewController

@synthesize canvasBackView;
@synthesize sourcesTableBackView;
@synthesize sourcesTable,sourcesTableNav;
@synthesize canvasView;
@synthesize canvasViewTablesDic;
@synthesize tagByTableNameMapping;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //array for saving the tables.
   self.sourceVOs = [[NSMutableArray alloc] init];
    
    for ( int i =1 ;i<=3;++i){
         NSMutableArray *fieldVOs = [[NSMutableArray alloc] init ];
        SourceVO * sourceVO = [[SourceVO alloc] init];
        sourceVO.name =[@"table" stringByAppendingString: [NSString stringWithFormat:@"%d",i]];
        sourceVO.sourceID = sourceVO.name;
        for( int j= 1;j<=12; ++j){
            FieldVO * fieldVO = [[FieldVO alloc] init];
            fieldVO.sourceVO = sourceVO ;
            fieldVO.type = FieldTypeString;
            fieldVO.isSelected = false;
            fieldVO.name =  [@"Field" stringByAppendingString: [NSString stringWithFormat:@"%d",j]];
            fieldVO.fieldID = fieldVO.name;
            [fieldVOs addObject:fieldVO];
        }
        sourceVO.fieldVOs = fieldVOs;
        [self.sourceVOs addObject:sourceVO];
    
    }
    
    //[sourcesDic setObject:tables forKey:kQueryBuilderSourceTablesKey];
    
    self.sourcesTable = [[SourcesTable alloc] initWithSources:self.sourceVOs];
    sourcesTableNav = [[UINavigationController alloc] initWithRootViewController:sourcesTable];
    sourcesTableNav.view.frame = CGRectMake(0, 0, sourcesTableBackView.frame.size.width, sourcesTableBackView.frame.size.height);
    [self.sourcesTableBackView addSubview:sourcesTableNav.view];
    
    canvasView = [[CanvasView alloc] initWithFrame:CGRectMake(0, 0, self.canvasBackView.frame.size.width, self.canvasBackView.frame.size.height)];
    
    canvasView.contentSize = self.canvasView.frame.size;
    canvasView.backgroundColor = [UIColor blueColor];
    canvasView.showsHorizontalScrollIndicator = canvasView.showsVerticalScrollIndicator = YES;
    canvasView.target =self;
    [self.canvasBackView addSubview:canvasView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleFacetPanning:)];
    [self.sourcesTableBackView addGestureRecognizer:panGesture];
    
    canvasViewTablesDic = [[NSMutableDictionary alloc] init];
    tagByTableNameMapping = [[NSMutableDictionary alloc] init];
    numberOfTablesExistInCanvasView = 0;
    if (!self.connectionVOs) {
        self.connectionVOs = [NSMutableArray array];
    }
    //[sourcesDic setObject:self.connectionVOs forKey:kQueryBuilderSourceConnectionsKey];
    
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
        ConnectionVO *connectionVo = [[ConnectionVO alloc] init];
        connectionVo.cell1 = initialDraggedCell;
        connectionVo.cell2 = highlightedCell;
        //Later following two fields will be replaced by VO's
        
        connectionVo.fieldVO1 = (FieldVO *)initialDraggedCell.data;
        connectionVo.fieldVO2 = (FieldVO *)highlightedCell.data;
        [self addConnection:connectionVo];

    }
    //[self redrawCanvasView];
    [self clearDraggingObjects];
    
}



- (void) stopDragging:(UIPanGestureRecognizer *)gesture{
     if(draggedCell != nil){
         
         CGPoint droppedAtPoint = [gesture locationInView:self.canvasBackView];
         if ([self.canvasBackView pointInside:droppedAtPoint withEvent:nil]) {
             SourceVO  *sourceVO = nil;
 
             
             // Determine whether user has dragged the table or a field of the table.
            // if([draggedTable isKindOfClass:[SourcesTable class]]){
             if([draggedCell.data isKindOfClass:[SourceVO class]]){
     
                 sourceVO = (SourceVO *) draggedCell.data ;
                 
                
             }else{
                 FieldVO *tempFieldVO = (FieldVO *)draggedCell.data;
                 sourceVO = tempFieldVO.sourceVO;
             }
             //Determine whether to create a new table on canvas or not.
             
             if( ![canvasViewTablesDic objectForKey:sourceVO.sourceID]){
                 FieldsTable *fieldTable = [[FieldsTable alloc] initWithSourceVO:sourceVO];
                 fieldTable.delegate = self;
                 fieldTable.view.frame = CGRectMake(0, 44,200, 200);
                 
                 
                 UINavigationController *sourceValueTableNav = [[UINavigationController alloc] initWithRootViewController:fieldTable];
                 // Create Delete Button for Field Table
                 UIButton *button = [UIButton  buttonWithType:UIButtonTypeCustom];
                 [button setTitle:@"X" forState:UIControlStateNormal];
                 button.titleLabel.textColor = [UIColor blackColor];
                 [button setFrame:CGRectMake(0, 0, 20, 20)];
                 
                 UIBarButtonItem *deleteTableButton = [[UIBarButtonItem  alloc] initWithCustomView:button];
                 
                 fieldTable.navigationItem.rightBarButtonItem = deleteTableButton;
                 
                 sourceValueTableNav.view.frame =CGRectMake(droppedAtPoint.x, droppedAtPoint.y,200, 200);
                 
                 //Apply Gestures
                 UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanningCanvasTable:)];
                 //UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTappingCanvasTable:)];
                 int tag = BaseTagForCanvasTable + numberOfTablesExistInCanvasView ;
                 sourceValueTableNav.view.tag = tag;
                 sourcesTableNav.view.alpha = .5;
                 [sourceValueTableNav.view addGestureRecognizer:panGesture];
                 sourceValueTableNav.navigationBar.tag =tag;
                // [sourceValueTableNav.navigationBar addGestureRecognizer:tapGesture];
                 [self.canvasView addSubview:sourceValueTableNav.view];
                 
                 [canvasViewTablesDic setObject:sourceValueTableNav forKey:sourceVO.sourceID];
                 [tagByTableNameMapping setObject:sourceVO.sourceID forKey:[NSString stringWithFormat:@"%d",tag]];
                 numberOfTablesExistInCanvasView++;
             }
             if([draggedCell.data isKindOfClass:[FieldVO class]]){
              //Get the value table to be updated
                 
                 FieldVO *tempFieldVO = (FieldVO *) draggedCell.data;
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
        [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
             [draggedTableNav.view setCenter:CGPointMake(draggedTableNav.view.center.x+translation.x, draggedTableNav.view.center.y+translation.y)];
        } completion:^(BOOL finished){
            // if you want to do something once the animation finishes, put it here
        }];
      
       
		[gesture setTranslation:CGPointZero inView:[draggedTableNav.view superview]];
        
        CGPoint draggedViewExtremePoint = CGPointMake(draggedTableNav.view.frame.origin.x + draggedTableNav.view.frame.size.width, draggedTableNav.view.frame.origin.y + draggedTableNav.view.frame.size.height);
        
        //This translation is required for this point containment check in Canvas View
        //CGPoint translatedExtremePoint = [self.canvasBackView convertPoint:draggedViewExtremePoint fromView:self.canvasView];
        [self updateContentSizeForCanvasView:draggedViewExtremePoint];

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
            ConnectionVO *tempConnectionVO = [[ConnectionVO alloc] init];
            tempConnectionVO.cell1 =initialDraggedCell;
            tempConnectionVO.cell2 = draggedCell;
            tempConnectionVO.fieldVO1 = (FieldVO *) initialDraggedCell.data;
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
    for (ConnectionVO *objConnectionVO in self.connectionVOs) {
        [lines addObject:[objConnectionVO getLineVOForView:self.canvasView]];
    }
    
    self.canvasView.lines = [NSArray arrayWithArray:lines];
    
    
}
#pragma mark FieldsTable delegate methods
-(void)fieldsTableDidScroll:(FieldsTable *)tableVC{
    [self redrawCanvasView];
    //NSLog(@"%@",NSStringFromCGPoint([self.canvasView convertPoint:tableVC.tableView.frame.origin fromView:tableVC.tableView.superview]));
    
    
}

-(void)addConnection:(ConnectionVO *)conn{
    BOOL shouldAdd = YES;
    for (ConnectionVO *objConn in self.connectionVOs) {
        if ([objConn isEqualToConnection:conn]) {
            shouldAdd = NO;
            break;
        }
    }
    if (shouldAdd) {
        [self.connectionVOs addObject:conn];
    }
}
// Index of line array in Canvas View and index of corrosponding connection VOs should be same
-(void)removeConnectionAtIndex:(int)index{
    if (self.connectionVOs.count > index) {
        [self.connectionVOs removeObjectAtIndex:index];
    }
    [self redrawCanvasView];
}

-(void)removeTemporaryConnections{
    for (int i=0; i < self.connectionVOs.count ; i++) {
        ConnectionVO *newConn = [self.connectionVOs objectAtIndex:i];
        if(newConn.isTemporary){
            [self.connectionVOs removeObject:newConn];
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
        CGPoint startingPointInTableNav = [gesture locationInView:fieldsTable.navigationItem.rightBarButtonItem.customView];
        CGPoint startingPointInTableView = [gesture locationInView:tableNav.topViewController.view];
        
        
        if([tableNav.view pointInside:[gesture locationInView:tableNav.view] withEvent:nil]){
            [self handleTappingCanvasTable:gesture];
            
            if([fieldsTable.navigationItem.rightBarButtonItem.customView  pointInside:startingPointInTableNav withEvent:nil]){
                
                //Handle Deletion of table here
                
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

-(void)removeAllConnectionsForSource:(SourceVO *)sourceVO{
    NSMutableArray *newConnectionVOs = [[NSMutableArray alloc] init];
    for (ConnectionVO *connectionVO in self.connectionVOs) {
        if ([connectionVO.fieldVO1.sourceVO.sourceID isEqualToString:sourceVO.sourceID]  ||  [connectionVO.fieldVO2.sourceVO.sourceID isEqualToString:sourceVO.sourceID] ) {
            continue;
        }
        [newConnectionVOs addObject:connectionVO];
    }
    self.connectionVOs = newConnectionVOs;
}
@end
