local x,y = display.contentCenterX, display.contentCenterY
local o = display.newRect( x, y, display.contentWidth, display.contentHeight )
o.fill = { type="image", filename="Backgrounds\\Lv3 Larry.png" }

--
--Util variables
local physics = require("physics")
physics.start()

local score = 0;

local sign
local miss = 0
local counter = 0
local openingWondowForShot = math.random(30, 60)
local closingWindowForShot = openingWondowForShot + 60

--
--Characters
local protagonist = display.newImage("Sprites\\Big Richard\\Bigger_Richard.png",100, display.contentCenterY+100, 20, 20)
physics.addBody(protagonist, "static", {radius = 20, isSensor=true })
protagonist.myName = "protagonist"

local antaganist = display.newImage("Sprites\\Enemies\\Larry (Sword Guy)\\Larry_Idle.png", 540, display.contentCenterY+100, 20, 20)
physics.addBody(antaganist, "static")
antaganist.myName = "antaganist"

--
--Bullets
local bullet

--
--Controls player's shooting and correctness of those
    function shoot(event)
        if (event.phase == "began") then
            if (counter >= openingWondowForShot) and (counter <= closingWindowForShot) and (miss == 0) then
                --Shooting at right time
                bullet = display.newRect(120, display.contentCenterY+100, 20, 5)
                physics.addBody(bullet, "dynamic", {radius = 20, isSensor=true })
                bullet.myName = "bullet"
                transition.to(bullet, {x = 560, time = 300,
                onComplete = function() display.remove( bullet ) end
                })
            else 
                --Miss shot
                print("miss: ".. miss)
                display.newText("MISS", display.contentCenterX, display.contentCenterY, native.systemFont, 40 )
                miss = 1;
            end
        end
    end

--
--Controls enemy's shooting and sign    
    function shootEnemy()
        --Sign
        if (counter == openingWondowForShot) then
            sign = display.newImage("Sprites\\Objects\\Fire!!.png", display.contentCenterX, display.contentCenterY)
        end

        if (counter == closingWindowForShot) then
            display.remove(sign)
        end
        
        --Enemy shooting
        if (counter == closingWindowForShot) and (score == 0) and not (miss == 2) then
            antaganist.bodyType = "dinamic", {radius = 20, isSensor=true }
            antaganist.gravityScale = 0

            display.remove(antaganist)
            antaganist = display.newImage("Sprites\\Enemies\\Larry (Sword Guy)\\Larry_Slash_F1.png", 540, display.contentCenterY+100, 20, 20)

            transition.to(antaganist, {x = 150, time = 525,
            onComplete = 
            function()
                display.remove(antaganist)
                antaganist = display.newImage("Sprites\\Enemies\\Larry (Sword Guy)\\Larry_Slash_F3.png", 150, display.contentCenterY+100, 20, 20)
            end
            })
        end

        counter = counter + 1
    end


Runtime:addEventListener("enterFrame", shootEnemy)
Runtime:addEventListener("touch", shoot)

--
--Collision

local function onLocalCollision(event)
    if (event.phase == "began") then
        local obj1 = event.object1 
        local obj2 = event.object2 
        print("obj1: " .. obj1.myName)
        print("obj2: " .. obj2.myName)

        --Successfull shot
        if ((obj1 == bullet and obj2 == antaganist) or 
            (obj1 == antaganist and obj2 == bullet))
        then
            if (counter < closingWindowForShot) and (counter > openingWondowForShot)
            then
                display.remove(antaganist)
                antaganist = display.newImage("Sprites\\Enemies\\Larry (Sword Guy)\\Larry_Die_F1.png", 540, display.contentCenterY+100, 20, 20)
                score = 1
            else
                miss = 2 
                display.remove(protagonist)
                protagonist = display.newImage("Sprites\\Big Richard\\Big_Richard_Die1_F4.png",100, display.contentCenterY+100, 20, 20)
            end
        end

        if ((obj1 == antaganist and obj2 == protagonist) or 
            (obj1 == protagonist and obj2 == antaganist))
        then
            display.remove(protagonist)
            protagonist = display.newImage("Sprites\\Big Richard\\Big_Richard_Die1_F4.png",100, display.contentCenterY+100, 20, 20)
            antaganist:toFront()
            miss = 2
        end
    end
end

Runtime:addEventListener("collision", onLocalCollision)