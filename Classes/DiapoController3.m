//
//  DiapoController3.m
//  Affinity
//
//  Created by Christophe Bergé on 19/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DiapoController3.h"


@implementation DiapoController3

@synthesize delegate=_delegate;

/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 */

- (void)dealloc
{
    UIImageView *iv;
    
    for (iv in [diaporama subviews]) {
        [iv release];
    }
    
    [navBar release];
    [diaporama release];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(afficheDiaporama:) name:@"afficheDiaporama" object: nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"afficheDiaporamaReady" object: @"afficheDiaporamaReady"];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    isFirstRotation = YES;
    
    //NAV BAR
    navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:[NSString stringWithString:arrayWithIndex.titre]];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];          
    navItem.rightBarButtonItem = anotherButton;
    [navBar pushNavigationItem:navItem animated:NO];
    [anotherButton release];
    
    navBar.backgroundColor = [UIColor blackColor];
    navBar.alpha = 0.5;
    
    [self.view addSubview:navBar];
    
    /*--- DIAPORAMA ---*/
    diaporama = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    [self getImages:images];
    
    scrollViewWidth = [images count];
    
    diaporama.contentSize = CGSizeMake(scrollViewWidth * 320, 480);
    diaporama.pagingEnabled = YES;
    diaporama.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                  UIViewAutoresizingFlexibleHeight |
                                  UIViewAutoresizingFlexibleBottomMargin |
                                  UIViewAutoresizingFlexibleLeftMargin |
                                  UIViewAutoresizingFlexibleRightMargin |
                                  UIViewAutoresizingFlexibleTopMargin
                                  );
    diaporama.showsHorizontalScrollIndicator = NO;
    diaporama.showsVerticalScrollIndicator = NO;
    [diaporama setAutoresizesSubviews:YES];
    diaporama.contentMode = UIViewContentModeCenter;
    diaporama.delegate = self;
    
    UIImage *image;
    
    int i = 0;
    for (image in images) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setImage:image];
        [imageView setFrame:CGRectMake(i * 320, 0, 320, 480)];
        imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                      UIViewAutoresizingFlexibleHeight |
                                      UIViewAutoresizingFlexibleBottomMargin |
                                      UIViewAutoresizingFlexibleLeftMargin |
                                      UIViewAutoresizingFlexibleRightMargin |
                                      UIViewAutoresizingFlexibleTopMargin);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [diaporama addSubview:imageView];
        i++;
        //[imageView release];
    }
    
    scrollViewIndex = arrayWithIndex.arrayIndex;
    
    CGRect frameCenter = diaporama.frame;
    frameCenter.origin.x = frameCenter.size.width * (arrayWithIndex.arrayIndex);
    frameCenter.origin.y = 0;
    [diaporama scrollRectToVisible:frameCenter animated:NO];
    
    [self.view insertSubview:diaporama atIndex:0];
    diaporama.backgroundColor = [UIColor blackColor];
    /*--- DIAPORAMA ---*/
    [images release];
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
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    CGFloat pageWidth = 320.0;
    
    if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        pageWidth = 480.0;
        page = (diaporama.contentOffset.x / pageWidth);
        
    }
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        pageWidth = 320.0;
        page = (diaporama.contentOffset.x / pageWidth);
        [navBar setFrame:CGRectMake(0, 0, 480, 45)];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    UIImageView *imageView;
    int i = 0;
    
    if (!isFirstRotation) {
        if(fromInterfaceOrientation == UIInterfaceOrientationPortrait || fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            [navBar setFrame:CGRectMake(0, 0, 480, 45)];
            [diaporama setFrame:CGRectMake(0, 0, 480, 320)];
            diaporama.contentSize = CGSizeMake(scrollViewWidth * 480, 320);
            
            for (imageView in [diaporama subviews]) {
                [imageView setFrame:CGRectMake(i * 480, 0, 480, 320)];
                i++;
            }
            
            CGRect frameCenter = diaporama.frame;
            frameCenter.origin.x = frameCenter.size.width * page;
            frameCenter.origin.y = 0;
            [diaporama scrollRectToVisible:frameCenter animated:NO];
        }
        
        if(fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
        {
            [navBar setFrame:CGRectMake(0, 0, 320, 45)];
            [diaporama setFrame:CGRectMake(0, 0, 320, 480)];
            diaporama.contentSize = CGSizeMake(scrollViewWidth * 320, 480);
            
            for (imageView in [diaporama subviews]) {
                [imageView setFrame:CGRectMake(i * 320, 0, 320, 480)];
                i++;
            }
            
            CGRect frameCenter = diaporama.frame;
            frameCenter.origin.x = frameCenter.size.width * page;
            frameCenter.origin.y = 0;
            [diaporama scrollRectToVisible:frameCenter animated:NO];
        }
    }
    else{
        isFirstRotation = NO;
    }
}

- (void) afficheDiaporama:(NSNotification *)notify {
	arrayWithIndex = [[ArrayWithIndex alloc] initWithIndexAndArray:[[notify object] arrayIndex]
                                                             array:[[notify object] array]
                                                              info:[[notify object] titre]];
}

- (void)getImages:(NSMutableArray *)tableau {
	
	NSString *string = @"";
	
	for (string in arrayWithIndex.array) {
		NSData* imageData = [[NSData alloc]initWithContentsOfURL:
							 [NSURL URLWithString:
							  [NSString stringWithFormat:@"%@",
							   string]]];
		UIImage *image = [[UIImage alloc] initWithData:imageData];
		
		[tableau addObject:image];
		
		[imageData release];
		[image release];
	}
}

- (void)done:(id)sender
{
    [self.delegate diapoControllerDidFinish:self];
}
@end
