//
//  canvasView.h
//  BatchQueryBuilderDemo
//
//  Created by Prateek Pradhan on 08/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CanvasView;

@protocol CanvasViewDelegate <NSObject>

@optional

-(void)canvasView:(CanvasView *)canvasView lineSelectedAtIndex:(NSInteger)index;

@end

@interface CanvasView : UIScrollView<UIScrollViewDelegate>


@property (strong) NSArray *lines;
@property (strong) id <CanvasViewDelegate> target;

@end
