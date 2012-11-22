//
//  AfficheListeAnnoncesController3.m
//  Affinity
//
//  Created by Christophe Bergé on 12/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AfficheListeAnnoncesController3.h"


@implementation AfficheListeAnnoncesController3

@synthesize listeAnnonces, criteres, annonceSelected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [pvc release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.navigationController.navigationBar.hidden = YES;
    //criteres = [[NSMutableDictionary alloc] init];
    //listeAnnonces = [[NSMutableArray alloc] init];
    
    
    appDelegate = (AffinityAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    listeAnnonces = appDelegate.favorisView.tableauAnnonces1;
    criteres = appDelegate.favorisView.criteres2;
    
    NSLog(@"LISTE ANNONCES:%@",listeAnnonces);
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(afficheAnnonceReady:) name:@"afficheAnnonceReady" object: nil];
    
    /*UIColor *fond = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = fond;
    [fond release];*/
    self.view.backgroundColor = [UIColor whiteColor];
    
    //HEADER
    UIImageView *enTete = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header.png"]];
    [enTete setFrame:CGRectMake(0,0,320,50)];
    [self.view addSubview:enTete];
    [enTete release];
    
    //BOUTON RETOUR
    UIButton *boutonRetour = [UIButton buttonWithType:UIButtonTypeCustom];
    boutonRetour.showsTouchWhenHighlighted = NO;
    boutonRetour.tag = 3;
    
    [boutonRetour setFrame:CGRectMake(10,7,50,30)];
    [boutonRetour addTarget:self action:@selector(buttonPushed:) 
           forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageNamed:@"bouton-retour.png"];
    [boutonRetour setImage:image forState:UIControlStateNormal];
    
    [self.view addSubview:boutonRetour];
    
    //BANDEAU RESULTATS DE RECHERCHE
    UIImageView *bandeauFavoris = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bandeau-resultat-recherche.png"]];
    [bandeauFavoris setFrame:CGRectMake(0,50,320,20)];
    [self.view addSubview:bandeauFavoris];
    [bandeauFavoris release];
    
    //BANDEAU VIERGE
    UIImageView *vierge; /*= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bandeau-vierge.png"]];
    [vierge setFrame:CGRectMake(0,72,320,20)];
    [self.view addSubview:vierge];
    [vierge release];*/
    
    //CRITERES
    if (([criteres valueForKey:@"prix_mini"] != NULL) || ([criteres valueForKey:@"prix_maxi"] != NULL)) {
        
        UILabel *labelPrix = [[UILabel alloc] initWithFrame:CGRectMake(10, 72, 320, 20)];
        labelPrix.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
        labelPrix.textAlignment = UITextAlignmentLeft;
        labelPrix.backgroundColor = [UIColor clearColor];
        labelPrix.textColor = [UIColor colorWithRed:197.0 green:47.0 blue:121.0 alpha:1.0];
        
        NSString *text = @"";
        text = [self setTextMinMax:@"prix" unit:@"€" texte:text];
        
        labelPrix.text = text;
        [self.view addSubview:labelPrix];
        [labelPrix release];
    }
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 92, 320, 20)];
    secondLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    secondLabel.textAlignment = UITextAlignmentLeft;
    secondLabel.backgroundColor = [UIColor clearColor];
    secondLabel.text = @"";
    
    BOOL criterePrinted = NO;
    
    if ([criteres valueForKey:@"types"] != NULL) {
        
        criterePrinted = YES;
        
        NSArray *typesPossibles = [NSArray arrayWithObjects:
                                   @"Appartement",
                                   @"Maison",
                                   @"Terrain",
                                   @"Bureau",
                                   @"Commerce",
                                   @"Immeuble",
                                   @"Parking",
                                   @"Autre",
                                   nil
                                   ];
        
        NSArray *types = [[criteres valueForKey:@"types"] componentsSeparatedByString:@","];
        
        NSString *text = @"";
        NSString *virgule = @",";
        int cpt = 0;
        
        for (NSString *type in types) {
            cpt++;
            if (cpt == [types count]) {
                virgule = @"";
            }
            text = [text stringByAppendingFormat:@"%@%@",[typesPossibles objectAtIndex:[type intValue]], virgule];
        }
        
        secondLabel.text = text;
    }
    
    if (([criteres valueForKey:@"nb_pieces_mini"] != NULL) && ([criteres valueForKey:@"nb_pieces_maxi"] != NULL)) {
        
        NSString *text = @"";
        
        if (criterePrinted) {
            text = @", ";
        }
        
        criterePrinted = YES;
        
        NSString *isS = @"";
        
        if ([[criteres valueForKey:@"nb_pieces_maxi"] intValue] > 1) {
            isS = @"s";
        }
        
        if ([[criteres valueForKey:@"nb_pieces_mini"] intValue] == [[criteres valueForKey:@"nb_pieces_maxi"] intValue]) {
            secondLabel.text = [secondLabel.text stringByAppendingFormat:@"%@%@ piece%@",
                                text,
                                [criteres valueForKey:@"nb_pieces_mini"],
                                isS
                                ];
        }
        else{
            secondLabel.text = [secondLabel.text stringByAppendingFormat:@"%@%@-%@ pieces",
                                text,
                                [criteres valueForKey:@"nb_pieces_mini"],
                                [criteres valueForKey:@"nb_pieces_maxi"]];
        }
    }
    
    if (([criteres valueForKey:@"surface_mini"] != NULL) && ([criteres valueForKey:@"surface_maxi"] != NULL)) {
        
        NSString *text = @"";
        
        if (criterePrinted) {
            text = @", ";
        }
        
        criterePrinted = YES;
        
        secondLabel.text = [secondLabel.text stringByAppendingFormat:@"%@%@-%@m²",
                            text,
                            [criteres valueForKey:@"surface_mini"],
                            [criteres valueForKey:@"surface_maxi"]];
    }
    
    if (([criteres valueForKey:@"surface_mini"] == NULL) && ([criteres valueForKey:@"surface_maxi"] != NULL)) {
        
        NSString *text = @"";
        
        if (criterePrinted) {
            text = @", ";
        }
        
        criterePrinted = YES;
        
        secondLabel.text = [secondLabel.text stringByAppendingFormat:@"%@<%@m²",
                            text,
                            [criteres valueForKey:@"surface_maxi"]];
    }
    
    if (([criteres valueForKey:@"surface_mini"] != NULL) && ([criteres valueForKey:@"surface_maxi"] == NULL)) {
        
        NSString *text = @"";
        
        if (criterePrinted) {
            text = @", ";
        }
        
        criterePrinted = YES;
        
        secondLabel.text = [secondLabel.text stringByAppendingFormat:@"%@>%@m²",
                            text,
                            [criteres valueForKey:@"surface_mini"]];
    }
    
    if ([criteres valueForKey:@"ville1"] != NULL) {
        
        NSString *text = @"";
        
        if (criterePrinted) {
            text = @" ";
        }
        
        criterePrinted = YES;
        
        secondLabel.text = [secondLabel.text stringByAppendingFormat:@"%@%@ %@",
                            text,
                            [criteres valueForKey:@"ville1"],
                            [criteres valueForKey:@"cp1"]
                            ];
    }
    
    if ([criteres valueForKey:@"ville2"] != NULL) {
        
        NSString *text = @"";
        
        if (criterePrinted) {
            text = @" ";
        }
        
        criterePrinted = YES;
        
        secondLabel.text = [secondLabel.text stringByAppendingFormat:@"%@%@ %@",
                            text,
                            [criteres valueForKey:@"ville2"],
                            [criteres valueForKey:@"cp2"]
                            ];
    }
    
    if ([criteres valueForKey:@"ville3"] != NULL) {
        
        NSString *text = @"";
        
        if (criterePrinted) {
            text = @" ";
        }
        
        criterePrinted = YES;
        
        secondLabel.text = [secondLabel.text stringByAppendingFormat:@"%@%@ %@",
                            text,
                            [criteres valueForKey:@"ville3"],
                            [criteres valueForKey:@"cp3"]
                            ];
    }
    
    if ([criteres valueForKey:@"ville4"] != NULL) {
        
        NSString *text = @"";
        
        if (criterePrinted) {
            text = @" ";
        }
        
        criterePrinted = YES;
        
        secondLabel.text = [secondLabel.text stringByAppendingFormat:@"%@%@ %@",
                            text,
                            [criteres valueForKey:@"ville4"],
                            [criteres valueForKey:@"cp4"]
                            ];
    }
    
    [self.view addSubview:secondLabel];
    [secondLabel release];
    
    //CRITERES DANS LE BANDEAU
    /*UIScrollView *textScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 72, 320, 20)];
    textScroll.contentSize = CGSizeMake(640, 20);
    textScroll.userInteractionEnabled = YES;
    textScroll.scrollsToTop = YES;
    
    UITextView *criteresTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 1000, 20)];
    criteresTextView.text = @"";

    NSString *text = @"";
    
    if ([criteres valueForKey:@"transaction"] != @"") {
        if ([criteres valueForKey:@"transaction"] == @"0") {
            text = @"Ventes - ";
        }
        if ([criteres valueForKey:@"transaction"] == @"1") {
            text = @"Locations - ";
        }
    }
    
    if ([criteres valueForKey:@"ville1"] != NULL) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"%@",[criteres valueForKey:@"ville1"]]];
    }
    
    NSString *cp1 = [criteres valueForKey:@"cp1"];
    if (cp1 != NULL) {
        int cp1Int = [cp1 intValue];
        NSString *indice = @"eme";
        if ((cp1Int > 75000) && (cp1Int < 75021)) {
            if (cp1Int == 75001) {
                indice = @"er";
            }
            text = [text stringByAppendingFormat:@" - %d%@ arrondissement",cp1Int - 75000, indice];
        }
        else{
            text = [text stringByAppendingFormat:@" - %@",
                    [NSString stringWithFormat:@"%@",cp1]];
        }
    }
    
    if ([criteres valueForKey:@"prix"] != NULL)
        text = [self setTextMinMax:@"prix" unit:@"€" texte:text];
    
    if ([criteres valueForKey:@"surface"] != NULL)
        text = [self setTextMinMax:@"surface" unit:@"m²" texte:text];
    
    if (([criteres valueForKey:@"nb_pieces_maxi"] != NULL) && ([criteres valueForKey:@"nb_pieces_mini"] != NULL))
        text = [self setTextMinMax:@"nb_pieces" unit:@"piece" texte:text];
    
    criteresTextView.text = text;
    
    criteresTextView.backgroundColor = [UIColor clearColor];
    
    [textScroll addSubview:criteresTextView];
    [self.view addSubview:textScroll];
    
    [criteresTextView release];
    [textScroll release];*/
    
    //BOUTON TRIS
    //PAR PRIX
    boutonPrix = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[boutonPrix setFrame:CGRectMake(48, 115, 72, 30)];
	[boutonPrix setUserInteractionEnabled:YES];
	[boutonPrix addTarget:self action:@selector(buttonPrixPushed:) 
               forControlEvents:UIControlEventTouchUpInside];
    
    image = [UIImage imageNamed:@"prix-middle.png"];
	[boutonPrix setImage:image forState:UIControlStateNormal];
    
    boutonPrix.showsTouchWhenHighlighted = NO;
    boutonPrix.tag = 1;
	
	[self.view addSubview:boutonPrix];
    
    //PAR SURFACE
    boutonSurface = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[boutonSurface setFrame:CGRectMake(122, 115, 72, 30)];
	[boutonSurface setUserInteractionEnabled:YES];
	[boutonSurface addTarget:self action:@selector(buttonSurfacePushed:) 
         forControlEvents:UIControlEventTouchUpInside];
    
    image = [UIImage imageNamed:@"m2-middle.png"];
	[boutonSurface setImage:image forState:UIControlStateNormal];
    
    boutonSurface.showsTouchWhenHighlighted = NO;
    boutonSurface.tag = 11;
	
	[self.view addSubview:boutonSurface];
    
    //PAR DATE
    boutonDate = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[boutonDate setFrame:CGRectMake(195, 115, 72, 30)];
	[boutonDate setUserInteractionEnabled:YES];
	[boutonDate addTarget:self action:@selector(buttonDatePushed:) 
         forControlEvents:UIControlEventTouchUpInside];
    
    image = [UIImage imageNamed:@"date-middle.png"];
	[boutonDate setImage:image forState:UIControlStateNormal];
    
    boutonDate.showsTouchWhenHighlighted = NO;
    boutonDate.tag = 111;
	
	[self.view addSubview:boutonDate];
    
    //BANDEAU VIERGE
    vierge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bandeau-vierge.png"]];
    [vierge setFrame:CGRectMake(0,150,320,20)];
    [self.view addSubview:vierge];
    [vierge release];
    
    //NOMBRE D'ANNONCES DANS BANDEAU
    UITextView *nbAnnoncesText = [[UITextView alloc] initWithFrame:CGRectMake(0, 150, 320, 20)];
    int nbAnnonces = [listeAnnonces count];
    
    if (nbAnnonces > 1) {
        nbAnnoncesText.text = [NSString stringWithFormat:@"%d biens trouvés", nbAnnonces];
    }
    else{
        nbAnnoncesText.text = [NSString stringWithFormat:@"1 bien trouvé"];
    }
                               
    nbAnnoncesText.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:nbAnnoncesText];
    
    [nbAnnoncesText release];
    
    //TABLE VIEW
    tableView1 = [[UITableView alloc] init];
    [tableView1 setFrame:CGRectMake(0, 170, 320, 235)];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    //tableView1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell.png"]];
    tableView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView1];
}

