//
//  canvasView.m
//  BatchQueryBuilderDemo
//
//  Created by Prateek Pradhan on 08/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import "CanvasView.h"
#import "LineVO.h"

@interface CanvasView()
{
    NSArray *pathArray;
    CGFloat lineWidth;
    UIColor *lineColor;
     UIColor *fillColor;

}
@end

@implementation CanvasView
@synthesize lines;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}
-(void)setLines:(NSArray *)paramLines{
    lines  = paramLines;
    NSMutableArray *mutablePaths = [NSMutableArray array];
    for (LineVO *line in self.lines) {
        CGPoint start = line.startPoint;
        CGPoint end = line.endPoint;
    
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:start];
        CGPoint controlPoint1;
        CGPoint controlPoint2;
        /*
        CGPoint midPoint = CGPointMake((line.startPoint.x + line.endPoint.x)/2, (line.startPoint.y + line.endPoint.y)/2);
        CGFloat slop;
       
        if (start.x == end.x) {
            // Parallal
            
            
        }else{
            slop = (start.y - end.y)/(start.x - end.x);
            slop = -1 / slop;
            //CGFloat slop = tanf(90);
            CGFloat c = midPoint.y - slop * midPoint.x;
            
            controlPoint1 = CGPointMake((start.y-c)/slop, start.y);
            controlPoint2 = CGPointMake(start.x, slop*start.x+c);
            NSLog(@"c p 1 = %@",NSStringFromCGPoint(controlPoint1));
             NSLog(@"c p 2 = %@",NSStringFromCGPoint(controlPoint2));
            NSLog(@"%f",slop);

        }*/
        CGFloat cp1x;
        CGFloat cp2x;
        CGFloat cp1y;
        CGFloat cp2y;
        CGFloat t = 50;
        
        if (start.x < end.x) {
            cp1x = start.x + t;
            cp2x = end.x - t;
        }else{
            cp1x = start.x - t;
            cp2x = end.x + t;
        }
        cp1y = start.y;
        cp2y = end.y;
        
        controlPoint1 = CGPointMake(cp1x, cp1y);
        controlPoint2 = CGPointMake(cp2x, cp2y);
        
        [path addCurveToPoint:end controlPoint1:controlPoint1 controlPoint2:controlPoint2];
        [mutablePaths addObject:path];
    }
    pathArray = [NSArray arrayWithArray:mutablePaths];
    
    [self setNeedsDisplay];
}
-(NSArray *)lines{
    return lines;
}
-(NSArray *)getLines:(float)num{
    LineVO *line1 = [[LineVO alloc]init];
    line1.startPoint1 = CGPointMake(20*num, 30*num);
    line1.startPoint2 = CGPointMake(20*num, 30*num);
    line1.endPoint1 = CGPointMake(420*num, 440*num);
    line1.endPoint2 = CGPointMake(420*num, 440*num);
    
    LineVO *line2 = [[LineVO alloc]init];
    line2.startPoint1 = CGPointMake(100*num, 130*num);
    line2.startPoint2 = CGPointMake(130*num, 170*num);
    line2.endPoint1 = CGPointMake(140*num, 180*num);
    line2.endPoint2 = CGPointMake(150*num, 130*num);
    
    LineVO *line3 = [[LineVO alloc]init];
    line3.startPoint1 = CGPointMake(120*num, 30*num);
    line3.startPoint2 = CGPointMake(120*num, 30*num);
    line3.endPoint1 = CGPointMake(120*num, 140*num);
    line3.endPoint2 = CGPointMake(120*num, 140*num);
    
    LineVO *line4 = [[LineVO alloc]init];
    line4.startPoint1 = CGPointMake(320, 130);
    line4.startPoint2 = CGPointMake(320, 130);
    line4.endPoint1 = CGPointMake(220, 130);
    line4.endPoint2 = CGPointMake(220, 130);
    
    
    return [NSArray arrayWithObjects:line1,line2,line3,line4, nil];
}
-(void)setup{
    self.lines = [self getLines:1];
    //self.lines = [NSArray arrayWithObjects:line1, nil];
    lineWidth = 5.0;
    lineColor = [UIColor redColor];
    fillColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
    //[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
}
-(void)handleTimer{
    self.lines = [self getLines:((double)arc4random() / 0x100000000)];
    
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    
    for (UIBezierPath *path in pathArray) {
        path.lineWidth = lineWidth;
        CGContextAddPath(context, path.CGPath);
    }
    CGContextDrawPath(context, kCGPathEOFillStroke);
}

-(void)handleTap:(UITapGestureRecognizer *)tap{
    CGPoint target = [tap locationInView:self];
    NSInteger index = -1;
    int counter = 0;
    for (UIBezierPath *path in pathArray) {
        if(CGPathContainsPoint(path.CGPath, &CGAffineTransformIdentity, target, NO)){
            index = counter;
            break;
        }
        counter++;
    }
    if (index != -1) {
        NSLog(@"line selected: %d",index);
        if ([self.target respondsToSelector:@selector(canvasView:lineSelectedAtIndex:)]) {
            [self.target canvasView:self lineSelectedAtIndex:index];
        }
    }
}

@end
