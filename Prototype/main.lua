require ("BaseCode.baseValues")
require ("BaseCode.baseLogic")
require ("BaseCode.baseEventHandlers")

lives = 1
levelNo = 4
enemyShootAnimation = "Enemy"..levelNo.."_shoot"

setBackgroundImage("Backgrounds\\Lv"..levelNo..".png")

setProtagonistAnimation("BR_idle")
setAntagonistAnimation("Enemy"..levelNo.."_idle")

Runtime:addEventListener("enterFrame", shootEnemy)
Runtime:addEventListener("touch", shoot)
Runtime:addEventListener("collision", onCollision)