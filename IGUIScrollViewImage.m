#import "IGUIScrollViewImage.h"  
   
#define kIGUIScrollViewImagePageIdentifier                      @"kIGUIScrollViewImagePageIdentifier"  
#define kIGUIScrollViewImageDefaultPageIdentifier               @"Default"  
   
   
 @implementation IGUIScrollViewImage  
   
 @synthesize scrollView;  
   
 - (int)getScrollViewWidth {  
     return ([contentArray count] * scrollWidth);  
 }  
   
 - (void)setWidth:(int)width andHeight:(int)height {  
     scrollWidth = width;  
     scrollHeight = height;  
     if (!width || !height) rectScrollView = [[UIScreen mainScreen] applicationFrame];  
     else rectScrollView = CGRectMake(0, 0, width, height);  
 }  
   
 - (void)setSizeFromParentView:(UIScrollView *)scView {  
     scrollWidth = scView.frame.size.width;  
     scrollHeight = scView.frame.size.height;  
     rectScrollView = CGRectMake(0, 0, scrollWidth, scrollHeight);  
 }  
   
 - (void)setContentArray:(NSArray *)images {  
     contentArray = images;  
 }  
   
 - (void)setBackGroudColor:(UIColor *)color {  
     bcgColor = color;  
 }  
   
 - (void)enablePageControlOnTop {  
     pageControlEnabledTop = YES;  
 }  
   
 - (void)enablePageControlOnBottom {  
     pageControlEnabledBottom = YES;  
 }  
   
 - (void)enablePositionMemoryWithIdentifier:(NSString *)identifier {  
     rememberPosition = YES;  
     if (!identifier) identifier = kIGUIScrollViewImageDefaultPageIdentifier;
     positionIdentifier = identifier;  
 }  
   
 - (void)enablePositionMemory {  
     [self enablePositionMemoryWithIdentifier:nil];  
 }  
   
 - (UIScrollView *)getWithPosition:(int)page {  
     if (!contentArray) {  
         contentArray = [[[NSArray alloc] init] autorelease];  
     }  
     if (page > [contentArray count]) page = 0;  
       
     if (!scrollWidth || !scrollHeight) {  
         rectScrollView = [[UIScreen mainScreen] applicationFrame];  
         scrollWidth = rectScrollView.size.width;  
         scrollHeight = rectScrollView.size.height;  
     }  
     rectScrollView = CGRectMake(0, 0, scrollWidth, scrollHeight);  
        
     self.scrollView = [[UIScrollView alloc] initWithFrame:rectScrollView];  
     self.scrollView.contentSize = CGSizeMake([self getScrollViewWidth], scrollHeight);  
     if (!bcgColor) bcgColor = [UIColor blackColor];  
     self.scrollView.backgroundColor = bcgColor;  
     self.scrollView.alwaysBounceHorizontal = YES;  
     self.scrollView.contentOffset = CGPointMake(page * scrollWidth, 0);  
     self.scrollView.pagingEnabled = YES;  
       
     UIView *main = [[[UIView alloc] initWithFrame:rectScrollView] autorelease];  
     int i = 0;  
     for (UIImage *img in contentArray) {  
         UIImageView *imageView = [[UIImageView alloc] init];  
         imageView.image = img;  
         imageView.contentMode = UIViewContentModeScaleAspectFit;  
         imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);  
         imageView.backgroundColor = [UIColor blackColor];  
         float ratio = img.size.width/rectScrollView.size.width;  
         CGRect imageFrame = CGRectMake(i, 0, rectScrollView.size.width, (img.size.height / ratio));  
         imageView.frame = imageFrame;  
         [self.scrollView addSubview:(UIView *)imageView];  
         i += scrollWidth;  
         [imageView release];  
     }  
     [main addSubview:scrollView];  
     if (pageControlEnabledTop) {  
         rectPageControl = CGRectMake(0, 5, scrollWidth, 15);  
     }  
     else if (pageControlEnabledBottom) {  
         rectPageControl = CGRectMake(0, (scrollHeight - 25), scrollWidth, 15);  
     }  
     if (pageControlEnabledTop || pageControlEnabledBottom) {  
         pageControl = [[[UIPageControl alloc] initWithFrame:rectPageControl] autorelease];  
         pageControl.numberOfPages = [contentArray count];  
         pageControl.currentPage = page;  
         [main addSubview:pageControl];  
     }  
     if (pageControlEnabledTop || pageControlEnabledBottom || rememberPosition) self.scrollView.delegate = self;  
     //if (margin) [margin release];  
     return (UIScrollView *)main;  
 }  
   
 - (UIScrollView *)get {  
     return [self getWithPosition:0];  
 }  
   
 - (UIScrollView *)getWithPositionMemory {  
     [self enablePositionMemory];  
     //return [self getWithPosition:[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@", kIGUIScrollViewImagePageIdentifier, kIGUIScrollViewImageDefaultPageIdentifier]] intValue]];  
	 return [self getWithPosition:0];  
	 
 }  
   
 - (UIScrollView *)getWithPositionMemoryIdentifier:(NSString *)identifier {  
     [self enablePositionMemoryWithIdentifier:identifier];  
     return [self getWithPosition:[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@", kIGUIScrollViewImagePageIdentifier, positionIdentifier]] intValue]];  
 }  
   
 - (void)scrollViewDidEndDecelerating:(UIScrollView *)sv {  
     int page = sv.contentOffset.x / sv.frame.size.width;  
     pageControl.currentPage = page;  
     if (rememberPosition) {  
         [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", page] forKey:[NSString stringWithFormat:@"%@%@", kIGUIScrollViewImagePageIdentifier, positionIdentifier]];  
         [[NSUserDefaults standardUserDefaults] synchronize];  
     }  
 }  
   
 - (void)dealloc {  
     [scrollView release];  
     [super dealloc];  
 }  
   
   
 @end  