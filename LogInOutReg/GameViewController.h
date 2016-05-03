//
//  ViewController.h
//  HelloBingo
//
//  Created by WHITEer on 2016/03/26.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "BlockButton.h"
#import "Player.h"
#import "Board.h"
#import "CallNumbers.h"
#import "SkillButton.h"
#import "Skill.h"
#import "SkillDestroy.h"
#import "SkillSeal.h"
#import "SkillAid.h"
#import "State.h"
#import "StateDestroy.h"
#import "StateSeal.h"
#import "StateAid.h"

#define CALL_NUMBER_TIME_INTERVAL 3 //unit is second. 3 may be used.
#define STATE_ACCESS_INTERVAL 1 //unit is second

@interface GameViewController : UIViewController
{
    UIView* clockView;
    
    //    Board* board;
    Player* player;
    UIView* boardView;
    BlockButton* blockButtons[LINE_LENGTH][LINE_LENGTH];
    UIImageView* drawBoardView;//used to draw line...
    __weak IBOutlet UILabel *scoreLabel;
    
    Player* opponent;
    UIView* opponentBoardView;
    __weak IBOutlet UILabel *opponentScoreLabel;
    UIImageView* drawOpponentBoardView;//used to draw line...
    
    CallNumbers* callNumbers;
    UIView* callNumberView;
    UILabel* callNumberLabels[CALL_NUMBER_COUNT];
    NSTimer* callNumberTimer;
    
    NSMutableArray<Skill*>* skills;
    UIView* skillActionBar;
    NSMutableArray<SkillButton*>* skillButtons;
//    NSMutableArray* skillSelectButtons;
    BOOL isPlayingAnimation;
    
    NSTimer* stateAccessTimer;
    NSMutableArray<State*>* states;
    
    AVAudioPlayer* bgmPlayer;
    __weak IBOutlet UILabel *bgmAuthor;
    //    __weak IBOutlet UILabel *bgmAuthorWeb;
    AVAudioPlayer* blockClickedSoundPlayer;
    BOOL isMuted;
    
    BOOL isOver;
}

- (void) blockPressed:(BlockButton*)sender;
- (void) drawOpponentBoard;

- (void) createCallNumber;
- (void) startCallNumber;
- (void) callNewNumber;

- (void) useSkill;

- (void) accessState;

- (void) updateScore;
- (void) updateCallNumbers;
- (void) updateSkillOperationArea;
- (void) updateGame;

- (void) backToMenu:(id)sender;
- (void) gameOver;

@end

