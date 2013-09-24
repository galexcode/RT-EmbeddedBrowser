//
//  RTViewController.h
//  RT-EmbeddedBrowser
//
//  Created by Mitchell Oliver on 9/4/13.
//  Copyright (c) 2013 Mitchell Oliver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTViewController : UIViewController<UIWebViewDelegate> {
    UIWebView* mWebView;
    UIToolbar* mToolbar;
    UIBarButtonItem* mBack;
    UIBarButtonItem* mForward;
    UIBarButtonItem* mRefresh;
    UIBarButtonItem* mStop;
    UILabel* mPageTitle;
    UITextField* mAddressField;
}

@property (nonatomic, retain) IBOutlet UIWebView* webView;
@property (nonatomic, retain) IBOutlet UIToolbar* toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* back;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* forward;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* refresh;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* stop;
@property (nonatomic, retain) IBOutlet UILabel* pageTitle;
@property (nonatomic, retain) IBOutlet UITextField* addressField;

- (void) updateButtons;
- (void)loadAddress:(id)sender event:(UIEvent*)event;
- (void)updateTitle:(UIWebView*)aWebView;


@end
