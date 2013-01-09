//
//  Facets.h
//  BatchQueryBuilderDemo
//
//  Created by Prateek Pradhan on 08/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Values.h"

@interface Facets : UITableViewController
{
    NSMutableDictionary *sources;

}

@property (strong)  NSMutableDictionary *sources;
- (id)initWithSources:(NSMutableDictionary *) paramSources;
@property  (strong) NSArray *facetKeys;
-(BOOL)isDetailedViewVisible;
@property (strong) Values *selectedValueTable;
@end

