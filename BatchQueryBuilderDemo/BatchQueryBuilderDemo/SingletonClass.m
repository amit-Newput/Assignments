//
//  SingletonClass.m
//  Cetas Analytics
//
//  Copyright (c) 2011 - 2012 Cetas Software, Inc. All rights reserved.
//  This is Cetas proprietary and confidential material and its use
//  is subject to license terms.
//

/**
 * Aim of this class is to provide APIs that can be called by getting sharedInstance of this class from any other class/controller in the app. This class wraps some of the common APIs at the app level.
 * Only one object of this class is created, i.e. singleton instance. Anyone wants to use APIs from this class can just get shared instance and call methods of this class.
 * Usage: [SingletonClass sharedInstance]
 */

#import "SingletonClass.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"

@implementation UITextField(myTextField)
/*
 * Called when any text field is started editing.
 * Basically it adjusts the window center So that user can edit text field  when keyboad is shown. 
 */

-(void)adjustWindowWhenKeyboardAppears:(UIInterfaceOrientation)orientation
{
    CGFloat newWindowCenterX = self.window.center.x;
    CGFloat newWindowCenterY = self.window.center.y;
    
    CGPoint textFieldCenterInWindow =  [self.superview convertPoint:self.center toView:self.window];
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        int diff = (1024 - 264);
        
        if(orientation == UIInterfaceOrientationPortrait){
            textFieldCenterInWindow.y += (self.frame.size.height/2);
            if (diff < textFieldCenterInWindow.y) {
                newWindowCenterY = (self.window.center.y - (textFieldCenterInWindow.y - diff));
            }
            
        }else{
            textFieldCenterInWindow.y = 1024 - textFieldCenterInWindow.y;
            textFieldCenterInWindow.y += (self.frame.size.height/2);
            if (diff < textFieldCenterInWindow.y) {
                newWindowCenterY = (self.window.center.y + (textFieldCenterInWindow.y - diff));
            }
        }            
        
    }else{
        
        int diff = (768 - 352);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            textFieldCenterInWindow.x +=(self.frame.size.height/2);
            if (textFieldCenterInWindow.x > diff) {
                newWindowCenterX = self.window.center.x -(textFieldCenterInWindow.x -diff);
                
            }
            
        }else{
            textFieldCenterInWindow.x = 768 - textFieldCenterInWindow.x;
            textFieldCenterInWindow.x +=(self.frame.size.height/2);
            if (textFieldCenterInWindow.x > diff) {
                newWindowCenterX = self.window.center.x +(textFieldCenterInWindow.x -diff);
            }
        }
        
    }
    [UIView beginAnimations:nil context:nil];
    self.window.center = CGPointMake(newWindowCenterX, newWindowCenterY);
    [UIView commitAnimations];
}
-(void)resetWindowWhenKeboardDisappears
{
    [UIView beginAnimations:nil context:nil];
//    CGSize windowSize = [[SingletonClass sharedInstance] getWindowSize];
//    self.window.center  = CGPointMake(windowSize.width/2.0, windowSize.height/2.0);
    [UIView commitAnimations];
}

@end

/*
 * UILabel category implementation used for showing tooltip for labels.
 * eg. currently used in CustomeGridView class.
 */
