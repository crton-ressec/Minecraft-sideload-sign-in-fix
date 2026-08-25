#import <UIKit/UIKit.h>
#import <AuthenticationServices/AuthenticationServices.h>

// Hooking Apple's Authentication Framework instead of Mojang's old layouts
%hook ASWebAuthenticationSession

- (id)initWithURL:(NSURL *)url callbackURLScheme:(NSString *)callbackURLScheme completionHandler:(void (^)(NSURL * _Nullable callbackURL, NSError * _Nullable error))completionHandler {
    
    NSLog(@"[MC-GlobalFix] Captured authentic cross-platform login URL packet: %@", url);
    
    // Check if the request is coming from Mojang's authentication server loops
    if ([url.absoluteString containsString:@"login.live.com"] || [callbackURLScheme containsString:@"microsoft-xbox-auth"]) {
        NSLog(@"[MC-GlobalFix] Overriding sandbox constraints for Microsoft account linking.");
        
        // This forces LiveContainer to intercept and process the callback scheme natively
        callbackURLScheme = @"livecontainer"; 
    }
    
    return %orig(url, callbackURLScheme, completionHandler);
}

- (BOOL)start {
    NSLog(@"[MC-GlobalFix] Initializing security authentication frame execution.");
    return %orig;
}

%end

__attribute__((constructor)) static void init() {
    NSLog(@"[MC-GlobalFix] Low-level system framework hook active under LiveContainer profile context.");
}
