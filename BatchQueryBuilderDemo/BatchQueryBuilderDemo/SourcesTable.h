//
//  SourcesTable.h
//  BatchQueryBuilderDemo
//
//  Created by Prateek Pradhan on 08/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FieldsTable.h"

@interface SourcesTable : UITableViewController

@property (strong)  NSMutableArray *sourceVOs;
- (id)initWithSources:(NSMutableArray *) paramSourceVOs;
-(BOOL)isDetailedViewVisible;
@property (strong) FieldsTable *selectedFieldsTable;
@end

