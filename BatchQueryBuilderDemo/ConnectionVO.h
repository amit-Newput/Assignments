//
//  ConnectionVO.h
//  BatchQueryBuilderDemo
//
//  Created by NewputMac04 on 09/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LineVO.h"

@interface ConnectionVO : NSObject

@property BOOL isTemporary;

@property (strong, nonatomic) UIView * cell1;
@property (strong, nonatomic) UIView * cell2;
@property (strong, nonatomic) NSString * value1;
@property (strong, nonatomic) NSString * value2;
@property (strong,nonatomic) NSString* sourceTable1;
@property (strong,nonatomic) NSString* sourceTable2;
-(LineVO *) getLineVOForView:(UIView *)view;
-(BOOL)isEqualToConnection:(ConnectionVO *)connection;
@end
