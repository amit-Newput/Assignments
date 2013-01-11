//
//  FieldsTable.h.h
//  BatchQueryBuilderDemo
//
//  Created by Prateek Pradhan on 08/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SourceVO.h"
#import "FieldVO.h"

@class FieldsTable;

@protocol FieldsTableDelegate <NSObject>
@optional
-(void)fieldsTableDidScroll:(FieldsTable *)tableVC;

@end

@interface FieldsTable : UITableViewController{
   
}
@property (strong) SourceVO *sourceVO;
@property (strong) id<FieldsTableDelegate>delegate;

- (id)initWithSourceVO:(SourceVO *)sourceVO ;
-(void) valueSelected: (FieldVO *)valueName;
-(void) toggleTableRowSelection:(NSIndexPath *)indexPath;
@end
