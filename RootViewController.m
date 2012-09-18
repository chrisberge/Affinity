//
//  RootViewController.m
//  Affinity
//
//  Created by Christophe Bergé on 16/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController

@synthesize tableauAnnonces1, criteres1, criteres2;

- (void)viewDidLoad {
    appDelegate = (AffinityAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    /*--- STOCKAGE DES ANNONCES ET CRITERES DE RECHERCHE ---*/
    nbRequetes = 0;
    
	criteres1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
				@"", @"transaction",
                @"", @"villes",
				@"", @"ville1",
				@"", @"ville2",
				@"", @"ville3",
                @"", @"ville4",
				@"", @"cp1",
				@"", @"cp2",
				@"", @"cp3",
                @"", @"cp4",
				@"", @"types",
                @"", @"nbPieces",
				@"", @"nb_pieces_mini",
				@"", @"nb_pieces_maxi",
				@"", @"prix_mini",
				@"", @"prix_maxi",
				@"", @"surface_mini",
				@"", @"surface_maxi",
				nil];
    
    criteres2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                 @"", @"transaction",
                 @"", @"villes",
                 @"", @"ville1",
                 @"", @"ville2",
                 @"", @"ville3",
                 @"", @"ville4",
                 @"", @"cp1",
                 @"", @"cp2",
                 @"", @"cp3",
                 @"", @"cp4",
                 @"", @"types",
                 @"", @"nbPieces",
                 @"", @"nb_pieces_mini",
                 @"", @"nb_pieces_maxi",
                 @"", @"prix_mini",
                 @"", @"prix_maxi",
                 @"", @"surface_mini",
                 @"", @"surface_maxi",
                 nil];
    
    typeBien = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                @"appartement", @"0",
                @"maison", @"1",
                @"terrain", @"2",
                @"bureau", @"3",
                @"commerce", @"4",
                @"immeuble", @"5",
                @"parking", @"6",
                @"autres", @"7",
                nil];
    
	tableauAnnonces1 = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(citySelectedMulti:) name:@"citySelectedMulti" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(typesSelectedMulti:) name:@"typesSelectedMulti" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(surfaceSelectedMulti:) name:@"surfaceSelectedMulti" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(nbPiecesSelectedMulti:) name:@"nbPiecesSelectedMulti" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(budgetSelectedMulti:) name:@"budgetSelectedMulti" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(getCriteresMulti:) name:@"getCriteresMulti" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(indexPathsSelected:) name:@"indexPathsSelected" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(getIndexPaths:) name:@"getIndexPaths" object: nil];
    
    isConnectionErrorPrinted = NO;
    
    /*--- QUEUE POUR LES REQUETES HTTP ---*/
    networkQueue = [[ASINetworkQueue alloc] init];
    [networkQueue reset];
	[networkQueue setRequestDidFinishSelector:@selector(requestDone:)];
	[networkQueue setRequestDidFailSelector:@selector(requestFailed:)];
	[networkQueue setDelegate:self];
    /*--- QUEUE POUR LES REQUETES HTTP ---*/
    
    /*--- STOCKAGE DES ANNONCES ET CRITERES DE RECHERCHE ---*/
    
    /*--- INTERFACE GRAPHIQUE ---*/
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,480)];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    UIImageView *enTete = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header.png"]];
    [enTete setFrame:CGRectMake(0,0,320,50)];
    [self.view addSubview:enTete];
    
    [enTete release];
    
    //BANDEAU RECHERCHE
    UIImageView *sousEnTete = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bandeau-recherche-multicritere.png"]];
    [sousEnTete setFrame:CGRectMake(0,50,320,20)];
    [self.view addSubview:sousEnTete];
    
    /*--- BOUTONS ---*/
    int xPos = 30;
    int yPos = 110;
    int yDecalage = 50;
    int xSize = 260;
    int ySize = 45;
    
    //BOUTON RETOUR
    UIButton *boutonRetour = [UIButton buttonWithType:UIButtonTypeCustom];
    boutonRetour.showsTouchWhenHighlighted = NO;
    boutonRetour.tag = 6;
    
    [boutonRetour setFrame:CGRectMake(10,7,50,30)];
    [boutonRetour addTarget:self action:@selector(buttonPushed:) 
           forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageNamed:@"bouton-retour.png"];
    [boutonRetour setImage:image forState:UIControlStateNormal];
    
    [self.view addSubview:boutonRetour];
    
    //BOUTON ACHAT
    UIButton *boutonAchat = [UIButton buttonWithType:UIButtonTypeCustom];
    boutonAchat.tag = 7;
    boutonAchat.showsTouchWhenHighlighted = NO;
    
    [boutonAchat setFrame:CGRectMake(xPos,yPos - 35,110,30)];
    [boutonAchat addTarget:self action:@selector(buttonPushed:) 
          forControlEvents:UIControlEventTouchUpInside];
    
    image = [self getImage:@"achat"];
	[boutonAchat setImage:image forState:UIControlStateNormal];
    
    [self.view addSubview:boutonAchat];
    
    //BOUTON LOCATION
    UIButton *boutonLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    boutonLocation.tag = 8;
    boutonLocation.showsTouchWhenHighlighted = NO;
    
    [boutonLocation setFrame:CGRectMake(xPos + 147,yPos - 35,110,30)];
    [boutonLocation addTarget:self action:@selector(buttonPushed:) 
          forControlEvents:UIControlEventTouchUpInside];
    
    image = [self getImage:@"location"];
	[boutonLocation setImage:image forState:UIControlStateNormal];
    
    [self.view addSubview:boutonLocation];
    
    //IMAGE COCHE
    coche = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coche.png"]];
    [coche setFrame:CGRectMake(103, yPos - 33, 25, 25)];
    [self.view addSubview:coche];
    coche.tag = 100;
    [criteres1 setValue:@"0" forKey:@"transaction"];
    
    //BOUTON VILLE
    UIButton *boutonVille = [UIButton buttonWithType:UIButtonTypeCustom];
    boutonVille.tag = 0;
    boutonVille.showsTouchWhenHighlighted = NO;
    
    [boutonVille setFrame:CGRectMake(xPos,yPos,xSize,ySize)];
    [boutonVille addTarget:self action:@selector(buttonPushed:) 
              forControlEvents:UIControlEventTouchUpInside];
    
    image = [self getImage:@"ville-departement-etc"];
	[boutonVille setImage:image forState:UIControlStateNormal];
    
    labelVille = [[UILabel alloc] initWithFrame:CGRectMake(xPos + 65, yPos + 2, xSize - 92, ySize)];
    labelVille.font = [UIFont fontWithName:@"Arial-BoldMT" size:10];
    labelVille.textColor = [UIColor whiteColor];
    labelVille.backgroundColor = [UIColor clearColor];
    labelVille.text = @"";
    
    [self.view addSubview:boutonVille];
    [self.view addSubview:labelVille];
    
    //BOUTON TYPE DE BIEN
    UIButton *boutonTypeBien = [UIButton buttonWithType:UIButtonTypeCustom];
    boutonTypeBien.tag = 1;
    boutonTypeBien.showsTouchWhenHighlighted = NO;
    
    [boutonTypeBien setFrame:CGRectMake(xPos,yPos + yDecalage,xSize,ySize)];
    [boutonTypeBien addTarget:self action:@selector(buttonPushed:) 
          forControlEvents:UIControlEventTouchUpInside];
    
    image = [self getImage:@"type-de-biens"];
	[boutonTypeBien setImage:image forState:UIControlStateNormal];
    
    labelTypeBien = [[UILabel alloc] initWithFrame:CGRectMake(xPos + 65, yPos + 2 + yDecalage, xSize - 92, ySize)];
    labelTypeBien.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    labelTypeBien.textColor = [UIColor whiteColor];
    labelTypeBien.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:boutonTypeBien];
    [self.view addSubview:labelTypeBien];
    
    //BOUTON SURFACE
    UIButton *boutonSurface = [UIButton buttonWithType:UIButtonTypeCustom];
    boutonSurface.tag = 2;
    boutonSurface.showsTouchWhenHighlighted = NO;
    
    [boutonSurface setFrame:CGRectMake(xPos,yPos + (yDecalage * 2),xSize,ySize)];
    [boutonSurface addTarget:self action:@selector(buttonPushed:) 
             forControlEvents:UIControlEventTouchUpInside];
    
    image = [self getImage:@"surface"];
	[boutonSurface setImage:image forState:UIControlStateNormal];
    
    labelSurface = [[UILabel alloc] initWithFrame:CGRectMake(xPos + 65, yPos + (yDecalage * 2) + 2, xSize, ySize)];
    labelSurface.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    labelSurface.textColor = [UIColor whiteColor];
    labelSurface.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:boutonSurface];
    [self.view addSubview:labelSurface];
    
    //BOUTON NB PIECE
    UIButton *boutonNbPiece = [UIButton buttonWithType:UIButtonTypeCustom];
    boutonNbPiece.tag = 3;
    boutonNbPiece.showsTouchWhenHighlighted = NO;
    
    [boutonNbPiece setFrame:CGRectMake(xPos,yPos + (yDecalage * 3),xSize,ySize)];
    [boutonNbPiece addTarget:self action:@selector(buttonPushed:) 
            forControlEvents:UIControlEventTouchUpInside];
    
    image = [self getImage:@"nombre-de-pieces"];
	[boutonNbPiece setImage:image forState:UIControlStateNormal];
    
    labelNbPiece = [[UILabel alloc] initWithFrame:CGRectMake(xPos + 65, yPos + (yDecalage * 3) + 2, xSize, ySize)];
    labelNbPiece.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    labelNbPiece.textColor = [UIColor whiteColor];
    labelNbPiece.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:boutonNbPiece];
    [self.view addSubview:labelNbPiece];
    
    //BOUTON BUDGET
    UIButton *boutonBudget = [UIButton buttonWithType:UIButtonTypeCustom];
    boutonBudget.tag = 4;
    boutonBudget.showsTouchWhenHighlighted = NO;
    
    [boutonBudget setFrame:CGRectMake(xPos,yPos + (yDecalage * 4),xSize,ySize)];
    [boutonBudget addTarget:self action:@selector(buttonPushed:) 
            forControlEvents:UIControlEventTouchUpInside];
    
    image = [self getImage:@"budget"];
	[boutonBudget setImage:image forState:UIControlStateNormal];
    
    labelBudget = [[UILabel alloc] initWithFrame:CGRectMake(xPos + 65, yPos + (yDecalage * 4) + 2, xSize, ySize)];
    labelBudget.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    labelBudget.textColor = [UIColor whiteColor];
    labelBudget.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:boutonBudget];
    [self.view addSubview:labelBudget];
    
    //BOUTON RECHERCHE
    UIButton *boutonRecherche = [UIButton buttonWithType:UIButtonTypeCustom];
    boutonRecherche.tag = 5;
    boutonRecherche.showsTouchWhenHighlighted = NO;
    
    [boutonRecherche setFrame:CGRectMake(xPos,yPos + (yDecalage * 5),xSize,ySize)];
    [boutonRecherche addTarget:self action:@selector(buttonPushed:) 
            forControlEvents:UIControlEventTouchUpInside];
    
    image = [self getImage:@"rechercher"];
	[boutonRecherche setImage:image forState:UIControlStateNormal];
    
    [self.view addSubview:boutonRecherche];
    /*--- INTERFACE GRAPHIQUE ---*/
    
}

