//
//  AfficheAnnonceControllerFavoris.m
//  Affinity
//
//  Created by Christophe Bergé on 13/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AfficheAnnonceControllerFavoris.h"

@implementation AfficheAnnonceControllerFavoris

- (void)diapoControllerDidFinish:(DiapoController3 *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

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
    [imagesArray release];
	[arrayWithIndex release];
	//[lAnnonce release];
    [myOpenFlowView release];
    myOpenFlowView = nil;
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
    arrayWithIndex = [[ArrayWithIndex alloc] init];
    
    appDelegate = (AffinityAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(afficheDiaporamaReady:) name:@"afficheDiaporamaReady" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(coverFlowFicheDetaillee:) name:@"coverFlowFicheDetaillee" object: nil];
    
	lAnnonce = appDelegate.annonceFavoris;
    
    UIColor *fond = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = fond;
    [fond release];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //SCROLLVIEW
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, 320, 340)];
    [scrollView setContentSize:CGSizeMake(320, 1120)];
    [scrollView setScrollEnabled:YES];
    [self.view addSubview:scrollView];
    
    //HEADER
    UIImageView *enTete = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header.png"]];
    [enTete setFrame:CGRectMake(0,0,320,50)];
    [self.view addSubview:enTete];
    [enTete release];
    
    /*--- BANDEAU FICHE DETAILLE ---*/
    UIImageView *bandeauFiche = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bandeau-fiche-detaillee.png"]];
    [bandeauFiche setFrame:CGRectMake(0,50,320,20)];
    [self.view addSubview:bandeauFiche];
    [bandeauFiche release];
    /*--- BANDEAU FICHE DETAILLE ---*/
    
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
    
    /*--- BANDEAU VIERGE ---*/
    /*UIImageView *vierge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bandeau-vierge.png"]];
     [vierge setFrame:CGRectMake(0,50,320,20)];
     [self.view addSubview:vierge];
     [vierge release];*/
    /*--- BANDEAU VIERGE ---*/
    
    /*--- CRITERES ---*/
    
    UILabel *labelPrix = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 75, 20)];
    labelPrix.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    labelPrix.textAlignment = UITextAlignmentLeft;
    labelPrix.backgroundColor = [UIColor clearColor];
    labelPrix.textColor = [UIColor colorWithRed:244.0 green:0.0 blue:161.0 alpha:1.0];
    
    UILabel *labelVille = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 320, 20)];
    labelVille.font = [UIFont fontWithName:@"Arial" size:11];
    labelVille.textAlignment = UITextAlignmentLeft;
    labelVille.backgroundColor = [UIColor clearColor];
    
    UILabel *labelSurface = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 320, 20)];
    labelSurface.font = [UIFont fontWithName:@"Arial-BoldMT" size:11];
    labelSurface.textAlignment = UITextAlignmentLeft;
    labelSurface.backgroundColor = [UIColor clearColor];
    
    NSString *isS = @"";
    NSString *nb_pieces = [lAnnonce valueForKey:@"nb_pieces"];
    nb_pieces = [nb_pieces stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if ([nb_pieces intValue] > 1) {
        isS = @"s";
    }
    
    NSString *prix = [lAnnonce valueForKey:@"prix"];
    prix = [prix stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSNumber *formattedResult;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setGroupingSeparator:@" "];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    formattedResult = [NSNumber numberWithInt:[prix intValue]];
    prix = [formatter stringForObjectValue:formattedResult];
    
    [formatter release];
    
    labelPrix.text = [NSString stringWithFormat:@"%@ €", prix];
    
    labelVille.text = [NSString stringWithFormat:@"%@ - %@",
                       [[lAnnonce valueForKey:@"ville"] substringFromIndex:1],
                       [[lAnnonce valueForKey:@"cp"] substringFromIndex:1]
                       ];
    
    labelSurface.text = [NSString stringWithFormat:@"%@ %@m², %@ piece%@",
                         [lAnnonce valueForKey:@"type"],
                         [lAnnonce valueForKey:@"surface"],
                         nb_pieces,
                         isS
                         ];
    
    [scrollView addSubview:labelPrix];
    [scrollView addSubview:labelVille];
    [scrollView addSubview:labelSurface];
    
    [labelPrix release];
    [labelVille release];
    [labelSurface release];
    
    /*--- CRITERES ---*/
    
    /*--- COVER FLOW ---*/
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"whichViewFrom" object: @"Fiche détaillée"];
    
    myOpenFlowView = [[AFOpenFlowViewDiapo alloc] init];
    [myOpenFlowView setFrame:CGRectMake(10, 65, 300, 130)];
    
    NSString *string = [lAnnonce valueForKey:@"photos"];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	
    if ([string length] > 0) {
		imagesArray = [[NSMutableArray alloc] initWithArray:[string componentsSeparatedByString:@","]];
		
		arrayWithIndex.array = imagesArray;
    }
    
    [myOpenFlowView setNumberOfImages:[imagesArray count]];
    
	for (int index = 0; index < [imagesArray count]; index++){
		NSData* imageData = [[NSData alloc]initWithContentsOfURL:
                             [NSURL URLWithString:
                              [NSString stringWithFormat:@"%@",
                               [imagesArray objectAtIndex:index]]]];
        if (imageData != nil) {
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            [myOpenFlowView setImage:image forIndex:index];
        }
        [imageData release];
        
	}
    
    [scrollView addSubview:myOpenFlowView];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"whichViewFrom" object: @"Fiche détaillée"];
    
    /*--- COVER FLOW ---*/
    
    /*--- DESCRIPTION ---*/
    //BANDEAU
    UIImageView *description = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bandeau-description.png"]];
    [description setFrame:CGRectMake(0,205,320,20)];
    [scrollView addSubview:description];
    [description release];
    
    //TEXTE
    UITextView *descriptif = [[UITextView alloc] initWithFrame:CGRectMake(0, 226, 320, 100)];
    descriptif.text = [lAnnonce valueForKey:@"descriptif"];
    descriptif.backgroundColor = [UIColor clearColor];
    descriptif.editable = NO;
    [scrollView addSubview:descriptif];
    [descriptif release];
    /*--- DESCRIPTION ---*/
    
    /*--- FICHE TECHNIQUE ---*/
    //BANDEAU
    UIImageView *ficheTechnique = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bandeau-fiche-technique.png"]];
    [ficheTechnique setFrame:CGRectMake(0,327,320,20)];
    [scrollView addSubview:ficheTechnique];
    [ficheTechnique release];
    
    /*---- INFOS ----*/
    UILabel *labelPrix2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 347, 200, 20)];
    UILabel *labelSurface2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 367, 200, 20)];
    UILabel *labelEtage = [[UILabel alloc] initWithFrame:CGRectMake(10, 387, 200, 20)];
    UILabel *labelAscenseur = [[UILabel alloc] initWithFrame:CGRectMake(10, 407, 200, 20)];
    UILabel *labelChauffage = [[UILabel alloc] initWithFrame:CGRectMake(10, 427, 200, 20)];
    
    labelPrix2.backgroundColor = [UIColor clearColor];
    labelPrix2.font = [UIFont fontWithName:@"Arial" size:12];
    labelPrix2.text = [NSString stringWithFormat:@"- Prix: %@€", prix];
    
    labelSurface2.backgroundColor = [UIColor clearColor];
    labelSurface2.font = [UIFont fontWithName:@"Arial" size:12];
    labelSurface2.text = [NSString stringWithFormat:@"- Surface: %@m²", [lAnnonce valueForKey:@"surface"]];
    
    labelEtage.backgroundColor = [UIColor clearColor];
    labelEtage.font = [UIFont fontWithName:@"Arial" size:12];
    labelEtage.text = [NSString stringWithFormat:@"- Etage: %@", [lAnnonce valueForKey:@"etage"]];
    //labelEtage.text = @"- Etage: 3";
    
    labelAscenseur.backgroundColor = [UIColor clearColor];
    labelAscenseur.font = [UIFont fontWithName:@"Arial" size:12];
    labelAscenseur.text = [NSString stringWithFormat:@"- Ascenseur: %@", [lAnnonce valueForKey:@"ascenseur"]];
    //labelAscenseur.text = @"- Ascenseur: Oui";
    
    NSDictionary *typeChauffage = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"radiateur",@"128",
                                   @"sol",@"256",
                                   @"mixte",@"384",
                                   @"gaz",@"512",
                                   @"gaz radiateur",@"640",
                                   @"gaz sol",@"768",
                                   @"gaz mixte",@"896",
                                   @"fuel",@"1024",
                                   @"fuel radiateur",@"1152",
                                   @"fuel sol",@"1280",
                                   @"fuel mixte",@"1408",
                                   @"électrique",@"2048",
                                   @"électrique radiateur",@"2176",
                                   @"électrique sol",@"2304",
                                   @"électrique mixte",@"2432",
                                   @"collectif",@"4096",
                                   @"collectif radiateur",@"4224",
                                   @"collectif sol",@"4352",
                                   @"collectif mixte",@"4480",
                                   @"collectif gaz",@"4608",
                                   @"collectif gaz radiateur",@"4736",
                                   @"collectif gaz sol",@"4864",
                                   @"collectif gaz mixte",@"4992",
                                   @"collectif fuel",@"5120",
                                   @"collectif fuel radiateur",@"5248",
                                   @"collectif fuel sol",@"5376",
                                   @"collectif fuel mixte",@"5504",
                                   @"collectif électrique",@"6144",
                                   @"collectif électrique radiateur",@"6272",
                                   @"collectif électrique sol",@"6400",
                                   @"collectif électrique mixte",@"6528",
                                   @"individuel",@"8192",
                                   @"individuel radiateur",@"8320",
                                   @"individuel sol",@"8448",
                                   @"individuel mixte",@"8576",
                                   @"individuel gaz",@"8704",
                                   @"individuel gaz radiateur",@"8832",
                                   @"individuel gaz sol",@"8960",
                                   @"individuel gaz mixte",@"9088",
                                   @"individuel fuel",@"9216",
                                   @"individuel fuel radiateur",@"9344",
                                   @"individuel fuel sol",@"9472",
                                   @"individuel fuel mixte",@"9600",
                                   @"individuel électrique",@"10240",
                                   @"individuel électrique radiateur",@"10368",
                                   @"individuel électrique sol",@"10496",
                                   @"individuel électrique mixte",@"10624",
                                   nil];
    
    labelChauffage.backgroundColor = [UIColor clearColor];
    labelChauffage.font = [UIFont fontWithName:@"Arial" size:12];
    NSString *chauffage = [lAnnonce valueForKey:@"chauffage"];
    chauffage = [chauffage stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    chauffage = [typeChauffage valueForKey:chauffage];
    
    if(chauffage == nil){
        chauffage = @"NC";
    }
    
    labelChauffage.text = [NSString stringWithFormat:@"- Chauffage: %@", chauffage];
    
    [scrollView addSubview:labelPrix2];
    [scrollView addSubview:labelSurface2];
    [scrollView addSubview:labelEtage];
    [scrollView addSubview:labelAscenseur];
    [scrollView addSubview:labelChauffage];
    
    [labelPrix2 release];
    [labelSurface2 release];
    [labelEtage release];
    [labelAscenseur release];
    [labelChauffage release];
    
    /*---- INFOS ----*/
    
    /*---- BILAN CONSO ENERGIE ----*/
    UILabel *bilanCe = [[UILabel alloc] initWithFrame:CGRectMake(10, 450, 250, 30)];
    bilanCe.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    bilanCe.text = @"Bilan consommation énergie";
    bilanCe.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:bilanCe];
    
    NSString *lettreCE = [lAnnonce valueForKey:@"bilan_ce"];
    //lettreCE = @"B";
    lettreCE = [lettreCE stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSLog(@"LETTRE CE: \"%@\"",lettreCE);
    
    int nextY = 500;
    BOOL isCe = NO;
    
    if ([lettreCE length] == 0) {
        UILabel *bilanCeNC = [[UILabel alloc] initWithFrame:CGRectMake(10, 480, 250, 20)];
        bilanCeNC.font = [UIFont fontWithName:@"Arial" size:12];
        bilanCeNC.text = @"NC";
        [scrollView addSubview:bilanCeNC];
    }
    
    if ([lettreCE length] > 0) {
        
        nextY = 670;
        isCe = YES;
        
        NSString *consoA = @"consommationenergieA";
        NSString *consoB = @"consommationenergieB";
        NSString *consoC = @"consommationenergieC";
        NSString *consoD = @"consommationenergieD";
        NSString *consoE = @"consommationenergieE";
        NSString *consoF = @"consommationenergieF";
        NSString *consoG = @"consommationenergieG";
        
        if (![lettreCE isEqualToString:@"A"]) {
            consoA = [consoA stringByAppendingString:@"_grisee.png"];
        }
        else{
            consoA = [consoA stringByAppendingString:@".png"];
        }
        
        if (![lettreCE isEqualToString:@"B"]) {
            consoB = [consoB stringByAppendingString:@"_grisee.png"];
        }
        else{
            consoB = [consoB stringByAppendingString:@".png"];
        }
        
        if (![lettreCE isEqualToString:@"C" ]) {
            consoC = [consoC stringByAppendingString:@"_grisee.png"];
        }
        else{
            consoC = [consoC stringByAppendingString:@".png"];
        }
        
        if (![lettreCE isEqualToString:@"D" ]) {
            consoD = [consoD stringByAppendingString:@"_grisee.png"];
        }
        else{
            consoD = [consoD stringByAppendingString:@".png"];
        }
        
        if (![lettreCE isEqualToString:@"E"]) {
            consoE = [consoE stringByAppendingString:@"_grisee.png"];
        }
        else{
            consoE = [consoE stringByAppendingString:@".png"];
        }
        
        if (![lettreCE isEqualToString:@"F" ]) {
            consoF = [consoF stringByAppendingString:@"_grisee.png"];
        }
        else{
            consoF = [consoF stringByAppendingString:@".png"];
        }
        
        if (![lettreCE isEqualToString:@"G" ]) {
            consoG = [consoG stringByAppendingString:@"_grisee.png"];
        }
        else{
            consoG = [consoG stringByAppendingString:@".png"];
        }
        
        UIImageView *imgConsoA = [[UIImageView alloc] initWithImage:[UIImage imageNamed:consoA]];
        UIImageView *imgConsoB = [[UIImageView alloc] initWithImage:[UIImage imageNamed:consoB]];
        UIImageView *imgConsoC = [[UIImageView alloc] initWithImage:[UIImage imageNamed:consoC]];
        UIImageView *imgConsoD = [[UIImageView alloc] initWithImage:[UIImage imageNamed:consoD]];
        UIImageView *imgConsoE = [[UIImageView alloc] initWithImage:[UIImage imageNamed:consoE]];
        UIImageView *imgConsoF = [[UIImageView alloc] initWithImage:[UIImage imageNamed:consoF]];
        UIImageView *imgConsoG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:consoG]];
        
        [imgConsoA setFrame:CGRectMake(10, 480, 55, 27)];
        [imgConsoB setFrame:CGRectMake(10, 507, 79, 27)];
        [imgConsoC setFrame:CGRectMake(10, 534, 104, 27)];
        [imgConsoD setFrame:CGRectMake(10, 561, 128, 27)];
        [imgConsoE setFrame:CGRectMake(10, 588, 152, 27)];
        [imgConsoF setFrame:CGRectMake(10, 615, 176, 27)];
        [imgConsoG setFrame:CGRectMake(10, 642, 200, 27)];
        
        [scrollView addSubview:imgConsoA];
        [scrollView addSubview:imgConsoB];
        [scrollView addSubview:imgConsoC];
        [scrollView addSubview:imgConsoD];
        [scrollView addSubview:imgConsoE];
        [scrollView addSubview:imgConsoF];
        [scrollView addSubview:imgConsoG];
        
        [bilanCe release];
        [imgConsoA release];
        [imgConsoB release];
        [imgConsoC release];
        [imgConsoD release];
        [imgConsoE release];
        [imgConsoF release];
        [imgConsoG release];
    }
    
    /*---- BILAN CONSO ENERGIE ----*/
    
    /*---- BILAN CONSO GES ----*/
    UILabel *bilanGes = [[UILabel alloc] initWithFrame:CGRectMake(10, nextY, 250, 30)];
    bilanGes.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    bilanGes.text = @"Bilan émission gaz à effet de serre";
    bilanGes.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:bilanGes];
    
    NSString *lettreGES = [lAnnonce valueForKey:@"bilan_ges"];
    //lettreGES = @"D";
    lettreGES = [lettreGES stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    nextY = nextY + 30;
    BOOL isGes = NO;
    
    if ([lettreGES length] == 0) {
        UILabel *bilanGesNC = [[UILabel alloc] initWithFrame:CGRectMake(10, nextY, 250, 20)];
        bilanGesNC.font = [UIFont fontWithName:@"Arial" size:12];
        bilanGesNC.text = @"NC";
        [scrollView addSubview:bilanGesNC];
        
        nextY = nextY +30;
    }
    
    if ([lettreGES length] > 0) {
        
        isGes = YES;
        
        NSString *gesA = @"emissiongesA";
        NSString *gesB = @"emissiongesB";
        NSString *gesC = @"emissiongesC";
        NSString *gesD = @"emissiongesD";
        NSString *gesE = @"emissiongesE";
        NSString *gesF = @"emissiongesF";
        NSString *gesG = @"emissiongesG";
        
        if (![lettreGES isEqualToString:@"A"]) {
            gesA = [gesA stringByAppendingString:@"_grisee.png"];
        }
        else{
            gesA = [gesA stringByAppendingString:@".png"];
        }
        
        if (![lettreGES isEqualToString:@"B"]) {
            gesB = [gesB stringByAppendingString:@"_grisee.png"];
        }
        else{
            gesB = [gesB stringByAppendingString:@".png"];
        }
        
        if (![lettreGES isEqualToString:@"C"]) {
            gesC = [gesC stringByAppendingString:@"_grisee.png"];
        }
        else{
            gesC = [gesC stringByAppendingString:@".png"];
        }
        
        if (![lettreGES isEqualToString:@"D"]) {
            gesD = [gesD stringByAppendingString:@"_grisee.png"];
        }
        else{
            gesD = [gesD stringByAppendingString:@".png"];
        }
        
        if (![lettreGES isEqualToString:@"E"]) {
            gesE = [gesE stringByAppendingString:@"_grisee.png"];
        }
        else{
            gesE = [gesE stringByAppendingString:@".png"];
        }
        
        if (![lettreGES isEqualToString:@"F"]) {
            gesF = [gesF stringByAppendingString:@"_grisee.png"];
        }
        else{
            gesF = [gesF stringByAppendingString:@".png"];
        }
        
        if (![lettreGES isEqualToString:@"G"]) {
            gesG = [gesG stringByAppendingString:@"_grisee.png"];
        }
        else{
            gesG = [gesG stringByAppendingString:@".png"];
        }
        
        UIImageView *imggesA = [[UIImageView alloc] initWithImage:[UIImage imageNamed:gesA]];
        UIImageView *imggesB = [[UIImageView alloc] initWithImage:[UIImage imageNamed:gesB]];
        UIImageView *imggesC = [[UIImageView alloc] initWithImage:[UIImage imageNamed:gesC]];
        UIImageView *imggesD = [[UIImageView alloc] initWithImage:[UIImage imageNamed:gesD]];
        UIImageView *imggesE = [[UIImageView alloc] initWithImage:[UIImage imageNamed:gesE]];
        UIImageView *imggesF = [[UIImageView alloc] initWithImage:[UIImage imageNamed:gesF]];
        UIImageView *imggesG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:gesG]];
        
        [imggesA setFrame:CGRectMake(10, nextY, 55, 27)];
        nextY = nextY + 27;
        [imggesB setFrame:CGRectMake(10, nextY, 79, 27)];
        nextY = nextY + 27;
        [imggesC setFrame:CGRectMake(10, nextY, 104, 27)];
        nextY = nextY + 27;
        [imggesD setFrame:CGRectMake(10, nextY, 128, 27)];
        nextY = nextY + 27;
        [imggesE setFrame:CGRectMake(10, nextY, 152, 27)];
        nextY = nextY + 27;
        [imggesF setFrame:CGRectMake(10, nextY, 176, 27)];
        nextY = nextY + 27;
        [imggesG setFrame:CGRectMake(10, nextY, 200, 27)];
        nextY = nextY + 37;
        
        [scrollView addSubview:imggesA];
        [scrollView addSubview:imggesB];
        [scrollView addSubview:imggesC];
        [scrollView addSubview:imggesD];
        [scrollView addSubview:imggesE];
        [scrollView addSubview:imggesF];
        [scrollView addSubview:imggesG];
        
        [bilanGes release];
        [imggesA release];
        [imggesB release];
        [imggesC release];
        [imggesD release];
        [imggesE release];
        [imggesF release];
        [imggesG release];
    }
    /*---- BILAN CONSO GES ----*/
    
    /*--- FICHE TECHNIQUE ---*/
    
    /*--- CONTACT ---*/
    //BANDEAU
    UIImageView *contact = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bandeau-contactez-nous.png"]];
    [contact setFrame:CGRectMake(0,nextY,320,20)];
    [scrollView addSubview:contact];
    [contact release];
    
    nextY = nextY + 30;
    
    //TEL
    NSError *error = nil;
    NSString *fullPath;
    NSString *texte;
    
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    texte = [NSString stringWithContentsOfFile: [directory stringByAppendingPathComponent:@"telephone-agence.txt"]
                                      encoding:NSUTF8StringEncoding
                                         error:&error];
    
    if (texte == nil) {
        fullPath = [[NSBundle mainBundle] pathForResource:@"telephone-agence" ofType:@"txt"];
        texte = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&error];
    }
    
    texte = [texte stringByReplacingOccurrencesOfString:@"." withString:@" "];
    
    UITextView *tel = [[UITextView alloc] initWithFrame:CGRectMake(15, nextY, 150, 20)];
    tel.text = [NSString stringWithFormat:@"Tél : %@", texte];
    tel.userInteractionEnabled = NO;
    tel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:tel];
    [tel release];
    
    //FAX
    error = nil;
    
    texte = [NSString stringWithContentsOfFile: [directory stringByAppendingPathComponent:@"fax-agence.txt"]
                                      encoding:NSUTF8StringEncoding
                                         error:&error];
    
    if (texte == nil) {
    
        fullPath = [[NSBundle mainBundle] pathForResource:@"fax-agence" ofType:@"txt"];
        texte = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&error];
    }
    
    texte = [texte stringByReplacingOccurrencesOfString:@"." withString:@" "];
    
    UITextView *fax = [[UITextView alloc] initWithFrame:CGRectMake(180, nextY, 150, 20)];
    fax.text = [NSString stringWithFormat:@"Fax : %@", texte];
    fax.userInteractionEnabled = NO;
    fax.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:fax];
    [fax release];
    
    nextY = nextY + 20;
    int otherY = nextY + 80;
    
    //BOUTON ECRIVEZ NOUS
    UIButton *ecrivez = [UIButton buttonWithType:UIButtonTypeCustom];
    [ecrivez setFrame:CGRectMake(30, nextY, 95, 65)];
    [ecrivez setImage:[UIImage imageNamed:@"ecrivez-nous.png"] forState:UIControlStateNormal];
    [ecrivez addTarget:self action:@selector(buttonEcrivez:) 
      forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:ecrivez];
    
    //BOUTON APPELEZ NOUS
    UIButton *appelez = [UIButton buttonWithType:UIButtonTypeCustom];
    [appelez setFrame:CGRectMake(30, otherY, 95, 65)];
    [appelez setImage:[UIImage imageNamed:@"appelez-nous.png"] forState:UIControlStateNormal];
    [appelez addTarget:self action:@selector(buttonAppelez:) 
      forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:appelez];
    
    //AJOUTER FAVORIS
    UIButton *favoris = [UIButton buttonWithType:UIButtonTypeCustom];
    [favoris setFrame:CGRectMake(185, nextY, 110, 65)];
    [favoris setImage:[UIImage imageNamed:@"ajouter-favoris.png"] forState:UIControlStateNormal];
    [favoris addTarget:self action:@selector(buttonFavoris:) 
      forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:favoris];
    
    //ENVOYEZ AMI
    UIButton *envoyez = [UIButton buttonWithType:UIButtonTypeCustom];
    [envoyez setFrame:CGRectMake(195, otherY, 95, 65)];
    [envoyez setImage:[UIImage imageNamed:@"envoyez-a-un-ami.png"] forState:UIControlStateNormal];
    [envoyez addTarget:self action:@selector(buttonEnvoyez:) 
      forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:envoyez];
    /*--- CONTACT ---*/
    
    if (!isCe && !isGes) {
        [scrollView setContentSize:CGSizeMake(320, 780)];
    }
    
    if (isCe && !isGes) {
        [scrollView setContentSize:CGSizeMake(320, 950)];
    }
    
    if (!isCe && isGes) {
        [scrollView setContentSize:CGSizeMake(320, 950)];
    }
}

