//
//  LYRUIConversationViewTest.m
//  LayerSample
//
//  Created by Kevin Coleman on 9/16/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LSApplicationController.h"
#import "LYRUITestInterface.h"
#import "LYRUILayerContentFactory.h"
#import "LSAppDelegate.h"
#import "LYRUITestUser.h"
#import "LYRUIConversationViewController.h"
#import "LYRUIMessageInputToolbar.h"
#import "LYRUIMessageComposeTextView.h"

@interface LYRUIConversationViewTest : XCTestCase

@property (nonatomic) LYRUITestInterface *testInterface;
@property (nonatomic) LYRUILayerContentFactory *layerContentFactory;

@end

@implementation LYRUIConversationViewTest

- (void)setUp
{
    [super setUp];
    
    LSApplicationController *applicationController =  [(LSAppDelegate *)[[UIApplication sharedApplication] delegate] applicationController];
    self.testInterface = [LYRUITestInterface testInterfaceWithApplicationController:applicationController];
    self.layerContentFactory = [LYRUILayerContentFactory layerContentFactoryWithLayerClient:applicationController.layerClient];
    [self.testInterface deleteContacts];
}

- (void)tearDown
{
    [self.testInterface deleteContacts];
    [self.testInterface logout];
    
    self.testInterface = nil;
    
    [super tearDown];
}

//Send a new message a verify it appears in the view.
- (void)testToVerifySentMessageAppearsInConversationView
{
    [self.testInterface registerAndAuthenticateUser:[LYRUITestUser testUserWithNumber:1]];
    LSUser *user1 = [self.testInterface randomUser];

    [self.layerContentFactory conversationsWithParticipants:[NSSet setWithArray:@[user1.userID]] number:1];
    [tester tapViewWithAccessibilityLabel:[self.testInterface conversationLabelForParticipants:[NSSet setWithArray:@[user1.userID]]]];
    [self sendMessageWithText:@"This is a test"];
    [tester tapViewWithAccessibilityLabel:@"Messages"];
}

//Synchronize a new message and verify it appears in the view.
- (void)testToVerifyRecievedMessageAppearsInConversationView
{
    
}

//Receive a transport push for a new message and verify that it appears in the view.
- (void)testToVerifyTransportPushCausesNewMessageToAppearInView
{
    
}

//Add an image to a message and verify that it sends.
- (void)testToVerifySentImageAppearsInConversationView
{
    [self.testInterface registerAndAuthenticateUser:[LYRUITestUser testUserWithNumber:1]];
    
    LSUser *user1 = [self.testInterface randomUser];
    
    LYRConversation *conversation = [LYRConversation conversationWithParticipants:[NSSet setWithArray:@[user1.userID]]];
    LYRUIConversationViewController *controller = [LYRUIConversationViewController conversationViewControllerWithConversation:conversation layerClient:self.testInterface.applicationController.layerClient];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [system presentModalViewController:navigationController configurationBlock:^(id viewController) {
        [self sendPhotoMessage];
    }];
}

//Add a video to a message and verify that it sends.
- (void)testToVerifySentVideoAppearsInConversationView
{
    [self.testInterface registerAndAuthenticateUser:[LYRUITestUser testUserWithNumber:1]];
    
    LSUser *user1 = [self.testInterface randomUser];
    
    LYRConversation *conversation = [LYRConversation conversationWithParticipants:[NSSet setWithArray:@[user1.userID]]];
    LYRUIConversationViewController *controller = [LYRUIConversationViewController conversationViewControllerWithConversation:conversation layerClient:self.testInterface.applicationController.layerClient];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [system presentModalViewController:navigationController configurationBlock:^(id viewController) {
        LYRUIMessageInputToolbar *toolBar = (LYRUIMessageInputToolbar *)[tester waitForViewWithAccessibilityLabel:@"Message Input Toolbar"];
        expect(toolBar.rightAccessoryButton.highlighted).to.beFalsy;

        UICollectionView *conversationCollectionView = (UICollectionView *)[tester waitForViewWithAccessibilityLabel:@"Conversation Collection View"];
        NSInteger numberOfMessagesPriorToSend = conversationCollectionView.numberOfSections;
        [tester tapViewWithAccessibilityLabel:@"Send Button"];
        NSInteger numberOfMessagesAfterSend = conversationCollectionView.numberOfSections;
        expect(numberOfMessagesPriorToSend).to.equal(numberOfMessagesAfterSend);
    }];
}

//Verify that the "Send" button is not enabled until there is content (text, audio, or video) in the message composition field.
- (void)testToVerifyThatSendButtonIsNotEnabledUntilContentIsInput
{
    
}

