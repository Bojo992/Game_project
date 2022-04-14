local x,y = display.contentCenterX, display.contentCenterY
local o = display.newRect( x, y, display.contentWidth, display.contentHeight )
o.fill = { type="image", filename="Backgrounds\\Lv1 (Sleepin' Steve).png" }
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
-- local protagonist = display.newRect(100, display.contentCenterY+100, 50, 50)
-- protagonist.alpha = 0;
local protagonist = display.newImage("Sprites\\Big Richard\\Bigger_Richard.png",100, display.contentCenterY+100, 20, 20)
physics.addBody(protagonist, "static", {radius = 20, isSensor=true })
protagonist.myName = "protagonist"

local antaganist = display.newImage("Sprites\\Enemies\\Wheelie Joe\\Wheelie Joe_ChargeAttack.png", 540, display.contentCenterY+100, 20, 20)
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
        if (counter == closingWindowForShot) and (score == 0) then
            local bulletEnemy = display.newRect(540, y + 100, 20, 5)
            physics.addBody(bulletEnemy, "dynamic", {isSensor = true})
            bulletEnemy.gravityScale = 0
            bulletEnemy.myName = "bulletEnemy"
            transition.to(bulletEnemy, {x = -100, time = 525,
            onComplete = function() display.remove(bulletEnemy) end
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
            --
            --switch to new level
            score = score + 1
        end

        if ((obj1.myName == "bulletEnemy" and obj2.myName == "protagonist") or 
            (obj1.myName == "protagonist" and obj2.myName == "bulletEnemy"))
        then
            display.remove(protagonist)
            protagonist = display.newImage("Sprites\\Big Richard\\Big_Richard_Die1_F4.png",100, display.contentCenterY+100, 20, 20)
            antaganist:toFront()
            miss = 2
        end
    end
end

Runtime:addEventListener("collision", onLocalCollision)