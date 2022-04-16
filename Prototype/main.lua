require ("baseClass")
            antaganist = display.newImage("Sprites\\Enemies\\Sleepin' Steve\\Sleepin' Steve_Shoot_F1.png", 540, display.contentCenterY+100, 20, 20)
            physics.addBody(antaganist, "static", {radius = 20, isSensor=true })
            physics.addBody(antaganist, "static", {radius = 20, isSensor=true })
            physics.addBody(bulletEnemy, "dynamic", {isSensor = true})
            bulletEnemy.gravityScale = 0
            bulletEnemy.myName = "bulletEnemy"
            transition.to(bulletEnemy, {x = -100, time = 525,
            onComplete = function() display.remove(bulletEnemy) end

lifes = 1
level = 2
enemyShootAnimation = "Enemy"..level.."_shoot"

background("Backgrounds\\Lv"..level..".png")

protagonist("BR_idle")
antagonist("Enemy"..level.."_idle")

function onLocalCollision(event)
    if (event.phase == "began") then
        local obj1 = event.object1 
        local obj2 = event.object2 

        print("obj1: " .. obj1.myName)
        print("obj2: " .. obj2.myName)

        --Successfull shot
        if ((obj1.myName == "missile" and obj2.myName == "antagonist") or 
            (obj1.myName == "antagonist" and obj2.myName == "missile"))
        then

                display.remove(sign)
                antagonistChange("Enemy"..level.."_die")
            --
                antagonistChange("Enemy"..level.."_"..lifes.."die")
        end

        if ((obj1.myName == "bulletEnemy" and obj2.myName == "protagonist") or 
            (obj1.myName == "protagonist" and obj2.myName == "bulletEnemy"))
        then
            protagonistChange("BR_Die"..level)
            antagonist:toFront()
            miss = 2
        end
    end
end

Runtime:addEventListener("enterFrame", shootEnemy)
Runtime:addEventListener("touch", shoot)
Runtime:addEventListener("collision", onLocalCollision)