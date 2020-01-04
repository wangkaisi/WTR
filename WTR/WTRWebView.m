//
//  WTRWebView.m
//  CnkiIPhoneClient
//
//  Created by wfz on 2019/7/25.
//  Copyright © 2019 net.cnki.www. All rights reserved.
//

#import "WTRWebView.h"
#import "WTRBaseDefine.h"

static void *WTRWebViewContentSizeContext = &WTRWebViewContentSizeContext;

@interface WTRWebView ()<WKUIDelegate,WKNavigationDelegate>

@property(nonatomic,strong)NSURLRequest *currentreq;

@property(nonatomic,assign)BOOL isAddObserver;

@end

@implementation WTRWebView

- (void)dealloc
{
    [self removeHHObserver];
    if (self.isLoading) {
        [self stopLoading];
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isAddObserver=NO;
        _isChangeHeight=NO;
        [self loadui];
    }
    return self;
}
-(void)loadui
{
    self.UIDelegate=self;
    self.navigationDelegate=self;

    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }
}
-(void)setIsChangeHeight:(BOOL)isChangeHeight
{
    _isChangeHeight=isChangeHeight;
    if (isChangeHeight) {
        [self addHHObserver];
    }else{
        [self removeHHObserver];
    }
}
-(void)addHHObserver
{
    if (self.isAddObserver) {
        return;
    }
    self.isAddObserver=YES;
    [self addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:WTRWebViewContentSizeContext];
}
-(void)removeHHObserver
{
    if (!self.isAddObserver) {
        return;
    }
    self.isAddObserver=NO;
    [self removeObserver:self forKeyPath:@"scrollView.contentSize"];
}
-(void)setCharsetUTF8
{
    ///<meta charset="UTF-8" />

    NSString* jScript = @"var meta = document.createElement('meta'); \
    meta.charset = 'UTF-8'; \
    var head = document.getElementsByTagName('head')[0];\
    head.appendChild(meta);";

    [self addUserScript:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
}
-(void)setScalesPageToFitWithUserScalable:(BOOL)userScalable
{
    ///<meta name="viewport" content="width=device-width,initial-scale=1;maximum-scale=1, minimum-scale=1, user-scalable=no" />

    NSString* jScript;

    if (userScalable) {
        jScript = @"var meta = document.createElement('meta'); \
        meta.name = 'viewport'; \
        meta.content = 'width=device-width, user-scalable=yes'; \
        var head = document.getElementsByTagName('head')[0];\
        head.appendChild(meta);";
    }else{
        jScript = @"var meta = document.createElement('meta'); \
        meta.name = 'viewport'; \
        meta.content = 'width=device-width,initial-scale=1;maximum-scale=1, minimum-scale=1, user-scalable=no'; \
        var head = document.getElementsByTagName('head')[0];\
        head.appendChild(meta);";
    }
    [self addUserScript:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
}
-(void)addUserScript:(NSString *)jScript injectionTime:(WKUserScriptInjectionTime)injectionTime forMainFrameOnly:(BOOL)forMainFrameOnly
{
    WKUserContentController *userContentController = self.configuration.userContentController;
    NSArray <WKUserScript *> *array = userContentController.userScripts;
    WKUserScript* fitWKUScript = nil;
    for (WKUserScript* wkUScript in array) {
        if ([wkUScript.source isEqual:jScript]) {
            fitWKUScript = wkUScript;
            break;
        }
    }
    if (!fitWKUScript) {
        fitWKUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:injectionTime forMainFrameOnly:forMainFrameOnly];
        [userContentController addUserScript:fitWKUScript];
    }
}
-(void)removeAllUserScripts
{
    [self.configuration.userContentController removeAllUserScripts];
}

#pragma mark webv代理
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context==WTRWebViewContentSizeContext) {
        [self updateframe];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
-(void)updateframe
{
    if (!self.isChangeHeight) {
        return;
    }
    if (ABS(self.height-self.scrollView.contentSize.height)<0.1) {
        return;
    }
    self.height=self.scrollView.contentSize.height;
    if (self.retupdatefreame) {
        self.retupdatefreame();
    }
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    if (self.didStartNavigation) {
        self.didStartNavigation(navigation);
    }
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (self.didFinishNavigation) {
        self.didFinishNavigation(navigation);
    }
}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    if (self.didFinishNavigation) {
        self.didFinishNavigation(navigation);
    }
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    if ([navigationResponse.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *resp=(NSHTTPURLResponse *)navigationResponse.response;
        if (resp.statusCode!=200) {
            decisionHandler(WKNavigationResponsePolicyCancel);
            if (self.didHaveErrorRes) {
                self.didHaveErrorRes(navigationResponse);
            }
            return;
        }
    }
    decisionHandler (WKNavigationResponsePolicyAllow);
}
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    BOOL resultBOOL = [self shouldStartLoadWithRequest:navigationAction.request navigationType:navigationAction.navigationType];
    if(resultBOOL)
    {
        self.currentreq=navigationAction.request;
        if(!navigationAction.targetFrame) //|| !navigationAction.targetFrame.mainFrame
        {
            [webView loadRequest:navigationAction.request];
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    else
    {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}
-(BOOL)shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(WKNavigationType)navigationType
{
    NSString *urlstr=request.URL.absoluteString;
    if (self.shouldStartLoad) {
        return self.shouldStartLoad(urlstr);
    }
    return NO;
}

//#pragma mark 额外的信息 可继承本类去实现
/**
 *  web界面中有弹出警告框时调用
 *
 *  webView           实现该代理的webview
 *  message           警告框中的内容
 *  completionHandler 警告框消失调用
 */
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
//{
//    NSLog(@"message:%@",message);
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"HTML的弹出框" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler();
//    }])];
//    [self presentViewController:alertController animated:YES completion:nil];
//}
// 确认框
//JavaScript调用confirm方法后回调的方法 confirm是js中的确定框，需要在block中把用户选择的情况传递进去
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
//{
//    NSLog(@"message:%@",message);
////    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
////    [alertController addAction:([UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
////        completionHandler(NO);
////    }])];
////    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
////        completionHandler(YES);
////    }])];
////    [self presentViewController:alertController animated:YES completion:nil];
//}
// 输入框
//JavaScript调用prompt方法后回调的方法 prompt是js中的输入框 需要在block中把用户输入的信息传入
//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
////    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
////    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
////        textField.text = defaultText;
////    }];
////    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
////        completionHandler(alertController.textFields[0].text?:@"");
////    }])];
////    [self presentViewController:alertController animated:YES completion:nil];
//}
//// 页面是弹出窗口 _blank 处理
//- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
//{
//    if (!navigationAction.targetFrame.isMainFrame) {
//        [webView loadRequest:navigationAction.request];
//    }
//    return nil;
//}

@end
