//
//  Favoris2.m
//  Affinity
//
//  Created by Christophe Bergé on 05/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Favoris2.h"

@implementation Favoris2

@synthesize whichView, rechercheMulti, tableauAnnonces1, annonceSelected, criteres2;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    appDelegate = (AffinityAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    tableauAnnonces1 = [[NSMutableArray alloc] init];
    criteres2 = [[NSMutableDictionary alloc] init];
    rechercheMulti = [[RootViewControllerModifierFavoris alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(afficheAnnonceFavorisReady:) name:@"afficheAnnonceFavorisReady" object: nil];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, 320, 480)];
    [scrollView setContentSize:CGSizeMake(320, 750)];
    [scrollView setScrollEnabled:YES];
    [self.view addSubview:scrollView];
    
    //COULEUR DE FOND
    UIColor *fond = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = fond;
    [fond release];
    //self.view.backgroundColor = [UIColor whiteColor];
    
    //HEADER
    UIImageView *enTete = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header.png"]];
    [enTete setFrame:CGRectMake(0,0,320,50)];
    [self.view addSubview:enTete];
    [enTete release];
    
    //BANDEAU FAVORIS
    UIImageView *bandeauFavoris = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bandeau-favoris.png"]];
    [bandeauFavoris setFrame:CGRectMake(0,50,320,20)];
    [self.view addSubview:bandeauFavoris];
    [bandeauFavoris release];
    
    //BANDEAU BIENS FAVORIS
    UIImageView *bandeauBiensFavoris = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bandeau-selection-de-biens.png"]];
    [bandeauBiensFavoris setFrame:CGRectMake(0,5,320,20)];
    [scrollView addSubview:bandeauBiensFavoris];
    [bandeauBiensFavoris release];
    
    //BANDEAU RECHERCHE RECENTES
    UIImageView *bandeauRecherche = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bandeau-mes-recherches-recentes.png"]];
    [bandeauRecherche setFrame:CGRectMake(0,190,320,20)];
    [scrollView addSubview:bandeauRecherche];
    [bandeauRecherche release];
    
    isConnectionErrorPrinted = NO;
    
    /*--- QUEUE POUR LES REQUETES HTTP ---*/
    networkQueue = [[ASINetworkQueue alloc] init];
    [networkQueue reset];
	[networkQueue setRequestDidFinishSelector:@selector(requestDone:)];
	[networkQueue setRequestDidFailSelector:@selector(requestFailed:)];
	[networkQueue setDelegate:self];
    /*--- QUEUE POUR LES REQUETES HTTP ---*/
    
    /*--- BOUTONS ---*/
    
    /*---- BIENS FAVORIS ----*/
    
    //TABLE VIEW
    tableView1 = [[UITableView alloc] init];
    [tableView1 setFrame:CGRectMake(0, 25, 320, 155)];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView1.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:tableView1];
    
    /*---- BIENS FAVORIS ----*/
    
    /*---- RECHERCHES RECENTES ----*/
    /*----- 1ERE RANGEE -----*/
    /*------ INFOS ------*/
    boutonRangee1 = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[boutonRangee1 setFrame:CGRectMake(10, 220, 200, 100)];
	[boutonRangee1 setUserInteractionEnabled:YES];
	[boutonRangee1 addTarget:self action:@selector(buttonInfosPushed:) 
            forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageNamed:@"espace-informations.png"];
	[boutonRangee1 setImage:image forState:UIControlStateNormal];
    
    boutonRangee1.showsTouchWhenHighlighted = NO;
    boutonRangee1.tag = 1;
	
	[scrollView addSubview:boutonRangee1];
    /*------ INFOS ------*/
    /*------ MODIFIER ------*/
    modifierRangee1 = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[modifierRangee1 setFrame:CGRectMake(220, 220, 90, 45)];
	[modifierRangee1 setUserInteractionEnabled:YES];
	[modifierRangee1 addTarget:self action:@selector(buttonModifierPushed:) 
              forControlEvents:UIControlEventTouchUpInside];
    
    image = [UIImage imageNamed:@"bouton-modifier.png"];
	[modifierRangee1 setImage:image forState:UIControlStateNormal];
    
    modifierRangee1.showsTouchWhenHighlighted = NO;
    modifierRangee1.tag = 11;
	
	[scrollView addSubview:modifierRangee1];
    /*------ MODIFIER ------*/
    /*------ SUPPRIMER ------*/
    supprimerRangee1 = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[supprimerRangee1 setFrame:CGRectMake(220, 275, 90, 45)];
	[supprimerRangee1 setUserInteractionEnabled:YES];
	[supprimerRangee1 addTarget:self action:@selector(buttonSupprimerPushed:) 
               forControlEvents:UIControlEventTouchUpInside];
    
    image = [UIImage imageNamed:@"bouton-supprimer-recherche.png"];
	[supprimerRangee1 setImage:image forState:UIControlStateNormal];
    
    supprimerRangee1.showsTouchWhenHighlighted = NO;
    supprimerRangee1.tag = 21;
	
	[scrollView addSubview:supprimerRangee1];
    /*------ SUPPRIMER ------*/
    /*----- 1ERE RANGEE -----*/
    /*----- 2EME RANGEE -----*/
    /*------ INFOS ------*/
    boutonRangee2 = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[boutonRangee2 setFrame:CGRectMake(10, 330, 200, 100)];
	[boutonRangee2 setUserInteractionEnabled:YES];
	[boutonRangee2 addTarget:self action:@selector(buttonInfosPushed:) 
            forControlEvents:UIControlEventTouchUpInside];
    
    image = [UIImage imageNamed:@"espace-informations.png"];
	[boutonRangee2 setImage:image forState:UIControlStateNormal];
    
    boutonRangee2.showsTouchWhenHighlighted = NO;
    boutonRangee2.tag = 2;
	
	[scrollView addSubview:boutonRangee2];
    /*------ INFOS ------*/
    /*------ MODIFIER ------*/
    modifierRangee2 = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[modifierRangee2 setFrame:CGRectMake(220, 330, 90, 45)];
	[modifierRangee2 setUserInteractionEnabled:YES];
	[modifierRangee2 addTarget:self action:@selector(buttonModifierPushed:) 
              forControlEvents:UIControlEventTouchUpInside];
    
    image = [UIImage imageNamed:@"bouton-modifier.png"];
	[modifierRangee2 setImage:image forState:UIControlStateNormal];
    
    modifierRangee2.showsTouchWhenHighlighted = NO;
    modifierRangee2.tag = 12;
	
	[scrollView addSubview:modifierRangee2];
    /*------ MODIFIER ------*/
    /*------ SUPPRIMER ------*/
     supprimerRangee2 = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[supprimerRangee2 setFrame:CGRectMake(220, 385, 90, 45)];
	[supprimerRangee2 setUserInteractionEnabled:YES];
	[supprimerRangee2 addTarget:self action:@selector(buttonSupprimerPushed:) 
               forControlEvents:UIControlEventTouchUpInside];
    
    image = [UIImage imageNamed:@"bouton-supprimer-recherche.png"];
	[supprimerRangee2 setImage:image forState:UIControlStateNormal];
    
    supprimerRangee2.showsTouchWhenHighlighted = NO;
    supprimerRangee2.tag = 22;
	
	[scrollView addSubview:supprimerRangee2];
    /*------ SUPPRIMER ------*/
    /*----- 2EME RANGEE -----*/
    /*----- 3EME RANGEE -----*/
    /*------ INFOS ------*/
    boutonRangee3 = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[boutonRangee3 setFrame:CGRectMake(10, 440, 200, 100)];
	[boutonRangee3 setUserInteractionEnabled:YES];
	[boutonRangee3 addTarget:self action:@selector(buttonInfosPushed:) 
            forControlEvents:UIControlEventTouchUpInside];
    
    image = [UIImage imageNamed:@"espace-informations.png"];
	[boutonRangee3 setImage:image forState:UIControlStateNormal];
    
    boutonRangee3.showsTouchWhenHighlighted = NO;
    boutonRangee3.tag = 3;
	
	[scrollView addSubview:boutonRangee3];
    /*------ INFOS ------*/
    /*------ MODIFIER ------*/
    modifierRangee3 = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[modifierRangee3 setFrame:CGRectMake(220, 440, 90, 45)];
	[modifierRangee3 setUserInteractionEnabled:YES];
	[modifierRangee3 addTarget:self action:@selector(buttonModifierPushed:) 
              forControlEvents:UIControlEventTouchUpInside];
    
    image = [UIImage imageNamed:@"bouton-modifier.png"];
	[modifierRangee3 setImage:image forState:UIControlStateNormal];
    
    modifierRangee3.showsTouchWhenHighlighted = NO;
    modifierRangee3.tag = 13;
	
	[scrollView addSubview:modifierRangee3];
    /*------ MODIFIER ------*/
    /*------ SUPPRIMER ------*/
    supprimerRangee3 = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[supprimerRangee3 setFrame:CGRectMake(220, 495, 90, 45)];
	[supprimerRangee3 setUserInteractionEnabled:YES];
	[supprimerRangee3 addTarget:self action:@selector(buttonSupprimerPushed:) 
               forControlEvents:UIControlEventTouchUpInside];
    
    image = [UIImage imageNamed:@"bouton-supprimer-recherche.png"];
	[supprimerRangee3 setImage:image forState:UIControlStateNormal];
    
    supprimerRangee3.showsTouchWhenHighlighted = NO;
    supprimerRangee3.tag = 23;
	
	[scrollView addSubview:supprimerRangee3];
    /*------ SUPPRIMER ------*/
    /*----- 3EME RANGEE -----*/
    /*---- RECHERCHES RECENTES ----*/
    
    /*--- BOUTONS ---*/
    
    /*--- MODELE: RETROUVER LES RECHERCHES ET BIENS SAUVES ET AFFICHER DANS LES BOUTONS ---*/
    /*---- RECHERCHES ----*/
    recherchesSauvees = [[NSMutableArray alloc] init];
    
    int xLabel = 0;
    int wLabel = 200;
    
    //TYPES DE BIENS
    labelType1 = [[UILabel alloc] initWithFrame:CGRectMake(xLabel, 5, wLabel, 20)];
    labelType2 = [[UILabel alloc] initWithFrame:CGRectMake(xLabel, 5, wLabel, 20)];
    labelType3 = [[UILabel alloc] initWithFrame:CGRectMake(xLabel, 5, wLabel, 20)];
    
    labelType3.backgroundColor = labelType2.backgroundColor = labelType1.backgroundColor = [UIColor clearColor];
    labelType3.text = labelType2.text = labelType1.text = @"Aucun critères";
    labelType3.textAlignment = labelType2.textAlignment = labelType1.textAlignment = UITextAlignmentCenter;
    labelType1.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    //labelType1.textColor = [UIColor colorWithRed:(51.0/255.0) green:(50.0/255.0) blue:(50.0/255.0) alpha:1.0];
    labelType3.font = labelType2.font = labelType1.font;
    labelType3.textColor = labelType2.textColor = labelType1.textColor;
    
    [boutonRangee1 addSubview:labelType1];
    [boutonRangee2 addSubview:labelType2];
    [boutonRangee3 addSubview:labelType3];
    
    //VILLES
    labelVille1 = [[UILabel alloc] initWithFrame:CGRectMake(xLabel, 25, wLabel, 20)];
    labelVille2 = [[UILabel alloc] initWithFrame:CGRectMake(xLabel, 25, wLabel, 20)];
    labelVille3 = [[UILabel alloc] initWithFrame:CGRectMake(xLabel, 25, wLabel, 20)];
    
    labelVille3.backgroundColor = labelVille2.backgroundColor = labelVille1.backgroundColor = [UIColor clearColor];
    labelVille3.text = labelVille2.text = labelVille1.text = @"";
    labelVille3.textAlignment = labelVille2.textAlignment = labelVille1.textAlignment = UITextAlignmentCenter;
    labelVille1.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    //labelVille1.textColor = [UIColor colorWithRed:(255.0/255.0) green:(247.0/255.0) blue:(205.0/255.0) alpha:1.0];
    labelVille3.font = labelVille2.font = labelVille1.font;
    labelVille3.textColor = labelVille2.textColor = labelVille1.textColor;
    
    [boutonRangee1 addSubview:labelVille1];
    [boutonRangee2 addSubview:labelVille2];
    [boutonRangee3 addSubview:labelVille3];
    
    //PRIX
    labelPrix1 = [[UILabel alloc] initWithFrame:CGRectMake(xLabel, 50, wLabel, 20)];
    labelPrix2 = [[UILabel alloc] initWithFrame:CGRectMake(xLabel, 50, wLabel, 20)];
    labelPrix3 = [[UILabel alloc] initWithFrame:CGRectMake(xLabel, 50, wLabel, 20)];
    
    labelPrix3.backgroundColor = labelPrix2.backgroundColor = labelPrix1.backgroundColor = [UIColor clearColor];
    labelPrix3.text = labelPrix2.text = labelPrix1.text = @"";
    labelPrix3.textAlignment = labelPrix2.textAlignment = labelPrix1.textAlignment = UITextAlignmentCenter;
    labelPrix1.font = [UIFont fontWithName:@"Arial" size:12];
    //labelPrix1.textColor = [UIColor colorWithRed:(42.0/255.0) green:(42.0/255.0) blue:(42.0/255.0) alpha:1.0];
    labelPrix3.font = labelPrix2.font = labelPrix1.font;
    labelPrix3.textColor = labelPrix2.textColor = labelPrix1.textColor;
    
    [boutonRangee1 addSubview:labelPrix1];
    [boutonRangee2 addSubview:labelPrix2];
    [boutonRangee3 addSubview:labelPrix3];
    
    //SURFACES
    labelSurface1 = [[UILabel alloc] initWithFrame:CGRectMake(xLabel, 70, wLabel, 20)];
    labelSurface2 = [[UILabel alloc] initWithFrame:CGRectMake(xLabel, 70, wLabel, 20)];
    labelSurface3 = [[UILabel alloc] initWithFrame:CGRectMake(xLabel, 70, wLabel, 20)];
    
    labelSurface3.backgroundColor = labelSurface2.backgroundColor = labelSurface1.backgroundColor = [UIColor clearColor];
    labelSurface3.text = labelSurface2.text = labelSurface1.text = @"";
    labelSurface3.textAlignment = labelSurface2.textAlignment = labelSurface1.textAlignment = UITextAlignmentCenter;
    labelSurface1.font = [UIFont fontWithName:@"Arial" size:12];
    //labelSurface1.textColor = [UIColor colorWithRed:(42.0/255.0) green:(42.0/255.0) blue:(42.0/255.0) alpha:1.0];
    labelSurface3.font = labelSurface2.font = labelSurface1.font;
    labelSurface3.textColor = labelSurface2.textColor = labelSurface1.textColor;
    
    [boutonRangee1 addSubview:labelSurface1];
    [boutonRangee2 addSubview:labelSurface2];
    [boutonRangee3 addSubview:labelSurface3];
    /*---- RECHERCHES ----*/
    /*---- BIENS ----*/
    biensSauves = [[NSMutableArray alloc] init];
    [self getBiens];
    
    /*---- BIENS ----*/
    /*--- MODELE: RETROUVER LES RECHERCHES ET BIENS SAUVES ET AFFICHER DANS LES BOUTONS ---*/
}

