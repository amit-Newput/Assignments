//
//  BQBDataVO.h
//  BatchQueryBuilderDemo
//
//  Created by NewputMac04 on 17/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BQBSourceVO.h"
#import "BQBConnectionVO.h"

@interface BQBDataVO : NSObject
@property (strong) NSMutableArray *sourceVOs;
@property (strong) NSMutableArray *connectionVOs;

@end
