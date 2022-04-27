-- Made by goup 8

require ("..BaseCode.baseLogic")

function onCollision(event)
    if (event.phase == "began") 
    then
        local obj1 = event.object1 
        local obj2 = event.object2 

        print("obj1: " .. obj1.myName)
        print("obj2: " .. obj2.myName)

        --Successfull shot
        if (checkCollision(obj1, obj2, "missile", "antagonist")) and (isWithinTimeWindow(frameCounter, openingFrameForShot, closingFrameForShot + 10))
        then
            lives = lives - 1
            if (lives == 0)
            then
                playSuccessSound()
                Runtime:removeEventListener("touch", onTouchShoot)
                score = 1
                display.remove(sign)
                display.remove(missile)
                nextLevel = display.newImage("KeepGoing Button.png", antagonistX, display.contentCenterY)
                nextLevel:scale(0.25, 0.25)
                nextLevel:addEventListener("touch", onTapChangeLevel)
                changeAntagonistAnimationOnCollision("Enemy"..levelNo.."_die")
                gameStatus = GAME_STATUS_LEVEL_COMPLETE
                print("Level done, level "..levelNo.." lives "..lives)
            elseif (lives > 0) then
                display.remove(missile)
                playShootSound(shootSound)
                playSignSound()
                changeAntagonistAnimationOnCollision("Enemy"..levelNo.."_"..lives.."_die")
                frameCounter = 0
                openingFrameForShot = math.random(30, 60)
                closingFrameForShot = openingFrameForShot + 60
                display.remove(fireSign)
            end
        end
        
        if (closeCombat)
        then
            enemyAtack = "antagonist"
        else
            enemyAtack = "bulletEnemy"
        end

        if (checkCollision(obj1, obj2, enemyAtack, "protagonist")) 
        then
            playFailSound()
            changeProtagonistAnimationOnCollision("BR_Die"..levelNo)
            gameStatus = GAME_STATUS_PROTAGONIST_SHOT
            print("gamestatus "..gameStatus)

            nextLevel = display.newImage("KeepGoing Button.png", antagonistX, display.contentCenterY)
            nextLevel:scale(0.25, 0.25)
            nextLevel:addEventListener("touch", onTapRepeatLevel)
        end
    end
end

function onTouchShoot(event)

    if (event.phase == "began") 
    then       
        if (isWithinTimeWindow(frameCounter, openingFrameForShot, closingFrameForShot)) and (gameStatus == GAME_STATUS_NONE)
        then
            --Shooting at right time
            playShootSound(shootSound)
            print("Frame of shoot "..frameCounter)
            print("Opening frame for shoot "..openingFrameForShot)
            changeProtagonistAnimation("BR_Shoot"..levelNo)
            
            physics.addBody(antagonist, "static", {radius = 100, isSensor=true})
            antagonist.myName = "antagonist"


            setMissile()

            transition.to(missile, {x = 700, time = 400,
                onComplete = function() 
                    display.remove(missile) 
                end
            })
        else 
                --Missed shot opportunity
                playShootSound(missSound)
                gameStatus = GAME_STATUS_PROTAGONIST_SHOT
                Runtime:removeEventListener("touch", onTouchShoot)
        end
    end
end

function onFrameEnemyShot()

    displaySign()
    
    --Enemy shooting
    if (frameCounter == closingFrameForShot) and (score == 0) then
        changeAntagonistAnimation(enemyShootAnimation)

        print(closeCombat)
        print(lives)

        local enemyAtackSound = shootSound

        if (closeCombat)
        then
            antagonist.bodyType = "dynamic"
            antagonist.gravityScale = 0

            if (levelNo == 3)
            then
                enemyAtackSound = swordSound
            end

            if (levelNo == 5)
            then
                enemyAtackSound = carSound
            end

            playShootSound(enemyAtackSound)

            transition.to(antagonist, {x = enemyCloseCombatFinalPosition, time = 550,
                onComplete = 
                    function() 
                        antagonist:toFront()                
                        physics.removeBody(antagonist) 
                    end
            })
        else
            playShootSound(enemyAtackSound)

            setEnemyBullet()

            transition.to(bulletEnemy, {x = -100, time = 525,
                onComplete = 
                    function() 
                        display.remove(bulletEnemy) 
                        physics.removeBody(antagonist)
                    end
            })
        end
    end

    frameCounter = frameCounter + 1
end

function onTapChangeLevel(event)
    gameStatus = GAME_STATUS_LEVEL_COMPLETE
    
    
    print("onTapChangeLevel, gamestatus "..gameStatus)

    if (gameStatus == GAME_STATUS_LEVEL_COMPLETE)
    then
        if (levelNo < 10)
        then
            nextLevel:removeEventListener("touch", onTapChangeLevel)
            display.remove(nextLevel)
            gotoGapLevel()
        else
            nextLevel:removeEventListener("touch", onTapChangeLevel)
            display.remove(nextLevel)
            fadeAnimation("levels.endScreen")
            Runtime:removeEventListener("enterFrame", onFrameEnemyShot)
            Runtime:removeEventListener("touch", onTouchShoot)
            Runtime:removeEventListener("collision", onCollision)
        end
    end
end

function onTapRepeatLevel(event)
    if (gameStatus == GAME_STATUS_PROTAGONIST_SHOT)
    then
        nextLevel:removeEventListener("touch", onTapChangeLevel)
        display.remove(nextLevel)
        fadeAnimation("levels.failScreen")
    end
