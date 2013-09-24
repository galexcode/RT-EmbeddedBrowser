//
//  RTViewController.m
//  RT-EmbeddedBrowser
//
//  Created by Mitchell Oliver on 9/4/13.
//  Copyright (c) 2013 Mitchell Oliver. All rights reserved.
//

#import "RTViewController.h"

static const CGFloat kNavBarHeight = 52.0f;
static const CGFloat kLabelHeight = 14.0f;
static const CGFloat kMargin = 10.0f;
static const CGFloat kSpacer = 2.0f;
static const CGFloat kLabelFontSize = 12.0f;
static const CGFloat kAddressHeight = 26.0f;

@interface RTViewController ()

@end

@implementation RTViewController
@synthesize webView = mWebView;
@synthesize toolbar = mToolbar;
@synthesize back = mBack;
@synthesize forward = mForward;
@synthesize refresh = mRefresh;
@synthesize stop = mStop;
@synthesize pageTitle = mPageTitle;
@synthesize addressField = mAddressField;

/*

- (void)dealloc
{
    [mWebView release];
    [mToolbar release];
    [mBack release];
    [mForward release];
    [mRefresh release];
    [mStop release];
    [super dealloc];
}
*/

- (void)viewDidUnload
{
    self.webView = nil;
    self.toolbar = nil;
    self.back = nil;
    self.forward = nil;
    self.refresh = nil;
    self.stop = nil;
    self.pageTitle = nil;
    self.addressField = nil;
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect navBarFrame = self.view.bounds;
    navBarFrame.size.height = kNavBarHeight;
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:navBarFrame];
    navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    CGRect labelFrame = CGRectMake(kMargin, kSpacer,
                                   navBar.bounds.size.width - 2*kMargin, kLabelHeight);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = UITextAlignmentCenter;
    [navBar addSubview:label];
    self.pageTitle = label;
    //[label release];
    
    CGRect addressFrame = CGRectMake(kMargin, kSpacer*2.0 + kLabelHeight,
                                     labelFrame.size.width, kAddressHeight);
    UITextField *address = [[UITextField alloc] initWithFrame:addressFrame];
    address.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    address.borderStyle = UITextBorderStyleRoundedRect;
    address.font = [UIFont systemFontOfSize:17];
    [address addTarget:self
                action:@selector(loadAddress:event:)
      forControlEvents:UIControlEventEditingDidEndOnExit];
    [navBar addSubview:address];
    self.addressField = address;
    //[address release];

    [self.view addSubview:navBar];
    //[navBar release];
    
    CGRect webViewFrame = self.webView.frame;
    webViewFrame.origin.y = navBarFrame.origin.y + navBarFrame.size.height;
    webViewFrame.size.height = self.toolbar.frame.origin.y - webViewFrame.origin.y;
    self.webView.frame = webViewFrame;

    
    NSAssert(self.back, @"Unconnected IBOutlet 'back'");
    NSAssert(self.forward, @"Unconnected IBOutlet 'forward'");
    NSAssert(self.refresh, @"Unconnected IBOutlet 'refresh'");
    NSAssert(self.stop, @"Unconnected IBOutlet 'stop'");
    NSAssert(self.webView, @"Unconnected IBOutlet 'webView'");
    
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    NSURL* url = [NSURL URLWithString:@"http://iosdeveloperzone.com"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self updateButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: -
// MARK: UIWebViewDelegate protocol
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateButtons];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
    [self updateTitle:webView];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}
- (void)updateButtons
{
    self.forward.enabled = self.webView.canGoForward;
    self.back.enabled = self.webView.canGoBack;
    self.stop.enabled = self.webView.loading;
}
- (void)loadAddress:(id)sender event:(UIEvent *)event
{
    NSString* urlString = self.addressField.text;
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}
- (void)updateTitle:(UIWebView*)aWebView
{
    NSString* pageTitle = [aWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.pageTitle.text = pageTitle;
}

@end