@implementation UILabel(myLabel)
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if(![NSStringFromClass([self class]) isEqualToString:@"UILabel"]){
        // We don't need tooltip for other then UILabel.
        return;
    }
    CGSize textSize = [self.text sizeWithFont:self.font];
    if (self.frame.size.width < textSize.width) {
        
        UIFont *font = [UIFont boldSystemFontOfSize:15.0];
        CGSize toolTipSize = [self.text sizeWithFont:font];
        UILabel *toolTip = nil;
        if (self.frame.origin.x < toolTipSize.width) {
            toolTip = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width,2, toolTipSize.width+10, self.frame.size.height-10)];
        }else{
            toolTip = [[UILabel alloc]initWithFrame:CGRectMake(-toolTipSize.width,2, toolTipSize.width+10, self.frame.size.height-10)];
        }
        
        toolTip.text = [NSString stringWithFormat:@" %@",self.text];
        
        
        toolTip.font = font;
        toolTip.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
        toolTip.textColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
        [toolTip.layer setCornerRadius:3];
        [self addSubview:toolTip];
        [self.superview bringSubviewToFront:self];
    }
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGSize textSize = [self.text sizeWithFont:self.font];
    if (self.frame.size.width < textSize.width) {
        [[self.subviews objectAtIndex:0] removeFromSuperview];
    }
    [super touchesEnded:touches withEvent:event];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGSize textSize = [self.text sizeWithFont:self.font];
    if (self.frame.size.width < textSize.width) {
        if (self.subviews.count) {
            [[self.subviews objectAtIndex:0] removeFromSuperview];
        }
        
    }
    [super touchesCancelled:touches withEvent:event];
    
}

@end

@implementation UIColor(myColor)

-(UIImage *)getImage{
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [self CGColor]);
    
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
    
}

@end

@implementation UIView(ViewFrameExtension)

-(void)updateX:(CGFloat )x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(void)updateY:(CGFloat )y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(void)updateWidth:(CGFloat )width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

-(void)updateHeight:(CGFloat )height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


@end

@implementation SingletonClass

@synthesize chartsList;



static SingletonClass *sharedInstance = nil;

/**
 * Called to get shared instance of this class. If not already exists, it creates one and returns that
 */