- (void) buttonPushed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) buttonPrixPushed:(id)sender
{
	UIButton *button = sender;
    UIImage *image = [UIImage imageNamed:@"m2-middle.png"];
    [boutonSurface setImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"date-middle.png"];
    [boutonDate setImage:image forState:UIControlStateNormal];
    
    NSSortDescriptor *sortDescriptor;
    NSArray *sortDescriptors;
    NSArray *sortedArray;
	switch (button.tag) {
		case 1:
            button.tag = 2;
            image = [UIImage imageNamed:@"prix-down.png"];
            [button setImage:image forState:UIControlStateNormal];
            //TRIER LES ANNONCES PAR PRIX EN ORDRE DECROISSANT
            
            sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"prix"
                                                          ascending:NO
                                                           selector:@selector(localizedStandardCompare:)] autorelease];
            sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            sortedArray = [listeAnnonces sortedArrayUsingDescriptors:sortDescriptors];
            [listeAnnonces release];
            listeAnnonces = nil;
            listeAnnonces = [[NSMutableArray alloc] initWithArray:sortedArray];
            [tableView1 reloadData];
			break;
		case 2:
            button.tag = 1;
            image = [UIImage imageNamed:@"prix-up.png"];
            [button setImage:image forState:UIControlStateNormal];
            //TRIER LES ANNONCES PAR PRIX EN ORDRE CROISSANT
            sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"prix"
                                                          ascending:YES
                                                           selector:@selector(localizedStandardCompare:)] autorelease];
            sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            sortedArray = [listeAnnonces sortedArrayUsingDescriptors:sortDescriptors];
            [listeAnnonces release];
            listeAnnonces = nil;
            listeAnnonces = [[NSMutableArray alloc] initWithArray:sortedArray];
            [tableView1 reloadData];
            break;
		default:
			break;
	}
}

