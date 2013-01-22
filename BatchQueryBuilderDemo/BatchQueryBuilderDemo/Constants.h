//
//  Constants.h
//  Cetas Analytics
//
//  Copyright (c) 2011 - 2012 Cetas Software, Inc. All rights reserved.
//  This is Cetas proprietary and confidential material and its use
//  is subject to license terms.
//

/**
 * This class has all the constants used throughout the app
 */

#import <Foundation/Foundation.h>

extern BOOL const kEnableNewFeatures;
extern BOOL const kEnableChartMaximizer;
extern BOOL const kEnableNewTheme;

//annoucements related constants
extern NSString * const kItemElementName;
extern NSString * const kTitleElementName;
extern NSString * const kLinkElementName;
extern NSString * const kPubdateElementName;
extern NSString * const kDescriptionElementName;
extern NSString * const kAnnouncementsFeedURL;

//notification names for orientation changed, project changed, filter value removed, user logout
extern NSString * const kOrientationChanged;
extern NSString * const kProjectChanged;
extern NSString * const kFilterValueRemoved;
extern NSString * const kFilterActionTypeAdded;
extern NSString * const kFilterActionTypeRemoved;
extern NSString * const kFilterValueKeyName;
extern NSString * const kFilterValueActionTypeKeyName;
extern NSString * const kFilterKeyName;
extern NSString * const kUserDidLogout;
extern NSString * const kUserDidLogin;
extern NSString * const kAnalyticsDataLoaded;

//constants for keys returned in the response from the backend
extern NSString * const kCetasApiResponseKeySuccess;
extern NSString * const kCetasApiResponseKeyRCode;
extern NSString * const kCetasApiResponseKeyCCookie;
extern NSString * const kCetasApiResponseKeyTenantId;
extern NSString * const kCetasApiResponseKeyProjectId;
extern NSString * const kCetasApiResponseKeyAction ;
extern NSString * const kCetasApiResponseKeyError;
extern NSString * const kCetasApiResponseKeyUserInfoSearchURL;
extern NSString * const kCetasApiResponseKeyUserInfoDisplayName;
extern NSString * const kCetasApiResponseKeyUserInfoConfigURL;
extern NSString * const kCetasApiResponseKeyDefaultProjectName;

extern NSString * const kCetasApiResponseKeyData;
extern NSString * const kCetasApiResponseKeyBaseURL;
extern NSString * const kCetasApiResponseKeyMoreFacetsURL;
extern NSString * const kCetasApiResponseKeyMoreFacetValuesURL;
extern NSString * const kCetasApiResponseKeySetChartPositionURL;
extern NSString * const kCetasApiResponseKeyTimepivotURL;
extern NSString * const kCetasApiResponseKeyMultiDimensionalURL;
extern NSString * const kCetasApiResponseKeySetSelectedFacetsURL;
extern NSString * const kCetasApiResponseKeySetSelectedFacetValuesURL;
extern NSString * const kCetasApiResponseKeyGetEventsURL;
extern NSString * const kCetasApiResponseKeyFacets;

extern NSString * const kCetasApiResponseKeySources;
extern NSString * const kCetasApiResponseKeyID;
extern NSString * const kCetasApiResponseKeyDisplayName;
extern NSString * const kCetasApiResponseKeyValueCount;
extern NSString * const kCetasApiResponseKeyValues;
extern NSString * const kCetasApiResponseKeyCounts;
extern NSString * const kCetasApiResponseKeyLinks;
extern NSString * const kCetasApiResponseKeyMoreLink;
extern NSString * const kCetasApiResponseKeyIsRemove;
extern NSString * const kCetasApiResponseKeyDataType;
extern NSString * const kCetasApiResponseKeyAttrDataType;
extern NSString * const kCetasApiResponseKeyAttrDistribution;
extern NSString * const kCetasApiResponseKeyTotalCount;

extern NSString * const kCetasApiResponseKeyDateFields;
extern NSString * const kCetasApiResponseKeyMeasures;
extern NSString * const kCetasApiResponseKeyDimensions;
extern NSString * const kCetasApiResponseKeyCustomMeasures;
extern NSString * const kCetasApiResponseKeyConstraints;
extern NSString * const kCetasApiResponseKeyChartLocations;
extern NSString * const kCetasApiResponseKeyPos;
extern NSString * const kCetasApiResponseKeyAttrId;
extern NSString * const kCetasApiResponseKeyDisplay;
extern NSString * const kCetasApiResponseValueFalse;

