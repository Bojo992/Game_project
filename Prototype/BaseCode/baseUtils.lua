require("BaseCode.baseValues")

function checkCollision(obj1, obj2, name1, name2) 
    return ((obj1.myName == name1 and obj2.myName == name2) or 
            (obj1.myName == name2 and obj2.myName == name1))
end


function setBackgroundImage(filePath)
    local x,y = display.contentCenterX, display.contentCenterY
    o = display.newRect(x, y, display.contentWidth, display.contentHeight)
    o.fill = {type = "image", filename = filePath}
end

-- function isWithinTimeWindow(frame, openingFrame, closingFrame) 
function isWithinTimeWindow(frame, openingFrame, closingFrame) 
    return ((frame >= openingFrame) and (frame <= closingFrame))
end

fade = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
fade:setFillColor(black)

function Start()
    print("start")
    
    fadeAnimation("levels.level"..(levelNo + 1))
end

function Exit()
    print("exit")
    
    fadeAnimation("main")
end

function gotoGapLevel()
    print("gotoGap")
    
    fadeAnimation("levels.gapLevel")
end

function Repeat()
    print("repeat")
    
    fadeAnimation("levels.level"..levelNo)
end

function fadeAnimation(destinationPath)
    composer.gotoScene(destinationPath)
    -- local fade = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    -- fade.alpha = 0
    -- fade:setFillColor(black)
    -- fade:toFront()
    -- transition.to(fade, {alpha = 1, time = 600,
    --     onComplete = 
    --         function()
    --             display.remove(fade)
    --             composer.gotoScene(destinationPath)
    --         end})
end