-(UIImage *) getImage:(NSString *)cheminImage{
	UIImage *image = [UIImage imageWithContentsOfFile:
					  [[NSBundle mainBundle] pathForResource:
					   cheminImage ofType:@"png"]];
	
	return image;
}

- (void) buttonPushed:(id)sender
{
	UIButton *button = sender;
	switch (button.tag) {
        case 0:
            NSLog(@"Ville");
            ChoixVilleController3 *choixVille = [[ChoixVilleController3 alloc] init];
            [self.navigationController pushViewController:choixVille animated:YES];
            [choixVille release];
            choixVille = nil;
            break;
		case 1:
            NSLog(@"Type de bien");
            SelectionTypeBienController *selectionTypeBienController =
			[[SelectionTypeBienController alloc] initWithStyle:UITableViewStylePlain];
            selectionTypeBienController.title = @"Type de bien";
            [self.navigationController pushViewController:selectionTypeBienController animated:YES];
            [selectionTypeBienController release];
            selectionTypeBienController = nil;
			break;
		case 2:
            NSLog(@"Surface");
            SelectionSurfaceController *selectionSurfaceController =
            [[SelectionSurfaceController alloc] initWithNibName:@"SelectionSurfaceController" bundle:nil];
            selectionSurfaceController.title = @"Surface";
            [self.navigationController pushViewController:selectionSurfaceController animated:YES];
            [selectionSurfaceController release];
            selectionSurfaceController = nil;
            break;
        case 3:
            NSLog(@"Nombre de pieces");
            SelectionNbPiecesController *selectionNbPiecesController =
			[[SelectionNbPiecesController alloc] initWithNibName:@"SelectionNbPiecesController" bundle:nil];
            selectionNbPiecesController.title = @"Nombre de pieces";
            [self.navigationController pushViewController:selectionNbPiecesController animated:YES];
            [selectionNbPiecesController release];
            selectionNbPiecesController = nil;
            break;
        case 4:
            NSLog(@"Budget");
            SelectionBudgetController *selectionBudgetController =
            [[SelectionBudgetController alloc] initWithNibName:@"SelectionBudgetController" bundle:nil];
            selectionBudgetController.title = @"Budget";
            [self.navigationController pushViewController:selectionBudgetController animated:YES];
            [selectionBudgetController release];
            selectionBudgetController = nil;
            break;
        case 5:
            NSLog(@"Lancer la recherche");
            /*if ([criteres1 valueForKey:@"ville1"] == @"") {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Veuillez choisir au moins une ville."
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                
            }
            else {*/
                
                //ENVOYER LA REQUETE ET AFFICHER LES RESULTATS
                isConnectionErrorPrinted = NO;
                [tableauAnnonces1 removeAllObjects];
                nbRequetes = 0;
                [self makeRequest];
                
            //}
            break;
        case 6:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 7:
            [coche setFrame:CGRectMake(103, 77, 25, 25)];
            [criteres1 setValue:@"0" forKey:@"transaction"];
            coche.tag = 100;
            break;
        case 8:
            [coche setFrame:CGRectMake(255, 77, 25, 25)];
            [criteres1 setValue:@"1" forKey:@"transaction"];
            coche.tag = 101;
            break;
		default:
			break;
	}
}

