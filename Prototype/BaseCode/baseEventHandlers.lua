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
                changeAntagonistAnimationOnCollision("Enemy"..levelNo.."_die")
                gameStatus = GAME_STATUS_LEVEL_COMPLETE
                print("Level done, level "..levelNo.." lives "..lives)
                Runtime:removeEventListener("touch", onTouchShoot)
            else
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
        end
    end
end

function onTouchShoot(event)

    if (event.phase == "began") 
    then       
        if (isWithinTimeWindow(frameCounter, openingFrameForShot, closingFrameForShot)) and (gameStatus == GAME_STATUS_NONE and not (gameStatus == GAME_STATUS_LEVEL_COMPLETE)) 
        then
            --Shooting at right time
            print("Frame of shoot "..frameCounter)
            print("Opening frame for shoot "..openingFrameForShot)
            changeProtagonistAnimation("BR_Shoot"..levelNo)
            
            setMissile()

            transition.to(missile, {x = 600, time = 300,
                onComplete = function() 
                    display.remove(missile) 
                end
            })
        else 
                --Missed shot opportunity
                gameStatus = GAME_STATUS_MISSED_TIMEFRAME
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
                    end
            })
        else
            setEnemyBullet()

            transition.to(bulletEnemy, {x = -100, time = 525,
                onComplete = 
                    function() 
                        display.remove(bulletEnemy) 
                    end
            })
        end
    end

    frameCounter = frameCounter + 1
end

function onTapChangeLevel(event)
    if (event.phase == "began")
    then
        print("game status "..gameStatus)
    end


    if (gameStatus == GAME_STATUS_LEVEL_COMPLETE)--      and (event.phase == "began")
    then
        Runtime:removeEventListener("enterFrame", onFrameEnemyShot)
		Runtime:removeEventListener("touch", onTouchShoot)
		Runtime:removeEventListener("collision", onCollision)

		resetVar()
		clear()

        gotoGapLevel()
    end
end