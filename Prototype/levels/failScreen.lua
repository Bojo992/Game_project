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
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		resetVar()

		
		
		setBackgroundImage("Backgrounds\\Game Over.png")

		start = display.newImage("KeepGoing Button.png", antagonistX - 150, protagonistY)
		start:scale(0.5, 0.5)
		start:addEventListener("tap", Repeat)
	
		
		exit = display.newImage("ToStart Button.png", antagonistX, antagonistY)
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
		start:removeEventListener("tap", Repeat)
		start.alpha = 0
		display.remove(start)
		exit:removeEventListener("tap", Exit)
		exit.alpha = 0
		display.remove(exit)
		display.remove(o)
		composer.removeScene("levels.failScreen")
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )
	
	local sceneGroup = self.view
	exit:removeEventListener("tap", Exit)
	start:removeEventListener("tap", Repeat)
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
