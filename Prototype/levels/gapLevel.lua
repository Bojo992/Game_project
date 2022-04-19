require ("BaseCode.baseEventHandlers")
resetVar()

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
	
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		Runtime:addEventListener("enterFrame", onFrameEnemyShot)
		Runtime:addEventListener("touch", onTouchShoot)
		Runtime:addEventListener("collision", onCollision)
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		setBackgroundImage("Backgrounds\\Kinda Pause Menu.png")

		start = display.newImage("KeepGoing Button.png", protagonistX, protagonistY)
		start:scale(0.5, 0.5)
		start:addEventListener("tap", Start)
	
		
		exit = display.newImage("Adios Button.png", antagonistX, antagonistY)
		exit:addEventListener("tap", Exit)
		exit:scale(0.25, 0.25)
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		
		local sceneGroup = self.view

		
		
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		start:removeEventListener("tap", Start)
		start.alpha = 0
		display.remove(start)
		start.alpha = 0
		print(start)
		exit:removeEventListener("tap", Exit)
		exit.alpha = 0
		display.remove(exit)
		display.remove(o)
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )
	
	local sceneGroup = self.view
	start:removeEventListener("tap", Start)
	exit:removeEventListener("tap", Exit)
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