extern NSString * const kCetasApiResponseKeyProjectApplicationKey;
extern NSString * const kCetasApiResponseKeyDataSourceProjectId;
extern NSString * const kCetasApiResponseKeyProjectDescription;
extern NSString * const kCetasApiResponseKeyProjectName;

//custom chart data response keys
extern NSString * const kCetasApiResponseKeyRdVersion;
extern NSString * const kCetasApiResponseKeyRdDimensions;
extern NSString * const kCetasApiResponseKeyRdDimType;
extern NSString * const kCetasApiResponseKeyRdMeasures;
extern NSString * const kCetasApiResponseKeyRdFunctions;
extern NSString * const kCetasApiResponseKeyRdFnFormats;
extern NSString * const kCetasApiResponseKeyRdData;
extern NSString * const kCetasApiResponseKeyRdValues;
extern NSString * const kCetasApiResponseKeyRdTimestamp;
extern NSString * const kCetasApiResponseKeyRdStartDate;
extern NSString * const kCetasApiResponseKeyRdEndDate;
extern NSString * const kCetasApiResponseKeyRdCustomChartInfo;
extern NSString * const kCetasApiResponseKeyRdScale;

extern NSString * const kCetasApiResponseValueTrue;

//constants for tokens replaced in the chart html files
extern NSString * const kTokenChartHeight;
extern NSString * const kTokenChartWidth;
extern NSString * const kTokenChartXAxisCategories;
extern NSString * const kTokenChartTitle;
extern NSString * const kTokenChartYAxisTitle;
extern NSString * const kTokenChartXAxisTitle;
extern NSString * const kTokenChartXAxis;
extern NSString * const kTokenChartYAxis;
extern NSString * const kTokenChartSeriesData;
extern NSString * const kTokenChartMarginRight;
extern NSString * const kTokenDimension2Title;
extern NSString * const kTokenIsMultiStackedChart;
extern NSString * const kTokenIsLegendEnabled;
extern NSString * const kTokenToolTip;
extern NSString * const kTokenChartMarkerEnabled;

//constants for actions passed to backend api calls
extern NSString * const kCetasApiActionTypeAuthentication;
extern NSString * const kCetasApiActionTypeListProjects;
extern NSString * const kCetasApiActionTypeQuery;
extern NSString * const kCetasApiActionTypeSetChartPosition;

extern NSString * const kDefaultSelectedChart;
extern NSString * const kChartTypeEmpty;
extern NSString * const kChartViewInfoKeyTagId ;
extern NSString * const kChartViewInfoKeyChartViewController;
extern NSString * const kFilterViewKeyCustomQuery ;
extern NSString * const kUserActionLoadMoreFacets;
extern NSString * const kUserActionLoadMoreValues;
extern NSString * const kUserActionCreateCustomMeasure;
extern NSString * const kUserActionDeleteCustomMeasure;
extern NSString * const kUserActionEditCustomMeasure;
extern NSString * const kCetasApiActionTypeGetMoreFacets;
extern NSString * const kCetasApiActionTypeGetMoreFacetsValues ;
extern NSString * const kCetasApiActionTypeSetSelectedFacets;
extern NSString * const kCetasApiActionTypeSetSelectedFacetsValues;
extern NSString * const kCetasApiActionTypeMultiFacet;
extern NSString * const kCetasApiActionTypeGetDerivedAttribute;
extern NSString * const kCetasApiActionTypeSaveDerivedAttribute;
extern NSString * const kCetasApiActionTypeDeleteAttribute;
extern NSString * const kCetasApiActionTypeSetAttributeDetails;
extern NSString * const kCetasApiActionTypeGetDataDiscoveryData;
extern NSString * const kCetasApiActionTypeAggregatedAnalytics;
extern NSString * const kCetasApiActionTypeAggregatesSaveDatasource;
extern NSString * const kCetasApiActionTypeAggregatesGetDatasource;
extern NSString * const kCetasApiActionTypeAggregatesDeleteDataSource;
extern NSString * const kCetasApiActionTypeDatasourceReprocessDatasource;
extern NSString * const kCetasApiActionTypeDatasourceListDataSource ;
extern NSString * const kCetasApiActionTypeAggregatedAnalyticsWithCubeId;
extern NSString * const kCetasApiAggregatedAnalyticsTypeSummary;
extern NSString * const kCetasApiAggregatedAnalyticsTypeUniques;

extern NSString * const kCetasApiActionTypeBatchQueryListInputTables;
extern NSString * const kCetasApiRequestParamBatchQueryRunModeAdd ;
extern NSString * const kCetasApiRequestParamBatchQueryRunModeEdit;
extern NSString * const kCetasApiRequestParamBatchQueryRunModeClone;
extern NSString * const kCetasApiActionTypeBatchQuerySaveDefinition;
extern NSString * const kCetasApiActionTypeBatchQuerySaveAndRunDefinition;

