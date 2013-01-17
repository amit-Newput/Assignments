//
//  FieldsTable.h.h
//  BatchQueryBuilderDemo
//
//  Created by Prateek Pradhan on 08/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQBSourceVO.h"
#import "BQBFieldVO.h"

@class FieldsTable;

@protocol FieldsTableDelegate <NSObject>
@optional
-(void)fieldsTableDidScroll:(FieldsTable *)tableVC;

@end

@interface FieldsTable : UITableViewController{
   
}
@property (strong) BQBSourceVO *sourceVO;
@property (strong) id<FieldsTableDelegate>delegate;

- (id)initWithSourceVO:(BQBSourceVO *)sourceVO ;
-(void) valueSelected: (BQBFieldVO *)valueName;
-(void) toggleTableRowSelection:(NSIndexPath *)indexPath;
@end
