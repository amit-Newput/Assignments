//
//  canvasView.m
//  BatchQueryBuilderDemo
//
//  Created by Prateek Pradhan on 08/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import "CanvasView.h"
#import "BQBLineVO.h"

@interface CanvasView()
{
    NSArray *pathArray;
    CGFloat lineWidth;
    UIColor *lineColor;
    UIColor *fillColor;
    int selectedLineIndex;
    BOOL highlighted;
    CGFloat highlightedLineWidth;

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
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

-(CGFloat)highlightedLineWidth{
    static BOOL shouldInc = YES;
    
    if (highlightedLineWidth >= lineWidth*2)
        shouldInc = NO;
    if (highlightedLineWidth <= 4)
        shouldInc = YES;
    
    highlightedLineWidth = shouldInc ? highlightedLineWidth+2: highlightedLineWidth-2;
    return highlightedLineWidth;
}
-(void)setLines:(NSArray *)paramLines{
    lines  = paramLines;
    NSMutableArray *mutablePaths = [NSMutableArray array];
    for (BQBLineVO *line in self.lines) {
        CGPoint start = line.startPoint;
        CGPoint end = line.endPoint;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:start radius:lineWidth startAngle:0 endAngle:180*M_1_PI clockwise:YES];
        //UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = lineWidth;
        [path moveToPoint:start];
        CGPoint controlPoint1 = start;
        CGPoint controlPoint2 = end;
        CGFloat t = 50;
        
        BOOL isStartPointLeftAligned = CGPointEqualToPoint(start, line.startPoint1);
        BOOL isEndPointLeftAligned = CGPointEqualToPoint(end, line.endPoint1);
        
        if (isStartPointLeftAligned)
            controlPoint1.x = start.x - t;
        else
            controlPoint1.x = start.x + t;
        
        if (isEndPointLeftAligned)
            controlPoint2.x = end.x - t;
        else
            controlPoint2.x = end.x + t;
        
        
        [path addCurveToPoint:end controlPoint1:controlPoint1 controlPoint2:controlPoint2];
        [path addArcWithCenter:end radius:lineWidth startAngle:0 endAngle:180*M_1_PI clockwise:YES];
        [mutablePaths addObject:path];
    }
    pathArray = [NSArray arrayWithArray:mutablePaths];
    
    [self setNeedsDisplay];
}
-(NSArray *)lines{
    return lines;
}
-(NSArray *)getLines:(float)num{
    BQBLineVO *line1 = [[BQBLineVO alloc]init];
    line1.startPoint1 = CGPointMake(20*num, 30*num);
    line1.startPoint2 = CGPointMake(20*num, 30*num);
    line1.endPoint1 = CGPointMake(420*num, 440*num);
    line1.endPoint2 = CGPointMake(420*num, 440*num);
    
    BQBLineVO *line2 = [[BQBLineVO alloc]init];
    line2.startPoint1 = CGPointMake(100*num, 130*num);
    line2.startPoint2 = CGPointMake(130*num, 170*num);
    line2.endPoint1 = CGPointMake(140*num, 180*num);
    line2.endPoint2 = CGPointMake(150*num, 130*num);
    
    BQBLineVO *line3 = [[BQBLineVO alloc]init];
    line3.startPoint1 = CGPointMake(120*num, 30*num);
    line3.startPoint2 = CGPointMake(120*num, 30*num);
    line3.endPoint1 = CGPointMake(120*num, 140*num);
    line3.endPoint2 = CGPointMake(120*num, 140*num);
    
    BQBLineVO *line4 = [[BQBLineVO alloc]init];
    line4.startPoint1 = CGPointMake(320, 130);
    line4.startPoint2 = CGPointMake(320, 130);
    line4.endPoint1 = CGPointMake(220, 130);
    line4.endPoint2 = CGPointMake(220, 130);
    
    
    return [NSArray arrayWithObjects:line1,line2,line3,line4, nil];
}
-(void)setup{
    self.delegate = self;
    lineWidth = 5.0;
    lineColor = [UIColor redColor];
    fillColor = [UIColor clearColor];
    selectedLineIndex = -1;
    highlightedLineWidth = 0;
    highlighted = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
    //[NSTimer scheduledTimerWithTimeInterval:1.0/10.0 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
}
-(void)handleTimer{
    if (selectedLineIndex != -1 && selectedLineIndex < pathArray.count ) {
        UIBezierPath *path = [pathArray objectAtIndex:selectedLineIndex];
        [self setNeedsDisplayInRect:CGPathGetBoundingBox(path.CGPath)];
    }
    
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
        
    
    int counter = 0;
    for (UIBezierPath *path in pathArray) {
        
        BQBLineVO *lineVO = [lines objectAtIndex:counter];
        CGContextSetStrokeColorWithColor(context, lineVO.lineColor.CGColor);
         CGContextSetLineWidth(context, lineVO.lineWidth);
        CGContextAddPath(context, path.CGPath);
        counter++;
        CGContextDrawPath(context, kCGPathStroke);
    }
}