- (void)makeRequest{
    
    NSString *bodyString = [NSString stringWithFormat:@"%@",
                            appDelegate.url_serveur];
    
    NSEnumerator *enume;
    NSString *key;
    
    [criteres1 setValue:@"" forKey:@"nbPieces"];
    [criteres1 setValue:@"" forKey:@"villes"];
    
    /*--- CODE POSTAL POUR TESTS ---*/
    //[criteres1 setValue:@"PRANGINS" forKey:@"ville1"];
    /*--- CODE POSTAL POUR TESTS ---*/
    
    enume = [criteres1 keyEnumerator];
    
    [criteres2 removeAllObjects];
    
    /*--- REQUETE POST ---*/
    NSURL *url = [NSURL URLWithString:bodyString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    while((key = [enume nextObject])) {
        if ([criteres1 objectForKey:key] != @"") {
            [request setPostValue:[criteres1 valueForKey:key] forKey:key];
            [criteres2 setObject:[criteres1 objectForKey:key] forKey:key];
        }
    }
    
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"recherche multicriteres" forKey:@"name"]];
    
    [networkQueue addOperation:request];
    [networkQueue go];
    /*--- REQUETE POST ---*/
}

/*- (void)makeRequestSaveGET{
    nbRequetes++;
    
    if (nbRequetes > 2) {
        return;
    }
    
    NSString *bodyString = [NSString stringWithFormat:@"%@?part=%@&id_agence=%@&%@&",
                            appDelegate.url_serveur,
                            appDelegate.partenaire,
                            appDelegate.id_agence,
                            appDelegate.transition];
    
    NSEnumerator *enume;
    NSString *key;
    
    [criteres1 setValue:@"" forKey:@"nbPieces"];
    [criteres1 setValue:@"" forKey:@"villes"];
    
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
            
            [criteres2 setValue:[criteres1 valueForKey:key] forKey:key];
            NSLog(@"ici criteres2: %@",criteres2);
        }
    }

    NSLog(@"bodyString:%@\n",bodyString);

    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:bodyString]] autorelease];
    [request setUserInfo:[NSDictionary dictionaryWithObject:[NSString stringWithString:@"recherche multicriteres"] forKey:@"name"]];
    [networkQueue addOperation:request];

    [networkQueue go];
}*/

