require ("BaseCode.baseUtils")

function onCollision(event)
    if (event.phase == "began") 
    then
        local obj1 = event.object1 
        local obj2 = event.object2 

        print("obj1: " .. obj1.myName)
        print("obj2: " .. obj2.myName)

        --Successfull shot
        if (checkCollision(obj1, obj2, "missile", "antagonist")) 
        then
            lives = lives - 1
            if (lives == 0)
            then
                score = 1
                display.remove(sign)
                changeAntagonistAnimation("Enemy"..levelNo.."_die")
            else
                changeAntagonistAnimation("Enemy"..levelNo.."_"..lives.."die")
            end
        end

        if (checkCollision(obj1, obj2, "bulletEnemy", "protagonist")) 
        then
            changeProtagonistAnimation("BR_Die"..levelNo)

            gameStatus = GAME_STATUS_PROTAGONIST_SHOT
        end
    end
end
