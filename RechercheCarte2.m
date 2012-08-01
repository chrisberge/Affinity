//
//  RechercheCarte2.m
//  Affinity
//
//  Created by Christophe Bergé on 18/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RechercheCarte2.h"


@interface RechercheCarte2 ()
- (void)requestDone:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;
- (void) hideButtonsAndLabels;
- (void) showButtonsAndLabels:(int)index;
@end

@implementation RechercheCarte2

@synthesize criteres1, tableauAnnonces1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    tableauAnnoncesTab = [[NSMutableArray alloc] initWithObjects:
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          nil];
    
    //tableauAnnoncesPrestigeTab = [[NSMutableArray alloc] init];
    
    isConnectionErrorPrinted = NO;
    
    criteres1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                 @"", @"transaction",
                 @"", @"cp1",
                 nil];
    
    tableauAnnonces1 = [[NSMutableArray alloc] init];
    labelTab = [[NSMutableArray alloc] init];
    buttonTab = [[NSMutableArray alloc] init];
    
    networkQueue = [[ASINetworkQueue alloc] init];
    [networkQueue reset];
	[networkQueue setRequestDidFinishSelector:@selector(requestDone:)];
	[networkQueue setRequestDidFailSelector:@selector(requestFailed:)];
	[networkQueue setDelegate:self];
    
    self.navigationController.navigationBar.hidden = YES;
    
    //COULEUR DE FOND
    UIColor *couleurFond = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = couleurFond;
    [couleurFond release];
    
    //HEADER
    UIImageView *enTete = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header.png"]];
    [enTete setFrame:CGRectMake(0,0,320,50)];
    [self.view addSubview:enTete];
    [enTete release];
    
    //BANDEAU RECHERCHE CARTE
    UIImageView *bandeau = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bandeau-recherche-carte.png"]];
    [bandeau setFrame:CGRectMake(0, 50, 320, 20)];
    [self.view addSubview:bandeau];
    [bandeau release];
    
    //BOUTON RETOUR
    UIButton *boutonRetour = [UIButton buttonWithType:UIButtonTypeCustom];
    boutonRetour.showsTouchWhenHighlighted = NO;
    boutonRetour.tag = 3;
    
    [boutonRetour setFrame:CGRectMake(20,375,50,30)];
    [boutonRetour addTarget:self action:@selector(buttonPushed:) 
          forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageNamed:@"bouton-retour.png"];
    [boutonRetour setImage:image forState:UIControlStateNormal];
    
    [self.view addSubview:boutonRetour];
    
    //CARTE
    UIImageView *carte = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"carte.png"]];
    [carte setFrame:CGRectMake(0, 140, 320, 250)];
    [self.view addSubview:carte];
    [carte release];
    
    /*--- BOUTONS ---*/
    int xPos = 40;
    int yPos = 80;
    int xDecalage = 60;
    int xSize = 60;
    int ySize = 30;
    
    //BOUTON Vente
    boutonVente = [UIButton buttonWithType:UIButtonTypeCustom];
    boutonVente.tag = 0;
    boutonVente.showsTouchWhenHighlighted = NO;
    
    [boutonVente setFrame:CGRectMake(xPos,yPos,xSize,ySize)];
    [boutonVente addTarget:self action:@selector(buttonPushed:) 
          forControlEvents:UIControlEventTouchUpInside];
    
    image = [UIImage imageNamed:@"ventes.png"];
    [boutonVente setImage:image forState:UIControlStateNormal];
    
    [self.view addSubview:boutonVente];
    
    //BOUTON LOCATION
    boutonLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    boutonLocation.tag = 1;
    boutonLocation.showsTouchWhenHighlighted = NO;
    
    [boutonLocation setFrame:CGRectMake(xPos + xDecalage,yPos,xSize,ySize)];
    [boutonLocation addTarget:self action:@selector(buttonPushed:) 
             forControlEvents:UIControlEventTouchUpInside];
    
    image = [UIImage imageNamed:@"locations.png"];
    [boutonLocation setImage:image forState:UIControlStateNormal];
    
    [self.view addSubview:boutonLocation];
    
    //BOUTON PRESTIGE
    boutonPrestige = [UIButton buttonWithType:UIButtonTypeCustom];
    boutonPrestige.tag = 2;
    boutonPrestige.showsTouchWhenHighlighted = NO;
    
    [boutonPrestige setFrame:CGRectMake(xPos + (xDecalage * 2),yPos,120,ySize)];
    [boutonPrestige addTarget:self action:@selector(buttonPushed:) 
             forControlEvents:UIControlEventTouchUpInside];
    
    image = [UIImage imageNamed:@"Prestige.png"];
    [boutonPrestige setImage:image forState:UIControlStateNormal];
    
    [self.view addSubview:boutonPrestige];
    /*--- BOUTONS ---*/
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(afficheListeAnnoncesReady:) name:@"afficheListeAnnoncesReady" object: nil];
    
    //isRequestFinished = YES;
    //[NSThread detachNewThreadSelector:@selector(testRequestFinished) toTarget:self withObject:nil];
    [self buttonPushed:boutonVente];
}

