--
--Util variables
    local physics = require("physics")
    physics.start()

    local score = 0;
    local scoreText = display.newText(score, 300, display.contentCenterY, native.systemFont, 16)

    local sign
    local miss = 0
    local counter = 0
    local openingWondowForShot = math.random(30, 60)
    local closingWindowForShot = openingWondowForShot + 60

--
--Characters
    local protagonist = display.newRect(100, 20, 20, 20)
    protagonist.fill = {0, 150, 255}
    physics.addBody(protagonist, "static")
    protagonist.myName = "protagonist"

    local antaganist = display.newRect(100, 520, 20, 20)
    antaganist.fill = {255, 0, 0}
    physics.addBody(antaganist, "static")
    antaganist.myName = "antaganist"

--
--Bullets
    local bullet = display.newRect(-100, 200, 30, 30)
    local bulletEnemy = display.newRect(0, -5, 0, 0)

    --
    --Controls player's shooting and correctness of those
        function shoot(event)
            if (event.phase == "began") then
                if (counter >= openingWondowForShot) and (counter <= closingWindowForShot) and (miss == 0) then
                    --Shooting at right time
                    bullet = display.newRect(100, 50, 5, 20)
                    physics.addBody(bullet, "dynamic", {radius = 20, isSensor=true })
                    bullet.myName = "bullet"
                    transition.to(bullet, {y = 525, time = 525,
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
                sign = display.newRect(300, 300, 100, 10)
            end

            if (counter == closingWindowForShot) then
                display.remove(sign)
            end
            
            --Enemy shooting
            if (counter == closingWindowForShot) and (score == 0) then
                bulletEnemy = display.newRect(100, 490, 5, 20)
                physics.addBody(bulletEnemy, "dinamick", {radius = 20, isSensor=true })
                bulletEnemy.myName = "bulletEnemy"
                transition.to(bulletEnemy, {y = 20, time = 525,
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

            --Bullets collision
            if ((obj1.myName == "bullet" and obj2.myName == "bulletEnemy") or 
                (obj1.myName == "bulletEnemy" and obj2.myName == "bullet")) then
                display.remove(obj1)
                display.remove(obj2)
                counter = 0
            end



            --Successfull shot
            if ((obj1.myName == "bullet" and obj2.myName == "antaganist") or 
                (obj1.myName == "antaganist" and obj2.myName == "bullet"))
            then
                score = score + 1
                scoreText.text = score
            end

            if (obj1.myName == "bulletEnemy" and obj2.myName == "protagonist") or 
                (obj1.myName == "protagonist" and obj2.myName == "bulletEnemy")
            then
                miss = 1
            end


        end
    end

Runtime:addEventListener("collision", onLocalCollision)