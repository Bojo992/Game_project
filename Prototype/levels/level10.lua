require ("baseClass")

lifes = 2

background("Backgrounds\\Lv8 Richolas.png")

protagonist("Sprites\\Big Richard\\Bigger_Richard.png")
antagonist("Sprites\\Enemies\\Big Banker\\Big_Banker_Idle.png")

function onLocalCollision(event)
    if (event.phase == "began") then
        local obj1 = event.object1 
        local obj2 = event.object2 
        print("obj1: " .. obj1.myName)
        print("obj2: " .. obj2.myName)

        --Successfull shot
        if ((obj1.myName == "bullet" and obj2.myName == "antagonist") or 
            (obj1.myName == "antagonist" and obj2.myName == "bullet"))
        then
            lifes = lifes - 1
            if (lifes == 0)
            then
                score = 1
                display.remove(sign)
                antagonistChange("Sprites\\Enemies\\Revolver Richolas\\Revolver_Richolas_Dead.png")
            else
                antagonistChange("Sprites\\Enemies\\Big Banker\\Big_Banker_Idle_2ndPhase.png")
                display.remove(sign)
                counter = 0
            end
        end

        if ((obj1.myName == "bulletEnemy" and obj2.myName == "protagonist") or 
            (obj1.myName == "protagonist" and obj2.myName == "bulletEnemy"))
        then
            protagonistChange("Sprites\\Big Richard\\Big_Richard_Die1_F4.png")
            antagonist:toFront()
            miss = 2
        end
    end
end

Runtime:addEventListener("enterFrame", shootEnemy)
Runtime:addEventListener("touch", shoot)
Runtime:addEventListener("collision", onLocalCollision)