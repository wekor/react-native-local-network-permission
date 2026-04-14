#import "LocalNetworkPermission.h"
#import <Network/Network.h>

static NSString *const kServiceType = @"_preflight_check._tcp";

@implementation LocalNetworkPermission

- (void)requestPermission:(RCTPromiseResolveBlock)resolve
                   reject:(RCTPromiseRejectBlock)reject
{
    if (@available(iOS 14.0, *)) {
        [self checkWithResolve:resolve];
    } else {
        resolve(@(YES));
    }
}

- (void)checkWithResolve:(RCTPromiseResolveBlock)resolve API_AVAILABLE(ios(14.0))
{
    __block nw_listener_t listener = nil;
    __block nw_browser_t browser = nil;
    __block BOOL didResolve = NO;

    void (^finish)(BOOL) = ^(BOOL granted) {
        if (didResolve) return;
        didResolve = YES;

        if (listener) {
            nw_listener_set_state_changed_handler(listener, NULL);
            nw_listener_set_new_connection_handler(listener, NULL);
            nw_listener_cancel(listener);
            listener = nil;
        }
        if (browser) {
            nw_browser_set_state_changed_handler(browser, NULL);
            nw_browser_set_browse_results_changed_handler(browser, NULL);
            nw_browser_cancel(browser);
            browser = nil;
        }

        resolve(@(granted));
    };

    // --- Listener ---
    nw_parameters_t listenerParams = nw_parameters_create_secure_tcp(
        NW_PARAMETERS_DISABLE_PROTOCOL,
        NW_PARAMETERS_DEFAULT_CONFIGURATION
    );

    listener = nw_listener_create(listenerParams);
    if (!listener) {
        finish(NO);
        return;
    }

    NSString *serviceName = [[NSUUID UUID] UUIDString];
    nw_advertise_descriptor_t ad = nw_advertise_descriptor_create_bonjour_service(
        serviceName.UTF8String, kServiceType.UTF8String, NULL
    );
    nw_listener_set_advertise_descriptor(listener, ad);
    nw_listener_set_new_connection_handler(listener, ^(nw_connection_t connection) {});

    nw_listener_set_state_changed_handler(listener, ^(nw_listener_state_t state, nw_error_t error) {
        switch (state) {
            case nw_listener_state_ready:
                break;
            case nw_listener_state_failed:
            case nw_listener_state_waiting:
                finish(NO);
                break;
            default:
                break;
        }
    });

    nw_listener_set_queue(listener, dispatch_get_main_queue());
    nw_listener_start(listener);

    // --- Browser ---
    nw_browse_descriptor_t desc = nw_browse_descriptor_create_bonjour_service(
        kServiceType.UTF8String, NULL
    );
    nw_parameters_t browserParams = nw_parameters_create();
    nw_parameters_set_include_peer_to_peer(browserParams, true);

    browser = nw_browser_create(desc, browserParams);

    nw_browser_set_state_changed_handler(browser, ^(nw_browser_state_t state, nw_error_t error) {
        switch (state) {
            case nw_browser_state_ready:
                break;
            case nw_browser_state_waiting:
            case nw_browser_state_failed:
                finish(NO);
                break;
            default:
                break;
        }
    });

    nw_browser_set_browse_results_changed_handler(browser, ^(
        nw_browse_result_t oldResult,
        nw_browse_result_t newResult,
        bool batchComplete
    ) {
        nw_browse_result_change_t changes = nw_browse_result_get_changes(oldResult, newResult);
        if (changes & nw_browse_result_change_result_added) {
            finish(YES);
        }
    });

    nw_browser_set_queue(browser, dispatch_get_main_queue());
    nw_browser_start(browser);
}

#pragma mark - TurboModule

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeLocalNetworkPermissionSpecJSI>(params);
}

+ (NSString *)moduleName
{
    return @"LocalNetworkPermission";
}

@end
