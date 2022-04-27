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
		setBackgroundImage("Backgrounds\\You're Winner.png")
		exit = display.newImage("Adios Button.png", protagonistX, protagonistY)
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
