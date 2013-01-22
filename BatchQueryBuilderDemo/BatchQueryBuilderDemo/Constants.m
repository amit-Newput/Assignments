//
//  Constants.m
//  Cetas Analytics
//
//  Copyright (c) 2011 - 2012 Cetas Software, Inc. All rights reserved.
//  This is Cetas proprietary and confidential material and its use
//  is subject to license terms.
//

/**
 * This class has all the constants used throughout the app
 */

#import "Constants.h"

BOOL const kEnableNewFeatures = YES;
BOOL const kEnableChartMaximizer = NO;
BOOL const kEnableNewTheme = NO;

//annoucements related constants
NSString * const kItemElementName = @"item";
NSString * const kTitleElementName = @"title";
NSString * const kLinkElementName = @"link";
NSString * const kPubdateElementName = @"pubDate";
NSString * const kDescriptionElementName = @"description";
NSString * const kAnnouncementsFeedURL = @"http://cetasserviceannouncements.wordpress.com/feed";

//notification names for orientation changed, project changed, filter value removed, user logout
NSString * const kOrientationChanged = @"orientationChanged";
NSString * const kProjectChanged = @"projectChanged";
NSString * const kFilterValueRemoved = @"filterValueRemoved";
NSString * const kFilterActionTypeAdded = @"filterActionTypeAdded";
NSString * const kFilterActionTypeRemoved = @"filterActionTypeRemoved";
NSString * const kFilterValueKeyName = @"filterValueKeyName";
NSString * const kFilterValueActionTypeKeyName = @"filterValueActionTypeKeyName";
NSString * const kFilterKeyName = @"filterKeyName";
NSString * const kUserDidLogout = @"userDidLogout";
NSString * const kUserDidLogin = @"userDidLogin";
NSString * const kAnalyticsDataLoaded = @"AnalyticsDataLoaded";

//constants for keys returned in the response from the backend
NSString * const kCetasApiResponseKeySuccess = @"success";
NSString * const kCetasApiResponseKeyRCode = @"rcode";
NSString * const kCetasApiResponseKeyCCookie = @"CCOOKIE";
NSString * const kCetasApiResponseKeyTenantId = @"registration.tenantid";
NSString * const kCetasApiResponseKeyProjectId = @"datasource.projectid";
NSString * const kCetasApiResponseKeyAction = @"action";
NSString * const kCetasApiResponseKeyError = @"error";

NSString * const kCetasApiResponseKeyUserInfoSearchURL = @"userinformation.search_url";
NSString * const kCetasApiResponseKeyUserInfoDisplayName = @"userinformation.displayname";
NSString * const kCetasApiResponseKeyUserInfoConfigURL = @"userinformation.config_url";
NSString * const kCetasApiResponseKeyDefaultProjectName = @"datasource.projectname";

NSString * const kCetasApiResponseKeyBaseURL = @"base_url";
NSString * const kCetasApiResponseKeyMoreFacetsURL = @"more_facets_url";
NSString * const kCetasApiResponseKeyMoreFacetValuesURL = @"more_facet_values_url";
NSString * const kCetasApiResponseKeySetChartPositionURL = @"setchartposition_url";
NSString * const kCetasApiResponseKeyTimepivotURL = @"timepivot_url";
NSString * const kCetasApiResponseKeyMultiDimensionalURL = @"multidimensional_url";
NSString * const kCetasApiResponseKeySetSelectedFacetsURL = @"setselectedfacets_url";
NSString * const kCetasApiResponseKeySetSelectedFacetValuesURL = @"setselectedfacetvalues_url";
NSString * const kCetasApiResponseKeyGetEventsURL = @"getevents_url";
NSString * const kCetasApiResponseKeyFacets = @"facets";

