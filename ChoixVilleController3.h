//
//  ChoixVilleController3.h
//  Affinity
//
//  Created by Christophe Bergé on 04/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AffinityAppDelegate.h"

@interface ChoixVilleController3 : UIViewController <NSFetchedResultsControllerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>{
    UITableView *myTableView;
    NSMutableArray *villes;
    NSMutableArray *selectedRows;
    NSFetchedResultsController *resultsController;
    UISearchBar *searchBar;
	BOOL searching;
	BOOL letUserSelectRow;
    UILabel *messageBas;
    NSString *postString;
    
}

@property (nonatomic,retain) NSMutableArray *villes;
@property (nonatomic,retain) NSFetchedResultsController *resultsController;
@property (nonatomic,assign) BOOL searching;
@property (nonatomic,assign) BOOL letUserSelectRow;

- (void) searchTableView:(NSString *)theText;
- (void) doneSearching_Clicked:(id)sender;

@end
