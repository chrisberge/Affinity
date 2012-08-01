//
//  AgenceModalView.m
//  Affinity
//
//  Created by Christophe Bergé on 19/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AgenceModalView.h"


@implementation AgenceModalView

@synthesize delegate=_delegate;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(afficheText:) name:@"afficheText" object: nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"afficheTextReady" object: @"afficheTextReady"];
    
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
    
    /*--- NAVIGATION BAR ---*/
    /*navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Titre"];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];          
    navItem.rightBarButtonItem = anotherButton;
    [navBar pushNavigationItem:navItem animated:NO];
    [anotherButton release];
    
    navBar.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:navBar];*/
    /*--- NAVIGATION BAR ---*/
    /*--- TEXT VIEW ---*/
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(40, 80, 250, 300)];
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSError *error = nil;
    NSString *fullPath;
    NSString *texte = nil;
    
    switch ([textIndex intValue]) {
        case 1:
            //[navItem setTitle:@"Historique"];
            
            texte = [NSString stringWithContentsOfFile: [directory stringByAppendingPathComponent:@"presentation-agence.txt"]
                                              encoding:NSUTF8StringEncoding
                                                 error:&error];
            
            NSLog(@"PRES AGENCE: %@", texte);
            
            if (texte == nil) {
            
                fullPath = [[NSBundle mainBundle] pathForResource:@"presentation-agence" ofType:@"txt"];
                texte = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&error];
            }
            
            textView.text = texte;
            break;
        case 2:
            //[navItem setTitle:@"Nos engagements"];
            textView.text = @"Nous nous engageons auprès de nos vendeurs et nos acquéreurs à porter une attention toute particulière et personnalisée aux demandes qui nous sont faites afin de répondre au mieux des besoins de chacun.\n\nNous mettons tout en œuvre pour vous accompagner tout au long de votre parcours d’acquisition & de location. A cet effet, nous mettons à votre disposition notre savoir-faire & notre expertise en vous assurant toute notre discrétion ainsi qu’une confidentialité absolue.";
            break;
        case 3:
            //[navItem setTitle:@"Nos collaborateurs"];
            textView.text = @"Au fil des années, nous avons réuni une équipe de collaborateurs expérimentés parlant anglais, espagnol, portugais, italien & iranien.";
            break;
        case 4:
            //[navItem setTitle:@"Nos prestations"];
            textView.text = @"Nous proposons également les services de partenaires auxquels vous êtes susceptibles de faire appel:\n\n- Notaire\n- Banque\n- Avocat\n- Fiscaliste\n- Entrepreneur\n- Architecte\n- Décorateur\n- Gestion locative\n\n\n\n\nCertains de nos biens n’étant pas publiés pour des raisons de confidentialité, n’hésitez pas à nous contacter pour nous préciser vos critères de recherche.";
            break;
        default:
            break;
    }
    [self.view addSubview:textView];
    /*--- TEXT VIEW ---*/
    
    
    
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
    [self.delegate agenceModalViewDidFinish:self];
}

- (void)afficheText:(NSNotification *)notify{
    textIndex = [notify object];
}

@end
