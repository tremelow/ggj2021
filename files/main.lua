debug = true

STATUS = 0
inDialog = false

function love.load(arg)
    -- Window dimensions
    WINDOW_HEIGHT = love.graphics.getHeight()
    WINDOW_WIDTH = love.graphics.getWidth()

    -- Extra libraries
    Object = require(".src.Classic")
    Camera = require(".src.Camera")
    Talkies = require(".src.Talkies")
    
    -- Background Image
    background = love.graphics.newImage("assets/foot.jpg")
    FIELD_SIZE = background:getWidth()
  
    -- Initialize Camera, left-right scrolling
    camera = Camera()
    camera:setFollowStyle('PLATFORMER')
    camera:setDeadzone(0, - 200, 0, 200)
    camera:setBounds(0, WINDOW_HEIGHT * 3/5, FIELD_SIZE, WINDOW_HEIGHT * 2/5)

    -- Load Characters
    require(".src.Character")
    require(".src.Player")
    require(".src.PNJ")

    -- Init Players and three PNJs
    Hero = Player(0,0)
    PNJs = {PNJ(200,200, "Robeeeert"),
            PNJ(400,300, "Giseeeeeele"),
            PNJ(600,300, "Eeeeeetienne")}

end

function love.update(dt)
    -- Update Camera
    camera:update(dt)
    camera:follow(Hero.x, Hero.y)

    -- Move Hero
    if not inDialog then
        Hero:update(dt)
    end

    -- Identify if PNJ close to player
    for i, v in ipairs(PNJs) do
        v:update(dt, Hero)
    end

    -- Talkies
    Talkies.update(dt)
end

function love.draw(dt)
    camera:attach()
    -- DRAW GAME HERE

    -- Draw background image
    love.graphics.draw(background, 0, 0, 0, 1, WINDOW_HEIGHT/background:getHeight())

    -- Draw NPCs
    for i, v in ipairs(PNJs) do
        v:draw()
    end

    -- Draw Hero last
    Hero:draw()

    camera:detach()
    --camera:draw() --

    Talkies.draw()
end


function love.keypressed(key)
    if not inDialog and key == "space" then
        inDialog = true
        for i, kid in ipairs(PNJs) do
            if kid:isCharacterClose(Hero) then
                Talkies.say(
                    kid.name,
                    {"Bonjour Morpion !", "Comment tu vas ?", "Ça te dit de jouer au foot ?"},
                    {
                        options = {{"Yes", function(dialog) end }, {"No", function(dialog) end}},
                        oncomplete= function(dialog) inDialog = false end
                    }
                )
            end
        end
    elseif inDialog and key == "space" then Talkies.onAction()
    elseif inDialog and key == "up" then Talkies.prevOption()
    elseif inDialog and key == "down" then Talkies.nextOption()
    end
end