NSString * const kCetasApiResponseKeySources = @"Sources";
NSString * const kCetasApiResponseKeyID = @"id";
NSString * const kCetasApiResponseKeyDisplayName = @"display-name";
NSString * const kCetasApiResponseKeyValueCount = @"value-count";
NSString * const kCetasApiResponseKeyValues= @"values";
NSString * const kCetasApiResponseKeyCounts = @"counts";
NSString * const kCetasApiResponseKeyLinks = @"links";
NSString * const kCetasApiResponseKeyMoreLink = @"more-link";
NSString * const kCetasApiResponseKeyIsRemove= @"isRemove";
NSString * const kCetasApiResponseKeyDataType = @"data-type";
NSString * const kCetasApiResponseKeyAttrDataType = @"attr-data-types";
NSString * const kCetasApiResponseKeyAttrDistribution = @"attribute-distribution";
NSString * const kCetasApiResponseKeyTotalCount = @"total-count";

NSString * const kCetasApiResponseKeyDateFields = @"Date Fields";
NSString * const kCetasApiResponseKeyMeasures = @"Measures";
NSString * const kCetasApiResponseKeyDimensions = @"Dimensions";
NSString * const kCetasApiResponseKeyConstraints = @"constraints";
NSString * const kCetasApiResponseKeyCustomMeasures = @"CustomMeasures";

NSString * const kCetasApiResponseKeyChartLocations= @"chart-locations";
NSString * const kCetasApiResponseKeyPos= @"pos";
NSString * const kCetasApiResponseKeyAttrId= @"attr-id";
NSString * const kCetasApiResponseKeyDisplay= @"display";
NSString * const kCetasApiResponseKeyData = @"data";

NSString * const kCetasApiResponseKeyProjectApplicationKey = @"project_application_key";
NSString * const kCetasApiResponseKeyDataSourceProjectId = @"datasource_projectid";
NSString * const kCetasApiResponseKeyProjectDescription = @"datasource_projectdescription";
NSString * const kCetasApiResponseKeyProjectName = @"datasource_projectname";

//constants for custom chart data response keys
NSString * const kCetasApiResponseKeyRdVersion = @"rdVersion";
NSString * const kCetasApiResponseKeyRdDimensions = @"rdDimensions";
NSString * const kCetasApiResponseKeyRdDimType = @"rdDimType";
NSString * const kCetasApiResponseKeyRdMeasures = @"rdMeasures";
NSString * const kCetasApiResponseKeyRdFunctions = @"rdFunctions";
NSString * const kCetasApiResponseKeyRdFnFormats = @"rdFnFormats";
NSString * const kCetasApiResponseKeyRdData = @"rdData";
NSString * const kCetasApiResponseKeyRdValues = @"rdValues";
NSString * const kCetasApiResponseKeyRdTimestamp = @"rdTimestamp";
NSString * const kCetasApiResponseKeyRdStartDate = @"rdStartDate";
NSString * const kCetasApiResponseKeyRdEndDate = @"rdEndDate";
NSString * const kCetasApiResponseKeyRdCustomChartInfo = @"rdCustomChartInfo";
NSString * const kCetasApiResponseKeyRdScale = @"rdScale";

NSString * const kCetasApiResponseValueTrue = @"true";
NSString * const kCetasApiResponseValueFalse = @"false";

//constants for tokens replaced in the chart html files
NSString * const kTokenChartHeight = @"%%CHART-HEIGHT%%";
NSString * const kTokenChartWidth = @"%%CHART-WIDTH%%";
NSString * const kTokenChartXAxisCategories = @"%%X-AXIS-CATEGORIES%%";
NSString * const kTokenChartTitle = @"%%CHART-TITLE%%";
NSString * const kTokenChartYAxisTitle = @"%%Y-AXIS-TITLE%%";
NSString * const kTokenChartXAxisTitle = @"%%X-AXIS-TITLE%%";
NSString * const kTokenChartXAxis = @"%%X-AXIS%%";
NSString * const kTokenChartYAxis = @"%%Y-AXIS%%";
NSString * const kTokenChartSeriesData = @"%%SERIES-DATA%%";
NSString * const kTokenChartMarginRight = @"%%MARGIN-RIGHT%%";
NSString * const kTokenDimension2Title = @"%%DIMENSION2-TITLE%%";
NSString * const kTokenIsMultiStackedChart = @"%%IS-MULTI-STACKED-CHART%%";
NSString * const kTokenIsLegendEnabled = @"%%IS-LEGEND-ENABLED%%";
NSString * const kTokenToolTip = @"%%TOOL-TIP%%";
NSString * const kTokenChartMarkerEnabled = @"%%MARKER-ENABLED%%";

