//
//  AgenceModalEstimation.m
//  Affinity
//
//  Created by Christophe Bergé on 14/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AgenceModalEstimation.h"

@implementation AgenceModalEstimation

@synthesize delegate=_delegate;

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
    
    UIColor *fond = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = fond;
    [fond release];
    //self.view.backgroundColor = [UIColor whiteColor];
    
    //HEADER
    UIImageView *enTete = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header.png"]];
    [enTete setFrame:CGRectMake(0,0,320,50)];
    [self.view addSubview:enTete];
    [enTete release];
    
    //BOUTON RETOUR
    UIButton *boutonRetour = [UIButton buttonWithType:UIButtonTypeCustom];
    boutonRetour.showsTouchWhenHighlighted = NO;
    boutonRetour.tag = 6;
    
    [boutonRetour setFrame:CGRectMake(10,7,50,30)];
    [boutonRetour addTarget:self action:@selector(done:) 
           forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageNamed:@"bouton-retour.png"];
    [boutonRetour setImage:image forState:UIControlStateNormal];
    
    [self.view addSubview:boutonRetour];
    
    //BANDEAU VENDRE
    UIImageView *bandeauFavoris = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bandeau-estimation.png"]];
    [bandeauFavoris setFrame:CGRectMake(0,50,320,20)];
    [self.view addSubview:bandeauFavoris];
    [bandeauFavoris release];
    
    //SCROLL VIEW
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, 320, 480)];
    scrollView.showsVerticalScrollIndicator = YES;
    
    [scrollView setContentSize:CGSizeMake(320, 1000)];
    [scrollView setScrollEnabled:YES];
    [self.view addSubview:scrollView];
    
    [scrollView flashScrollIndicators];
    [scrollView release];
    
    //NOM
    UILabel *labelNom = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, 30)];
    labelNom.backgroundColor = [UIColor clearColor];
    labelNom.text = @"NOM:";
    [scrollView addSubview:labelNom];
    [labelNom release];
    
    nomTF = [[UITextField alloc] initWithFrame:CGRectMake(30, 30, 250, 30)];
    nomTF.borderStyle = UITextBorderStyleRoundedRect;
    [nomTF becomeFirstResponder];
    [scrollView addSubview:nomTF];
    [nomTF release];
    
    //PRENOM
    UILabel *labelPrenom = [[UILabel alloc] initWithFrame:CGRectMake(30, 60, 100, 30)];
    labelPrenom.backgroundColor = [UIColor clearColor];
    labelPrenom.text = @"PRENOM:";
    [scrollView addSubview:labelPrenom];
    [labelPrenom release];
    
    prenomTF = [[UITextField alloc] initWithFrame:CGRectMake(30, 90, 250, 30)];
    prenomTF.borderStyle = UITextBorderStyleRoundedRect;
    [scrollView addSubview:prenomTF];
    [prenomTF release];
    
    //TELEPHONE
    UILabel *labelTelephone = [[UILabel alloc] initWithFrame:CGRectMake(30, 120, 150, 30)];
    labelTelephone.backgroundColor = [UIColor clearColor];
    labelTelephone.text = @"TELEPHONE:";
    [scrollView addSubview:labelTelephone];
    [labelTelephone release];
    
    telephoneTF = [[UITextField alloc] initWithFrame:CGRectMake(30, 150, 250, 30)];
    telephoneTF.borderStyle = UITextBorderStyleRoundedRect;
    telephoneTF.keyboardType = UIKeyboardTypePhonePad;
    [scrollView addSubview:telephoneTF];
    [telephoneTF release];
    
    //EMAIL
    UILabel *labelEmail = [[UILabel alloc] initWithFrame:CGRectMake(30, 180, 150, 30)];
    labelEmail.backgroundColor = [UIColor clearColor];
    labelEmail.text = @"EMAIL:";
    [scrollView addSubview:labelEmail];
    [labelEmail release];
    
    emailTF = [[UITextField alloc] initWithFrame:CGRectMake(30, 210, 250, 30)];
    emailTF.borderStyle = UITextBorderStyleRoundedRect;
    emailTF.keyboardType = UIKeyboardTypeEmailAddress;
    [scrollView addSubview:emailTF];
    [emailTF release];
    
    //TYPE DE BIEN
    UILabel *labelTypeBien = [[UILabel alloc] initWithFrame:CGRectMake(30, 240, 150, 30)];
    labelTypeBien.backgroundColor = [UIColor clearColor];
    labelTypeBien.text = @"TYPE DE BIEN:";
    [scrollView addSubview:labelTypeBien];
    [labelTypeBien release];
    
    type_bienTF = [[UITextField alloc] initWithFrame:CGRectMake(30, 270, 250, 30)];
    type_bienTF.borderStyle = UITextBorderStyleRoundedRect;
    [scrollView addSubview:type_bienTF];
    [type_bienTF release];
    
    //SURFACE
    UILabel *labelSurface = [[UILabel alloc] initWithFrame:CGRectMake(30, 300, 150, 30)];
    labelSurface.backgroundColor = [UIColor clearColor];
    labelSurface.text = @"SURFACE:";
    [scrollView addSubview:labelSurface];
    [labelSurface release];
    
    surfaceTF = [[UITextField alloc] initWithFrame:CGRectMake(30, 330, 250, 30)];
    surfaceTF.borderStyle = UITextBorderStyleRoundedRect;
    surfaceTF.keyboardType = UIKeyboardTypeNumberPad;
    [scrollView addSubview:surfaceTF];
    [surfaceTF release];
    
    //NB DE PIECES
    UILabel *labelnbPieces = [[UILabel alloc] initWithFrame:CGRectMake(30, 360, 200, 30)];
    labelnbPieces.backgroundColor = [UIColor clearColor];
    labelnbPieces.text = @"NOMBRE DE PIECES:";
    [scrollView addSubview:labelnbPieces];
    [labelnbPieces release];
    
    nb_piecesTF = [[UITextField alloc] initWithFrame:CGRectMake(30, 390, 250, 30)];
    nb_piecesTF.borderStyle = UITextBorderStyleRoundedRect;
    nb_piecesTF.keyboardType = UIKeyboardTypeNumberPad;
    [scrollView addSubview:nb_piecesTF];
    [nb_piecesTF release];

    //ADRESSE
    UILabel *labelAdresse = [[UILabel alloc] initWithFrame:CGRectMake(30, 420, 150, 30)];
    labelAdresse.backgroundColor = [UIColor clearColor];
    labelAdresse.text = @"ADRESSE:";
    [scrollView addSubview:labelAdresse];
    [labelAdresse release];
    
    adresseTF = [[UITextField alloc] initWithFrame:CGRectMake(30, 450, 250, 30)];
    adresseTF.borderStyle = UITextBorderStyleRoundedRect;
    [scrollView addSubview:adresseTF];
    [adresseTF release];
    
    //CODE POSTAL
    UILabel *labelCodePostal = [[UILabel alloc] initWithFrame:CGRectMake(30, 480, 150, 30)];
    labelCodePostal.backgroundColor = [UIColor clearColor];
    labelCodePostal.text = @"CODE POSTAL:";
    [scrollView addSubview:labelCodePostal];
    [labelCodePostal release];
    
    code_postalTF = [[UITextField alloc] initWithFrame:CGRectMake(30, 510, 250, 30)];
    code_postalTF.borderStyle = UITextBorderStyleRoundedRect;
    code_postalTF.keyboardType = UIKeyboardTypeNumberPad;
    [scrollView addSubview:code_postalTF];
    [code_postalTF release];
    
    //VILLE
    UILabel *labelVille = [[UILabel alloc] initWithFrame:CGRectMake(30, 540, 150, 30)];
    labelVille.backgroundColor = [UIColor clearColor];
    labelVille.text = @"VILLE:";
    [scrollView addSubview:labelVille];
    [labelVille release];
    
    villeTF = [[UITextField alloc] initWithFrame:CGRectMake(30, 570, 250, 30)];
    villeTF.borderStyle = UITextBorderStyleRoundedRect;
    [scrollView addSubview:villeTF];
    [villeTF release];
    
    //BOUTON ENVOYER
    UIButton *boutonEnvoyer = [UIButton buttonWithType:UIButtonTypeCustom];
    boutonEnvoyer.showsTouchWhenHighlighted = NO;
    boutonEnvoyer.tag = 1;
    
    [boutonEnvoyer setFrame:CGRectMake(50,620,200,50)];
    [boutonEnvoyer addTarget:self action:@selector(buttonPushed:) 
            forControlEvents:UIControlEventTouchUpInside];
    
    image = [UIImage imageNamed:@"bouton-envoyer.png"];
    [boutonEnvoyer setImage:image forState:UIControlStateNormal];
    
    [scrollView addSubview:boutonEnvoyer];
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