- (void) printHUD{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    pvc = [[ProgressViewContoller alloc] init];
    [scrollView addSubview:pvc.view];
    
    [pool release];
}

- (void) afficheDiaporamaReady:(NSNotification *)notify {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"afficheDiaporama" object: arrayWithIndex];
}

- (void) coverFlowFicheDetaillee:(NSNotification *)notify {
    [NSThread detachNewThreadSelector:@selector(printHUD) toTarget:self withObject:nil];
    
	NSNumber *num = [notify object];
    arrayWithIndex.arrayIndex = [num intValue];
    arrayWithIndex.titre = [NSString stringWithString:[lAnnonce valueForKey:@"ref"]];
    
    DiapoController3 *diaporamaController = [[DiapoController3 alloc] init];
    diaporamaController.delegate = self;
    diaporamaController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:diaporamaController animated:YES];
    [diaporamaController release];
}

- (void) buttonPushed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) buttonEcrivez:(id)sender
{
    NSLog(@"Mail à l'agence...");
    NSString *htmlBody = [NSString stringWithFormat:
                          @"Bonjour, <br>Je souhaite recevoir plus d'informations concernant le bien %@.</br> Merci.",
                          [lAnnonce valueForKey:@"ref"]]; 
    
    NSString *escapedBody = [(NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)htmlBody, NULL, CFSTR("?=&+"), kCFStringEncodingISOLatin1) autorelease];
    
    NSError *error = nil;
    NSString *fullPath;
    NSString *texte;
    
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    texte = [NSString stringWithContentsOfFile: [directory stringByAppendingPathComponent:@"email-agence.txt"]
                                      encoding:NSUTF8StringEncoding
                                         error:&error];
    
    if (texte == nil) {
    
        fullPath = [[NSBundle mainBundle] pathForResource:@"email-agence" ofType:@"txt"];
        texte = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&error];
    }
        
    NSString *mailtoPrefix = [[NSString stringWithFormat:@"mailto:%@?subject=Demande d'informations - %@&body=",
                               texte,
                               [lAnnonce valueForKey:@"ref"]] stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding];
    
    NSString *mailtoStr = [mailtoPrefix stringByAppendingString:escapedBody];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailtoStr]];
}