- (void) getCriteresMulti:(NSNotification *)notify {
    NSLog(@"criteres1 getCrit: %@",criteres1);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setCriteres" object: criteres1];
}

- (void) citySelectedMulti:(NSNotification *)notify {
	NSMutableArray *array = [notify object];
    
    if ([array count] != 0) {
        int i=0;
        for (NSDictionary *dict in array) {
            NSString *cp = [NSString stringWithFormat:@"cp%d",i+1];
            NSString *ville = [NSString stringWithFormat:@"ville%d",i+1];
            [criteres1 setValue:[dict valueForKey:@"code"] forKey:cp];
            [criteres1 setValue:[dict valueForKey:@"commune"] forKey:ville];
            i++;
        }
    
    }
	NSLog(@"criteres1: %@",criteres1);
}

- (void) indexPathsSelected:(NSNotification *)notify {
    indexPathsVilles = [[NSMutableArray alloc] initWithArray:[notify object] copyItems:YES];
}

- (void) getIndexPaths:(NSNotification *)notify {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setIndexes" object: indexPathsVilles];
}

- (void) typesSelectedMulti:(NSNotification *)notify {
	NSMutableArray *typesSelected = [notify object];
    
	NSString *types = @"";
	
	NSUInteger nbTypes = [typesSelected count];
	
	for (int i = 0; i < nbTypes; i++) {
        NSIndexPath *indexPath = [typesSelected objectAtIndex:i];
        NSString *string = [NSString stringWithFormat:@"%d", indexPath.row];
		types = [types stringByAppendingString:string];
		
		if (i < (nbTypes - 1)) {
            types = [types stringByAppendingString:@","];
        }
        
	}
	
	[criteres1 setValue:types forKey:@"types"];
    NSLog(@"criteres1: %@",criteres1);
}