- (void) afficheListeAnnoncesReady:(NSNotification *)notify {
    NSString *code_postal = [NSString stringWithFormat:@"%d",75001 + indexAnnoncesTab];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:code_postal forKey:@"cp1"];
    [dict setValue:@"Paris" forKey:@"ville1"];
    [dict setValue:typeTransaction forKey:@"transaction"];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[tableauAnnoncesTab objectAtIndex:indexAnnoncesTab] copyItems:NO];
    NSArray *criteresEtAnnonces = [NSArray arrayWithObjects:dict, array, nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"afficheListeAnnonces" object: criteresEtAnnonces];
}

- (void) printHUD{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    pvc = [[ProgressViewContoller alloc] init];
    [self.navigationController.view addSubview:pvc.view];
    
    [pool release];
    
}

- (void) testRequestFinished{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    while (YES) {
        NSLog(@"COUCOU bool: %d",isRequestFinished);
        if (isRequestFinished == YES) {
            break;
        }
    }
    [pvc.view removeFromSuperview];
    [pool release];
}

- (void) buttonPushed:(id)sender
{
	UIButton *button = sender;
    UIImage *image;
    
	switch (button.tag) {
        case 0:
            NSLog(@"VENTES");
            //REQUETE SUR LES VENTES A PARIS
            image = [UIImage imageNamed:@"vente-survol.png"];
            [boutonVente setImage:image forState:UIControlStateNormal];
            boutonVente.userInteractionEnabled = NO;
            
            image = [UIImage imageNamed:@"locations.png"];
            [boutonLocation setImage:image forState:UIControlStateNormal];
            boutonLocation.userInteractionEnabled = YES;
            
            image = [UIImage imageNamed:@"Prestige.png"];
            [boutonPrestige setImage:image forState:UIControlStateNormal];
            boutonPrestige.userInteractionEnabled = YES;
            
            [self hideButtonsAndLabels];
            isRequestFinished = NO;
            [NSThread detachNewThreadSelector:@selector(testRequestFinished) toTarget:self withObject:nil];
            [NSThread detachNewThreadSelector:@selector(printHUD) toTarget:self withObject:nil];
            isConnectionErrorPrinted = NO;
            isBiensPrestige = NO;
            typeTransaction = @"0";
            [self makeRequest:typeTransaction];
            break;
		case 1:
            NSLog(@"LOCATIONS");
            //REQUETE SUR LES LOCATIONS A PARIS
            image = [UIImage imageNamed:@"ventes.png"];
            [boutonVente setImage:image forState:UIControlStateNormal];
            boutonVente.userInteractionEnabled = YES;
            
            image = [UIImage imageNamed:@"location-survol.png"];
            [boutonLocation setImage:image forState:UIControlStateNormal];
            boutonLocation.userInteractionEnabled = NO;
            
            image = [UIImage imageNamed:@"Prestige.png"];
            [boutonPrestige setImage:image forState:UIControlStateNormal];
            boutonPrestige.userInteractionEnabled = YES;
            
            [self hideButtonsAndLabels];
            isRequestFinished = NO;
            [NSThread detachNewThreadSelector:@selector(testRequestFinished) toTarget:self withObject:nil];
            [NSThread detachNewThreadSelector:@selector(printHUD) toTarget:self withObject:nil];
            isConnectionErrorPrinted = NO;
            isBiensPrestige = NO;
            typeTransaction = @"1";
            [self makeRequest:typeTransaction];
			break;
		case 2:
            NSLog(@"PRESTIGES");
            //REQUETE SUR LES BIENS DE PRESTIGES (ON LES A DEJA DEPUIS LA PAGE D'ACCUEIL)
            image = [UIImage imageNamed:@"ventes.png"];
            [boutonVente setImage:image forState:UIControlStateNormal];
            boutonVente.userInteractionEnabled = YES;
            
            image = [UIImage imageNamed:@"locations.png"];
            [boutonLocation setImage:image forState:UIControlStateNormal];
            boutonLocation.userInteractionEnabled = YES;
            
            image = [UIImage imageNamed:@"prestige-survol.png"];
            [boutonPrestige setImage:image forState:UIControlStateNormal];
            boutonPrestige.userInteractionEnabled = NO;
            
            [self hideButtonsAndLabels];
            isRequestFinished = NO;
            [NSThread detachNewThreadSelector:@selector(testRequestFinished) toTarget:self withObject:nil];
            [NSThread detachNewThreadSelector:@selector(printHUD) toTarget:self withObject:nil];
            isConnectionErrorPrinted = NO;
            isBiensPrestige = YES;
            typeTransaction = @"";
            [self makeRequestPrestige];
            break;
        case 3:
            [self.navigationController popViewControllerAnimated:YES];
            break;
		default:
			break;
	}
}

