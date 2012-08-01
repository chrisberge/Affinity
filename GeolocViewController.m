//
//  RetourViewController.m
//  Affinity
//
//  Created by Christophe Bergé on 16/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GeolocViewController.h"


@implementation GeolocViewController

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
    UIColor *fond = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = fond;
    [fond release];
    
    //HEADER
    UIImageView *enTete = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header.png"]];
    [enTete setFrame:CGRectMake(0,0,320,50)];
    [self.view addSubview:enTete];
    [enTete release];
    
    /*--- BOUTON RETOUR ---*/
    //DEPLACER EN HAUT SUR LE LOGO
    UIButton *boutonRetour = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[boutonRetour setFrame:CGRectMake(10,7,50,30)];
	[boutonRetour setUserInteractionEnabled:YES];
	[boutonRetour addTarget:self action:@selector(buttonPushed:) 
           forControlEvents:UIControlEventTouchUpInside];
    //[boutonRetour setTitle:@"Retour" forState:UIControlStateNormal];
    UIImage *image= [UIImage imageNamed:@"bouton-retour.png"];
	[boutonRetour setImage:image forState:UIControlStateNormal];
    
    boutonRetour.titleLabel.textColor = [UIColor blackColor];
    boutonRetour.showsTouchWhenHighlighted = NO;
    boutonRetour.tag = 1;
	
	[self.view addSubview:boutonRetour];
    /*--- BOUTON RETOUR ---*/
    /*--- MAP VIEW ---*/
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 50, 320, 350)];
    
    mapView.showsUserLocation=FALSE;
    mapView.mapType=MKMapTypeStandard;
    mapView.delegate=self;
    
    /*Region and Zoom*/
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.1;
    span.longitudeDelta=0.1;
    
    NSError *error = nil;
    NSString *fullPath;
    NSString *texte;
    
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    texte = [NSString stringWithContentsOfFile: [directory stringByAppendingPathComponent:@"coordonnees-postales.txt"]
                                      encoding:NSUTF8StringEncoding
                                         error:&error];
    
    if (texte == nil) {
    
        fullPath = [[NSBundle mainBundle] pathForResource:@"coordonnees-postales" ofType:@"txt"];
        texte = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&error];
    }
    
    CLLocationCoordinate2D location=[self addressLocationWithAddress:texte];
    
    region.span=span;
    region.center=location;
    
    AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location];
    
    [mapView addAnnotation:addAnnotation];
    [mapView setRegion:region animated:TRUE];
    [mapView regionThatFits:region];
    
    [self.view addSubview:mapView];
    [mapView release];
    /*--- MAP VIEW ---*/
    /*--- TEXT VIEW ---*/
    UITextView *adresse = [[UITextView alloc] initWithFrame:CGRectMake(100, 410, 200, 50)];
    adresse.editable = NO;
    adresse.text = @"Zoomez pour agrandir";
    adresse.textAlignment = UITextAlignmentCenter;
    adresse.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:adresse];
    [adresse release];
    /*--- TEXT VIEW ---*/
}

- (void) buttonPushed:(id)sender
{
	UIButton *button = sender;
	switch (button.tag) {
        case 1:
            [self.delegate geolocViewControllerDidFinish:self];
            break;
		default:
			break;
	}
}

- (CLLocationCoordinate2D)addressLocationWithAddress:(NSString *)address
{
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv",
                           [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:NULL];
    NSArray *listItems = [locationString componentsSeparatedByString:@","];
    
    double latitude = 0.0;
    double longitude = 0.0;
    
    if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"])
    {
        latitude = [[listItems objectAtIndex:2] doubleValue];
        longitude = [[listItems objectAtIndex:3] doubleValue];
    }
    else {
        NSLog(@"WRONG");
    }
    
    //NSLog(@"")
    CLLocationCoordinate2D location;
    location.latitude = latitude;
    location.longitude = longitude;
    
    return location;
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    annView.pinColor = MKPinAnnotationColorGreen;
    annView.animatesDrop=TRUE;
    annView.canShowCallout = YES;
    annView.calloutOffset = CGPointMake(-5, 5);
    return annView;
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

@end
