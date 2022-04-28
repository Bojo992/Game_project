-- Made by goup 8

require ("BaseCode.baseEventHandlers")

local shootprotection = true

function onTouchShootLv9(event)
    if (event.phase == "began") 
    then       
        if (isWithinTimeWindow(frameCounter, openingFrameForShot, closingFrameForShot)) and (gameStatus == GAME_STATUS_NONE) and shootprotection
        then
            --Shooting at right time
            shootprotection = false
            Runtime:removeEventListener("touch", onTouchShootLv9)
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
                Runtime:removeEventListener("touch", onTouchShootLv9)
                gameStatus = GAME_STATUS_PROTAGONIST_SHOT
                Runtime:removeEventListener("touch", onTouchShoot)
        end
    end
end


function onCollisionLv9(event)
    if (event.phase == "began") 
    then
        local obj1 = event.object1 
        local obj2 = event.object2 

        print("obj1: " .. obj1.myName)
        print("obj2: " .. obj2.myName)

        --Successfull shot
        if (checkCollision(obj1, obj2, "missile", "antagonist")) 
        then
            changeProtagonistAnimationOnCollision("BR_Die"..levelNo)
            gameStatus = GAME_STATUS_PROTAGONIST_SHOT
            nextLevel = display.newImage("KeepGoing Button.png", antagonistX, display.contentCenterY)
            nextLevel:scale(0.25,0.25)
            nextLevel:addEventListener("tap", onTapRepeatLevel)
        end
    end
end

function onFrameEnemyShotLv9()
    --display fire sign within opening and closing frames
    displaySign()
    
    --Enemy shooting
    if (frameCounter == closingFrameForShot) and not (gameStatus == GAME_STATUS_PROTAGONIST_SHOT) then
        gameStatus = GAME_STATUS_LEVEL_COMPLETE

        nextLevel = display.newImage("KeepGoing Button.png", antagonistX, display.contentCenterY)
        nextLevel:scale(0.25, 0.25)
        nextLevel:addEventListener("touch", onTapChangeLevel)
    end

    frameCounter = frameCounter + 1
end

local scene = composer.newScene()

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
    
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
        shootprotection = true
        resetVar()
        lives = 1
        levelNo = 9

        openingFrameForShot = 0

        enemyShootAnimation = "Enemy"..levelNo.."_shoot"
       
        setBackgroundImage("Backgrounds\\Lv"..levelNo..".png")

        setProtagonistAnimation("BR_idle")
        setAntagonistAnimation("Enemy"..levelNo.."_idle")
        
        Runtime:addEventListener("enterFrame", onFrameEnemyShotLv9)
        Runtime:addEventListener("touch", onTouchShootLv9)
        Runtime:addEventListener("collision", onCollisionLv9)
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
        
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
        
        composer.removeScene("levels.level"..levelNo)
        clear()
        physics.removeBody(protagonist)
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
