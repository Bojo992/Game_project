local physics = require( "physics" )
physics.start()

local score = 0;
local scoreText = display.newText( score, 300, display.contentCenterY, native.systemFont, 16 )

--
--Characters

local protagonist = display.newRect(100, 20, 20, 20)
protagonist.fill = {0, 150, 255}
physics.addBody(protagonist, "static")

local antaganist = display.newRect(100, 520, 20, 20)
antaganist.fill = {255, 0, 0}
physics.addBody(antaganist, "static")

--
--Bullet
local bullet

function shoot(event)
    if event.phase == "began" then
        bullet = display.newRect(100, 40, 5, 20)
        physics.addBody(bullet, "dynamic", { isSensor=true })
        bullet.isBullet = true
        transition.to(bullet, {y = 525, time = 525,
        onComplete = function() display.remove( bullet ) end
        })
    end
end

Runtime:addEventListener("touch", shoot)

--
--Collision

local function onLocalCollision( self, event )
 
    if ( event.phase == "began" ) then
        score = score + 1
        scoreText.text = score
        bullet:toBack()
    end
end
 
antaganist.collision = onLocalCollision
antaganist:addEventListener( "collision" )