- (void) buttonSurfacePushed:(id)sender
{
	UIButton *button = sender;
    UIImage *image = [UIImage imageNamed:@"prix-middle.png"];
    [boutonPrix setImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"date-middle.png"];
    [boutonDate setImage:image forState:UIControlStateNormal];
    
    NSSortDescriptor *sortDescriptor;
    NSArray *sortDescriptors;
    NSArray *sortedArray;
	switch (button.tag) {
		case 11:
            button.tag = 12;
            image = [UIImage imageNamed:@"m2-down.png"];
            [button setImage:image forState:UIControlStateNormal];
            //TRIER LES ANNONCES PAR PRIX EN ORDRE DECROISSANT
            
            sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"surface"
                                                          ascending:NO
                                                           selector:@selector(localizedStandardCompare:)] autorelease];
            sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            sortedArray = [listeAnnonces sortedArrayUsingDescriptors:sortDescriptors];
            [listeAnnonces release];
            listeAnnonces = nil;
            listeAnnonces = [[NSMutableArray alloc] initWithArray:sortedArray];
            [tableView1 reloadData];
			break;
		case 12:
            button.tag = 11;
            image = [UIImage imageNamed:@"m2-up.png"];
            [button setImage:image forState:UIControlStateNormal];
            //TRIER LES ANNONCES PAR PRIX EN ORDRE CROISSANT
            sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"surface"
                                                          ascending:YES
                                                           selector:@selector(localizedStandardCompare:)] autorelease];
            sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            sortedArray = [listeAnnonces sortedArrayUsingDescriptors:sortDescriptors];
            [listeAnnonces release];
            listeAnnonces = nil;
            listeAnnonces = [[NSMutableArray alloc] initWithArray:sortedArray];
            [tableView1 reloadData];
            break;
		default:
			break;
	}
}