- (void)testToStart10ConversationsWith10MessagesFromEachParticipant
{
    [self.testInterface registerAndAuthenticateUser:[LYRUITestUser testUserWithNumber:0]];
    
    NSString *user1ID = [self.testInterface registerUser:[LYRUITestUser testUserWithNumber:1]];
    [self.testInterface loadContacts];
    NSMutableSet *participantSet = [NSMutableSet setWithArray:@[user1ID]];
    [self.layerContentFactory conversationsWithParticipants:participantSet number:1];
    [tester waitForViewWithAccessibilityLabel:[self.testInterface conversationLabelForParticipants:participantSet]];
    
    NSString *user2ID = [self.testInterface registerUser:[LYRUITestUser testUserWithNumber:2]];
    [self.testInterface loadContacts];
    [participantSet addObject:user2ID];
    [self.layerContentFactory conversationsWithParticipants:participantSet number:1];
    [tester waitForViewWithAccessibilityLabel:[self.testInterface conversationLabelForParticipants:participantSet]];
    
    NSString *user3ID = [self.testInterface registerUser:[LYRUITestUser testUserWithNumber:3]];
    [self.testInterface loadContacts];
    [participantSet addObject:user3ID];
    [self.layerContentFactory conversationsWithParticipants:participantSet number:1];
    [tester waitForViewWithAccessibilityLabel:[self.testInterface conversationLabelForParticipants:participantSet]];
    
    NSString *user4ID = [self.testInterface registerUser:[LYRUITestUser testUserWithNumber:4]];
    [self.testInterface loadContacts];
    [participantSet addObject:user4ID];
    [self.layerContentFactory conversationsWithParticipants:participantSet number:1];
    [tester waitForViewWithAccessibilityLabel:[self.testInterface conversationLabelForParticipants:participantSet]];
    
    participantSet = [NSMutableSet setWithArray:@[user1ID]];
    [tester tapViewWithAccessibilityLabel:[self.testInterface conversationLabelForParticipants:participantSet]];
    [self sendMessageWithText:@"Testing"];
    [self sendMessageWithText:@"Testing"];
    [self sendMessageWithText:@"Testing"];
    [self sendMessageWithText:@"Testing"];
    [self sendMessageWithText:@"Testing"];
    [tester tapViewWithAccessibilityLabel:@"Messages"];
    
    [participantSet addObject:user2ID];
    [tester tapViewWithAccessibilityLabel:[self.testInterface conversationLabelForParticipants:participantSet]];
    [self sendMessageWithText:@"Testing"];
    [self sendMessageWithText:@"Testing"];
    [self sendMessageWithText:@"Testing"];
    [self sendMessageWithText:@"Testing"];
    [self sendMessageWithText:@"Testing"];
    [tester tapViewWithAccessibilityLabel:@"Messages"];
    
    [participantSet addObject:user3ID];
    [tester tapViewWithAccessibilityLabel:[self.testInterface conversationLabelForParticipants:participantSet]];
    [self sendMessageWithText:@"Testing"];
    [self sendMessageWithText:@"Testing"];
    [self sendMessageWithText:@"Testing"];
    [self sendMessageWithText:@"Testing"];
    [self sendMessageWithText:@"Testing"];
    [tester tapViewWithAccessibilityLabel:@"Messages"];
    
    [participantSet addObject:user4ID];
    [tester tapViewWithAccessibilityLabel:[self.testInterface conversationLabelForParticipants:participantSet]];
    [self sendMessageWithText:@"Testing"];
    [self sendMessageWithText:@"Testing"];
    [self sendMessageWithText:@"Testing"];
    [self sendMessageWithText:@"Testing"];
    [self sendMessageWithText:@"Testing"];
    [tester tapViewWithAccessibilityLabel:@"Messages"];
}

- (void)sendMessageWithText:(NSString *)messageText
{
    [tester enterText:messageText intoViewWithAccessibilityLabel:@"Text Input View"];
    [tester tapViewWithAccessibilityLabel:@"Send Button"];
    [tester waitForViewWithAccessibilityLabel:[NSString stringWithFormat:@"Message: %@", messageText]];
}

- (void)sendPhotoMessage
{
    [tester tapViewWithAccessibilityLabel:@"Camera Button"];
    [tester tapViewWithAccessibilityLabel:@"Choose Existing"];
    [tester tapViewWithAccessibilityLabel:@"Photo, Landscape, 10:59 AM"];
    [tester tapViewWithAccessibilityLabel:@"Send Button"];
    [tester waitForViewWithAccessibilityLabel:[NSString stringWithFormat:@"Message: Photo"]];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
