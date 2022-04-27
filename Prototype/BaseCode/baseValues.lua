-- Made by goup 8

GAME_STATUS_NONE             = 0
GAME_STATUS_MISSED_TIMEFRAME = 1
GAME_STATUS_PROTAGONIST_SHOT = 2
GAME_STATUS_LEVEL_COMPLETE = 3

score = 0
lives = 1
gameStatus = GAME_STATUS_NONE
closeCombat = false
enemyCloseCombatFinalPosition = -100
frameCounter = 0

antagonistX = 540
antagonistY = protagonistY

protagonistX = 100
protagonistY = display.contentCenterY + 100