//constants for actions passed to backend api calls
NSString * const kCetasApiActionTypeAuthentication = @"authentication.authenticate";
NSString * const kCetasApiActionTypeListProjects = @"datasource.list_projects";
NSString * const kCetasApiActionTypeQuery = @"SEARCHANALYTICS.QUERY";
NSString * const kCetasApiActionTypeSetChartPosition = @"SEARCHANALYTICS.SET_CHART_POSITION";
NSString * const kCetasApiActionTypeGetMoreFacets = @"SEARCHANALYTICS.GET_MORE_FACETS";
NSString * const kCetasApiActionTypeGetMoreFacetsValues = @"SEARCHANALYTICS.GET_MORE_FACET_VALUES";
NSString * const kCetasApiActionTypeSetSelectedFacets = @"SEARCHANALYTICS.SET_SELECTED_FACETS";
NSString * const kCetasApiActionTypeSetSelectedFacetsValues = @"SEARCHANALYTICS.SET_SELECTED_FACET_VALUES";
NSString * const kCetasApiActionTypeMultiFacet = @"SERVICE.MULTIFACET";
NSString * const kCetasApiActionTypeGetDerivedAttribute = @"schema.get_derived_attribute";
NSString * const kCetasApiActionTypeDeleteAttribute = @"schema.delete_attribute";
NSString * const kCetasApiActionTypeSaveDerivedAttribute = @"schema.derived_attribute";
NSString * const kCetasApiActionTypeSetAttributeDetails = @"schema.set_attribute_details";
NSString * const kCetasApiActionTypeGetDataDiscoveryData = @"service.data_discovery";
NSString * const kCetasApiActionTypeAggregatedAnalytics = @"aggregatedanalytics.query";
NSString * const kCetasApiActionTypeAggregatedAnalyticsWithCubeId = @"aggregatedanalytics.query_with_cube_id";
NSString * const kCetasApiAggregatedAnalyticsTypeSummary = @"SUMMARY";
NSString * const kCetasApiAggregatedAnalyticsTypeUniques = @"UNIQUES";

NSString * const kCetasApiActionTypeAggregatesSaveDatasource = @"aggregates.save_datasource";
NSString * const kCetasApiActionTypeAggregatesGetDatasource = @"aggregates.get_datasource";
NSString * const kCetasApiActionTypeAggregatesDeleteDataSource = @"aggregates.delete_datasource";
NSString * const kCetasApiActionTypeDatasourceReprocessDatasource = @"datasource.reprocess_datasource";
NSString * const kCetasApiActionTypeDatasourceListDataSource = @"datasource.list_datasources";

NSString * const kCetasApiActionTypeBatchQueryListInputTables = @"batchanalytics.list_input_tables";
NSString * const kCetasApiRequestParamBatchQueryRunModeAdd = @"ADD";
NSString * const kCetasApiRequestParamBatchQueryRunModeEdit = @"EDIT";
NSString * const kCetasApiRequestParamBatchQueryRunModeClone = @"CLONE";
NSString * const kCetasApiActionTypeBatchQuerySaveDefinition = @"batchanalytics.save_definition";
NSString * const kCetasApiActionTypeBatchQuerySaveAndRunDefinition = @"batchanalytics.save_and_run_definition";

NSString * const kDefaultSelectedChart = @"column";
NSString * const kChartTypeEmpty = @"empty";
NSString * const kChartViewInfoKeyTagId = @"tagId";
NSString * const kChartViewInfoKeyChartViewController = @"chartViewController";

