//
//  DemoAppViewController.h
//  BatchQueryBuilderDemo
//
//  Created by Prateek Pradhan on 08/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SourcesTable.h"
#import "CanvasView.h"
#import "FieldsTable.h"
#import "DataCell.h"
#import "BQBDataVO.h"

@interface BatchQueryController : UIViewController<FieldsTableDelegate,CanvasViewDelegate>{
    IBOutlet UIView *canvasBackView;
    IBOutlet UIView *sourcesTableBackView;
    SourcesTable *sourcesTable;
    UINavigationController *sourcesTableNav;
    //UITableViewController *draggedTable;
    UINavigationController *draggedTableNav;
    DataCell *draggedCell;
    DataCell *initialDraggedCell;
    DataCell *highlightedCell;
    NSMutableDictionary *canvasViewTablesDic;
}

@property (strong) IBOutlet UIView *canvasBackView;
@property (strong) IBOutlet UIView *sourcesTableBackView;
@property (strong) UIScrollView   *connectionListView;
//@property (strong) NSMutableArray *sourceVOs;
@property (strong) SourcesTable *sourcesTable;
@property (strong) UINavigationController *sourcesTableNav;
@property (strong) CanvasView *canvasView ;
@property (strong) NSMutableDictionary *canvasViewTablesDic;
@property (strong) BQBDataVO * dataVO;
@end
