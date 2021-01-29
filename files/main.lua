debug = true

STATUS = 0
inDialog = false

-- 0 : main area
-- 1 : Headball
inMiniGame = 0

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

    -- Load Football game
    require(".src.Soccer")

    -- Init Players and three PNJs
    Hero = Player(0,0)
    PNJs = {PNJ(200,200, "Robeeeert"),
            PNJ(400,300, "Giseeeeeele"),
            PNJ(600,300, "Eeeeeetienne")}
    Soccer = SoccerGame()

end

function love.update(dt)
    if inMiniGame == 0 then
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
    elseif inMiniGame == 1 and not inDialog then
        Soccer:update(dt)
    end
    -- Talkies
    Talkies.update(dt)
end

function love.draw(dt)
    if inMiniGame == 0 then
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
    elseif inMiniGame == 1 then
        Soccer:draw()
    end

    Talkies.draw()
end


function love.keypressed(key)
    if inMiniGame == 0 then
        if not inDialog and key == "space" then
            inDialog = true
            for i, kid in ipairs(PNJs) do
                if kid:isCharacterClose(Hero) then
                    Talkies.say(
                        kid.name,
                        {"Bonjour Morpion !", "Comment tu vas ?", "Ça te dit de jouer au foot ?"},
                        {
                            options = {{"Yes", function(dialog) inMiniGame = 1 end },
                                       {"No", function(dialog) end}},
                            oncomplete= function(dialog) inDialog = false end
                        }
                    )
                end
            end
        elseif inDialog and key == "space" then Talkies.onAction()
        elseif inDialog and key == "up" then Talkies.prevOption()
        elseif inDialog and key == "down" then Talkies.nextOption()
        end
    -- elseif inMiniGame == 1 then
    --     if not inDialog then
    --         inDialog = true
    --         Talkies.say(
    --             "Le gamin footeux",
    --             {"Les regles sont super simples, tu dois faire rebondir le ballon sur ta tête sans" ..
    --              " le faire tomber au sol !", 'Tu as prêt ?'
    --             },
    --             {
    --                 options = {{"Yes", function(dialog) end }},
    --                 oncomplete= function(dialog) inDialog = false end
    --             }
    --         )
    --     elseif inDialog and key == "space" then Talkies.onAction()
    --     elseif inDialog and key == "up" then Talkies.prevOption()
    --     elseif inDialog and key == "down" then Talkies.nextOption()
    --     end
    end
end