NSString * const kFilterViewKeyCustomQuery = @"Query";
NSString * const kUserActionLoadMoreFacets = @"Load More Facets";
NSString * const kUserActionLoadMoreValues = @"Load More Values";
NSString * const kUserActionCreateCustomMeasure = @"Create Custom Measure";
NSString * const kUserActionEditCustomMeasure = @"Edit Custom Measure";
NSString * const kUserActionDeleteCustomMeasure = @"Delete Custom Measure";
NSString * const kUserActionUserLogin = @"login";
NSString * const kUserActionProjectChanged = @"projectChanged";
NSString * const kUserActionKey = @"userAction";

//Custom chart data keys
NSString * const kCustomChartDataKeyData = @"data";
NSString * const kCustomChartDataKeyName = @"name";
NSString * const kCustomChartDataKeyCategories = @"categories";
NSString * const kCustomChartDataKeySeries = @"series";
NSString * const kChartDataKeyChartTitle = @"chartTitle";
NSString * const kChartDataKeyXAxis = @"xAxis";
NSString * const kChartDataKeyYAxis = @"yAxis";
NSString * const kChartDataKeyXAxisTitle = @"xAxisTitle";
NSString * const kChartDataKeyYAxisTitle = @"yAxisTitle";
NSString * const kChartDataKeyMarginRight = @"marginRight";
NSString * const kChartDataKeyDimension2Title = @"dimension2Title";
NSString * const kChartDataKeyIsMultiStackedChart = @"isMultiStackedChart";
NSString * const kChartDataKeyIsLegendEnabled = @"isLegendEnabled";
NSString * const kChartDataKeyTooltip = @"tooltip";

//constants for Cetas backend API base urls
NSString * const kCetasAPIURL = @"https://insights.cetas.net/CetasRequestBroker?";
NSString * const kCetasBaseAPIURL = @"https://insights.cetas.net";

//custom chart layouts
NSString * const kCustomGridViewLayoutGrid = @"TABLE";
NSString * const kCustomGridViewLayoutChart = @"CHART";

// CustomGridView Data dict keys
NSString * const kGridViewDictKeycolumnTitle = @"CustomGridViewTitle";
NSString * const kGridViewDictKeyDataArray = @"CustomGridViewData";

//dashboard related constants
NSString * const kCetasApiResponseKeyDashboardDataObject = @"dashboard_object";
NSString * const kCetasApiResponseKeyDashboardTable = @"dashboardTable";
NSString * const kCetasApiResponseKeyDashboardTabAdj = @"dashboardTabAdj";
NSString * const kCetasApiResponseKeyReportTable = @"reportTable";
NSString * const kCetasApiResponseKeyReportTabAdj = @"reportTabAdj";
NSString * const kCetasApiResponseKeyDashboardLayouts = @"layouts";
NSString * const kCetasApiResponseKeyReports = @"reports";
NSString * const kCetasApiResponseKeyLayoutReports = @"layoutReports";
NSString * const kCetasApiResponseKeySelectedRow = @"selectedRow";
NSString * const kCetasApiResponseKeyLayoutTitle = @"lTitle";

//management related constants
NSString * const kCetasDataSourceTypeUpload = @"UPLOAD";
NSString * const kCetasDataSourceTypeLiveFeed = @"LIVEFEED";
NSString * const kCetasDataSourceTypeAmazonS3 = @"CRAWL";
NSString * const kCetasDataSourceTypeCetasBox = @"CETASBOX";

//constants for report dictionary
NSString * const kCetasApiResponseKeyRVersion = @"rVersion";
NSString * const kCetasApiResponseKeyRName = @"rName";
NSString * const kCetasApiResponseKeyRNum = @"rNum";
NSString * const kCetasApiResponseKeyRDataType = @"rDataType";
NSString * const kCetasApiResponseKeyRQuery = @"rQuery";
NSString * const kCetasApiResponseKeyRTimeRange = @"rTimeRange";
NSString * const kCetasApiResponseKeyRMeasures = @"rMeasures";
NSString * const kCetasApiResponseKeyRDimensions = @"rDimensions";
NSString * const kCetasApiResponseKeyRShowFn = @"rShowFn";
NSString * const kCetasApiResponseKeyRLibrary = @"rLibrary";
NSString * const kCetasApiResponseKeyRType = @"rType";
NSString * const kCetasApiResponseKeyRSubType = @"rSubType";
NSString * const kCetasApiResponseKeyRHeader = @"rHeader";
NSString * const kCetasApiResponseKeyRFooter = @"rFooter";
NSString * const kCetasApiResponseKeyRData = @"rData";
NSString * const kLayoutTypeHorizontal = @"H";
NSString * const kLayoutTypeVertical = @"V";
NSString * const kLayoutTypePanel = @"panel";