+ (SingletonClass *)sharedInstance 
{
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

//default initializer
- (id)init
{
    self = [super init];
    
    if (self) {
        // Work your initialising magic here as you normally would
        [self getChartsList];
    }
    
    return self;
}

/**
 * Called to get charts list for dynamic charts
 */
- (NSArray *) getChartsList
{
    if (self.chartsList == nil) {
        NSDictionary *chartOptionColumn = [NSDictionary dictionaryWithObjectsAndKeys:@"column", @"chartType", @"Column Chart", @"chartName", @"analytics.png", @"chartIconName", @"column-chart", @"chartURL", nil];
        NSDictionary *chartOptionPie = [NSDictionary dictionaryWithObjectsAndKeys:@"pie", @"chartType", @"Pie Chart", @"chartName", @"piechart.png", @"chartIconName", @"pie-chart", @"chartURL", nil];
        NSDictionary *chartOptionBar = [NSDictionary dictionaryWithObjectsAndKeys:@"bar", @"chartType", @"Bar Chart", @"chartName", @"barchart.png", @"chartIconName", @"bar-stacked", @"chartURL", nil];
        NSDictionary *chartOptionLine = [NSDictionary dictionaryWithObjectsAndKeys:@"line", @"chartType", @"Line Chart", @"chartName", @"line-chart.png", @"chartIconName", @"line-chart", @"chartURL", nil];
        NSDictionary *chartOptionFunnel = [NSDictionary dictionaryWithObjectsAndKeys:@"funnel", @"chartType", @"Funnel Chart", @"chartName", @"funnel.png", @"chartIconName", @"funnel-chart", @"chartURL", nil];
        NSDictionary *chartOptionSpLine = [NSDictionary dictionaryWithObjectsAndKeys:@"spline", @"chartType", @"Spline Chart", @"chartName", @"line-chart.png", @"chartIconName", @"spline-chart", @"chartURL", nil];
        NSDictionary *chartOptionSplineArea = [NSDictionary dictionaryWithObjectsAndKeys:@"areaspline", @"chartType", @"Area Spline Chart", @"chartName", @"line-chart.png", @"chartIconName", @"area-spline-chart", @"chartURL", nil];
        NSDictionary *chartOptionTable = [NSDictionary dictionaryWithObjectsAndKeys:@"table", @"chartType", @"Table", @"chartName", @"funnel.png", @"chartIconName", @"table", @"chartURL", nil];
        chartsList = [NSArray arrayWithObjects:chartOptionColumn, chartOptionPie, chartOptionBar, chartOptionLine, chartOptionFunnel,chartOptionSpLine,chartOptionSplineArea, chartOptionTable, nil];
    }
    return chartsList;    
    
}
- (NSArray *) getTabSubmenuListForTabIndex:(NSInteger)tabIndex{
    
    NSMutableArray *submenus = [[NSMutableArray alloc] init];
    if(tabIndex == kAnalyticsTabAggregateTabIndex){
        NSDictionary *itemDict = [[NSDictionary alloc]initWithObjectsAndKeys:kCetasApiAggregatedAnalyticsTypeSummary,kItemListItemNameKey,@"Summaries",kItemListItemDisplayNameKey,@"summaries.png",kItemListItemIconImageKey, nil];
        NSDictionary *itemDict1 = [[NSDictionary alloc]initWithObjectsAndKeys:kCetasApiAggregatedAnalyticsTypeUniques,kItemListItemNameKey,@"Uniques",kItemListItemDisplayNameKey,@"uniques.png",kItemListItemIconImageKey, nil];
        [submenus addObject:itemDict];
        [submenus addObject:itemDict1];
    }else{
        submenus = nil;
    }
    return submenus;
}
/**
 * Called to get dictionary for a chart by chart type
 * Return value format: 
 * NSDictionary *chartOptionColumn = [NSDictionary dictionaryWithObjectsAndKeys:@"column", @"chartType", @"Column Chart", @"chartName", @"analytics.png", @"chartIconName", @"column-chart", @"chartURL", nil]; 
 */
- (NSDictionary *)getChartInfoForType:(NSString *)paramterChartType
{
    NSDictionary *chartInfo = nil;
    if ([self.chartsList count]) {
        for (NSDictionary *chartInfoDic in self.chartsList) {
            if ([[chartInfoDic objectForKey:@"chartType"] isEqualToString:paramterChartType]) {
                chartInfo = chartInfoDic;
                break;
            }
        }
    }
    return chartInfo;
}

- (NSArray *)getChartsForTypes:(NSArray *)paramterChartTypes
{
    NSMutableArray *chartsInfo = nil;
    if (paramterChartTypes == nil) {
        return chartsInfo;
    }
    chartsInfo = [[NSMutableArray alloc] initWithCapacity:[paramterChartTypes count]];
    for (NSString *chartType in paramterChartTypes) {
        [chartsInfo addObject:[self getChartInfoForType:chartType]];
    }
    
    return chartsInfo;
}


/**
 * Called to get currently displayed iPad window size height and width in points
 */
//-(CGSize) getWindowSize
//{
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    UIWindow *window = delegate.window;
//    CGSize size = CGSizeMake(window.frame.size.width ,window.frame.size.height);
//    return size;
//}

/**
 * Called to get main bundle path
 * Main bundle = bundle of the resources in the project eg, images, html, js files
 */
- (NSURL *)getBaseURL
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    return baseURL;
}

/**
 * Replace tokens in the html files with the actual JS object 
 */
- (NSString *)replaceToken:(NSString *)token withValue:(NSString *)value inStr:(NSString *)inputStr
{
    NSString *str = nil;
    if (value == nil) {
        value = @"''"; //replace token with empty string
    }
    if (value != nil) {
        str = [inputStr stringByReplacingOccurrencesOfString:token withString:value];
    } else {
        str = inputStr; //TODO: may be do something better
    }
    
    return str;
}

