//
//  STPPaymentHandler.h
//  StripeiOS
//
//  Created by Cameron Sabol on 5/10/19.
//  Copyright © 2019 Stripe, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class STPAPIClient;
@class STPPaymentIntent;
@class STPPaymentIntentParams;
@class STPThreeDSCustomizationSettings;
@protocol STPAuthenticationContext;

/**
 `STPPaymentHandlerActionStatus` represents the possible outcomes of requesting an action by STPPaymentHandler
 such as confirming and/or handling the next action for a PaymentIntent.
 */
typedef NS_ENUM(NSInteger, STPPaymentHandlerActionStatus) {
    /**
     The action succeeded.
     */
    STPPaymentHandlerActionStatusSucceeded,

    /**
     The action was cancelled by the cardholder/user.
     */
    STPPaymentHandlerActionStatusCanceled,

    /**
     The action failed. See the error code for more details.
     */
    STPPaymentHandlerActionStatusFailed,
};

/**
 The error domain for errors in STPPaymentHandler.
 */
FOUNDATION_EXPORT NSString * const STPPaymentHandlerErrorDomain;

/**
 Indicates that the action requires an authentication method not recognized or supported by the SDK.
 */
FOUNDATION_EXPORT const NSInteger STPPaymentHandlerUnsupportedAuthenticationErrorCode;

/**
 The PaymentIntent could not be confirmed because it is missing an associated payment method.
 */
FOUNDATION_EXPORT const NSInteger STPPaymentHandlerRequiresPaymentMethodErrorCode;

/**
 The PaymentIntent status cannot be resolved by `STPPaymentHandler`.
 */
FOUNDATION_EXPORT const NSInteger STPPaymentHandlerPaymentIntentStatusErrorCode;

/**
 The action timed out.
 */
FOUNDATION_EXPORT const NSInteger STPPaymentHandlerTimedOutErrorCode;

/**
 There was an error in the Stripe3DS2 SDK.
 */
FOUNDATION_EXPORT const NSInteger STPPaymentHandlerStripe3DS2ErrorCode;

/**
 There was an error in the Three Domain Secure process.
 */
FOUNDATION_EXPORT const NSInteger STPPaymentHandlerThreeDomainSecureErrorCode;

/**
 There was an internal error processing the action.
 */
FOUNDATION_EXPORT const NSInteger STPPaymentHandlerInternalErrorCode;

/**
 `STPPaymentHandler` does not support concurrent actions.
 */
FOUNDATION_EXPORT const NSInteger STPPaymentHandlerNoConcurrentActionsErrorCode;

/**
 Payment requires an `STPAuthenticationContext`.
 */
FOUNDATION_EXPORT const NSInteger STPPaymentHandlerRequiresAuthenticationContext;

typedef void (^STPPaymentHandlerActionCompletionBlock)(STPPaymentHandlerActionStatus, STPPaymentIntent * _Nullable, NSError * _Nullable);

/**
 `STPPaymentHandler` is a utility class to handle confirming PaymentIntents and executing
 any additional required actions to authenticate.
 */
NS_EXTENSION_UNAVAILABLE("STPPaymentHandler is not available in extensions")
@interface STPPaymentHandler : NSObject

/**
 The globally shared instance of `STPPaymentHandler`.
 */
+ (instancetype)sharedHandler;

/**
 By default `sharedHandler` initializes with [STPAPIClient sharedClient].
 */
@property (nonatomic) STPAPIClient *apiClient;

/**
 Customizable settings to use when performing 3DS2 authentication. Defaults to `[STPThreeDSCustomizationSettings defaultSettings]`.
 */
@property (nonatomic) STPThreeDSCustomizationSettings *threeDSCustomizationSettings;

/**
 Confirms the PaymentIntent with the provided parameters and handles any `nextAction` required
 to authenticate the PaymentIntent.
 */
- (void)confirmPayment:(STPPaymentIntentParams *)paymentParams
withAuthenticationContext:(nullable id<STPAuthenticationContext>)authenticationContext
            completion:(STPPaymentHandlerActionCompletionBlock)completion;

/**
 Handles any `nextAction` required to authenticate the PaymentIntent.
 */
- (void)handleNextActionForPayment:(STPPaymentIntent *)paymentIntent
         withAuthenticationContext:(id<STPAuthenticationContext>)authenticationContext
                        completion:(STPPaymentHandlerActionCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END