-(void)handleTap:(UITapGestureRecognizer *)tap{
    if([self.target respondsToSelector:@selector(handleTapOnCanvasView:)]){
        [self.target handleTapOnCanvasView:tap];
    }
    
    
    CGPoint target = [tap locationInView:self];
    NSInteger index = -1;
    int counter = 0;
  
    for (UIBezierPath *path in pathArray) {
        if([self containsPoint:target onPath:path inFillArea:NO]){
            
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
        /*if(self.deleteButton){
            [self.deleteButton removeFromSuperview];
            self.deleteButton =nil;
        }
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.deleteButton setTitle:@"X" forState:UIControlStateNormal];
        self.deleteButton.titleLabel.font =[UIFont boldSystemFontOfSize:15.0];
        self.deleteButton.frame = CGRectMake(target.x, target.y, 50, 50);
        [self.deleteButton addTarget:self action:@selector(deleteConnection:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.deleteButton];
        self.deleteButton.tag = index;
         */
        
        
       
    }
    
}
- (BOOL)containsPoint:(CGPoint)point onPath:(UIBezierPath*)path inFillArea:(BOOL)inFill
{
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPathRef cgPath = path.CGPath;
    BOOL    isHit = NO;
    
    // Determine the drawing mode to use. Default to
    // detecting hits on the stroked portion of the path.
    CGPathDrawingMode mode = kCGPathStroke;
    if (inFill)
    {
        // Look for hits in the fill area of the path instead.
        if (path.usesEvenOddFillRule)
            mode = kCGPathEOFill;
        else
            mode = kCGPathFill;
    }
    
    // Save the graphics state so that the path can be
    // removed later.
    CGContextSaveGState(context);
    CGContextAddPath(context, cgPath);
    
    // Do the hit detection.
    for (int i =1; i<=5; i++) {
        CGPoint t = CGPointMake(point.x, point.y+i);
        isHit = CGContextPathContainsPoint(context, t, mode);
        if (isHit) {
            break;
        }
        t = CGPointMake(point.x+i, point.y);
        isHit = CGContextPathContainsPoint(context, t, mode);
        if (isHit) {
            break;
        }
        t = CGPointMake(point.x-i, point.y);
        isHit = CGContextPathContainsPoint(context, t, mode);
        if (isHit) {
            break;
        }
        t = CGPointMake(point.x, point.y-i);
        isHit = CGContextPathContainsPoint(context, t, mode);
        if (isHit) {
            break;
        }
        
    }
    
    CGContextRestoreGState(context);
    CFRelease(context);
    return isHit;
}
-(void)deleteConnection:(UIButton *)button{
    
    if ([self.target respondsToSelector:@selector(canvasView:lineSelectedAtIndex:)]) {
        [self.target canvasView:self lineSelectedAtIndex:button.tag];
    }
    [button removeFromSuperview];

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self setNeedsDisplay];
}

@end
