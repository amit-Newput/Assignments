//
//  Values.m
//  BatchQueryBuilderDemo
//
//  Created by Prateek Pradhan on 08/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import "FieldsTable.h"
#import "FieldVO.h"
#import "DataCell.h"


@implementation FieldsTable


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSourceVO:(SourceVO *)paramSourceVO
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.sourceVO = paramSourceVO ;
        self.title = paramSourceVO.name;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.tableView.bounces = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void) valueSelected: (FieldVO*)paramFieldVO{
    paramFieldVO.isSelected = YES;
    [self.tableView reloadData];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.sourceVO.fieldVOs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.section,indexPath.row];
    DataCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    FieldVO * fieldVO = [self.sourceVO.fieldVOs objectAtIndex:indexPath.row];
    cell.data = fieldVO;
    cell.textLabel.text = fieldVO.name;
    
    //Add the check mark to show the field is selected or not
    if( fieldVO.isSelected){
        cell.accessoryType = UITableViewCellAccessoryCheckmark ;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    // Configure the cell...
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(void) toggleTableRowSelection:(NSIndexPath *)indexPath{
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataCell *cell  = (DataCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    FieldVO * fieldVO = [self.sourceVO.fieldVOs objectAtIndex:indexPath.row];
    
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
        cell.accessoryType = UITableViewCellAccessoryNone;
        fieldVO.isSelected = NO;
    }
    else{
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
        fieldVO.isSelected = YES;

    }
    [self.navigationController.view.superview bringSubviewToFront:self.navigationController.view];
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"Coming in scroll view");
    if ([self.delegate respondsToSelector:@selector(fieldsTableDidScroll:)]) {
        [self.delegate fieldsTableDidScroll:self];
    }
//    if (scrollView.contentOffset.y <= -100)
//    {
//        CGPoint offset = scrollView.contentOffset;
//        offset.y = -100;
//        scrollView.contentOffset = offset;
//    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //NSLog(@"Coming in scroll view scrollViewDidEndDragging");
}

@end