- (void) buttonDatePushed:(id)sender
{
	UIButton *button = sender;
    UIImage *image = [UIImage imageNamed:@"prix-middle.png"];
    [boutonPrix setImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"m2-middle.png"];
    [boutonSurface setImage:image forState:UIControlStateNormal];
    
    NSSortDescriptor *sortDescriptor;
    NSArray *sortDescriptors;
    NSArray *sortedArray;
	switch (button.tag) {
		case 111:
            button.tag = 112;
            image = [UIImage imageNamed:@"date-down.png"];
            [button setImage:image forState:UIControlStateNormal];
            //TRIER LES ANNONCES PAR PRIX EN ORDRE DECROISSANT
            
            sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"date"
                                                          ascending:NO
                                                           selector:@selector(localizedStandardCompare:)] autorelease];
            sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            sortedArray = [listeAnnonces sortedArrayUsingDescriptors:sortDescriptors];
            [listeAnnonces release];
            listeAnnonces = nil;
            listeAnnonces = [[NSMutableArray alloc] initWithArray:sortedArray];
            [tableView1 reloadData];
			break;
		case 112:
            button.tag = 111;
            image = [UIImage imageNamed:@"date-up.png"];
            [button setImage:image forState:UIControlStateNormal];
            //TRIER LES ANNONCES PAR PRIX EN ORDRE CROISSANT
            sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"date"
                                                          ascending:YES
                                                           selector:@selector(localizedStandardCompare:)] autorelease];
            sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            sortedArray = [listeAnnonces sortedArrayUsingDescriptors:sortDescriptors];
            [listeAnnonces release];
            listeAnnonces = nil;
            listeAnnonces = [[NSMutableArray alloc] initWithArray:sortedArray];
            [tableView1 reloadData];
            break;
		default:
			break;
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [listeAnnonces count];
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	Annonce *uneAnnonce = [listeAnnonces objectAtIndex:indexPath.row];
    NSLog(@"LISTE ANNONCES:%@",listeAnnonces);
    
	//IMAGE
    
	/*NSString *string = [uneAnnonce valueForKey:@"photos"];
	NSLog(@"string photos: %@",string);*/
    
    UIImage *image= [UIImage imageNamed:@"appareil-photo-photographie-icone-6076-64.png"];
    [cell.imageView setImage:image];
    
    [NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:[NSArray arrayWithObjects:cell, uneAnnonce, nil]];
    
    cell.textLabel.textColor = [UIColor colorWithRed:244.0 green:0.0 blue:161.0 alpha:1.0];
    
    NSNumber *formattedResult;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setGroupingSeparator:@" "];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *prix1 = [uneAnnonce valueForKey:@"prix"];
    prix1 = [prix1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    formattedResult = [NSNumber numberWithInt:[prix1 intValue]];
    
    NSString *prix = [formatter stringForObjectValue:formattedResult];
    
    [formatter release];
    
	NSString *texte = [[NSString alloc] initWithFormat:@"%@ €",prix];
	
	cell.textLabel.text = texte;
	
	//SOUS TITRE
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
	NSString *codePostal = [uneAnnonce valueForKey:@"codePostal"];
    codePostal = [codePostal stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if (codePostal == nil) {
        codePostal = @"";
    }
    
    NSString *ville = [uneAnnonce valueForKey:@"ville"];
    ville = [ville stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
	NSString *surface = [uneAnnonce valueForKey:@"surface"];
    surface = [surface stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if (surface == nil) {
        surface = @"";
    }
    else{
        surface = [surface stringByAppendingString:@"m²"];
    }
    
	NSString *nbPieces = [uneAnnonce valueForKey:@"nb_pieces"];
    nbPieces = [nbPieces stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if (nbPieces == nil) {
        nbPieces = @"";
    }
    else{
        nbPieces = [nbPieces stringByAppendingString:@"piece"];
    }
    
    NSString *type = [uneAnnonce valueForKey:@"type"];
    type = [type stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if (type == nil) {
        type = @"";
    }
    
    NSString *isS = @"";
    
    if ([nbPieces intValue] > 1) {
        isS = @"s";
    }
    
	NSString *subTitle = [[NSString alloc] initWithFormat:@"%@ %@ %@ %@\n%@ %@",
                          type,
                          surface,
                          nbPieces,
                          isS,
                          ville,
                          codePostal
                          ];
	cell.detailTextLabel.text = subTitle;
	
	[texte release];
	[subTitle release];
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
	annonceSelected = [listeAnnonces objectAtIndex:indexPath.row];
    
    appDelegate.annonceFavoris = annonceSelected;
    
    [NSThread detachNewThreadSelector:@selector(printHUD) toTarget:self withObject:nil];

    
	AfficheAnnonceControllerFavoris *afficheAnnonceController = [[AfficheAnnonceControllerFavoris alloc] init];
	[self.navigationController pushViewController:afficheAnnonceController animated:YES];
	[afficheAnnonceController release];
	
}

- (void) printHUD{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    pvc = [[ProgressViewContoller alloc] init];
    [self.navigationController.view addSubview:pvc.view];
    
    [pool release];
    
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
    Annonce *uneAnnonce = [tableau objectAtIndex:1];
    
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

-(NSString *)setTextMinMax:(NSString *)critere unit:(NSString *)unit texte:(NSString *)text{
    NSString *critMin = [NSString stringWithFormat:@"%@_mini", critere];
    NSString *critMax = [NSString stringWithFormat:@"%@_maxi", critere];
    NSString *sMin = @"";
    NSString *sMax = @"";
    
    
    if (unit == @"piece") {
        sMax = @"s";
        if ([critMin intValue] > 1) {
            sMin = @"s";
        }
    }
    
    if ([criteres valueForKey:critMin] != NULL && [criteres valueForKey:critMax] != NULL) {
        
        NSNumber *formattedResult;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setGroupingSeparator:@" "];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        formattedResult = [NSNumber numberWithInt:[[criteres valueForKey:critMin] intValue]];
        NSString *mini = [formatter stringForObjectValue:formattedResult];
        
        formattedResult = [NSNumber numberWithInt:[[criteres valueForKey:critMax] intValue]];
        NSString *maxi = [formatter stringForObjectValue:formattedResult];
        
        text = [text stringByAppendingFormat:@"%@ %@%@ à %@ %@%@",mini, unit, sMin, maxi, unit, sMax];
        
        [formatter release];
    }
    
    if ([criteres valueForKey:critMin] != NULL && [criteres valueForKey:critMax] == NULL) {
        
        NSNumber *formattedResult;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setGroupingSeparator:@" "];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        formattedResult = [NSNumber numberWithInt:[[criteres valueForKey:critMin] intValue]];
        NSString *mini = [formatter stringForObjectValue:formattedResult];
        
        text = [text stringByAppendingFormat:@"A partir de %@ %@%@",mini, unit, sMin];
        
        [formatter release];
    }
    
    if ([criteres valueForKey:critMin] == NULL && [criteres valueForKey:critMax] != NULL) {
        
        NSNumber *formattedResult;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setGroupingSeparator:@" "];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        formattedResult = [NSNumber numberWithInt:[[criteres valueForKey:critMax] intValue]];
        NSString *maxi = [formatter stringForObjectValue:formattedResult];
        
        text = [text stringByAppendingFormat:@"Jusqu'à %@ %@%@",maxi, unit, sMax];
        
        [formatter release];
    }
    return text;
}

- (void) viewWillAppear:(BOOL)animated{
    //[listeAnnonces removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"afficheListeAnnoncesReadyFavoris" object: @"afficheListeAnnoncesReadyFavoris"];
    
    //[self viewDidLoad];
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

@end
