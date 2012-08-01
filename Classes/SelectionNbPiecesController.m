//
//  SelectionNbPiecesController.m
//  Affinity
//
//  Created by Christophe Bergé on 28/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SelectionNbPiecesController.h"


@implementation SelectionNbPiecesController

@synthesize listOfItems, rowSelected, rowSelectedValue;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(setCriteres:) name:@"setCriteres" object: nil];
    
    UIViewController *tempView = [self.navigationController.viewControllers objectAtIndex:0];
    
    if (tempView.title == @"Accueil") {
        postString = @"Multi";
    }
    
    if (tempView.title == @"Favoris") {
        postString = @"Favoris";
    }
    
    NSString *name = [NSString stringWithFormat:@"getCriteres%@",postString];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object: nil];
    
	listOfItems = [[NSMutableArray alloc] init];
	
	NSArray *type1 = [NSArray arrayWithObjects: @"1 piece", @"2 pieces", @"3 pieces", @"4 pieces", @"5 pieces", @"6 pieces", @"+6 pieces", nil];
	NSDictionary *type1Dict = [NSDictionary dictionaryWithObject:type1 forKey:@"NbPieces"];
		
	[listOfItems addObject:type1Dict];
	
	rowSelected = [[NSMutableArray alloc] init];
	rowSelectedValue = [[NSMutableArray alloc] init];

    for (NSString *nbp in nbPieces) {
        NSUInteger indexArr[] = {0,[nbp intValue]};
        
        NSIndexPath *path = [NSIndexPath indexPathWithIndexes:indexArr length:2];
        [rowSelected addObject:path];
        [rowSelectedValue addObject:@""];
        [self.tableView reloadData];
        NSLog(@"rowSelected NbP: %@", rowSelected);
    }
    
    [self.tableView reloadData];
    
    UIColor *fond = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = fond;
    [fond release];
    
    //BOUTON RETOUR
    UIButton *boutonRetour = [UIButton buttonWithType:UIButtonTypeCustom];
    boutonRetour.showsTouchWhenHighlighted = NO;
    boutonRetour.tag = 3;
    
    [boutonRetour setFrame:CGRectMake(250,375,50,30)];
    [boutonRetour addTarget:self action:@selector(buttonPushed:) 
           forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageNamed:@"bouton-retour.png"];
    [boutonRetour setImage:image forState:UIControlStateNormal];
    
    [self.view addSubview:boutonRetour];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) buttonPushed:(id)sender
{
	UIButton *button = sender;
    
	switch (button.tag) {
        case 3:
            [self.navigationController popViewControllerAnimated:YES];
            break;
		default:
			break;
	}
}

- (void) setCriteres:(NSNotification *)notify
{
    NSLog(@"criteres setCriteres %@",[notify object]);
    NSMutableDictionary *criteres = [notify object];
    
    NSString *NbPiecesInt = [criteres valueForKey:@"nbPieces"];
    nbPieces = [NbPiecesInt componentsSeparatedByString:@","];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    NSString *name = [NSString stringWithFormat:@"nbPiecesSelected%@",postString];
	[[NSNotificationCenter defaultCenter] postNotificationName:name object:rowSelected];
    [super viewWillDisappear:animated];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [listOfItems count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSDictionary *dictionary = [listOfItems objectAtIndex:section];
	NSArray *array = [dictionary objectForKey:@"NbPieces"];
	return [array count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	
	NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
	NSArray *array = [dictionary objectForKey:@"NbPieces"];
	NSString *cellValue = [array objectAtIndex:indexPath.row];
	cell.textLabel.text = cellValue;
	
	if ([rowSelected containsObject:indexPath]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
		 
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	
	NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
	NSArray *array = [dictionary objectForKey:@"NbPieces"];
	NSString *cellValue = [array objectAtIndex:indexPath.row];
	
	if ([rowSelected containsObject:indexPath]) {
		[rowSelected removeObject:indexPath];
		[rowSelectedValue removeObject:cellValue];
	}
	else {
		[rowSelected addObject:indexPath];
		[rowSelectedValue addObject:cellValue];
	}
	
	[self.tableView reloadData];
		
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[listOfItems release];
	[rowSelected release];
	[rowSelectedValue release];
    [super dealloc];
}


@end

