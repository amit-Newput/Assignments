//
//  SourceVO.h
//  BatchQueryBuilderDemo
//
//  Created by NewputMac04 on 11/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BQBSourceVO : NSObject
@property (strong) NSString *name;
@property (strong) NSString *sourceID;
@property (strong) NSMutableArray *fieldVOs;

@end