- (void) nbPiecesSelectedMulti:(NSNotification *)notify {
    NSMutableArray *nbPiecesSelected = [notify object];
    NSLog(@"nbpieces: %@", nbPiecesSelected);
    
    NSString *nbPiecess = @"";
	
	NSUInteger nbNbPieces = [nbPiecesSelected count];
	
	for (int i = 0; i < nbNbPieces; i++) {
        NSIndexPath *indexPath = [nbPiecesSelected objectAtIndex:i];
        NSString *string = [NSString stringWithFormat:@"%d", indexPath.row];
		nbPiecess = [nbPiecess stringByAppendingString:string];
		
		if (i < (nbNbPieces - 1)) {
            nbPiecess = [nbPiecess stringByAppendingString:@","];
        }
        
	}
	
    
    NSLog(@"nombre de pieces: %@", nbPiecess);
    
    NSMutableArray *nbPiecesArray = [[NSMutableArray alloc] initWithArray:[nbPiecess componentsSeparatedByString:@","]];
    
    [nbPiecesArray sortUsingSelector:@selector(caseInsensitiveCompare:)];
    
    NSString *mini = [NSString stringWithFormat:@"%d",[[nbPiecesArray objectAtIndex:0] intValue] + 1];
    NSString *maxi = [NSString stringWithFormat:@"%d",[[nbPiecesArray lastObject] intValue] + 1];
    
    [criteres1 setValue:mini forKey:@"nb_pieces_mini"];
    [criteres1 setValue:maxi forKey:@"nb_pieces_maxi"];
    
    [criteres1 setValue:nbPiecess forKey:@"nbPieces"];
    NSLog(@"criteres1: %@",criteres1);
    
    [nbPiecesArray release];
    
}

