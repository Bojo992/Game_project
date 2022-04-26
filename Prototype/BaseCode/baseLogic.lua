require("BaseCode.baseUtils")

physics = require("physics")
physics.start()

composer = require("composer")

--Sounds
successSound = audio.loadSound("Sound\\Success_sound_effect.mp4")
failSound = audio.loadSound("Sound\\Fail_sound_effect.mp4")
shootSound = audio.loadSound("Sound\\shoot_soun_effect.mp3")
carSound = audio.loadSound("Sound\\car_sound_effect.mp3")
swordSound = audio.loadSound("Sound\\sword_sound_effect.mp3")
happyDogSound = audio.loadSound("Sound\\happy_dog_sound_effect.mp3")
angryDogSound = audio.loadSound("Sound\\angry_dog_sound_effect.mp3")
missSound = audio.loadSound("Sound\\miss_sound_effect.mp3")
signSound = audio.loadSound("Sound\\sign_sound_effect.mp3")
backgroundSound = audio.loadSound("Sound\\background_sound_effect.mp3")


--Setup for protagonist animations 
local protagonistAnimations = require("Animation.BR")
local protagonistSheetOptions = protagonistAnimations:getSheet()
local protagonistSequences = protagonistAnimations:get()
local protagonistSpritesheet = graphics.newImageSheet("Animation\\BR.png", protagonistSheetOptions)

--Setup for antagonist animations
local antagonistAnimations = require("Animation.Enemies")
local antagonistSheetOptions = antagonistAnimations:getSheet()
local antagonistSequences = antagonistAnimations:get()
local antagonistSpritesheet = graphics.newImageSheet("Animation\\Enemies.png", antagonistSheetOptions)

--Setup for missile animations
missileAnimations = require("Missile")
missileSheetOptions = missileAnimations:getSheet()
missileSequences = missileAnimations:get()
missileSpritesheet = graphics.newImageSheet("Missile.png", missileSheetOptions)

score = 0;
lives = 0
gameStatus = GAME_STATUS_NONE
levelNo = 0
closeCombat = false
enemyCloseCombatFinalPosition = -100

frameCounter = 0

openingFrameForShot = math.random(30, 60)
closingFrameForShot = openingFrameForShot + 60

--Setup for protagonist
fireSign = nil
protagonist = nil
protagonistX = 100
protagonistY = display.contentCenterY + 100

--Setup for antagonist
antagonist = nil
antagonistX = 540
antagonistY = protagonistY
enemyShootAnimation = ""

--Setup for missile
missileX = 120
missileY = display.contentCenterY + 100

function displaySign()
    if (frameCounter == openingFrameForShot) and (score == 0) 
    then
        playSignSound()

        fireSign = display.newImage("Fire!!.png", display.contentCenterX, display.contentCenterY)
        
        antagonist.myName = "antagonist"
    end

    if (frameCounter == closingFrameForShot) 
    then
        display.remove(fireSign)
    end
end

function setProtagonistAnimation(animationName)
    protagonist = display.newSprite(protagonistSpritesheet, protagonistSequences)
    protagonist.x = protagonistX
    protagonist.y = protagonistY
    protagonist:setSequence(animationName)
    protagonist:play()

    physics.addBody(protagonist, "static", {radius = 20, isSensor=true })
    protagonist.myName = "protagonist"

    
end

function changeProtagonistAnimation(animationName)
    physics.removeBody(protagonist)
    display.remove(protagonist)
    protagonist = display.newSprite(protagonistSpritesheet, protagonistSequences)
    protagonist.x = protagonistX
    protagonist.y = protagonistY
    protagonist:setSequence(animationName)
    protagonist:play()

    physics.addBody(protagonist, "static", {radius = 100, isSensor=true})
    protagonist.myName = "protagonist"

    
end

