//
//  ConnectionVO.m
//  BatchQueryBuilderDemo
//
//  Created by NewputMac04 on 09/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import "BQBConnectionVO.h"


@interface BQBConnectionVO()

{
    // Below four points stores the cell position before going out of table view
    CGPoint pSP1;
    CGPoint pSP2;
    CGPoint pEP1;
    CGPoint pEP2;
   
}

// Tableviews of two fields
@property (strong) UIView *superView1;
@property (strong) UIView *superView2;
// Navigation controllers having tableView
@property (strong) UIView *superSuperView1;
@property (strong) UIView *superSuperView2;

@end

@implementation BQBConnectionVO

-(BQBLineVO *) getLineVOForView: (UIView*)view{
    
    CGPoint startPoint1 = CGPointMake(self.cell1.frame.origin.x  ,self.cell1.frame.origin.y + (self.cell1.frame.size.height /2) );
    CGPoint startPoint2 = CGPointMake((self.cell1.frame.origin.x-1 + self.cell1.frame.size.width) ,(self.cell1.frame.origin.y + (self.cell1.frame.size.height)/2) );
    
    CGPoint endPoint1 = CGPointMake(self.cell2.frame.origin.x  ,(self.cell2.frame.origin.y + (self.cell2.frame.size.height) /2) );
    CGPoint endPoint2 = CGPointMake((self.cell2.frame.origin.x-1 + self.cell2.frame.size.width) ,(self.cell2.frame.origin.y + (self.cell2.frame.size.height) /2) );
      
    if (self.cell1.superview) {
        self.superView1 = self.cell1.superview;
        if (self.superView1) {
            self.superSuperView1 = self.superView1.superview;
        }
        pSP1 = startPoint1;
        pSP2 = startPoint2;
    }
    
    if (self.cell2.superview) {
        self.superView2 = self.cell2.superview;
        if (self.superView2) {
            self.superSuperView2 = self.superView2.superview;
        }
        pEP1 = endPoint1;
        pEP2 = endPoint2;
        
    }
    
    // Super view frame in coordinate system of given view
    CGRect fromView1TranslatedRect = [view convertRect:self.superView1.frame fromView:self.superSuperView1];
    startPoint1 = [view convertPoint:pSP1 fromView:self.superView1];
    startPoint2 = [view convertPoint:pSP2 fromView:self.superView1];
    if(startPoint1.y  <= fromView1TranslatedRect.origin.y ){
        
        startPoint1.y = fromView1TranslatedRect.origin.y-(self.cell1.frame.size.height/2);
        startPoint2.y = fromView1TranslatedRect.origin.y-(self.cell1.frame.size.height/2);
    }
    else if(startPoint1.y  >= (fromView1TranslatedRect.origin.y + fromView1TranslatedRect.size.height)){
        startPoint1.y = (fromView1TranslatedRect.origin.y + fromView1TranslatedRect.size.height);
        startPoint2.y = (fromView1TranslatedRect.origin.y + fromView1TranslatedRect.size.height);
    }
    
    
    CGRect fromView2TranslatedRect = [view convertRect:self.superView2.frame fromView:self.superSuperView2];
    endPoint1 = [view convertPoint:pEP1 fromView:self.superView2];
    endPoint2 = [view convertPoint:pEP2 fromView:self.superView2];
    // We are decreasing the endPoint y coordinate by 1 because y coordinate of startPoint and endPoint will be same and
    // will create closed path
    if(endPoint1.y  <= fromView2TranslatedRect.origin.y ){
        
        endPoint1.y = fromView2TranslatedRect.origin.y-(self.cell2.frame.size.height/2) -1;
        endPoint2.y = fromView2TranslatedRect.origin.y-(self.cell2.frame.size.height/2) -1;
    }
    else if(endPoint1.y  >= (fromView2TranslatedRect.origin.y + fromView2TranslatedRect.size.height)){
        endPoint1.y = (fromView2TranslatedRect.origin.y + fromView2TranslatedRect.size.height-1);
        endPoint2.y = (fromView2TranslatedRect.origin.y + fromView2TranslatedRect.size.height-1);
    }
    
    BQBLineVO *objLineVO = [[BQBLineVO alloc] initWithStartPoint1:startPoint1 startPoint2:startPoint2 endPoint1:endPoint1 endPoint2:endPoint2];
	objLineVO.lineColor = self.connectionLineColor;
    
    objLineVO.lineWidth = 5.0;
    if(self.isLineSelected){
        objLineVO.lineWidth = 10.0;
    }
    return objLineVO;
}

-(BOOL)isEqualToConnection:(BQBConnectionVO *)connection{
    
    // There are two fields Ids in self and two in connection. So total there will be four combinations. Below we
    // are checking those combinations.
    NSString * thisField1 = [self.fieldVO1.sourceVO.name stringByAppendingString:self.fieldVO1.fieldID];
    NSString * thisField2 = [self.fieldVO2.sourceVO.name stringByAppendingString:self.fieldVO2.fieldID];
    NSString * connField1 = [connection.fieldVO1.sourceVO.name stringByAppendingString:connection.fieldVO1.fieldID];
    NSString * connField2 = [connection.fieldVO2.sourceVO.name stringByAppendingString:connection.fieldVO2.fieldID];
    
    if(([thisField1 isEqualToString:connField1] && [thisField2 isEqualToString:connField2]) ||
       ([thisField1 isEqualToString:connField2] && [thisField2 isEqualToString:connField1]) ){
        return YES;
    }
    return NO;
}
-(BOOL)isTemporary{
    return self.fieldVO2 ? NO : YES;
}
@end
