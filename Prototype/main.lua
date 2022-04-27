-- Made by goup 8

require("BaseCode.baseEventHandlers")

audio.setVolume(0.1, {channel=6})

local frame = 0

local function fadeAnimation(event)
    frame = frame + 1
	local fade = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    fade.alpha = -1
    fade:setFillColor(black)
    fade:toFront()
	if (frame == 100)
	then
		transition.to(fade, {alpha = 1, time = 500,
			onComplete = 
				function()
					display.remove(fade)
					composer.gotoScene("levels.mainMenu")
				end})
	end
end

setBackgroundImage("Backgrounds\\madeBy.png")


Runtime:addEventListener("enterFrame", fadeAnimation)

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