//Constants for event view.
NSString * const kCetasApiResponseKeyEventData = @"event_data";
NSString * const kCetasApiResponseKeyMetaData = @"metaData";
NSString * const kCetasApiResponseKeyEvents = @"events";
NSString * const kCetasApiResponseKeyTotalEventsCount = @"total_events_count";
NSString * const kCetasApiResponseKeyEventsPerPage = @"events_per_page";
NSString * const kCetasApiResponseKeyCurrentPageNumber = @"current_page_number";
NSString * const kCetasApiResponseKeyEventDate = @"event_date";
NSString * const kCetasApiResponseKeyEventFormat = @"event_format";
NSString * const kCetasApiResponseKeyEventSourceType = @"event_source_type";
NSString * const kCetasApiResponseKeyEventSource = @"event_source";
NSString * const kCetasApiResponseKeyDetails = @"details";
NSString * const kCetasApiResponseKeyValue= @"value";
NSString * const kCetasApiResponseKeyLink= @"link";
NSString * const kCetasApiResponseKeyHighlight= @"highlight";


NSString * const kNSUserDefaultKeyUserEmail = @"userEmail";
NSString * const kNSUserDefaultKeyAnalyticsBaseURL = @"analyticsBaseURL";

NSString * const kJSSeparatorToken = @"##";
NSString * const kJSSeparatorStartToken = @"\"##";
NSString * const kJSSeparatorEndToken = @"##\"";

NSString * const kTokenCountsArray = @"%%COUNTS-ARRAY%%";
NSString * const kTokenChartInfo = @"%%CHART-INFO%%";
NSString * const kDiscoveryChartTypeLine = @"line";
NSString * const kDiscoveryChartTypeColumn = @"column";
NSString * const kDiscoveryChartSourceSchemaInformation = @"SchemaInformation";
NSString * const kDiscoveryChartSourceDataDiscovery = @"DataDiscovery";
NSString * const kDiscoveryRTypeSparkline = @"SPARKLINE";
NSString * const kDiscoveryRTypeSchemaInformation = @"SchemaInformation";

NSString * const kCetasAPIResponseDataVOTypeAnalytics = @"AnalyticsVO";
NSString * const kCetasAPIResponseDataVOTypeAggregates = @"AggregatesVO";
NSString * const kValuesTableCellTypeSummaryDefinitions = @"Summary Definitions";
NSString * const kValuesTableCellTypeSummaryDefinitionDetail = @"Summary Definitions Detail";


NSString * const kCetasAPIParamKeyAggregatedAnalyticsType = @"aggregatedanalytics.type";
NSString * const  kListTypeAggregatesTabSubmenu = @"AggregatesTabSubmenu";

// Constant for Data Discovery
NSString* kWidgetTypeChart = @"1";
NSString* kWidgetTypeTable = @"2";

NSString * const  kListTypeChart = @"chartList";
NSString * const  kListTypeFunction = @"functionList";
NSString * const  kListTypeTimeScale = @"timeScaleList";
NSString * const  kListTypeAction = @"actionList";
NSString * const  kListTypeSubmenu = @"Submenu";
NSString * const  kItemListItemNameKey = @"itemName";
NSString * const  kItemListItemDisplayNameKey = @"itemDisplayName";
NSString * const  kItemListItemIconImageKey = @"itemIcon";


@implementation Constants

+ (float) getGridViewHeaderTitleFontSize {
    return 13.0;
}



@end