-(void)handlerError:(NSError *)error
{
    
    if (error.code == -1009) {
        NSString *errorMsg = [error localizedDescription];
        static UIAlertView *alertView = nil;
        if (!alertView) {
            alertView = [[UIAlertView alloc]init];
            [alertView addButtonWithTitle:@"OK"];
        }
        alertView.title = @"Error";
        alertView.message = errorMsg;
        alertView.delegate = nil; 
        [alertView show]; 
        
    }
    if (error.code >=500 && error.code < 600) {
        NSString *errorMsg = @"Server error";
        static UIAlertView *alertView = nil;
        if (!alertView) {
            alertView = [[UIAlertView alloc]init];
            [alertView addButtonWithTitle:@"OK"];
        }
        alertView.title = @"Error";
        alertView.message = errorMsg;
        alertView.delegate = nil; 
        [alertView show]; 
    }

}
+ (NSString *)getHTMLString:(NSString*)msg isErrorMsg:(BOOL)isErrorMsg{
    
    NSString *htmlStr = [NSString stringWithFormat:@"<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.1//EN' 'xhtml11.dtd'><html><head></head><body><div style='font-family:Lucida Grande,arial,helvetica;;color:#666;padding:20px;margin:20px;text-align:center;border:2px dashed green;height:100%%'><h2>%@</h2></div></body></html>",msg];
    if (isErrorMsg) {
        htmlStr =[NSString stringWithFormat:@"<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.1//EN' 'xhtml11.dtd'><html><head></head><body><div style='font-family:Lucida Grande,arial,helvetica;;color:#666;padding:20px;margin:20px;text-align:center;border:2px dashed green;height:100%%'>%@</div></body></html>",msg];
    }
    return htmlStr;
}
+ (void) setNavigationTitleFont: (UINavigationItem *) navItem navigationBarType:(NSInteger)navigationBarType {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = UITextAlignmentCenter;
    label.text = navItem.title;
   

    switch (navigationBarType) {
        case kNavigationBarTypeFacets:{
            label.textColor =[UIColor whiteColor];
            label.font = [UIFont boldSystemFontOfSize:13.0];
        }
        break;
        case kNavigationBarTypePopover:{
            label.font = [UIFont boldSystemFontOfSize:15.0];
            //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
            label.textColor =[UIColor darkGrayColor];
        }
        break;
        case kNavigationBarTypeItemList:{
            label.textColor =[UIColor whiteColor];
            label.font = [UIFont boldSystemFontOfSize:15.0];
        }
        break;
        case kNavigationBarTypeDashboard:{
            label.textColor =[UIColor whiteColor];
            label.font = [UIFont boldSystemFontOfSize:16.0];
        }
        break;
        default:
            break;
    }
    navItem.titleView = label;
    [navItem.titleView sizeToFit];

}


+(NSString *)encodeString:(NSString *)str{
    
    NSString *encodedStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (!encodedStr) {
        encodedStr = str;
    }
    return encodedStr;
}

+(NSString *)decodeString:(NSString *)str{
    
    NSString *decodedStr = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (!decodedStr) {
        decodedStr = str;
    }
    return decodedStr;
}

/*
 * It url encodes the string passed if not already encoded.
 */
+ (NSString *)encodeParameterValue:(NSString *)string
{
    if([string rangeOfString:@"%25"].location !=NSNotFound || [string rangeOfString:@"%26"].location !=NSNotFound || [string rangeOfString:@"%3D"].location !=NSNotFound ){
        //It means string it already encoded.
        return  string;
    }
    CFStringRef encodedStrRef = CFURLCreateStringByAddingPercentEscapes(
                                                                        NULL, /* allocator */
                                                                        (__bridge CFStringRef)string,
                                                                        NULL,
                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                        kCFStringEncodingUTF8);
    NSString *encodedStr = [NSString stringWithString:(__bridge NSString*)encodedStrRef];
    CFRelease(encodedStrRef);
    return encodedStr;
}

