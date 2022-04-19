require ("BaseCode.baseEventHandlers")

local scene = composer.newScene()
closeCombat = true

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
		resetVar()
		
		closeCombat = true		
		lives = 1
		levelNo = 5
		enemyCloseCombatFinalPosition = -100
		enemyShootAnimation = "Enemy"..levelNo.."_shoot"
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		setBackgroundImage("Backgrounds\\Lv"..levelNo..".png")

		setProtagonistAnimation("BR_idle")
		setAntagonistAnimation("Enemy"..levelNo.."_idle")

		Runtime:addEventListener("enterFrame", onFrameEnemyShot)
		Runtime:addEventListener("touch", onTouchShoot)
		Runtime:addEventListener("collision", onCollision)
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	Runtime:removeEventListener("enterFrame", onFrameEnemyShot)
	Runtime:removeEventListener("touch", onTouchShoot)
	Runtime:removeEventListener("collision", onCollision)
	physics.removeBody(antagonist)
	physics.removeBody(protagonist)
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