extern NSString * const kUserActionUserLogin;
extern NSString * const kUserActionProjectChanged;
extern NSString * const kUserActionKey;

//custom chart data key
extern NSString * const kCustomChartDataKeyData;
extern NSString * const kCustomChartDataKeyName;
extern NSString * const kCustomChartDataKeyCategories;
extern NSString * const kCustomChartDataKeySeries;
extern NSString * const kChartDataKeyChartTitle;
extern NSString * const kChartDataKeyXAxisTitle;
extern NSString * const kChartDataKeyXAxis;
extern NSString * const kChartDataKeyYAxis;
extern NSString * const kChartDataKeyYAxisTitle;
extern NSString * const kChartDataKeyMarginRight;
extern NSString * const kChartDataKeyDimension2Title;
extern NSString * const kChartDataKeyIsMultiStackedChart;
extern NSString * const kChartDataKeyIsLegendEnabled;
extern NSString * const kChartDataKeyTooltip;

//constants for Cetas backend API base urls
extern NSString * const kCetasAPIURL;
extern NSString * const kCetasBaseAPIURL;

//custom chart layouts
extern NSString * const kCustomGridViewLayoutGrid;
extern NSString * const kCustomGridViewLayoutChart;

// CustomGridView Data dict keys
extern NSString * const kGridViewDictKeycolumnTitle;
extern NSString * const kGridViewDictKeyDataArray;

//dashboard related constants
extern NSString * const kCetasApiResponseKeyDashboardDataObject;
extern NSString * const kCetasApiResponseKeyDashboardTable;
extern NSString * const kCetasApiResponseKeyDashboardTabAdj;
extern NSString * const kCetasApiResponseKeyReportTable;
extern NSString * const kCetasApiResponseKeyReportTabAdj;
extern NSString * const kCetasApiResponseKeyDashboardLayouts;
extern NSString * const kCetasApiResponseKeyReports;
extern NSString * const kCetasApiResponseKeyLayoutReports;
extern NSString * const kCetasApiResponseKeySelectedRow ;
extern NSString * const kCetasApiResponseKeyLayoutTitle;

//management related constants
extern NSString * const kCetasDataSourceTypeUpload;
extern NSString * const kCetasDataSourceTypeLiveFeed;
extern NSString * const kCetasDataSourceTypeAmazonS3;
extern NSString * const kCetasDataSourceTypeCetasBox;

//constants for report dictionary
extern NSString * const kCetasApiResponseKeyRVersion;
extern NSString * const kCetasApiResponseKeyRName;
extern NSString * const kCetasApiResponseKeyRDataType;
extern NSString * const kCetasApiResponseKeyRQuery;
extern NSString * const kCetasApiResponseKeyRTimeRange;
extern NSString * const kCetasApiResponseKeyRMeasures ;
extern NSString * const kCetasApiResponseKeyRDimensions;
extern NSString * const kCetasApiResponseKeyRShowFn;
extern NSString * const kCetasApiResponseKeyRLibrary;
extern NSString * const kCetasApiResponseKeyRType;
extern NSString * const kCetasApiResponseKeyRSubType;
extern NSString * const kCetasApiResponseKeyRHeader;
extern NSString * const kCetasApiResponseKeyRFooter;
extern NSString * const kCetasApiResponseKeyRData;
extern NSString * const kCetasApiResponseKeyRNum;
extern NSString * const kLayoutTypeHorizontal;
extern NSString * const kLayoutTypeVertical;
extern NSString * const kLayoutTypePanel;
//Constants for event view.
extern NSString * const kCetasApiResponseKeyEventData;
extern NSString * const kCetasApiResponseKeyMetaData;
extern NSString * const kCetasApiResponseKeyEvents;
extern NSString * const kCetasApiResponseKeyTotalEventsCount;
extern NSString * const kCetasApiResponseKeyEventsPerPage;
extern NSString * const kCetasApiResponseKeyCurrentPageNumber;
extern NSString * const kCetasApiResponseKeyEventDate ;
extern NSString * const kCetasApiResponseKeyEventFormat;
extern NSString * const kCetasApiResponseKeyEventSourceType;
extern NSString * const kCetasApiResponseKeyEventSource ;
extern NSString * const kCetasApiResponseKeyDetails;
extern NSString * const kCetasApiResponseKeyValue;
extern NSString * const kCetasApiResponseKeyLink;
extern NSString * const kCetasApiResponseKeyHighlight;

