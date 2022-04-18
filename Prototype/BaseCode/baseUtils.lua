require("BaseCode.baseValues")

function checkCollision(obj1, obj2, name1, name2) 
    return ((obj1.myName == name1 and obj2.myName == name2) or 
            (obj1.myName == name2 and obj2.myName == name1))
end


function setBackgroundImage(filePath)
    local x,y = display.contentCenterX, display.contentCenterY
    o = display.newRect(x, y, display.contentWidth, display.contentHeight)
    o:toFront()
    o.fill = {type = "image", filename = filePath}
end

-- function isWithinTimeWindow(frame, openingFrame, closingFrame) 
function isWithinTimeWindow(frame, openingFrame, closingFrame) 
    return ((frame >= openingFrame) and (frame <= closingFrame))
end

fade = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
fade:setFillColor(black)

function fadeAnimation(destinationPath)
    local fade = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    fade.alpha = 0
    fade:setFillColor(black)
    fade:toFront()
    transition.to(fade, {alpha = 1, time = 600,
        onComplete = 
            function()
                display.remove(fade)
                composer.gotoScene(destinationPath)
            end})
end


function resetVar()
    score = 0
    lives = 1
    gameStatus = GAME_STATUS_NONE
    closeCombat = false
    enemyCloseCombatFinalPosition = -100
    frameCounter = 0

    protagonistX = 100
    protagonistY = display.contentCenterY + 100

    antagonistX = 540
    antagonistY = protagonistY
end