- (void) surfaceSelectedMulti:(NSNotification *)notify {
	Intervalle *intervalle = [notify object];
	int min = [intervalle min];
	int max = [intervalle max];
	
	if ((min != 0) && (max != 0)) {
		[criteres1 setValue:[@"" stringByAppendingFormat:@"%d",min] forKey:@"surface_mini"];
		[criteres1 setValue:[@"" stringByAppendingFormat:@"%d",max] forKey:@"surface_maxi"];
	}
    
    if ((min != 0) && (max == 0)) {
		[criteres1 setValue:[@"" stringByAppendingFormat:@"%d",min] forKey:@"surface_mini"];
        [criteres1 setValue:@"" forKey:@"surface_maxi"];
	}
    
    if ((min == 0) && (max != 0)) {
        [criteres1 setValue:@"" forKey:@"surface_mini"];
		[criteres1 setValue:[@"" stringByAppendingFormat:@"%d",max] forKey:@"surface_maxi"];
	}
    
    if ((min == 0) && (max ==0)) {
        [criteres1 setValue:@"" forKey:@"surface_mini"];
        [criteres1 setValue:@"" forKey:@"surface_maxi"];
    }
    
    NSLog(@"criteres1: %@",criteres1);
}

- (void) budgetSelectedMulti:(NSNotification *)notify {
	Intervalle *intervalle = [notify object];
	int min = [intervalle min];
	int max = [intervalle max];
	
	if ((min != 0) && (max != 0)) {
		[criteres1 setValue:[@"" stringByAppendingFormat:@"%d",min] forKey:@"prix_mini"];
		[criteres1 setValue:[@"" stringByAppendingFormat:@"%d",max] forKey:@"prix_maxi"];
	}
    
    if ((min != 0) && (max == 0)) {
		[criteres1 setValue:[@"" stringByAppendingFormat:@"%d",min] forKey:@"prix_mini"];
        [criteres1 setValue:@"" forKey:@"prix_maxi"];
	}
    
    if ((min == 0) && (max != 0)) {
        [criteres1 setValue:@"" forKey:@"prix_mini"];
		[criteres1 setValue:[@"" stringByAppendingFormat:@"%d",max] forKey:@"prix_maxi"];
	}
    
    if((min == 0) && (max == 0))
    {
        [criteres1 setValue:@"" forKey:@"prix_mini"];
        [criteres1 setValue:@"" forKey:@"prix_maxi"];
    }
    
    NSLog(@"criteres1: %@",criteres1);
}

