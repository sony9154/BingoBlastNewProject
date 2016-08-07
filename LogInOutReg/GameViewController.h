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

#define SKILL_ANIME_FADE_IN_INTERVAL 1
#define SKILL_ANIME_FADE_OUT_INTERVAL 1
#define SKILL_ANIME_INTERVAL 2
#define SKILL_ANIME_BACKGROUND_LOOP_INTERVAL 1

typedef enum GameResultType{
    
    GameResultWin,
    GameResultLose,
    GameResultDraw
    
}GameResultType;

@interface GameViewController : UIViewController
{
    UIView* clockView;
    UILabel* clockLabel;
    
    //    Board* board;
    Player* player;
    UIView* boardView;
    BlockButton* blockButtons[LINE_LENGTH][LINE_LENGTH];
    UIImageView* drawBoardView;//used to draw line...
    __weak IBOutlet UILabel *scoreLabel;
//    BOOL isWin;
    GameResultType gameResult;
    
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
//    UIView* skillAnimeView;
    UIView* skillAnimeDarkView;
    UIImageView* skillAnimeBackgroundView;
    UIImageView* skillAnimeForegroundView;
    UIView* skillAnimeLightView;
    
    NSTimer* stateAccessTimer;
    NSMutableArray<State*>* states;
    
    
    
    NSURL* bgmFile;
    AVAudioPlayer* bgmPlayer;
    __weak IBOutlet UILabel *bgmAuthor;
    //    __weak IBOutlet UILabel *bgmAuthorWeb;
    AVAudioPlayer* blockClickedSoundPlayer;
    BOOL isMuted;
    
    BOOL isOver;
}

- (void) loadBGMFile;

- (void) blockPressed:(BlockButton*)sender;
- (void) drawOpponentBoard;

- (void) createCallNumber;
- (void) startCallNumber;
- (void) callNewNumber;

- (void) useSkill;

- (void) accessState;

- (void) updateScore;
- (void) updateCallNumbers;
- (void) updateClock;
- (void) updateSkillOperationArea;
- (void) updateGame;

- (void) gameOver;
- (void) backToMenu:(id)sender;
- (IBAction)surrender:(id)sender;


@end

