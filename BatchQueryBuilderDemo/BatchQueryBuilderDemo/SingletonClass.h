//
//  SingletonClass.h
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

#import <Foundation/Foundation.h>
@interface UITextField(myTextField) 
/*
 * Called when any text field is started editing.
 * Basically it adjusts the window center So that user can edit text field  when keyboad is shown. 
 */
-(void)adjustWindowWhenKeyboardAppears:(UIInterfaceOrientation)orientation;
-(void)resetWindowWhenKeboardDisappears;
@end
/*
 * UILabel category implementation used for showing tooltip for labels.
 * eg. currently used in CustomeGridView class.
 */
@interface UILabel(myLabel)

@end

@interface UIColor(myColor)

-(UIImage *)getImage;
@end

@interface UIView(ViewFrameExtension)

-(void)updateX:(CGFloat)x;
-(void)updateY:(CGFloat)y;
-(void)updateWidth:(CGFloat)width;
-(void)updateHeight:(CGFloat)height;

@end

@interface SingletonClass : NSObject
{
    NSArray *chartsList;
}
@property (strong) NSArray *chartsList;


/**
 * Called to get shared instance of this class. If not already exists, it creates one and returns that
 */
+ (id)sharedInstance;

/**
 * Called to get charts list for dynamic charts
 */
- (NSArray *) getChartsList;

/**
 * Called to get dictionary for a chart by chart type
 * Return value format: 
 * NSDictionary *chartOptionColumn = [NSDictionary dictionaryWithObjectsAndKeys:@"column", @"chartType", @"Column Chart", @"chartName", @"analytics.png", @"chartIconName", @"column-chart", @"chartURL", nil]; 
 */
- (NSDictionary *)getChartInfoForType:(NSString *)paramterChartType;

/**
 * Called to get charts details array for supplied chart types
 * 
 */
- (NSArray *)getChartsForTypes:(NSArray *)paramterChartTypes;

/**
 * Called to get currently displayed iPad window size height and width in points
 */
//- (CGSize) getWindowSize;

/**
 * Called to get main bundle path
 * Main bundle = bundle of the resources in the project eg, images, html, js files
 */
- (NSURL *)getBaseURL;

/**
 * Replace tokens in the html files with the actual JS object 
 */
- (NSString *)replaceToken:(NSString *)token withValue:(NSString *)value inStr:(NSString *)inputStr;

- (void)handlerError:(NSError *)error;
+ (NSString *)getHTMLString:(NSString*)msg isErrorMsg:(BOOL)isErrorMsg;
+ (void) setNavigationTitleFont: (UINavigationItem *) navItem navigationBarType:(NSInteger)navigationBarType ;

+ (NSString *)encodeString:(NSString *)str;
+ (NSString *)decodeString:(NSString *)str;
/*
 * It url encodes the string passed if not already encoded.
 */
+ (NSString *)encodeParameterValue:(NSString *)string;
+ (int)getFacetTypeIndex:(NSString *)facetType;
//return the string equivalent of the corresponding facet Type 
+(NSString *)getFacetTypeStringOfIndex:(int)facetIndex;
+ (NSString *)getEncodedConstraintLink:(NSString *)link;
/*
 * This will format value with maximumFractionDigits 2 and minimumIntegerDigits 1
 */
+ (NSString *)getFormatedStringFromValue:(id)value;
// Draw gradient for colors passed
+ (void) drawLinearGradient:(CGContextRef) context rect: (CGRect) rect startColor:(CGColorRef) startColor endColor:(CGColorRef)  endColor ;
// Draw gradient with glossy effect for colors passed
+ (void) drawGlossAndGradient:(CGContextRef) context rect:(CGRect) rect startColor:(CGColorRef) startColor endColor:(CGColorRef) endColor;

- (NSArray *) getTabSubmenuListForTabIndex:(NSInteger)tabIndex;
//URL Encode String. 
+ (NSString *)encodeString:(NSString *)string encoding:(NSStringEncoding)encoding;
//URL Decode String.
+ (NSString *)decodeString:(NSString *)string encoding:(NSStringEncoding)encoding;
@end
