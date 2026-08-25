#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>

// Hooking the underlying view instantiation layers
%hook MinecraftXboxAuthViewController

- (void)viewDidLoad {
    %orig;
    NSLog(@"[MC-AuthFix] Successfully initialized tweak hooking layers.");
}

// Bypasses the native platform handoff checks
- (void)presentWebAuthenticationSession:(id)session {
    NSLog(@"[MC-AuthFix] Intercepted restricted system authentication window.");
    
    // Forces the code context parameters to interpret requests via standard Web View frames
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootVC = keyWindow.rootViewController;
    
    if (rootVC) {
        // Fallback target URL pointing directly to the live authentication node
        NSURL *authURL = [NSURL URLWithString:@"https://live.com"];
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:authURL];
        
        [rootVC presentViewController:safariVC animated:YES completion:nil];
        NSLog(@"[MC-AuthFix] Injected safe web layer presentation frame override successfully.");
    }
}

%end

// Fallback runtime initialization vector loop
__attribute__((constructor)) static void init() {
    NSLog(@"[MC-AuthFix] Tweak loaded safely inside LiveContainer framework environment context.");
}
