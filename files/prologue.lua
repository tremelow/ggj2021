debug = true

STATUS = 0

function love.load(arg)
    -- Window dimensions
    WINDOW_HEIGHT = love.graphics.getHeight()
    WINDOW_WIDTH = love.graphics.getWidth()

    -- Extra libraries
    Object = require(".src.Classic")
	-- Camera = require(".src.Camera")
    Talkies = require(".src.Talkies")

    -- Background Image
    background = love.graphics.newImage("assets/foot.jpg")
    --FIELD_SIZE = background:getWidth()
  
    -- Load Characters
    require(".src.Character")
    require(".src.Player")
    require(".src.PNJ")

	-- Initialize Camera, left-right scrolling
    -- camera = Camera()
    -- camera:setFollowStyle('PLATFORMER')
    -- camera:setDeadzone(0, - 200, 0, 200)
    -- camera:setBounds(0, WINDOW_HEIGHT * 3/5, FIELD_SIZE, WINDOW_HEIGHT * 2/5)

end

function love.update(dt)
    -- Update Camera
    -- camera:update(dt)
    -- camera:follow(Hero.x, Hero.y)

    -- Talkies
    Talkies.update(dt)
end

function love.draw(dt)
    -- camera:attach()
    -- DRAW GAME HERE

    -- Draw background image
    love.graphics.draw(background, 0, 0, 0, 1, WINDOW_HEIGHT/background:getHeight())

    -- Draw NPCs
    for i, v in ipairs(PNJs) do
        v:draw()
    end

    -- Draw Hero last
    Hero:draw()

    -- camera:detach()
    --camera:draw() --

    Talkies.draw()
end


function love.keypressed(key)
    if STATUS == 0 then
			Talkies.say(
				"Théodule",
				{"Bonjour Morpion !", "Comment tu vas ?", "Ça te dit de jouer au foot ?"},
				{
					options = {{"Yes", function(dialog) end }, {"No", function(dialog) end}},
					oncomplete= function(dialog) inDialog = false end
				}
			)
    end
end
