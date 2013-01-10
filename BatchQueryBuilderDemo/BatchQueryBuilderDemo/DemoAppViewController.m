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

#define BaseTagForCanvasTable 1000

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
@synthesize sources,sourcesTable,sourcesTableNav;
@synthesize canvasView;
@synthesize canvasViewTablesDic;
@synthesize tagByTableNameMapping;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    sources = [[NSMutableDictionary alloc] init];
    NSArray *table1 = [[NSArray alloc] initWithObjects:@"Field11",@"Field12",@"Field13",@"Field14",@"Field15",@"Field16",@"Field17",@"Field18",@"Field19",@"Field110",@"Field111",@"Field112", nil];
    [sources setObject:table1 forKey:@"table1"];
    NSArray *table2 = [[NSArray alloc] initWithObjects:@"Field21",@"Field22",@"Field23",@"Field24",@"Field25",@"Field26", nil];
    [sources setObject:table2 forKey:@"table2"];
    NSArray *table3 = [[NSArray alloc] initWithObjects:@"Field31",@"Field32",@"Field33",@"Field34",@"Field35",@"Field36", nil];
    [sources setObject:table3 forKey:@"table3"];
    
    sourcesTable = [[Facets alloc] initWithSources:sources];
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
- (void)initDraggedFacetWithCell:(UITableViewCell *)cell atPoint:(CGPoint)point
{
	if (draggedCell != nil) {
		[draggedCell removeFromSuperview];
		draggedCell = nil;
	}
	CGRect frame = CGRectMake(point.x, point.y, cell.frame.size.width, cell.frame.size.height);
	draggedCell = [[UITableViewCell alloc] init];
	draggedCell.textLabel.text = cell.textLabel.text;
	draggedCell.alpha = 0.8;
	draggedCell.frame = frame;
	//draggedCell.highlighted = YES;
    draggedCell.backgroundColor = [UIColor darkGrayColor];
    draggedCell.textLabel.textColor = [UIColor whiteColor];
    draggedCell.textLabel.font = [UIFont systemFontOfSize:14.0];
	draggedCell.selectionStyle = UITableViewCellSelectionStyleGray;
	[self.view addSubview:draggedCell];
}
- (void)validateAndStartDragging:(UIPanGestureRecognizer *)gesture{

    draggedTable =nil;
    if(!sourcesTable.isDetailedViewVisible){
        draggedTable = sourcesTable;
    }else{
        draggedTable = sourcesTable.selectedValueTable;
    }
    CGPoint startingPoint = [gesture locationInView:draggedTable.tableView];
    NSIndexPath *indexPath = [draggedTable.tableView indexPathForRowAtPoint:startingPoint];
    UITableViewCell *cell = [draggedTable.tableView cellForRowAtIndexPath:indexPath];
    if (cell != nil) {
        CGPoint origin = cell.frame.origin;
        CGPoint locInMainView = [gesture locationInView:self.view];
        //this cell should be placed at point on which dragging initiated
        origin.x = locInMainView.x - 5;
        origin.y = locInMainView.y - 5;
        [self initDraggedFacetWithCell:cell atPoint:origin];
        cell.highlighted = NO;
        
        
        
        if (draggedCellData != nil) {
            draggedCellData = nil;
        }
        if([draggedTable isKindOfClass:[Facets class]]){
            // If dragged conent is table name then set the dragged cell data as table name.
            draggedCellData = [sourcesTable.facetKeys objectAtIndex:indexPath.row];
            
        }
        else{
            // If dragged content is Field name then set the dragged cell data as field name
            draggedCellData = cell.textLabel.text;
        }

    }
    
}

-(void)stopCanvasDragging:(UIPanGestureRecognizer *)gesture{
    highlightedCell.highlighted = NO;
    if (draggedCell && highlightedCell) {
        ConnectionVO *connectionVo = [[ConnectionVO alloc] init];
        connectionVo.cell1 = initialDraggedCell;
        connectionVo.cell2 = highlightedCell;
        //Later following two fields will be replaced by VO's
        connectionVo.value1 = initialDraggedCell.textLabel.text;
        connectionVo.value2 = highlightedCell.textLabel.text;
        
        [self addConnection:connectionVo];

    }
    //[self redrawCanvasView];
    [self clearDraggingObjects];
    
}