- (void) buttonAppelez:(id)sender
{
    NSLog(@"Phone...");
    NSError *error = nil;
    NSString *fullPath;
    NSString *texte;
    
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    texte = [NSString stringWithContentsOfFile: [directory stringByAppendingPathComponent:@"telephone-agence.txt"]
                                      encoding:NSUTF8StringEncoding
                                         error:&error];
    
    if (texte == nil) {
        fullPath = [[NSBundle mainBundle] pathForResource:@"telephone-agence" ofType:@"txt"];
        texte = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&error];
    }
    
    if ([texte rangeOfString:@"+"].length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                    [NSString stringWithFormat:@"tel://%@",texte]]];
    }
    else{
        
        texte = [texte stringByReplacingOccurrencesOfString:@"." withString:@""];
        texte = [texte substringFromIndex:1];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                    [NSString stringWithFormat:@"tel://+33%@",texte]]];
    }
}

- (void) buttonEnvoyez:(id)sender
{
    //ENVOIE UN MAIL SANS DESTINATAIRE
    NSLog(@"Mail à un ami...");
    
    NSError *error = nil;
    NSString *fullPath;
    NSString *texte;
    
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    texte = [NSString stringWithContentsOfFile: [directory stringByAppendingPathComponent:@"site-agence.txt"]
                                      encoding:NSUTF8StringEncoding
                                         error:&error];
    
    if (texte == nil) {
    
        fullPath = [[NSBundle mainBundle] pathForResource:@"site-agence" ofType:@"txt"];
        texte = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&error];
    }
    
    NSString *htmlBody = [NSString stringWithFormat:
                          @"Plus d'infos sur %@, r&eacute;f&eacute;rence: %@",
                          texte,
                          [lAnnonce valueForKey:@"ref"]];
    
    NSString *escapedBody = [(NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)htmlBody, NULL, CFSTR("?=&+"), kCFStringEncodingISOLatin1) autorelease];
    
    NSString *mailtoPrefix = [@"mailto:?subject=Un ami vous recommande un bien&body=" stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding];
    
    NSString *mailtoStr = [mailtoPrefix stringByAppendingString:escapedBody];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailtoStr]];
    
    //TODO:
    //PARTAGE FACEBOOK ETC.
    //NSLog(@"Partage Facebook...");
}

