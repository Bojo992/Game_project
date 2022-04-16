physics = require("physics")
physics.start()

composer = require("composer")

--Setup for protagonist animations 
local protagonistAnimations = require("BR")
local protagonistSheetOptions = protagonistAnimations:getSheet()
local protagonistSequences = protagonistAnimations:get()
local protagonistSpritesheet = graphics.newImageSheet("BR.png", protagonistSheetOptions)

--Setup for antagonist animations
local antagonistAnimations = require("Enemies")
local antagonistSheetOptions = antagonistAnimations:getSheet()
local antagonistSequences = antagonistAnimations:get()
local antagonistSpritesheet = graphics.newImageSheet("Enemies.png", antagonistSheetOptions)

--Setup for missile animations
local missileAnimations = require("Missile")
local missileSheetOptions = missileAnimations:getSheet()
local missileSequences = missileAnimations:get()
local missileSpritesheet = graphics.newImageSheet("Missile.png", missileSheetOptions)

score = 0;
lifes = 0
counter = 0
miss = 0
level = 0

openingWondowForShot = math.random(30, 60)
closingWindowForShot = openingWondowForShot + 60

--Setup for protagonist
sign = nil
protagonist = nil
protagonistX = 100
protagonistY = display.contentCenterY + 100

--Setup for antagonist
antagonist = nil
antagonistX = 540
antagonistY = protagonistY
enemyShootAnimation = ""

--Setup for missile
missileX = 120
missileY = display.contentCenterY + 100


--Adding background
function background(filePath)
    local x,y = display.contentCenterX, display.contentCenterY
    o = display.newRect(x, y, display.contentWidth, display.contentHeight)
    o.fill = {type="image", filename=filePath}
end

function shoot(event)
    if (event.phase == "began") then
        if (counter >= openingWondowForShot) and (counter <= closingWindowForShot) and (miss == 0) then
            --Shooting at right time
            protagonistChange("BR_Shoot"..level)
            
            --Creating protagonist bullet
            local missile = display.newSprite(missileSpritesheet, missileSequences)
            missile.x = missileX
            missile.y = missileY
            missile:setSequence("Missile")
            missile:play()
            physics.addBody(missile, "dynamic", {radius = 100, isSensor=true })
            missile.myName = "missile"
            missile.gravityScale = 0

            physics.addBody(antagonist, "static", {radius = 20, isSensor=true })
            antagonist.myName = "antagonist"

            transition.to(missile, {x = 600, time = 300,
            onComplete = function() display.remove(missile) end
            })
        else 
            --Miss shot
            print("miss: ".. miss)
            miss = 1;
        end
    end
end

function shootEnemy()
    --Sign
    if (counter == openingWondowForShot) and not (counter == closingWindowForShot) then
        sign = display.newImage("Fire!!.png", display.contentCenterX, display.contentCenterY)
    end

    if (counter == closingWindowForShot) 
    then
        display.remove(sign)
    end
    
    --Enemy shooting
    if (counter == closingWindowForShot) and (score == 0) then
        antagonistChange(enemyShootAnimation)

        --Creating enemy's bullet
        local bulletEnemy = display.newRect(antagonistX, antagonistY, 35, 10)
        bulletEnemy.fill = {129, 133, 137}
        physics.addBody(bulletEnemy, "dynamic", {isSensor = true})
        bulletEnemy.gravityScale = 0
        bulletEnemy.myName = "bulletEnemy"

        physics.addBody(protagonist, "static", {radius = 20, isSensor=true })
        protagonist.myName = "protagonist"

        transition.to(bulletEnemy, {x = -100, time = 525,
        onComplete = function() display.remove(bulletEnemy) end
        })
    end

    counter = counter + 1
end

function protagonist(animationName)
    protagonist = display.newSprite(protagonistSpritesheet, protagonistSequences)
    protagonist.x = protagonistX
    protagonist.y = protagonistY
    protagonist:setSequence(animationName)
    protagonist:play()
end

function protagonistChange(animationName)
    display.remove(protagonist)
    protagonist = display.newSprite(protagonistSpritesheet, protagonistSequences)
    protagonist.x = protagonistX
    protagonist.y = protagonistY
    protagonist:setSequence(animationName)
    protagonist:play()
end

function antagonist(animationName)
    antagonist = display.newSprite(antagonistSpritesheet, antagonistSequences)
    antagonist.x = antagonistX
    antagonist.y = antagonistY
    antagonist:setSequence(animationName)
    antagonist:play()

    physics.addBody(antagonist, "static", {radius = 100, isSensor=true})
    antagonist.myName = "antagonist"
end

function antagonistChange(animationName)
    display.remove(antagonist)
    antagonist = display.newSprite(antagonistSpritesheet, antagonistSequences)
    antagonist.x = antagonistX
    antagonist.y = antagonistY
    antagonist:setSequence(animationName)
    antagonist:play()
end

function cleare()
    display.remove(protagonist)
    display.remove(antagonist)
    display.remove(sign)
end