- (void)done:(id)sender
{
    [self.delegate agenceModalEstimationDidFinish:self];
}

- (void)buttonPushed:(id)sender
{
    UIButton *button = sender;
	switch (button.tag) {
		case 1:
            NSLog(@"email.");
            nom = [NSString stringWithString:@"Nom:"];
            if(nomTF.text == nil){
                nomTF.text = @"";
            }
            nom = [nom stringByAppendingFormat:@"\t%@\n",nomTF.text];
            
            prenom = [NSString stringWithString:@"Prenom:"];
            if(prenomTF.text == nil){
                prenomTF.text = @"";
            }
            prenom = [prenom stringByAppendingFormat:@"\t%@\n",prenomTF.text];
            
            telephone = [NSString stringWithString:@"Telephone:"];
            if(telephoneTF.text == nil){
                telephoneTF.text = @"";
            }
            telephone = [telephone stringByAppendingFormat:@"\t%@\n",telephoneTF.text];
            
            email = [NSString stringWithString:@"Email:"];
            if(emailTF.text == nil){
                emailTF.text = @"";
            }
            email = [email stringByAppendingFormat:@"\t%@\n",emailTF.text];
            
            type_bien = [NSString stringWithString:@"Type de bien:"];
            if(type_bienTF.text == nil){
                type_bienTF.text = @"";
            }
            type_bien = [type_bien stringByAppendingFormat:@"\t%@\n",type_bienTF.text];
            
            surface = [NSString stringWithString:@"Surface:"];
            if(surfaceTF.text == nil){
                surfaceTF.text = @"";
            }
            surface = [surface stringByAppendingFormat:@"\t%@\n",surfaceTF.text];
            
            nb_pieces = [NSString stringWithString:@"Nombre de pieces:"];
            if(nb_piecesTF.text == nil){
                nb_piecesTF.text = @"";
            }
            nb_pieces = [nb_pieces stringByAppendingFormat:@"\t%@\n",nb_piecesTF.text];
            
            adresse = [NSString stringWithString:@"Adresse:"];
            if(adresseTF.text == nil){
                adresseTF.text = @"";
            }
            adresse = [adresse stringByAppendingFormat:@"\t%@\n",adresseTF.text];
            
            code_postal = [NSString stringWithString:@"Code Postal:"];
            if(code_postalTF.text == nil){
                code_postalTF.text = @"";
            }
            code_postal = [code_postal stringByAppendingFormat:@"\t%@\n",code_postalTF.text];
            
            ville = [NSString stringWithString:@"Ville:"];
            if(villeTF.text == nil){
                villeTF.text = @"";
            }
            ville = [ville stringByAppendingFormat:@"\t%@\n",villeTF.text];
            
            NSString *htmlBody = [NSString stringWithFormat:
                                  @"%@%@%@%@%@%@%@%@%@%@",
                                  nom,
                                  prenom,
                                  telephone,
                                  email,
                                  type_bien,
                                  surface,
                                  nb_pieces,
                                  adresse,
                                  code_postal,
                                  ville];
            
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
                
            NSString *mailtoPrefix = [[NSString stringWithFormat:@"mailto:%@?subject=Demande d'estimation&body=", texte] stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding];
            
            NSString *mailtoStr = [mailtoPrefix stringByAppendingString:escapedBody];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailtoStr]];
            break;
        default:
			break;
	}
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    
    if ([newString length] <= 10) {
        
        NSNumber *formattedResult;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setGroupingSeparator:@" "];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        formattedResult = [NSNumber numberWithInt:[newString intValue]];
        
        string = [formatter stringForObjectValue:formattedResult];
        [textField setText:string];
        [formatter release];
    }
    //Returning yes allows the entered chars to be processed
    return NO;
}

@end
