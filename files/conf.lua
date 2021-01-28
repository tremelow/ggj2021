-- Volé du tuto OSMstudios
-- http://osmstudios.com/tutorials/your-first-love2d-game-in-200-lines-part-1-of-3

-- Configuration
function love.conf(t)
	t.title = "Méga Compet" 	-- The title of the window the game is in (string)
	t.version = "11.3"         	-- The LÖVE version this game was made for (string)
	t.window.width = 1080       -- not quite the pixel resolution?
	t.window.height = 480

	-- For Windows debugging
	-- t.console = true
end
