#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>

%hook MinecraftXboxAuthViewController

- (void)viewDidLoad {
    %orig;
    NSLog(@"[MC-AuthFix] Successfully initialized tweak hooking layers.");
}

// Modern iOS Scene-Safe View Presentation Context Override
- (void)presentWebAuthenticationSession:(id)session {
    NSLog(@"[MC-AuthFix] Intercepted restricted system authentication window.");
    
    UIViewController *rootVC = nil;
    
    // Safely iterate through modern UIWindowScenes to find the active foreground window
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        rootVC = window.rootViewController;
                        break;
                    }
                }
            }
            if (rootVC) break;
        }
    }
    
    // Fallback block if running on an environment where scenes fail to populate
    if (!rootVC) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        #pragma clang diagnostic pop
    }
    
    // Inject the internal web portal framework over the top of the root context
    if (rootVC) {
        NSURL *authURL = [NSURL URLWithString:@"https://live.com"];
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:authURL];
        
        [rootVC presentViewController:safariVC animated:YES completion:nil];
        NSLog(@"[MC-AuthFix] Injected safe web layer presentation frame override successfully.");
    } else {
        NSLog(@"[MC-AuthFix] Error: Could not resolve a valid UIWindow root controller.");
    }
}

%end

__attribute__((constructor)) static void init() {
    NSLog(@"[MC-AuthFix] Tweak loaded safely inside LiveContainer framework environment context.");
}