- (void) buttonFavoris:(id)sender
{
    //AJOUTE CETTE ANNONCE AUX FAVORIS
    NSLog(@"AJOUTE CETTE ANNONCE AUX FAVORIS");
    NSString *nbPieces = [lAnnonce valueForKey:@"nb_pieces"];
    nbPieces = [nbPieces stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *prix = [lAnnonce valueForKey:@"prix"];
    prix = [prix stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *photos = [lAnnonce valueForKey:@"photos"];
    photos = [photos stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *bilan_ce = [lAnnonce valueForKey:@"bilan_ce"];
    bilan_ce = [bilan_ce stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *bilan_ges = [lAnnonce valueForKey:@"bilan_ges"];
    bilan_ges = [bilan_ges stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSDictionary *recordAnnonce = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [lAnnonce valueForKey:@"ref"], @"ref",
                                   [lAnnonce valueForKey:@"type"], @"type",
                                   nbPieces, @"nb_pieces",
                                   [lAnnonce valueForKey:@"surface"], @"surface",
                                   [lAnnonce valueForKey:@"ville"], @"ville",
                                   [lAnnonce valueForKey:@"cp"], @"cp",
                                   prix, @"prix",
                                   [lAnnonce valueForKey:@"descriptif"], @"descriptif",
                                   photos, @"photos",
                                   bilan_ce, @"bilan_ce",
                                   bilan_ges, @"bilan_ges",
                                   [lAnnonce valueForKey:@"etage"], @"etage",
                                   [lAnnonce valueForKey:@"ascenseur"], @"ascenseur",
                                   [lAnnonce valueForKey:@"chauffage"], @"chauffage",
                                   [lAnnonce valueForKey:@"date"], @"date",
                                   nil];
    
    NSLog(@"Annonce record: %@", recordAnnonce);
    
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSMutableArray *biensSauves = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < 11; i++) {
        NSString *name = [NSString stringWithFormat:@"bien%d.plist", i];
        NSDictionary *bien = [NSDictionary dictionaryWithContentsOfFile:
                              [directory stringByAppendingPathComponent:name]];
        if (bien != nil) {
            [biensSauves addObject:bien];
        }
    }
    
    if ([biensSauves count] == 0) {
        [recordAnnonce writeToFile:[directory stringByAppendingPathComponent:@"bien1.plist"] atomically:YES];
    }
    else{
        [biensSauves insertObject:recordAnnonce atIndex:0];
        if ([biensSauves count] == 11) {
            [biensSauves removeLastObject];
        }
        for (int j = 1; j < [biensSauves count] + 1; j++) {
            NSDictionary *save = [biensSauves objectAtIndex:j - 1];
            NSString *name = [NSString stringWithFormat:@"bien%d.plist", j];
            [save writeToFile:[directory stringByAppendingPathComponent:name] atomically:YES];
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [myOpenFlowView centerOnSelectedCover:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [pvc.view removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return NO;
}

@end