- (void) buttonBadgePushed:(id)sender
{
	UIButton *button = sender;
    indexAnnoncesTab = button.tag - 10;
    
    AfficheListeAnnoncesController2 *afficheListeAnnoncesController =
    [[AfficheListeAnnoncesController2 alloc] init];
    afficheListeAnnoncesController.title = @"Annonces";
    [self.navigationController pushViewController:afficheListeAnnoncesController animated:YES];
    [afficheListeAnnoncesController release];
	
}

- (void)makeRequestPrestige{
    [tableauAnnoncesTab release];
    tableauAnnoncesTab = nil;
    
    tableauAnnoncesTab = [[NSMutableArray alloc] initWithObjects:
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          nil];
    
    NSString *bodyString = @"http://paris-demeures.com/biens_prestiges.asp";
    bodyString = [bodyString stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding];
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:bodyString]] autorelease];
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"biens_prestige" forKey:@"name"]];
    [networkQueue addOperation:request];

    [networkQueue go];
}

- (void)makeRequest:(NSString *)transaction{
    /*--- REQUETES SUR CHAQUE ARRONDISSEMENT DE PARIS ET AFFICHAGE DES BADGES ---*/
    
    [tableauAnnoncesTab release];
    tableauAnnoncesTab = nil;
    
    tableauAnnoncesTab = [[NSMutableArray alloc] initWithObjects:
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:1],
                          nil];
    
    criteres1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                 @"", @"cp1",
                 nil];
    int cp = 75001;
    
    for (cp = 75001; cp < 75021; cp++) {
        [criteres1 setValue:[NSString stringWithFormat:@"%d",cp] forKey:@"cp1"];
        [criteres1 setValue:transaction forKey:@"transaction"];
        NSLog(@"criteres carte: %@",criteres1);
        
        [tableauAnnonces1 removeAllObjects];
        
        NSString *bodyString = @"";
        
        NSEnumerator *enume;
        NSString *key;
        
        enume = [criteres1 keyEnumerator];
        BOOL isFirstObject = YES;
        NSString *esperluette = @"http://paris-demeures.com/iphone.asp?";
        
        while((key = [enume nextObject])) {
            if (!isFirstObject) {
                esperluette = @"&";
            }
            else{
                isFirstObject = NO;
            }
            if ([criteres1 objectForKey:key] != @"") {
                bodyString = [bodyString stringByAppendingFormat:@"%@%@=%@",esperluette, key, [criteres1 valueForKey:key]];
                bodyString = [bodyString stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding];
            }
        }	
        
        NSLog(@"bodyString:%@\n",bodyString);
        
        ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:bodyString]] autorelease];
        [request setUserInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",cp] forKey:@"name"]];
        [networkQueue addOperation:request];
    }
    [networkQueue go];
    
    /*--- REQUETES SUR CHAQUE ARRONDISSEMENT DE PARIS ET AFFICHAGE DES BADGES ---*/
}

