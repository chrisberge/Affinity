//
//  AffinityAppDelegate.m
//  Affinity
//
//  Created by Christophe Bergé on 23/07/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AffinityAppDelegate.h"


@implementation AffinityAppDelegate

@synthesize window, /*myTableViewController,*/ myTabBarController, accueilView;
@synthesize favorisView, agenceView, contactView;
@synthesize isAccueil, whichView;
@synthesize annonceAccueil, annonceMulti, annonceFavoris, annonceBiensFavoris, annonceModifierFavoris;
@synthesize url_serveur, partenaire, id_agence, nom_appli, date_maj_appli;
@synthesize transition;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	
	//CORE DATA - - GARDER CE BOUT DE CODE POUR CREER LE FICHIER BDD DANS LE SIMULATEUR IPHONE
	/*******************
	NSManagedObjectContext *context = [self managedObjectContext];
	NSManagedObject *codesPostauxInfo = [NSEntityDescription
										 insertNewObjectForEntityForName:@"Codes" 
										 inManagedObjectContext:context];
	[codesPostauxInfo setValue:@"77" forKey:@"code"];
	[codesPostauxInfo setValue:@"Seine et Marne" forKey:@"commune"];
	
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
	}
	******************/
	
    url_serveur = @"http://www.affinityprestige-immobilier.com/passerelleAkios/akios.php";
    partenaire = @"";
    id_agence = @"";
    nom_appli = @"";
    transition = @"";
    
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	NSMutableDictionary *dicDateMaj;
    
    dicDateMaj = [NSMutableDictionary dictionaryWithContentsOfFile:
                 [directory stringByAppendingPathComponent:@"date_maj.plist"]];
    
    if (dicDateMaj != nil) {
        date_maj_appli = [dicDateMaj valueForKey:@"date_maj"];
    }
    else {
        date_maj_appli = @"1970-01-01";
        
        dicDateMaj = [NSMutableDictionary dictionary];
        [dicDateMaj setValue:date_maj_appli forKey:@"date_maj"];
        [dicDateMaj writeToFile:[directory stringByAppendingPathComponent:@"date_maj.plist"] atomically:YES];
    }
    
    isAccueil = NO;
    
	// creates your tab bar so you can add everything else to it
	myTabBarController = [[UITabBarController alloc] init];

    /******/
	/*** VUE ONGLET ACCUEIL AVEC NAVIGATION ***/
	accueilView = [[Accueil  alloc] init];
    accueilView.title = @"Accueil";
    
    UINavigationController *tableNavController = [[[UINavigationController alloc] initWithRootViewController:accueilView] autorelease];
	
    [accueilView release];
    
	//tableNavController.navigationBar.topItem.title = @"Accueil";
    //tableNavController.navigationBarHidden = YES;
    /******/

	/*** VUE ONGLET FAVORIS***/
	favorisView = [[Favoris2 alloc] init];
    favorisView.title = @"Favoris";
    
    UINavigationController *tableNavControllerFavoris = [[[UINavigationController alloc] initWithRootViewController:favorisView] autorelease];
	
    [favorisView release];
    
	/*** VUE ONGLET AGENCES***/
	agenceView = [[AgenceViewController alloc] init];

	/*** VUE ONGLET CONTACT***/
	contactView = [[ContactViewController alloc] init];

	/*** AJOUT DES ONGLETS DANS LA BARRE D'ONGLETS***/
	Utility *utility = [[Utility alloc] init];
	
	NSInteger tag = -1;
	
	tableNavController.tabBarItem = [utility getItem:@"" imagePath:@"/accueil.png" tag:tag++];
    tableNavController.tabBarItem.title = @"Biens";
    
    tableNavControllerFavoris.tabBarItem = [utility getItem:@"" imagePath:@"/favoris.png" tag:tag++];
    tableNavControllerFavoris.tabBarItem.title = @"Favoris";
    
	//favorisView.tabBarItem = [utility getItem:@"" imagePath:@"/favoris.png" tag:tag++];
	//favorisView.tabBarItem.title = @"Favoris";
    
	agenceView.tabBarItem = [utility getItem:@"" imagePath:@"/lagence.png" tag:tag++];
	agenceView.tabBarItem.title = @"L'agence";
    
	contactView.tabBarItem = [utility getItem:@"" imagePath:@"/contact.png" tag:tag++];
	contactView.tabBarItem.title = @"Contact";
    
	[utility release];
	
	//add both of your navigation controllers to the tab bar. You can put as many controllers on as you like, but they will turn into the more button.
	myTabBarController.viewControllers = [NSArray arrayWithObjects: tableNavController,
                                        /*favorisView,*/
                                        tableNavControllerFavoris,
                                        agenceView,
                                        contactView,
                                        nil];
	/*** FIN AJOUT DES ONGLETS DANS LA BARRE D'ONGLETS***/
	/******/
    
    myTabBarController.delegate = self;
    
	[window addSubview:myTabBarController.view];
    
    imagePresentation = [[[UIImageView alloc] autorelease] initWithImage:[UIImage imageNamed:@"Default.png"]];
    [myTabBarController.view addSubview:imagePresentation];
    [UIView beginAnimations:@"ImagePresentation" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector( removeDefaultView: )];
    [UIView setAnimationDelay:2.0];
    [UIView setAnimationDuration:4];
    [imagePresentation setAlpha:0.0];
    [UIView commitAnimations];
    
    [window makeKeyAndVisible];
	
	return YES;
}

- (void) removeDefaultView
{
    [imagePresentation removeFromSuperview];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
	
	managedObjectModel_ = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
	/*---   ---*/
	/*--- LE CODE SUIVANT EST TIRE DE L'EXEMPLE "CoreDataBooks" DE LA DOC APPLE ---*/
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Affinity.sqlite"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
	NSError *error1 = nil;
	//NSDictionary *fileAttributes = [[NSDictionary alloc] init];
	
	NSString *defaultStorePath;
	
	defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Affinity" ofType:@"sqlite"];
	[fileManager removeItemAtPath:storePath error:&error1];
	[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:&error1];
	
	/*
    if (![fileManager fileExistsAtPath:storePath]) {
        defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Affinity" ofType:@"sqlite"];
        if (defaultStorePath) {
            [fileManager copyItemAtPath:defaultStorePath toPath:storePath error:&error1];
        }
    }
	else {
		fileAttributes = [fileManager attributesOfItemAtPath:storePath error:&error1];
		if ([fileAttributes fileSize] < 1200000) {
			defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Affinity" ofType:@"sqlite"];
			if (defaultStorePath) {
				[fileManager removeItemAtPath:storePath error:&error1];
				[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:&error1];
			}
		}
	}*/
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES], 
							 NSMigratePersistentStoresAutomaticallyOption, 
							 [NSNumber numberWithBool:YES], 
							 NSInferMappingModelAutomaticallyOption, nil];
	/*--- FIN DE COPIE COLLE ---*/
	/*---   ---*/
	
    NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	//NSLog(@"storeUrl:%@",storeUrl);
	
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator_;
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[myTabBarController release];
	[accueilView release];
	[favorisView release];
	[agenceView release];
	[contactView release];
	
	
    [managedObjectContext_ release];
    [managedObjectModel_ release];
    [persistentStoreCoordinator_ release];
	
    [window release];
    [super dealloc];
}


@end
