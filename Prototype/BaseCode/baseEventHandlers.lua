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
                changeAntagonistAnimationOnCollision("Enemy"..levelNo.."_"..lives.."_die")
                frameCounter = 0
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
            print("Frame of shoot "..frameCounter)
            print("Opening frame for shoot "..openingFrameForShot)
            changeProtagonistAnimation("BR_Shoot"..levelNo)
            
            physics.addBody(antagonist, "static", {radius = 100, isSensor=true})
            antagonist.myName = "antagonist"


            setMissile()

            transition.to(missile, {x = 700, time = 200,
                onComplete = function() 
                    display.remove(missile) 
                end
            })
        else 
                --Missed shot opportunity
                gameStatus = GAME_STATUS_PROTAGONIST_SHOT
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

        if (closeCombat)
        then
            antagonist.bodyType = "dynamic"
            antagonist.gravityScale = 0

            transition.to(antagonist, {x = enemyCloseCombatFinalPosition, time = 525,
                onComplete = 
                    function() 
                        antagonist:toFront()                
                        physics.removeBody(antagonist) 
                    end
            })
        else
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