extern NSString * const kNSUserDefaultKeyUserEmail;
extern NSString * const kNSUserDefaultKeyAnalyticsBaseURL;
extern NSString * const kJSSeparatorToken ;
extern NSString * const kJSSeparatorStartToken;
extern NSString * const kJSSeparatorEndToken;


extern NSString * const kTokenCountsArray ;
extern NSString * const kTokenChartInfo ;
extern NSString * const kDiscoveryChartTypeLine;
extern NSString * const kDiscoveryChartTypeColumn;
extern NSString * const kDiscoveryChartSourceSchemaInformation;
extern NSString * const kDiscoveryChartSourceDataDiscovery;
extern NSString * const kDiscoveryRTypeSparkline;
extern NSString * const kDiscoveryRTypeSchemaInformation;

extern NSString * const kCetasAPIResponseDataVOTypeAnalytics;
extern NSString * const kCetasAPIResponseDataVOTypeAggregates;
extern NSString * const kValuesTableCellTypeSummaryDefinitions;
extern NSString * const kValuesTableCellTypeSummaryDefinitionDetail;
extern NSString * const kCetasAPIParamKeyAggregatedAnalyticsType;
extern NSString * const  kListTypeAggregatesTabSubmenu ;
// Constant for Data Discovery
extern NSString* kWidgetTypeChart;
extern NSString* kWidgetTypeTable;

extern NSString * const  kListTypeChart;
extern NSString * const  kListTypeFunction;
extern NSString * const  kListTypeTimeScale;
extern NSString * const  kListTypeAction;
extern NSString * const  kListTypeSubmenu;
extern NSString * const  kItemListItemDisplayNameKey;
extern NSString * const  kItemListItemNameKey;
extern NSString * const  kItemListItemIconImageKey;

#define kChartHeight 305
#define kChartWidth 382
#define kPaddingBetweenCharts 15
#define kPaddingBetweenModules 5
#define kDynamicChartModeIndex 0
#define kCustomChartModeIndex 1
#define kEventsViewModeIndex 2
#define kStartingTagIdForPortlet 50
#define kAspectRatioForDeviceDimensions 1.395
#define kTimePivotChartHeight 250
#define kFilterViewHeight 30
#define kRightColumnWidthInPortrait 513
#define kRightColumnWidthInLandscape 769
#define kRightColumnHeightInLandscape 645
#define kToolbarHeight 44
#define kAutoRefreshTime 30 //In seconds
#define kDefaultEventsViewPageNumber 0

//error codes
#define kErrorCodeInvalidSession -10001

//query constaint types
#define kAddQueryConstraint 1
#define kRemoveQueryConstraint 2
#define kSearchQueryConstraint 3
#define kQueryTypeDefault 4
#define kTPConstraint 5
#define kCustomQuery 6
#define kCTMConstraint 7
#define kSearchAttributeID 8
#define kSearchAttributeValue 9
#define kSearchMoreAttributeID 10
#define kSearchUnselectAttributeID 11

#define kFacetypeSources 1
#define kFacetypeDates 2
#define kFacetypeMeasures 3
#define kFacetypeDimensions 4
#define kFacetypeCustomMeasures 5

//Dashbord related array index
#define kDashboardTableIndexForDashboardName 2
#define kDashboardTableIndexForDashboardId 0
#define kReportTableIndexForReportName 2
#define kReportTableIndexForIsReportSelected 7
#define kRowSelectionStyle UITableViewCellSelectionStyleGray
#define kCustomChartDataMaxCountForMarker 3000

#define kAnalyticsTabBehavioralTabIndex 0
#define kAnalyticsTabAggregateTabIndex 1
#define kAnalyticsTabDataDiscoveryTabIndex 2
#define kAnalyticsTabClusteringTabIndex 3
#define kAnalyticsTabBatchQueryTabIndex 4

#define kIndexForAggregateSubmenuTypeSummaries 0
#define kIndexForAggregateSubmenuTypeUniques 1

#define kChartTypeCustomChart 1
#define kChartTypeMultiAxisChart 2
#define kChartTypeMultiAxisStackedChart 3
#define kChartTypePieChart 4

#define kNavigationBarTypePopover 1
#define kNavigationBarTypeFacets 2
#define kNavigationBarTypeItemList 3
#define kNavigationBarTypeDashboard 4

#define kChartTypePieChart 4
#define kCellTypeHeader 1
#define kCellTypeRowTypeOne 2
#define kCellTypeRowTypeTwo 3

@interface Constants : NSObject

+ (float) getGridViewHeaderTitleFontSize;
@end
