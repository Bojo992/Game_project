-- Made by goup 8

--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:3bdd69527e4bca2bfdf9dd5eee5d0485:db374434021a4b6c9609118eae9a4998:bddd0cd1e75e0d19459273fd08fa0369$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- Missile_F1
            x=1,
            y=1,
            width=80,
            height=50,

        },
        {
            -- Missile_F2
            x=83,
            y=1,
            width=80,
            height=50,

        },
    },

    sheetContentWidth = 164,
    sheetContentHeight = 52
}

SheetInfo.frameIndex =
{

    ["Missile_F1"] = 1,
    ["Missile_F2"] = 2,
}

SheetInfo.sequences =
{
    {
        name = "Missile",
        frames = {1, 2},
        time = 400,
        loopCount = 0,
    },
}

function SheetInfo:get()
    return self.sequences
end

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
