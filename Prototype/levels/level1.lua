require("BaseCode.baseEventHandlers")

local scene = composer.newScene()


function scene:create( event )
	local sceneGroup = self.view
end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

		
	resetVar()
	print("frame counterf: "..frameCounter)	

	lives = 1
	levelNo = 1
	print(levelNo)
	enemyShootAnimation = "Enemy"..levelNo.."_shoot"
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on scree

		setBackgroundImage("Backgrounds\\Lv"..levelNo..".png")

		setProtagonistAnimation("BR_idle")
		setAntagonistAnimation("Enemy"..levelNo.."_idle")
		
		Runtime:addEventListener("enterFrame", onFrameEnemyShot)
		Runtime:addEventListener("touch", onTouchShoot)
		Runtime:addEventListener("collision", onCollision)	
	end
end

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