end

function Start(event)
    print("start, level "..levelNo)
    resetVar()
    fadeAnimation("levels.level"..(levelNo + 1))

end

function Exit()
    print("exit")
    resetVar()
    fadeAnimation("..levels.mainMenu")
end

function Repeat(event)
    print("start, level "..levelNo)
    resetVar()
    fadeAnimation("levels.level"..(levelNo))

end

function gotoGapLevel()
    print("gotoGap")
    
    fadeAnimation("levels.gapLevel")
end

function Extra()
    print("extra")
    resetVar()
    fadeAnimation("..levels.extrasLevel")
end

textImage = nil
function Icon1(event)
    if ( event.phase == "began" ) 
    then
        print("WORKINGG")
        antagonistX = 120
        antagonistY = 80
        setBackgroundImage("Backgrounds\\Character Bios.png")
        clear()
        setAntagonistAnimation("Enemy10_idle")
        textImage = display.newImageRect( "bankerBio.png", 325, 200 )
        textImage.x = 425
        textImage.y = 130
    end
end

function Icon2(event)
    if ( event.phase == "began" ) 
    then
        print("WORKINGG")
        antagonistX = 120
        antagonistY = 80
        setBackgroundImage("Backgrounds\\Character Bios.png")
        clear()
        setAntagonistAnimation("Enemy1_idle")
        textImage = display.newImageRect( "sleepingJoeBio.png", 325, 200 )
        textImage.x = 425
        textImage.y = 130
        
    end
end

function Icon3(event)
    if ( event.phase == "began" ) 
    then
        print("WORKINGG")
        antagonistX = 120
        antagonistY = 80
        setBackgroundImage("Backgrounds\\Character Bios.png")
        clear()
        setAntagonistAnimation("Enemy2_idle")
        textImage = display.newImageRect( "bandaBio.png", 325, 200 )
        textImage.x = 425
        textImage.y = 130
    end
end

function Icon4(event)
    if ( event.phase == "began" ) 
    then
        print("WORKINGG")
        antagonistX = 120
        antagonistY = 80
        setBackgroundImage("Backgrounds\\Character Bios.png")
        clear()
        setAntagonistAnimation("Enemy3_idle")
        textImage = display.newImageRect( "larryBio.png", 325, 200 )
        textImage.x = 425
        textImage.y = 130
    end
end

function Icon5(event)
    if ( event.phase == "began" ) 
    then
        print("WORKINGG")
        antagonistX = 120
        antagonistY = 80
        setBackgroundImage("Backgrounds\\Character Bios.png")
        clear()
        setAntagonistAnimation("Enemy4_idle")
        textImage = display.newImageRect( "bigToothBio.png", 325, 200 )
        textImage.x = 425
        textImage.y = 130
    end
end

function Icon6(event)
    if ( event.phase == "began" ) 
    then
        print("WORKINGG")
        antagonistX = 120
        antagonistY = 80
        setBackgroundImage("Backgrounds\\Character Bios.png")
        clear()
        setAntagonistAnimation("Enemy5_idle")
        textImage = display.newImageRect( "joeBio.png", 325, 200 )
        textImage.x = 425
        textImage.y = 130
    end
end

function Icon7(event)
    if ( event.phase == "began" ) 
    then
        print("WORKINGG")
        antagonistX = 120
        antagonistY = 70
        setBackgroundImage("Backgrounds\\Character Bios.png")
        clear()
        setAntagonistAnimation("Enemy6_idle")
        textImage = display.newImageRect( "foxBio.png", 325, 200 )
        textImage.x = 425
        textImage.y = 130
    end
end

function Icon8(event)
    if ( event.phase == "began" ) 
    then
        print("WORKINGG")
        antagonistX = 120
        antagonistY = 50
        setBackgroundImage("Backgrounds\\Character Bios.png")
        clear()
        setAntagonistAnimation("Enemy7_idle")
        textImage = display.newImageRect( "churroBio.png", 325, 200 )
        textImage.x = 425
        textImage.y = 130
    end
end

function Icon9(event)
    if ( event.phase == "began" ) 
    then
        print("WORKINGG")
        antagonistX = 120
        antagonistY = 80
        setBackgroundImage("Backgrounds\\Character Bios.png")
        clear()
        setAntagonistAnimation("Enemy8_idle")
        textImage = display.newImageRect( "richolasBio.png", 325, 200 )
        textImage.x = 425
        textImage.y = 130
    end
end

function Icon10(event)
    if ( event.phase == "began" ) 
    then
        print("WORKINGG")
        antagonistX = 120
        antagonistY = 80
        setBackgroundImage("Backgrounds\\Character Bios.png")
        clear()
        --FIX
        --need to scale
        setAntagonistAnimation("Enemy9_idle")
        antagonist:scale(0.4, 0.4)
        textImage = display.newImageRect( "suicideBio.png", 325, 200 )
        textImage.x = 425
        textImage.y = 130
    end
end

function Icon11(event)
    if ( event.phase == "began" ) 
    then
        print("WORKINGG")
        protagonistX = 120
        protagonistY = 80
        setBackgroundImage("Backgrounds\\Character Bios.png")
        clear()
        setProtagonistAnimation("BR_idle")
        textImage = display.newImageRect( "normanBio.png", 325, 200 )
        textImage.x = 425
        textImage.y = 130
    end
end