- (void) stopDragging:(UIPanGestureRecognizer *)gesture{
     if(draggedCell != nil && draggedCellData != nil){
        BOOL droppedAtCorrectTarget = NO;
         
         CGPoint droppedAtPoint = [gesture locationInView:self.canvasBackView];
         if ([self.canvasBackView pointInside:droppedAtPoint withEvent:nil]) {
             droppedAtCorrectTarget = YES;
             NSMutableArray  *valueArray = nil;
             NSString *tableName = nil;
             
             // Determine whether user has dragged the table or a field of the table.
             if([draggedTable isKindOfClass:[Facets class]]){
                 valueArray = [NSMutableArray arrayWithArray:[self.sources objectForKey:draggedCellData]];
                 tableName = draggedCellData;
                 
                
             }else{
                 Values *valueTable = (Values *)draggedTable;
                 valueArray = [NSMutableArray arrayWithArray:[valueTable values]] ;
                 tableName = valueTable.tableName;
                 
             }
             //Determine whether to create a new table on canvas or not.
             
             if( ![canvasViewTablesDic objectForKey:tableName]){
                 Values *sourceValueTable = [[Values alloc] initWithValues:valueArray withTableName:tableName];
                 sourceValueTable.delegate = self;
                 sourceValueTable.view.frame = CGRectMake(0, 44,200, 200);
                 
                 
                 UINavigationController *sourceValueTableNav = [[UINavigationController alloc] initWithRootViewController:sourceValueTable];
                 
                 UIButton *button = [UIButton  buttonWithType:UIButtonTypeCustom];
                 [button setTitle:@"X" forState:UIControlStateNormal];
                 [button setFrame:CGRectMake(0, 0, 20, 20)];
                 
                 UIBarButtonItem *deleteTableButton = [[UIBarButtonItem  alloc] initWithCustomView:button];
                 
                 sourceValueTable.navigationItem.rightBarButtonItem = deleteTableButton;
                 
                 sourceValueTableNav.view.frame =CGRectMake(droppedAtPoint.x, droppedAtPoint.y,200, 200);
                 
                 UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanningCanvasTable:)];
                 UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTappingCanvasTable:)];
                 int tag = BaseTagForCanvasTable + numberOfTablesExistInCanvasView ;
                 sourceValueTableNav.view.tag = tag;
                 sourcesTableNav.view.alpha = .5;
                 [sourceValueTableNav.view addGestureRecognizer:panGesture];
                 sourceValueTableNav.navigationBar.tag =tag;
                 [sourceValueTableNav.navigationBar addGestureRecognizer:tapGesture];
                 [self.canvasView addSubview:sourceValueTableNav.view];
                 
                 [canvasViewTablesDic setObject:sourceValueTableNav forKey:tableName];
                 [tagByTableNameMapping setObject:tableName forKey:[NSString stringWithFormat:@"%d",tag]];
                 numberOfTablesExistInCanvasView++;
             }
             if([draggedTable isKindOfClass:[Values class]]){
              //Get the value table to be updated
                 Values *existingValueTable = (Values *)[[canvasViewTablesDic objectForKey:tableName] topViewController];
                 // mark dragged field as checked in the table
                 [existingValueTable valueSelected:draggedCellData];
                 
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
            [self clearDraggingObjects];
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
	draggedCellData = nil;
    draggedTable = nil;
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
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
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
        NSLog(@"Coming inside navigation bar");
        draggedTableNav = tableNav;
        
        //draggedTableNav.view.frame = CGRectMake(draggedTableNav.view.frame.origin.x+5, draggedTableNav.view.frame.origin.y +5, draggedTableNav.view.frame.size.width, draggedTableNav.view.frame.size.height);
        [draggedTableNav.view.superview bringSubviewToFront:draggedTableNav.view];
        
    }else if([tableNav.topViewController.view pointInside:startingPointInTableView withEvent:nil]){
        NSLog(@"Coming inside table cell %@", [tableNav topViewController].view);
        
        UITableView * tableView = (UITableView *)[tableNav topViewController].view;
        CGPoint cellPoint = [gesture locationInView:tableView];
         NSLog(@"cell point %f  : % f", cellPoint.x,cellPoint.y);
        
        NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:cellPoint];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
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
            tempConnectionVO.value1 = initialDraggedCell.textLabel.text;
            tempConnectionVO.value2 = draggedCell.textLabel.text;
            tempConnectionVO.isTemporary = YES;
            [self addConnection:tempConnectionVO];

            
            cell.highlighted = NO;
            if (draggedCellData != nil) {
                draggedCellData = nil;
            }
        
            // If dragged content is Field name then set the dragged cell data as field name
            draggedCellData = cell.textLabel.text;
        }
         
        
    }
    
}
- (void) dragObject:(UIPanGestureRecognizer *)gesture{
    if(draggedCell != nil && draggedCellData != nil){
        CGPoint translation = [gesture translationInView:draggedTable.tableView];
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

-(void)valuesTableDidScroll:(Values *)tableVC{
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
        Values * valuesTable = (Values *)[tableNav topViewController];
        CGPoint startingPointInTableNav = [gesture locationInView:valuesTable.navigationItem.rightBarButtonItem.customView ];
        CGPoint startingPointInTableView = [gesture locationInView:tableNav.topViewController.view];
        
        
        if([valuesTable.navigationItem.rightBarButtonItem.customView  pointInside:startingPointInTableNav withEvent:nil]){
            
            //Handle Deletion of table here
            
        }
        else if([tableNav.topViewController.view pointInside:startingPointInTableView withEvent:nil]){
                
                CGPoint cellPoint = [gesture locationInView:valuesTable.view];
                NSIndexPath *indexPath = [valuesTable.tableView indexPathForRowAtPoint:cellPoint];
               // UITableViewCell *cell = [valuesTable.tableView cellForRowAtIndexPath:indexPath];
                [valuesTable tableView:valuesTable.tableView didSelectRowAtIndexPath:indexPath];

                break;
        } 
        
    }
}
@end
