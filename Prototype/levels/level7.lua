require ("BaseCode.baseEventHandlers")



local scene = composer.newScene()

function onCollisionDog(event)
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
                display.remove(missileDog)
                changeAntagonistAnimationOnCollision("Enemy"..levelNo.."_die")
                gameStatus = GAME_STATUS_LEVEL_COMPLETE
                display.remove(antagonist)
                nextLevel = display.newImage("KeepGoing Button.png", display.contentCenterX, display.contentCenterY)
                nextLevel:scale(0.25,0.25)
                nextLevel:addEventListener("touch", onTapChangeLevel)

                Runtime:removeEventListener("enterFrame", onFrameEnemyShotDog)
                Runtime:removeEventListener("touch", onTouchShootDog)
                Runtime:removeEventListener("collision", onCollisionDog)

                print("Level done, game status "..gameStatus.." frame "..frameCounter)
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
            nextLevel = display.newImage("KeepGoing Button.png", display.contentCenterX, display.contentCenterY)
                nextLevel:scale(0.25,0.25)
                nextLevel:addEventListener("touch", onTapRepeatLevel)

            display.remove(antagonist)
            changeProtagonistAnimationOnCollision("BR_Die"..levelNo)

            gameStatus = GAME_STATUS_PROTAGONIST_SHOT
        end
    end
end

function onTouchShootDog(event)

    if (event.phase == "began") 
    then       
        if (isWithinTimeWindow(frameCounter, openingFrameForShot - 10, closingFrameForShot)) and (gameStatus == GAME_STATUS_NONE and not (gameStatus == GAME_STATUS_LEVEL_COMPLETE)) 
        then
            --Shooting at right time
            changeProtagonistAnimation("BR_Shoot"..levelNo)
            
            setMissileDog()

            transition.to(missileDog, {x = 500, time = 300,
                onComplete = function() 
                    display.remove(missileDog)
                end
            })
        else 
            if not (gameStatus == GAME_STATUS_LEVEL_COMPLETE)
            then
                --Missed shot opportunity
                print("gameStatus: ".. gameStatus)
                gameStatus = GAME_STATUS_MISSED_TIMEFRAME
            end
        end
    end
end

function setMissileDog()
    missileDog = display.newSprite(missileSpritesheet, missileSequences)
    missileDog.x = missileX+400
    missileDog.y = missileY
    physics.addBody(missileDog, "dynamic", { radius = 100, isSensor=true })
    missileDog.myName = "missile"
    missileDog.gravityScale = 0
    missileDog.alpha = 0
end

function onFrameEnemyShotDog()

    displaySign()
    
    --Enemy shooting
    if (frameCounter == closingFrameForShot) and (score == 0) then
        changeAntagonistAnimation(enemyShootAnimation)

        if (closeCombat)
        then
            antagonist.bodyType = "dynamic"
            antagonist.gravityScale = 0

            transition.to(antagonist, {x = enemyCloseCombatFinalPosition, time = 525,
                onComplete = 
                    function() 
                        display.remove(antagonist) 
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

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
    lives = 1
    levelNo = 7
    closeCombat = true
    enemyCloseCombatFinalPosition = display.contentCenterX - 5
    enemyShootAnimation = "Enemy"..levelNo.."_shoot"
    
    protagonistX = display.contentCenterX - 40
    
    antagonistX = display.contentCenterX + 40
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
        resetVar()
        
        lives = 1
        levelNo = 7
        closeCombat = true
        enemyCloseCombatFinalPosition = display.contentCenterX - 5
        enemyShootAnimation = "Enemy"..levelNo.."_shoot"
        
        protagonistX = display.contentCenterX - 40
        
        antagonistX = display.contentCenterX + 40
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
        setBackgroundImage("Backgrounds\\Lv"..levelNo..".png")

        setProtagonistAnimation("BR_idle")
        setAntagonistAnimation("Enemy"..levelNo.."_idle")

        Runtime:addEventListener("enterFrame", onFrameEnemyShotDog)
        Runtime:addEventListener("touch", onTouchShootDog)
        Runtime:addEventListener("collision", onCollisionDog)
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
        composer.removeScene("levels.level"..levelNo)
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
    clear()
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