+(int)getFacetTypeIndex:(NSString *)facetType
{
    
    NSDictionary *facetTypes = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [NSNumber numberWithInteger:kFacetypeSources],kCetasApiResponseKeySources,
                                [NSNumber numberWithInteger:kFacetypeDates],kCetasApiResponseKeyDateFields,
                                [NSNumber numberWithInteger:kFacetypeMeasures],kCetasApiResponseKeyMeasures,
                                [NSNumber numberWithInteger:kFacetypeDimensions],kCetasApiResponseKeyDimensions,
                                [NSNumber numberWithInteger:kFacetypeCustomMeasures],kCetasApiResponseKeyCustomMeasures,
                                nil];
    int facetTypeIndex = [[facetTypes objectForKey:facetType] intValue];
    return facetTypeIndex;

}
//return the string equivalent of the corresponding facet Type 
+(NSString *)getFacetTypeStringOfIndex:(int)facetIndex
{
    NSString * facetTypeString = nil;
    switch (facetIndex) {
        case kFacetypeSources:
        {
            facetTypeString = kCetasApiResponseKeySources;
            break;
        }
        case kFacetypeDates:
        {
            facetTypeString = kCetasApiResponseKeyDateFields;
            break;
        }
        case kFacetypeMeasures:
        {
            facetTypeString = kCetasApiResponseKeyMeasures;
            break;
        }
        case kFacetypeDimensions:
        {
            facetTypeString = kCetasApiResponseKeyDimensions;
            break;
        }
        case kFacetypeCustomMeasures:
        {
            facetTypeString = kCetasApiResponseKeyCustomMeasures;
            break;
        }
    }
    return facetTypeString;
    
}

+(NSString *)getEncodedConstraintLink:(NSString *)link{
    
    NSRange keyRange = [link rangeOfString:@"="];
    // We get value link without url encoding .It causes error(bad url) when filter is applied if there are some special character in link. So we need to url encode them.
    if(keyRange.location != NSNotFound && keyRange.length){
        NSString *value = [link substringFromIndex:keyRange.location+1];
        NSString *key = [link substringToIndex:keyRange.location+1];
        value =[SingletonClass encodeParameterValue:value];
        link = [key stringByAppendingString:value];
    }
    return link;
}
/*
 * This will format value with maximumFractionDigits 2 and minimumIntegerDigits 1
 */

+(NSString *)getFormatedStringFromValue:(id)value{
    
    NSString *returnValue = [NSString stringWithFormat:@"%@",value];
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc]init];
    NSNumber *num = [numFormatter numberFromString:[value description]];
    if (num) {
        [numFormatter setMinimumIntegerDigits:1];
        [numFormatter setMaximumFractionDigits:2];
        [numFormatter setRoundingMode:NSNumberFormatterRoundCeiling];
        returnValue = [numFormatter stringFromNumber:num];
    }
    
    return returnValue;
}
// Draw gradient for colors passed
+ (void) drawLinearGradient:(CGContextRef) context rect: (CGRect) rect startColor:(CGColorRef) startColor endColor:(CGColorRef)  endColor {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColor, (__bridge id)endColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}
// Draw gradient with glossy effect for colors passed
+ (void) drawGlossAndGradient:(CGContextRef) context rect:(CGRect) rect startColor:(CGColorRef) startColor endColor:(CGColorRef) endColor{
    
    [SingletonClass drawLinearGradient:context rect:rect startColor:startColor endColor:endColor];

    CGColorRef glossColor1 = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.35].CGColor;
    CGColorRef glossColor2 = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1].CGColor;
    
    CGRect topHalf = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height/2);
    [SingletonClass drawLinearGradient:context rect:topHalf startColor:glossColor1 endColor:glossColor2];
}
/*
 * Utility Method to get URL Encoded String
 */
+ (NSString *)encodeString:(NSString *)string encoding:(NSStringEncoding)encoding
{
    CFStringRef encodedStrRef = CFURLCreateStringByAddingPercentEscapes(
                                                                        NULL, /* allocator */
                                                                        (__bridge CFStringRef)string,
                                                                        NULL,
                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                        encoding);
    NSString *encodedStr = [NSString stringWithString:(__bridge NSString*)encodedStrRef];
    CFRelease(encodedStrRef);
    return encodedStr;
}
/*
 * Utility Method to get URL Decoded String
 */
+ (NSString *)decodeString:(NSString *)string encoding:(NSStringEncoding)encoding
{
    
    
    string = [string
              stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    return [SingletonClass decodeString:string];
    
}
@end
