local x,y = display.contentCenterX, display.contentCenterY
local o = display.newRect( x, y, display.contentWidth, display.contentHeight )
o.fill = { type="image", filename="Backgrounds\\Lv8 Richolas.png" }
--
--Util variables
local physics = require("physics")
physics.start()

local score = 0;

lifes = 2
local sign
local miss = 0
local counter = 0
local openingWondowForShot = math.random(30, 60)
local closingWindowForShot = openingWondowForShot + 60

--
--Characters
-- local protagonist = display.newRect(100, display.contentCenterY+100, 50, 50)
-- protagonist.alpha = 0;
local protagonist = display.newImage("Sprites\\Big Richard\\Bigger_Richard.png",100, display.contentCenterY+100, 20, 20)
physics.addBody(protagonist, "static", {radius = 20, isSensor=true })
protagonist.myName = "protagonist"

local antaganist = display.newImage("Sprites\\Enemies\\Big Banker\\Big_Banker_Idle.png", 540, display.contentCenterY+100, 20, 20)
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
                physics.addBody(antaganist, "static", {radius = 20, isSensor=true })
                transition.to(bullet, {x = 560, time = 300,
                onComplete = function() display.remove( bullet ) end
                })
            else 
                --Miss shot
                print("miss: ".. miss)
                miss = 1;
            end
        end
    end

--
--Controls enemy's shooting and sign    
    function shootEnemy()
        --Sign
        if (counter == openingWondowForShot) then
            antaganist = display.newImage("Sprites\\Enemies\\Big Banker\\Big_Banker_Shoot_F3.png", 540, display.contentCenterY+100, 20, 20)
            antaganist.myName = "antaganist"
            sign = display.newImage("Sprites\\Objects\\Fire!!.png", display.contentCenterX, display.contentCenterY)
        end

        if (counter == closingWindowForShot) then
            display.remove(sign)
        end
        
        --Enemy shooting
        if (counter == closingWindowForShot) and (score == 0) then
            antaganist.bodyType = "dinamic", {radius = 20, isSensor=true }
            antaganist = display.newImage("Sprites\\Enemies\\Big Banker\\Big_Banker_Shoot_F1.png", 540, display.contentCenterY+100, 20, 20)
            antaganist.myName = "antaganist"
            onComplete = function() display.remove(antaganist) end
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
            lifes = lifes - 1
            if (lifes == 0)
            then
                score = 1
                display.remove(antaganist)
                antaganist = display.newImage("Sprites\\Enemies\\Revolver Richolas\\Revolver_Richolas_Dead.png", 540, display.contentCenterY+100, 20, 20)
            else
                display.remove(antaganist)
                antaganist = display.newImage("Sprites\\Enemies\\Big Banker\\Big_Banker_ShotOnce.png", 540, display.contentCenterY+100, 20, 20)
                antaganist.myName = "antaganist"
                transition.to(antaganist, {x = 541, time = 525,
                onComplete = 
                function()
                    display.remove(antaganist)
                    antaganist = display.newImage("Sprites\\Enemies\\Big Banker\\Big_Banker_Idle_2ndPhase.png", 540, display.contentCenterY+100, 20, 20)
                    antaganist.myName = "antaganist"
                end
                })
                display.remove(sign)
                counter = 0

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