- (void) hideButtonsAndLabels{
    UILabel *tempLabel;
    
    for (tempLabel in labelTab) {
        [tempLabel removeFromSuperview];
        [tempLabel release];
        tempLabel = nil;
    }
    
    UIButton *tempButton;
    
    for (tempButton in buttonTab) {
        [tempButton removeFromSuperview];
        tempButton = nil;
    }
    
    [labelTab removeAllObjects];
    [buttonTab removeAllObjects];
}

- (void) showButtonsAndLabels:(int)index{
    if ([[tableauAnnoncesTab objectAtIndex:index] count] > 0 ) {
        //AFFICHER BADGE A L'ENDROIT DE L'ARRONDISSEMENT SUR LA CARTE
        //PLUS LE NOMBRE DE BIENS A CET ENDROIT
        
        UIButton *badge = [UIButton buttonWithType:UIButtonTypeCustom];
        badge.tag = index + 10;
        badge.showsTouchWhenHighlighted = NO;
        
        int xBadge = 0;
        int yBadge = 0;
        
        switch (index) {
            case 0:
                xBadge = 140;
                yBadge = 240;
                break;
            case 1:
                xBadge = 145;
                yBadge = 225;
                break;
            case 2:
                xBadge = 203;
                yBadge = 242;
                break;
            case 3:
                xBadge = 200;
                yBadge = 270;
                break;
            case 4:
                xBadge = 180;
                yBadge = 300;
                break;
            case 5:
                xBadge = 130;
                yBadge = 285;
                break;
            case 6:
                xBadge = 115;
                yBadge = 260;
                break;
            case 7:
                xBadge = 110;
                yBadge = 225;
                break;
            case 8:
                xBadge = 130;
                yBadge = 190;
                break;
            case 9:
                xBadge = 173;
                yBadge = 195;
                break;
            case 10:
                xBadge = 245;
                yBadge = 260;
                break;
            case 11:
                xBadge = 270;
                yBadge = 325;
                break;
            case 12:
                xBadge = 220;
                yBadge = 350;
                break;
            case 13:
                xBadge = 110;
                yBadge = 338;
                break;
            case 14:
                xBadge = 50;
                yBadge = 310;
                break;
            case 15:
                xBadge = 50;
                yBadge = 225;
                break;
            case 16:
                xBadge = 105;
                yBadge = 160;
                break;
            case 17:
                xBadge = 190;
                yBadge = 160;
                break;
            case 18:
                xBadge = 250;
                yBadge = 190;
                break;
            case 19:
                xBadge = 280;
                yBadge = 260;
                break;
            default:
                break;
        }
        
        [badge setFrame:CGRectMake(xBadge, yBadge,25,25)];
        
        [badge addTarget:self action:@selector(buttonBadgePushed:) 
        forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *image = [UIImage imageNamed:@"badge.png"];
        [badge setImage:image forState:UIControlStateNormal];
        
        [self.view addSubview:badge];
        
        UILabel *nbBiens = [[UILabel alloc] init];
        
        nbBiens.textAlignment = UITextAlignmentCenter;
        nbBiens.text = [NSString stringWithFormat:@"%d", [[tableauAnnoncesTab objectAtIndex:index] count]];
        nbBiens.textColor = [UIColor whiteColor];
        nbBiens.backgroundColor = [UIColor clearColor];
        nbBiens.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
        
        [nbBiens setFrame:CGRectMake(xBadge - 1, yBadge + 4,25,15)];
        
        [self.view addSubview:nbBiens];
        
        [labelTab addObject:nbBiens];
        [buttonTab addObject:badge];
    }
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
        
        /*--- POUR LE TEST OFF LINE ---*/
        /*if (isBiensPrestige) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *xmlSamplePath = [[NSBundle mainBundle] pathForResource:@"Biens_prestige" ofType:@"xml"];
            data = [fileManager contentsAtPath:xmlSamplePath];
            string = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
            NSLog(@"REPONSE DU WEB: %@\n",string);
        }
         */
        
        if ([string rangeOfString:@"<biens></biens>"].length != 0) {
            //AUCUNE ANNONCES
            NSDictionary *userInfo = [NSDictionary 
                                      dictionaryWithObject:@"Aucun bien ne correspond à ces critères dans notre base de données."
                                      forKey:NSLocalizedDescriptionKey];
            
            error =[NSError errorWithDomain:@"Aucun bien trouvé."
                                       code:1 userInfo:userInfo];
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
        }
        [string release];
    }
    
    if ([[request userInfo] valueForKey:@"name"] != @"biens_prestige")
    {
        [tableauAnnoncesTab replaceObjectAtIndex:([[[request userInfo] valueForKey:@"name"] intValue] - 75001)
                                      withObject:[NSMutableArray arrayWithArray:[[NSMutableArray alloc] initWithArray:tableauAnnonces1]]];
        [tableauAnnonces1 removeAllObjects];
        [self showButtonsAndLabels:([[[request userInfo] valueForKey:@"name"] intValue] - 75001)];
        
        if ([[[request userInfo] valueForKey:@"name"] intValue] == 75020) {
            isRequestFinished = YES;
        }
        
    }
    
    if ([[request userInfo] valueForKey:@"name"] == @"biens_prestige") {
        isRequestFinished = YES;
        //NSLog(@"ICI");
        //tableauAnnoncesPrestigeTab = [[NSMutableArray alloc] initWithArray:tableauAnnonces1 copyItems:YES];
        
        NSSortDescriptor *sortDescriptor;
        NSArray *sortDescriptors;
        NSArray *sortedArray;
        
        sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"cp"
                                                      ascending:YES
                                                       selector:@selector(localizedStandardCompare:)] autorelease];
        sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        sortedArray = [tableauAnnonces1 sortedArrayUsingDescriptors:sortDescriptors];
        
        NSMutableArray *arrondissement = [[NSMutableArray alloc] init];
        int currentCP = -1;
        
        for (Annonce *uneAnnonce in sortedArray) {
            int cp = [[uneAnnonce valueForKey:@"cp"] intValue];
            
            if (cp != currentCP) {
                if([arrondissement count] > 0)
                {
                    [tableauAnnoncesTab replaceObjectAtIndex:currentCP - 75001
                                                  withObject:[NSMutableArray arrayWithArray:[[NSMutableArray alloc] initWithArray:arrondissement]]];
                    [arrondissement removeAllObjects];
                }
                currentCP = cp;
            }
            [arrondissement addObject:uneAnnonce];
            if (uneAnnonce == [sortedArray lastObject]) {
                [tableauAnnoncesTab replaceObjectAtIndex:currentCP - 75001
                                              withObject:[NSMutableArray arrayWithArray:[[NSMutableArray alloc] initWithArray:arrondissement]]];
                [arrondissement removeAllObjects];
            }
        }
        [arrondissement release];
        
        for (int i = 0; i < 20; i++) {
            if ([tableauAnnoncesTab objectAtIndex:i] != [NSNumber numberWithInt:1]) {
                [self showButtonsAndLabels:i];
            }
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    UIAlertView *alert;
    
    NSLog(@"Connection failed! Error - %@",
          [error localizedDescription]);
    
    isRequestFinished = YES;
    
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

- (void)dealloc
{
    [tableauAnnonces1 release];
    [labelTab release];
    [buttonTab release];
    [tableauAnnoncesTab release];
	[criteres1 release];
    [networkQueue release];
    [pvc release];
    //[tableauAnnoncesPrestigeTab release];
    [super dealloc];
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
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

@end
