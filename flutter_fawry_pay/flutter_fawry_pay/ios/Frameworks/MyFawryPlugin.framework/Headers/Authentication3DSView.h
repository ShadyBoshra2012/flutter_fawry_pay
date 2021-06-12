//
//  Authentication3DSView.h
//  ;
//
//  Created by Ehab Asaad Hanna on 5/4/16.
//  Copyright © 2016 Ehab Asaad Hanna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface Authentication3DSView : UIView<WKUIDelegate,WKNavigationDelegate>

@property (strong, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property NSString* migsReturnURL;
- (IBAction)cancelButtonAction:(UIButton *)sender;
- (void) loadWebView:(WKWebView *)theWebView withURLString:(NSString *)urlString andPostDictionaryOrNil:(NSDictionary *)postDictionary;
@property (weak, nonatomic) IBOutlet UIView *loadingView;

@end
