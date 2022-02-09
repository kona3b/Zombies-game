function love.conf(t)
	t.window.width = 1200
	t.window.height = 900
	t.modules.joystick = false
    t.modules.physics = false
	t.window.title = "Zombies!"
	t.window.fullscreen = false
	t.window.fullscreentype = "exclusive"
	t.window.highdpi = true
	t.window.usedpiscale = true
end