function changeProtagonistAnimationOnCollision(animationName)
    display.remove(protagonist)
    protagonist = display.newSprite(protagonistSpritesheet, protagonistSequences)
    protagonist.x = protagonistX
    protagonist.y = protagonistY
    protagonist:setSequence(animationName)
    protagonist:play()

    
end

function setAntagonistAnimation(animationName)

    antagonist = display.newSprite(antagonistSpritesheet, antagonistSequences)
    antagonist.x = antagonistX
    antagonist.y = antagonistY
    antagonist:setSequence(animationName)
    antagonist:play()

    physics.addBody(antagonist, "static", {radius = 100, isSensor=true})
    antagonist.myName = "antagonist"

    
end

function changeAntagonistAnimation(animationName)
    display.remove(antagonist)
    antagonist = display.newSprite(antagonistSpritesheet, antagonistSequences)
    antagonist.x = antagonistX
    antagonist.y = antagonistY
    antagonist:setSequence(animationName)
    antagonist:play()

    physics.addBody(antagonist, "static", { radius = 20, isSensor=true })
    antagonist.myName = "antagonist"
    
    
end

function changeAntagonistAnimationOnCollision(animationName)
    display.remove(antagonist)
    print("Enemys death "..animationName)
    antagonist = display.newSprite(antagonistSpritesheet, antagonistSequences)
    antagonist.x = antagonistX
    antagonist.y = antagonistY
    antagonist:setSequence(animationName)
    antagonist:play()

    
end

function setMissile()
    missile = display.newSprite(missileSpritesheet, missileSequences)
    missile.x = missileX
    missile.y = missileY
    missile:setSequence("Missile")
    missile:play()
    physics.addBody(missile, "dynamic", { radius = 100, isSensor=true })
    missile.myName = "missile"
    missile.gravityScale = 0
end

function setEnemyBullet()
    bulletEnemy = display.newRect(antagonistX, antagonistY, 35, 10)
    bulletEnemy.fill = {129, 133, 137}
    physics.addBody(bulletEnemy, "dynamic", {isSensor = true})
    bulletEnemy.gravityScale = 0
    bulletEnemy.myName = "bulletEnemy"

    physics.addBody(protagonist, "static", {radius = 20, isSensor=true })
    protagonist.myName = "protagonist"
end

function playSuccessSound()
    audio.play(successSound,{
        channel = 1,
        loop = 1,
        fedein = 500,
    })
end

function playFailSound()
    audio.play(failSound,{
        channel = 1,
        loop = 1,
        fedein = 500,
    })
end

function playShootSound(enemyShootSound)
    audio.play(enemyShootSound,{
        channel = 2,
        loop = 1,
        fedein = 500,
    })
end

function playSignSound()
    audio.play(signSound,{
        channel = 3,
        loop = 1,
        fedein = 500,
    })
end

function clear()
    display.remove(protagonist)
    display.remove(antagonist)
    display.remove(fireSign)
    display.remove(o)

    Runtime:removeEventListener("enterFrame", onFrameEnemyShot)
    Runtime:removeEventListener("touch", onTouchShoot)
    Runtime:removeEventListener("collision", onCollision)

    Runtime:removeEventListener("enterFrame", onFrameEnemyShotDog)
    Runtime:removeEventListener("touch", onTouchShootDog)
    Runtime:removeEventListener("collision", onCollisionDog)

    Runtime:removeEventListener("enterFrame", onFrameEnemyShotLv9)
    Runtime:removeEventListener("collision", onCollisionLv9)
end

function resetVar()
    score = 0
    lives = 1
    gameStatus = GAME_STATUS_NONE
    closeCombat = false
    enemyCloseCombatFinalPosition = -100
    frameCounter = 0

    protagonistX = 100
    protagonistY = display.contentCenterY + 100

    antagonistX = 540
    antagonistY = protagonistY

    openingFrameForShot = math.random(30, 60)
    closingFrameForShot = openingFrameForShot + 60
end