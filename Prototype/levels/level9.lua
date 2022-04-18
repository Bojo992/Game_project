require ("BaseCode.baseEventHandlers")

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
        end
    end
end

function onFrameEnemyShotLv9()
    --display fire sign within opening and closing frames
    displaySign()
    
    --Enemy shooting
    if (frameCounter == closingFrameForShot) and (score == 0) and not (gameStatus == GAME_STATUS_PROTAGONIST_SHOT) then
        gotoGapLevel()
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
    lives = 1
    levelNo = 9
    enemyShootAnimation = "Enemy"..levelNo.."_shoot"
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
        setBackgroundImage("Backgrounds\\Lv"..levelNo..".png")

        setProtagonistAnimation("BR_idle")
        setAntagonistAnimation("Enemy"..levelNo.."_idle")
        
        Runtime:addEventListener("enterFrame", onFrameEnemyShotLv9)
        Runtime:addEventListener("touch", onTouchShoot)
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
        Runtime:removeEventListener("enterFrame", onFrameEnemyShotLv9)
		Runtime:removeEventListener("touch", onTouchShoot)
		Runtime:removeEventListener("collision", onCollisionLv9)

		resetVar()
		clear()
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
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