- (void) getBiens{
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    [biensSauves removeAllObjects];
    
    for (int i = 1; i < 11; i++) {
        NSString *name = [NSString stringWithFormat:@"bien%d.plist", i];
        NSDictionary *bien = [NSDictionary dictionaryWithContentsOfFile:
                              [directory stringByAppendingPathComponent:name]];
        if (bien != nil) {
            [biensSauves addObject:bien];
        }
    }
}

- (void) buttonInfosPushed:(id)sender
{
	UIButton *button = sender;
	switch (button.tag) {
		case 1:
            NSLog(@"Recherche 1");
            [tableauAnnonces1 removeAllObjects];
            [self makeRequest:0];
			break;
		case 2:
            NSLog(@"Recherche 2");
            [tableauAnnonces1 removeAllObjects];
            [self makeRequest:1];
            break;
        case 3:
            NSLog(@"Recherche 3");
            [tableauAnnonces1 removeAllObjects];
            [self makeRequest:2];
            break;
        default:
			break;
	}
}

- (void) printHUD{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    pvc = [[ProgressViewContoller alloc] init];
    [self.navigationController.view addSubview:pvc.view];
    
    [pool release];
    
}

- (void)makeRequest:(int)num{
    appDelegate.whichView = @"favoris";
    NSMutableDictionary *criteres1 = [recherchesSauvees objectAtIndex:num];
    
    NSString *bodyString = [NSString stringWithFormat:@"%@?part=%@&id_agence=%@&%@&",
                            appDelegate.url_serveur,
                            appDelegate.partenaire,
                            appDelegate.id_agence,
                            appDelegate.transition];
    
    NSEnumerator *enume;
    NSString *key;
    
    enume = [criteres1 keyEnumerator];
    BOOL isFirstObject = YES;
    NSString *esperluette = @"";
    
    [criteres2 removeAllObjects];
    
    while((key = [enume nextObject])) {
        if ([criteres1 objectForKey:key] != @"") {
            if (!isFirstObject) {
                esperluette = @"&";
            }
            else{
                isFirstObject = NO;
            }
            bodyString = [bodyString stringByAppendingFormat:@"%@%@=%@",esperluette, key, [criteres1 valueForKey:key]];
            bodyString = [bodyString stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding];
            [criteres2 setObject:[criteres1 objectForKey:key] forKey:key];
        }
    }
    
    NSLog(@"bodyString:%@\n",bodyString);
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:bodyString]] autorelease];
    [request setUserInfo:[NSDictionary dictionaryWithObject:[NSString stringWithString:@"recherche multicriteres"] forKey:@"name"]];
    [networkQueue addOperation:request];
    
    [networkQueue go];
}