- (void)requestDone:(ASIHTTPRequest *)request
{
	NSData *responseData = [request responseData];
    
    NSLog(@"dataBrute long: %d",[responseData length]);
    
    NSString * string = [[NSString alloc] initWithData:responseData encoding:NSISOLatin1StringEncoding];
    
    NSLog(@"REPONSE DU WEB: \"%@\"\n",string);
    
    NSError *error = nil;
    
    if ([string length] > 0) {
        
        NSUInteger zap = 39;
        
        NSData *dataString = [string dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:YES];
        
        NSData *data = [[NSData alloc] initWithData:[dataString subdataWithRange:NSMakeRange(38, [dataString length] - zap)]];
        //NSData *data = [[NSData alloc] initWithData:responseData];
        
        //ON PARSE DU XML
        
        /*--- POUR LE TEST OFF LINE ---
         NSFileManager *fileManager = [NSFileManager defaultManager];
         NSString *xmlSamplePath = [[NSBundle mainBundle] pathForResource:@"Biens" ofType:@"xml"];
         data = [fileManager contentsAtPath:xmlSamplePath];
         string = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
         NSLog(@"REPONSE DU WEB: %@\n",string);
         */
        
        if ([string rangeOfString:@"<Annonces></Annonces>"].length != 0) {
            //AUCUNE ANNONCES
            NSDictionary *userInfo;
            UIAlertView *alert;
            
            if (nbRequetes < 2 && ([criteres1 valueForKey:@"cp1"] != @"")) {
                userInfo = [NSDictionary 
                                          dictionaryWithObject:@"Votre recherche a été élargie à tout le département."
                                          forKey:NSLocalizedDescriptionKey];
                
                error =[NSError errorWithDomain:@"Recherche élargie."
                                           code:1 userInfo:userInfo];
                
                alert = [[UIAlertView alloc] initWithTitle:@"Recherche élargie"
                                                                message:[error localizedDescription]
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                
                NSString *cpCritere = [criteres1 valueForKey:@"cp1"];
                NSString *cp = [cpCritere substringToIndex:2];
                NSLog(@"cp elargi: %@", cp);
                
                [criteres1 setValue:cp forKey:@"cp1"];
                [self makeRequest];
            }
            else{
                userInfo = [NSDictionary 
                                          dictionaryWithObject:@"Aucun bien ne correspond à ces critères dans notre base de données."
                                          forKey:NSLocalizedDescriptionKey];
                
                error =[NSError errorWithDomain:@"Aucun bien trouvé."
                                           code:1 userInfo:userInfo];
                
                alert = [[UIAlertView alloc] initWithTitle:@"Aucun bien trouvé"
                                                                message:[error localizedDescription]
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                //[criteres1 setValue:@"" forKey:@"cp1"];
            }
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
            
            [self sauvegardeRecherches];
            
            NSString *transaction = [NSString stringWithFormat:@"%d", coche.tag - 100];
            [criteres1 setValue:transaction forKey:@"transaction"];
            
            AfficheListeAnnoncesController2 *afficheListeAnnoncesController = 
            [[AfficheListeAnnoncesController2 alloc] init];
            [self.navigationController pushViewController:afficheListeAnnoncesController animated:YES];
            [afficheListeAnnoncesController release];
            
            [xmlParser release];
            [parser release];
            
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

-(void) sauvegardeRecherches{
	int i = 0;
	NSMutableDictionary *recherche;
	NSMutableArray *recherches = [[NSMutableArray alloc] init];
	NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	
	for (i = 0; i < 3; i++) {
		[recherches addObject:@""];
		if ((recherche = [NSDictionary dictionaryWithContentsOfFile:
						  [directory stringByAppendingPathComponent:
						   [@"" stringByAppendingFormat:@"%d.plist",i+1]]]) != nil ) {
                              [recherches replaceObjectAtIndex:i withObject:recherche];
                          }
	}
	
	for (i = 2; i > 0; i--) {
		if ([recherches objectAtIndex:i-1] != @"") {
			[recherches replaceObjectAtIndex:i withObject:[recherches objectAtIndex:i-1]];
		}
	}
	
	[recherches replaceObjectAtIndex:0 withObject:criteres2];
	
	for (i = 0; i < 3; i++) {
		if ([recherches objectAtIndex:i] != @"") {
			recherche = [recherches objectAtIndex:i];
			[recherche writeToFile:[directory stringByAppendingPathComponent:
									[@"" stringByAppendingFormat:@"%d.plist",i+1]] atomically:YES];
		}
	}
	NSLog(@"recherches: %@",recherches);
    [recherche release];
    //[recherches release];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)viewWillAppear:(BOOL)animated {
    nbRequetes = 0;
    //AFFICHAGE DES CRITERES CHOISIS
    
    //VILLE
    labelVille.text = @"";
    for (int i = 1; i <= 4; i++) {
        
        NSString *ville = [NSString stringWithFormat:@"ville%d", i];
        
        if ([criteres1 valueForKey:ville] != @"" && [criteres1 valueForKey:ville] != nil) {
            if (labelVille.text == @"") {
                labelVille.text = [NSString stringWithFormat:@"%@", [criteres1 valueForKey:ville]];
            }
            else{
                labelVille.text = [labelVille.text stringByAppendingFormat:@",%@", [criteres1 valueForKey:ville]];
            }
        }
    }
    
    //TYPES DE BIEN
    NSString *types = [criteres1 valueForKey:@"types"];
    
    NSMutableArray *arrayTypes = [[NSMutableArray alloc] initWithArray:[types componentsSeparatedByString:@","]];
    
    NSString *typesPrint = @"";
    
    for (NSString *type in arrayTypes) {
        if (typesPrint == @"") {
            typesPrint = [typeBien valueForKey:type];
        }
        else{
            typesPrint = [typesPrint stringByAppendingFormat:@",%@",[typeBien valueForKey:type]];
        }
        
    }
    
    labelTypeBien.text = typesPrint;
    
    //SURFACE
    if ([criteres1 valueForKey:@"surface_mini"] != @"" && [criteres1 valueForKey:@"surface_maxi"] != @"") {
        labelSurface.text = [NSString stringWithFormat:@"De %d m² à %d m²",
                         [[criteres1 valueForKey:@"surface_mini"] intValue],
                         [[criteres1 valueForKey:@"surface_maxi"] intValue]];
    }
    
    if ([criteres1 valueForKey:@"surface_mini"] != @"" && [criteres1 valueForKey:@"surface_maxi"] == @"") {
        labelSurface.text = [NSString stringWithFormat:@"A partir de %d m²",
                             [[criteres1 valueForKey:@"surface_mini"] intValue]];
    }
    
    if ([criteres1 valueForKey:@"surface_mini"] == @"" && [criteres1 valueForKey:@"surface_maxi"] != @"") {
        labelSurface.text = [NSString stringWithFormat:@"Jusqu'à %d m²",
                             [[criteres1 valueForKey:@"surface_maxi"] intValue]];
    }
    
    if ([criteres1 valueForKey:@"surface_mini"] == @"" && [criteres1 valueForKey:@"surface_maxi"] == @"") {
        labelSurface.text = @"";
    }
    
    //NOMBRE DE PIECES
    if ([criteres1 valueForKey:@"nb_pieces_mini"] != @"" || [criteres1 valueForKey:@"nb_pieces_maxi"] != @"") {
        labelNbPiece.text = [NSString stringWithFormat:@"De %@ piece(s) à %@ pieces",
                             [criteres1 valueForKey:@"nb_pieces_mini"],
                             [criteres1 valueForKey:@"nb_pieces_maxi"]];
    }
    
    //BUDGET
    if ([criteres1 valueForKey:@"prix_mini"] != @"" && [criteres1 valueForKey:@"prix_maxi"] == @"") {
        NSNumber *formattedResult;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setGroupingSeparator:@" "];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        formattedResult = [NSNumber numberWithInt:[[criteres1 valueForKey:@"prix_mini"] intValue]];
        
        NSString *prix_mini = [formatter stringForObjectValue:formattedResult];
        prix_mini = [prix_mini stringByAppendingString:@"€"];
        
        labelBudget.text = [NSString stringWithFormat:@"A partir de %@",
                            prix_mini];
    }
    
    if ([criteres1 valueForKey:@"prix_mini"] == @"" && [criteres1 valueForKey:@"prix_maxi"] != @"") {
        NSNumber *formattedResult;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setGroupingSeparator:@" "];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        formattedResult = [NSNumber numberWithInt:[[criteres1 valueForKey:@"prix_maxi"] intValue]];
        
        NSString *prix_maxi = [formatter stringForObjectValue:formattedResult];
        prix_maxi = [prix_maxi stringByAppendingString:@"€"];
        
        labelBudget.text = [NSString stringWithFormat:@"Jusqu'à %@",
                            prix_maxi];
    }
    
    if ([criteres1 valueForKey:@"prix_mini"] != @"" && [criteres1 valueForKey:@"prix_maxi"] != @"") {
        
        NSNumber *formattedResult;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setGroupingSeparator:@" "];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        formattedResult = [NSNumber numberWithInt:[[criteres1 valueForKey:@"prix_mini"] intValue]];
        
        NSString *prix_mini = [formatter stringForObjectValue:formattedResult];
        prix_mini = [prix_mini stringByAppendingString:@"€"];
        
        formattedResult = [NSNumber numberWithInt:[[criteres1 valueForKey:@"prix_maxi"] intValue]];
        
        NSString *prix_maxi = [formatter stringForObjectValue:formattedResult];
        prix_maxi = [prix_maxi stringByAppendingString:@"€"];
        
        [formatter release];
        
        labelBudget.text = [NSString stringWithFormat:@"De %@ à %@",
                             prix_mini,
                             prix_maxi];
    }
    
    if ([criteres1 valueForKey:@"prix_mini"] == @"" && [criteres1 valueForKey:@"prix_maxi"] == @"") {
        labelBudget.text = @"";
    }
    
    [super viewWillAppear:animated];
}

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


- (void)dealloc {
    [self.view release];
    [tableauAnnonces1 release];
	[criteres1 release];
    [criteres2 release];
    [networkQueue release];
    [coche release];
    [labelVille release];
    [labelTypeBien release];
    [labelSurface release];
    [labelNbPiece release];
    [labelBudget release];
    [typeBien release];
    [indexPathsVilles release];
    [super dealloc];
}


@end

