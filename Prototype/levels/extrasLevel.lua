-- Made by goup 8

require ("BaseCode.baseEventHandlers")

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
	print("switch")

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		resetVar()

		setBackgroundImage("Backgrounds\\Character Bios.png")
		o:toFront()

		exit = display.newImage("ToStart Button.png", 230,315)
		exit:addEventListener("tap", Exit)
		exit:scale(0.25, 0.25)
		
		protagonistX = 120
        protagonistY = 80
		setProtagonistAnimation("BR_idle")
        textImage = display.newImageRect( "normanBio.png", 325, 200 )
        textImage.x = 425
        textImage.y = 130
		
		icon1 = display.newImageRect("bios_banker.png",300,315)
		icon1.x = 310
		icon1.y = 315
		icon1:scale(0.075,0.075)
		icon1:addEventListener("touch",Icon1)

		icon2 = display.newImageRect("bios_steve.png",300,315)
		icon2.x = 340
		icon2.y = 315
		icon2:scale(0.075,0.075)
		icon2:addEventListener("touch",Icon2)

		icon3 = display.newImageRect("bios_banda.png",300,315)
		icon3.x = 370
		icon3.y = 315
		icon3:scale(0.075,0.075)
		icon3:addEventListener("touch",Icon3)

		icon4 = display.newImageRect("bios_larry.png",300,315)
		icon4.x = 400
		icon4.y = 315
		icon4:scale(0.075,0.075)
		icon4:addEventListener("touch",Icon4)
		
		icon5 = display.newImageRect("bios_bigTooth.png",300,315)
		icon5.x = 430
		icon5.y = 315
		icon5:scale(0.075,0.075)
		icon5:addEventListener("touch",Icon5)

		icon6 = display.newImageRect("bios_wheelieJoe.png",300,315)
		icon6.x = 460
		icon6.y = 315
		icon6:scale(0.075,0.075)
		icon6:addEventListener("touch",Icon6)
		
		icon7 = display.newImageRect("bios_fox.png",300,315)
		icon7.x = 490
		icon7.y = 315
		icon7:scale(0.075,0.075)
		icon7:addEventListener("touch",Icon7)

		icon8 = display.newImageRect("bios_churro.png",300,315)
		icon8.x = 520
		icon8.y = 315
		icon8:scale(0.075,0.075)
		icon8:addEventListener("touch",Icon8)

		icon9 = display.newImageRect("bios_richolas.png",300,315)
		icon9.x = 550
		icon9.y = 315
		icon9:scale(0.075,0.075)
		icon9:addEventListener("touch",Icon9)

		icon10 = display.newImageRect("bios_suicideButton.png",300,315)
		icon10.x = 580
		icon10.y = 315
		icon10:scale(0.075,0.075)
		icon10:addEventListener("touch",Icon10)

		icon11 = display.newImageRect("bios_norman.png",300,315)
		icon11.x = 610
		icon11.y = 315
		icon11:scale(0.075,0.075)
		icon11:addEventListener("touch",Icon11)
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
        exit:removeEventListener("tap", Exit)
		exit.alpha = 0
		display.remove(exit)
		display.remove(o)
		icon1:removeEventListener("touch",Icon1)
		icon2:removeEventListener("touch",Icon2)
		icon3:removeEventListener("touch",Icon3)
		icon4:removeEventListener("touch",Icon4)
		icon5:removeEventListener("touch",Icon5)
		icon6:removeEventListener("touch",Icon6)
		icon7:removeEventListener("touch",Icon7)
		icon8:removeEventListener("touch",Icon8)
		icon9:removeEventListener("touch",Icon9)
		icon10:removeEventListener("touch",Icon10)
		icon11:removeEventListener("touch",Icon11)
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