- (void)requestDone:(ASIHTTPRequest *)request
{
	NSData *responseData = [request responseData];
    
    NSLog(@"dataBrute long: %d",[responseData length]);
    
    NSString * string = [[NSString alloc] initWithData:responseData encoding:NSISOLatin1StringEncoding];
    NSLog(@"REPONSE DU WEB: \"%@\"\n",string);
    
    NSError *error = nil;
    
    if ([string length] > 0) {
        
        NSUInteger zap = 60;
        
        NSData *dataString = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        NSData *data = [[NSData alloc] initWithData:[dataString subdataWithRange:NSMakeRange(59, [dataString length] - zap)]];
        
        //ON PARSE DU XML
        
        /*--- POUR LE TEST OFF LINE ---
         NSFileManager *fileManager = [NSFileManager defaultManager];
         NSString *xmlSamplePath = [[NSBundle mainBundle] pathForResource:@"Biens" ofType:@"xml"];
         data = [fileManager contentsAtPath:xmlSamplePath];
         string = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
         NSLog(@"REPONSE DU WEB: %@\n",string);
         */
        
        if ([string rangeOfString:@"<biens></biens>"].length != 0) {
            //AUCUNE ANNONCES
            NSDictionary *userInfo = [NSDictionary 
                                      dictionaryWithObject:@"Aucun bien ne correspond à ces critères dans notre base de données."
                                      forKey:NSLocalizedDescriptionKey];
            
            error =[NSError errorWithDomain:@"Aucun bien trouvé."
                                       code:1 userInfo:userInfo];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aucun bien trouvé"
                                                            message:[error localizedDescription]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else{
            NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
            XMLParser *parser = [[XMLParser alloc] initXMLParser];
            
            [xmlParser setDelegate:parser];
            
            BOOL success = [xmlParser parse];
            
            if(success)
                NSLog(@"No Errors on XML parsing.");
            else
                NSLog(@"Error on XML parsing!!!");
            
            AfficheListeAnnoncesController3 *afficheListeAnnoncesController = 
            [[AfficheListeAnnoncesController3 alloc] init];
            [self.navigationController pushViewController:afficheListeAnnoncesController animated:YES];
            [afficheListeAnnoncesController release];
            
        }
        [string release];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    UIAlertView *alert;
    
    NSLog(@"Connection failed! Error - %@",
          [error localizedDescription]);
    
    if (!isConnectionErrorPrinted) {
        alert = [[UIAlertView alloc] initWithTitle:@"Erreur de connection."
                                           message:[error localizedDescription]
                                          delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
        [alert release];
        isConnectionErrorPrinted = YES;
    }
}

- (void) buttonModifierPushed:(id)sender
{
	UIButton *button = sender;
    
    NSMutableDictionary *rechercheSauvee;
    
	switch (button.tag) {
		case 11:
            NSLog(@"Mod Recherche 1");
            appDelegate.whichView = @"favoris_modifier";
            
            [self.navigationController pushViewController:rechercheMulti animated:YES];
            
            rechercheSauvee = [recherchesSauvees objectAtIndex:0];
            if (rechercheSauvee == nil) {
                rechercheSauvee = [NSMutableDictionary dictionaryWithObject:@"0" forKey:@"transaction"];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"rechercheSauveeFavoris"
                                                                object:rechercheSauvee];
			break;
		case 12:
            NSLog(@"Mod Recherche 2");
            appDelegate.whichView = @"favoris_modifier";
            
            [self.navigationController pushViewController:rechercheMulti animated:YES];
            
            rechercheSauvee = [recherchesSauvees objectAtIndex:1];
            if (rechercheSauvee == nil) {
                rechercheSauvee = [NSMutableDictionary dictionaryWithObject:@"0" forKey:@"transaction"];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"rechercheSauveeFavoris"
                                                                object:rechercheSauvee];
            break;
        case 13:
            NSLog(@"Mod Recherche 3");
            appDelegate.whichView = @"favoris_modifier";
            
            [self.navigationController pushViewController:rechercheMulti animated:YES];
            
            rechercheSauvee = [recherchesSauvees objectAtIndex:2];
            if (rechercheSauvee == nil) {
                rechercheSauvee = [NSMutableDictionary dictionaryWithObject:@"0" forKey:@"transaction"];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"rechercheSauveeFavoris"
                                                                object:rechercheSauvee];
            break;
        default:
			break;
	}
}

- (void) buttonSupprimerPushed:(id)sender
{
	UIButton *button = sender;
	switch (button.tag) {
		case 21:
            [self effaceRecherche:1];
            break;
		case 22:
            [self effaceRecherche:2];
            break;
        case 23:
            [self effaceRecherche:3];
            break;
        default:
			break;
	}
}

- (void) effaceRecherche:(int)num{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    [fileManager removeItemAtPath:
     [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.plist",num]]
                            error:NULL];
    
    switch (num) {
        case 1:
            labelType1.text = @"Aucun critères";
            labelVille1.text = @"";
            labelSurface1.text = @"";
            labelPrix1.text = @"";
            boutonRangee1.userInteractionEnabled = NO;
            modifierRangee1.userInteractionEnabled = NO;
            break;
        case 2:
            labelType2.text = @"Aucun critères";
            labelVille2.text = @"";
            labelSurface2.text = @"";
            labelPrix2.text = @"";
            boutonRangee2.userInteractionEnabled = NO;
            modifierRangee2.userInteractionEnabled = NO;
            break;
        case 3:
            labelType3.text = @"Aucun critères";
            labelVille3.text = @"";
            labelSurface3.text = @"";
            labelPrix3.text = @"";
            boutonRangee3.userInteractionEnabled = NO;
            modifierRangee3.userInteractionEnabled = NO;
            break;
        default:
            break;
    }
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) getRecherches{
    [recherchesSauvees removeAllObjects];
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	NSMutableDictionary *recherche;
    
    noRecherche = YES;
    int i = 0;
	for (i = 0; i < 3; i++) {
		[recherchesSauvees addObject:[NSMutableDictionary dictionary]];
		
		recherche = [NSMutableDictionary dictionaryWithContentsOfFile:
					 [directory stringByAppendingPathComponent:
					  [NSString stringWithFormat:@"%d.plist",i+1]]];
		
		if (recherche != nil) {
            noRecherche = NO;
			[recherchesSauvees replaceObjectAtIndex:i withObject:recherche];
		}
		
	}
    if (noRecherche == NO) {
        i = 0;
        for (i = 0; i < 3; i++) {
            @try{
                recherche = [recherchesSauvees objectAtIndex:i];
            }
            @catch(NSException* ex){
                break;
            }
            NSLog(@"recherche%d: %@", i, recherche);
            
            if(recherche == nil)
            {
                switch (i) {
                    case 0:
                        boutonRangee1.userInteractionEnabled = NO;
                        break;
                    case 1:
                        boutonRangee2.userInteractionEnabled = NO;
                        break;
                    case 2:
                        boutonRangee3.userInteractionEnabled = NO;
                        break;
                    default:
                        break;
                }
            }
            
            if (recherche != nil && [recherche count] != 0) {
                
                switch (i) {
                    case 0:
                        boutonRangee1.userInteractionEnabled = YES;
                        modifierRangee1.userInteractionEnabled = YES;
                        supprimerRangee1.userInteractionEnabled = YES;
                        break;
                    case 1:
                        boutonRangee2.userInteractionEnabled = YES;
                        modifierRangee2.userInteractionEnabled = YES;
                        supprimerRangee2.userInteractionEnabled = YES;
                        break;
                    case 2:
                        boutonRangee3.userInteractionEnabled = YES;
                        modifierRangee3.userInteractionEnabled = YES;
                        supprimerRangee3.userInteractionEnabled = YES;
                        break;
                    default:
                        break;
                }
                
                NSString *typesInt = [recherche objectForKey:@"types"];
                
                NSArray *types = [typesInt componentsSeparatedByString:@","];
                NSString *typeString = @"";
                
                for (NSString *type in types) {
                    if (type != @"") {
                        
                        switch ([type intValue]) {
                            case 0:
                                typeString = [typeString stringByAppendingString:@"Appartement "];
                                break;
                            case 1:
                                typeString = [typeString stringByAppendingString:@"Maison "];
                                break;
                            case 2:
                                typeString = [typeString stringByAppendingString:@"Terrain "];
                                break;
                            case 3:
                                typeString = [typeString stringByAppendingString:@"Bureau "];
                                break;
                            case 4:
                                typeString = [typeString stringByAppendingString:@"Commerce "];
                                break;
                            case 5:
                                typeString = [typeString stringByAppendingString:@"Immeuble "];
                                break;
                            case 6:
                                typeString = [typeString stringByAppendingString:@"Parking "];
                                break;
                            case 7:
                                typeString = [typeString stringByAppendingString:@"Autre "];
                                break;
                            default:
                                break;
                        }
                    }
                }
                
                
                switch (i) {
                    case 0:
                        labelType1.text = typeString;
                        break;
                    case 1:
                        labelType2.text = typeString;
                        break;
                    case 2:
                        labelType3.text = typeString;
                        break;
                    default:
                        break;
                }
                
                NSString *ville = [recherche objectForKey:@"ville1"];
                
                switch (i) {
                    case 0:
                        labelVille1.text = ville;
                        break;
                    case 1:
                        labelVille2.text = ville;
                        break;
                    case 2:
                        labelVille3.text = ville;
                        break;
                    default:
                        break;
                }
                
                NSString *prix_mini = [recherche objectForKey:@"prix_mini"];
                NSString *prix_maxi = [recherche objectForKey:@"prix_maxi"];
                NSString *prix = @"";
                NSLog(@"prix_mini: %@",prix_mini);
                
                if (prix_mini != nil && prix_maxi != nil) {
                    NSNumber *formattedResult;
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    [formatter setGroupingSeparator:@" "];
                    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
                    
                    formattedResult = [NSNumber numberWithInt:[prix_mini intValue]];
                    prix_mini = [formatter stringForObjectValue:formattedResult];
                    
                    formattedResult = [NSNumber numberWithInt:[prix_maxi intValue]];
                    prix_maxi = [formatter stringForObjectValue:formattedResult];
                    //
                    [formatter release];
                    
                    prix = [NSString stringWithFormat:@"de %@€ à %@€", prix_mini, prix_maxi];
                }
                
                if (prix_mini != nil && prix_maxi == nil) {
                    NSNumber *formattedResult;
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    [formatter setGroupingSeparator:@" "];
                    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
                    
                    formattedResult = [NSNumber numberWithInt:[prix_mini intValue]];
                    prix_mini = [formatter stringForObjectValue:formattedResult];
                    
                    [formatter release];
                    
                    prix = [NSString stringWithFormat:@"à partir de %@€", prix_mini];
                }
                
                if (prix_mini == nil && prix_maxi != nil) {
                    NSNumber *formattedResult;
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    [formatter setGroupingSeparator:@" "];
                    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
                    
                    formattedResult = [NSNumber numberWithInt:[prix_maxi intValue]];
                    prix_maxi = [formatter stringForObjectValue:formattedResult];
                    
                    [formatter release];
                    
                    prix = [NSString stringWithFormat:@"jusqu'à %@€", prix_maxi];
                }
                
                switch (i) {
                    case 0:
                        labelPrix1.text = prix;
                        break;
                    case 1:
                        labelPrix2.text = prix;
                        break;
                    case 2:
                        labelPrix3.text = prix;
                        break;
                    default:
                        break;
                }
                
                NSString *surface_mini = [recherche objectForKey:@"surface_mini"];
                NSString *surface_maxi = [recherche objectForKey:@"surface_maxi"];
                NSString *surface = @"";
                
                if (surface_mini != nil && surface_maxi != nil) {
                    NSNumber *formattedResult;
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    [formatter setGroupingSeparator:@" "];
                    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
                    
                    formattedResult = [NSNumber numberWithInt:[surface_mini intValue]];
                    surface_mini = [formatter stringForObjectValue:formattedResult];
                    
                    formattedResult = [NSNumber numberWithInt:[surface_maxi intValue]];
                    surface_maxi = [formatter stringForObjectValue:formattedResult];
                    
                    [formatter release];
                    //€
                    surface = [NSString stringWithFormat:@"de %@m² à %@m²", surface_mini, surface_maxi];
                }
                
                if (surface_mini != nil && surface_maxi == nil) {
                    NSNumber *formattedResult;
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    [formatter setGroupingSeparator:@" "];
                    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
                    
                    formattedResult = [NSNumber numberWithInt:[surface_mini intValue]];
                    surface_mini = [formatter stringForObjectValue:formattedResult];
                    
                    [formatter release];
                    
                    surface = [NSString stringWithFormat:@"à partir de %@m²", surface_mini];
                }
                
                if (surface_mini == nil && surface_maxi != nil) {
                    NSNumber *formattedResult;
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    [formatter setGroupingSeparator:@" "];
                    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
                    
                    formattedResult = [NSNumber numberWithInt:[surface_maxi intValue]];
                    surface_maxi = [formatter stringForObjectValue:formattedResult];
                    
                    [formatter release];
                    
                    surface = [NSString stringWithFormat:@"jusqu'à %@m²", surface_maxi];
                }
                
                switch (i) {
                    case 0:
                        labelSurface1.text = surface;
                        break;
                    case 1:
                        labelSurface2.text = surface;
                        break;
                    case 2:
                        labelSurface3.text = surface;
                        break;
                    default:
                        break;
                }
                
            }
        }
    }
}

- (void) afficheAnnonceFavorisReady:(NSNotification *)notify {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"afficheAnnonceFavoris" object: annonceSelected];
}


- (void) viewWillAppear:(BOOL)animated{
    [self getRecherches];
    [self getBiens];
    [tableView1 reloadData];
}

 
- (void) viewWillDisappear:(BOOL)animated{
    UIView *view;
    
    for (view in [self.navigationController.view subviews]) {
        if (view == pvc.view) {
            [pvc.view removeFromSuperview];
        }
    }
}

- (void)dealloc {
    [recherchesSauvees release];
    [biensSauves release];
    
    [labelType1 release];
    [labelType2 release];
    [labelType3 release];
    
    [labelVille1 release];
    [labelVille2 release];
    [labelVille3 release];
    
    [labelPrix1 release];
    [labelPrix2 release];
    [labelPrix3 release];
    
    [labelSurface1 release];
    [labelSurface2 release];
    [labelSurface3 release];
    
    [rechercheMulti release];
    [tableauAnnonces1 release];
    [criteres2 release];
    
    [tableView1 release];
    
    [pvc release];
    [annonceSelected release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [biensSauves count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    else{
        UIImage *image= [UIImage imageNamed:@"appareil-photo-photographie-icone-6076-64.png"];
        UIImageView *iv = [[UIImageView alloc] initWithImage:image];
        [cell.imageView addSubview:iv];
        [iv release];
        
    }
    
	// Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    NSDictionary *bien = [NSDictionary dictionaryWithDictionary:[biensSauves objectAtIndex:indexPath.row]];
    
	//IMAGE DICLOSURE BUTTON
    UIImage *image = [UIImage   imageNamed:@"bouton-supprimer.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(44.0, 44.0, image.size.width, image.size.height);
    button.frame = frame;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(accessoryButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    cell.accessoryView = button;
    
	/*NSString *string = [uneAnnonce valueForKey:@"photos"];
     NSLog(@"string photos: %@",string);*/
    
    image= [UIImage imageNamed:@"appareil-photo-photographie-icone-6076-64.png"];
    [cell.imageView setImage:image];
    
    [NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:[NSArray arrayWithObjects:cell, bien, nil]];
    
    cell.textLabel.textColor = [UIColor colorWithRed:244.0 green:0.0 blue:161.0 alpha:1.0];
    
    NSNumber *formattedResult;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setGroupingSeparator:@" "];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *prix1 = [bien valueForKey:@"prix"];
    prix1 = [prix1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    formattedResult = [NSNumber numberWithInt:[prix1 intValue]];
    
    NSString *prix = [formatter stringForObjectValue:formattedResult];
    
    [formatter release];
    
    NSString *texte = [[NSString alloc] initWithFormat:@"%@ €",prix];
	
	cell.textLabel.text = texte;
	
	//SOUS TITRE
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
	NSString *codePostal = [bien valueForKey:@"codePostal"];
    codePostal = [codePostal stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *ville = [bien valueForKey:@"ville"];
    ville = [ville stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
	NSString *surface = [bien valueForKey:@"surface"];
    surface = [surface stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	
    NSString *nbPieces = [bien valueForKey:@"nb_pieces"];
    nbPieces = [nbPieces stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *type = [bien valueForKey:@"type"];
    type = [type stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *isS = @"";
    
    if ([nbPieces intValue] > 1) {
        isS = @"s";
    }
    
	NSString *subTitle = @"";
    
    if (ville != NULL) {
        subTitle = [subTitle stringByAppendingString:ville];
    }
    
    if (codePostal != NULL) {
        subTitle = [subTitle stringByAppendingFormat:@" %@", codePostal];
    }
    
	cell.detailTextLabel.text = subTitle;
	
	[texte release];
	[subTitle release];
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    indexASupprimer = indexPath.row;
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Supprimer des favoris?"
                          message: @"Appuyez sur OK pour supprimer ce bien de la liste des favoris."
                          delegate: self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:@"Annuler",nil];
    [alert show];
    [alert release];

}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
    if (annonceSelected != nil) {
        annonceSelected = nil;
        [annonceSelected release];
    }
    
    annonceSelected = [[Annonce alloc] init];
    
	NSDictionary *bien1 = [biensSauves objectAtIndex:indexPath.row];
    
    [annonceSelected setValue:[bien1 valueForKey:@"ref"] forKey:@"ref"];
    /*[annonceSelected setValue:[bien1 valueForKey:@"type"] forKey:@"type"];
    [annonceSelected setValue:[bien1 valueForKey:@"nb_pieces"] forKey:@"nb_pieces"];
    [annonceSelected setValue:[bien1 valueForKey:@"surface"] forKey:@"surface"];*/
    [annonceSelected setValue:[bien1 valueForKey:@"ville"] forKey:@"ville"];
    [annonceSelected setValue:[bien1 valueForKey:@"codePostal"] forKey:@"codePostal"];
    [annonceSelected setValue:[bien1 valueForKey:@"prix"] forKey:@"prix"];
    [annonceSelected setValue:[bien1 valueForKey:@"descriptif"] forKey:@"descriptif"];
    [annonceSelected setValue:[bien1 valueForKey:@"photos"] forKey:@"photos"];
    [annonceSelected setValue:[bien1 valueForKey:@"bilan_ce"] forKey:@"bilan_ce"];
    /*[annonceSelected setValue:[bien1 valueForKey:@"bilan_ges"] forKey:@"bilan_ges"];
    [annonceSelected setValue:[bien1 valueForKey:@"etage"] forKey:@"etage"];
    [annonceSelected setValue:[bien1 valueForKey:@"ascenseur"] forKey:@"ascenseur"];
    [annonceSelected setValue:[bien1 valueForKey:@"chauffage"] forKey:@"chauffage"];
    [annonceSelected setValue:[bien1 valueForKey:@"date"] forKey:@"date"];*/
    
    appDelegate.annonceBiensFavoris = annonceSelected;
    
    [NSThread detachNewThreadSelector:@selector(printHUD) toTarget:self withObject:nil];
    
    
	AfficheAnnonceController4 *afficheAnnonceController = [[AfficheAnnonceController4 alloc] init];
	[self.navigationController pushViewController:afficheAnnonceController animated:YES];
	[afficheAnnonceController release];
	
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell.png"]];
    cell.backgroundColor = [UIColor whiteColor];
}

- (void) loadImage:(NSArray *)tableau{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc]init];
    
    UITableViewCell *cell = [tableau objectAtIndex:0];
    NSDictionary *uneAnnonce = [tableau objectAtIndex:1];
    
	NSString *string = [uneAnnonce valueForKey:@"photos"];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if ([string length] > 0) {
        NSMutableArray * images;
		images = [[NSMutableArray alloc] initWithArray:[string componentsSeparatedByString:@","]];
		NSData* imageData = [[NSData alloc]initWithContentsOfURL:
                             [NSURL URLWithString:
                              [NSString stringWithFormat:@"%@",
                               [images objectAtIndex:0]]]];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        UIImageView *iv = [[UIImageView alloc] initWithImage:image];
        [iv setFrame:CGRectMake(0, 0, 64, 64)];
        [cell.imageView addSubview:iv];
        //[cell.imageView setImage:image];
        
        [images	release];
        [imageData release];
        [image release];
        [iv release];
        [pool release];
    }
}

- (void)accessoryButtonTapped:(id)sender event:(id)event
{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:tableView1];
	NSIndexPath *indexPath = [tableView1 indexPathForRowAtPoint: currentTouchPosition];
	if (indexPath != nil)
		
	{
        [self tableView: tableView1 accessoryButtonTappedForRowWithIndexPath: indexPath];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		NSLog(@"user pressed OK");
        NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *name = [NSString stringWithFormat:@"bien%d.plist", indexASupprimer + 1];
        NSString *path = [directory stringByAppendingPathComponent:name];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error1 = nil;
        
        [fileManager removeItemAtPath:path error:&error1];
        
        [biensSauves removeObjectAtIndex:indexASupprimer];
        
        for (int j = 1; j < [biensSauves count] + 1; j++) {
            NSDictionary *save = [biensSauves objectAtIndex:j - 1];
            NSString *nom = [NSString stringWithFormat:@"bien%d.plist", j];
            [save writeToFile:[directory stringByAppendingPathComponent:nom] atomically:YES];
        }
        
        name = [NSString stringWithFormat:@"bien%d.plist", [biensSauves count] + 1];
        path = [directory stringByAppendingPathComponent:name];
        
        [fileManager removeItemAtPath:path error:&error1];
        
        [self getBiens];
        
        [tableView1 reloadData];
	}
	else {
		NSLog(@"user pressed Annuler");
	}
}

@end
