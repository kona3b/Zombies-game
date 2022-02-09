function love.load()
	arenaWidth = love.graphics.getWidth( )
	arenaHeight = love.graphics.getHeight( )

	personSpeed = arenaWidth / 12
	zombieSpeed = arenaWidth / 6
	playerSpeed = arenaWidth / 6
	playerImage = love.graphics.newImage("resources/images/doctor.png")
	zombieImage = love.graphics.newImage("resources/images/zombie.png")
	personImage = love.graphics.newImage("resources/images/person.png")
	wallSize = arenaWidth / 120

	menuImage = love.graphics.newImage("resources/images/mainMenu.png")
	winImage = love.graphics.newImage("resources/images/winMenu.png")
	loseImage = love.graphics.newImage("resources/images/loseMenu.png")
	errorImage = love.graphics.newImage("resources/images/errorMenu.png")

	Timer = require "hump.timer"

	--Flames from https://opengameart.org/content/lpc-flames
	--Graphic artist Sharm and/or Lanea Zimmerman

	fireanimation = newAnimation(love.graphics.newImage("resources/images/flames.png"), 16, 24, 1)

	currentScreen = 'menu'

end

function startGame()

	player = {xPos = arenaWidth / 2, yPos = arenaHeight / 2, width = 32, height = 32,
				speed = playerSpeed, img = playerImage}

	walls = {
		{--top
			xPos = 0,
			yPos = 0,
			width = arenaWidth,
			height = wallSize,
		},
		{--bottom
			xPos = 0,
			yPos = arenaHeight - wallSize,
			width = arenaWidth,
			height = wallSize,
		},
		{--left
			xPos = 0,
			yPos = 0,
			width = wallSize,
			height = arenaHeight,
		},
		{--right
			xPos = arenaWidth - wallSize,
			yPos = 0,
			width = wallSize,
			height = arenaHeight,
		},

		--vertical walls
		{--first from left
			xPos = arenaWidth / 9,
			yPos = arenaHeight / 6,
			width = wallSize,
			height = arenaHeight - (arenaHeight / 3) + wallSize,
		},
		{--first from right
			xPos = arenaWidth - arenaWidth / 9 - wallSize,
			yPos = arenaHeight / 6,
			width = wallSize,
			height = arenaHeight - (arenaHeight / 3) + wallSize,
		},
		{--top second from left
			xPos = arenaWidth / 9 + arenaWidth / 6,
			yPos = arenaHeight / 6,
			width = wallSize,
			height = arenaWidth / 6,
		},
		{--top second from right
			xPos = arenaWidth - (arenaWidth / 9 + arenaWidth / 6),
			yPos = arenaHeight / 6,
			width = wallSize,
			height = arenaWidth / 6 - wallSize,
		},
		{--bottom second from left
			xPos = arenaWidth / 9 + arenaWidth / 6,
			yPos = arenaHeight / 2 + arenaHeight / 8,
			width = wallSize,
			height = arenaWidth / 6,
		},
		{--bottom second from right
			xPos = arenaWidth - (arenaWidth / 9 + arenaWidth / 6),
			yPos = arenaHeight / 2 + arenaHeight / 8,
			width = wallSize,
			height = arenaWidth / 6,
		},
		{--third from left
			xPos = arenaWidth / 2 - arenaWidth / 12,
			yPos = arenaHeight / 8,
			width = wallSize,
			height = 4 * arenaHeight / 7 + wallSize,
		},
		{--third from right
			xPos = arenaWidth / 2 + arenaWidth / 12 - wallSize,
			yPos = arenaHeight - (arenaHeight / 8 + 4 * arenaHeight / 7),
			width = wallSize,
			height = 4 * arenaHeight / 7,
		},

		--horizontal walls
		{--top left
			xPos = arenaWidth / 9,
			yPos = arenaHeight / 6,
			width = arenaWidth / 6,
			height = wallSize,
		},
		{--top right
			xPos = arenaWidth - (arenaWidth / 9 + arenaWidth / 6),
			yPos = arenaHeight / 6,
			width = arenaWidth / 6,
			height = wallSize,
		},
		{--top center
			xPos = arenaWidth / 2 - arenaWidth / 12,
			yPos = arenaHeight / 8,
			width = arenaWidth / 6,
			height = wallSize,
		},
		{--bottom center
			xPos = arenaWidth / 2 - arenaWidth / 12,
			yPos = arenaHeight - arenaHeight / 8 - wallSize,
			width = arenaWidth / 6,
			height = wallSize,
		},
		{--bottom left
			xPos = arenaWidth / 9,
			yPos = arenaHeight - arenaHeight / 6 + wallSize,
			width = arenaWidth / 6 + wallSize,
			height = wallSize,
		},
		{--bottom right
			xPos = arenaWidth - (arenaWidth / 9 + arenaWidth / 6),
			yPos = arenaHeight - (arenaHeight / 6) + wallSize,
			width = arenaWidth / 6,
			height = wallSize,
		},
		{--blocker left
			xPos = arenaWidth / 9 + arenaWidth / 6,
			yPos = arenaHeight / 2 + arenaHeight / 8,
			width = arenaWidth / 7,
			height = wallSize,
		},
		{--blocker right
			xPos = arenaWidth - (5 * arenaWidth / 12) - wallSize,
			yPos = 6 * arenaHeight / 16,
			width = arenaWidth / 7 + 1.5 * wallSize,
			height = wallSize,
		}
	}

	zombies = {
		{
			xPos = arenaWidth - arenaWidth / 16,
			yPos = arenaHeight / 2,
			width = 32,
			height = 32,
			img = zombieImage,
			angle = 1.5 * math.pi,
		},
		{
			xPos =arenaWidth / 16,
			yPos =arenaHeight / 2,
			width = 32,
			height = 32,
			img = zombieImage,
			angle = 0.5 * math.pi,
		}
	}

	persons = {
		{--1
			xPos = arenaWidth / 10,
			yPos = arenaHeight / 10,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--2
			xPos = arenaWidth - arenaWidth / 10,
			yPos = arenaHeight / 10,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--3
			xPos = arenaWidth / 10,
			yPos = arenaHeight - arenaHeight / 10,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--4
			xPos = arenaWidth - arenaWidth / 10,
			yPos = arenaHeight - arenaHeight / 10,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--5
			xPos = arenaWidth / 2,
			yPos = arenaHeight / 16,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--6
			xPos = arenaWidth / 2,
			yPos = arenaHeight - arenaHeight / 16,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--7
			xPos = arenaWidth / 2,
			yPos = arenaHeight / 2 + arenaHeight / 16,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--8
			xPos = arenaWidth / 2,
			yPos = arenaHeight / 2 - arenaHeight / 16,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--9
			xPos = arenaWidth / 5,
			yPos = arenaHeight / 2 - arenaHeight / 5,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--10
			xPos = arenaWidth - arenaWidth / 5,
			yPos = arenaHeight / 2 - arenaHeight / 5,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--11
			xPos = arenaWidth - arenaWidth / 5,
			yPos = arenaHeight / 2 + arenaHeight / 5,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--12
			xPos = arenaWidth / 5,
			yPos = arenaHeight / 2 + arenaHeight / 5,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--13
			xPos = arenaWidth / 2 - arenaWidth / 6,
			yPos = arenaHeight / 2,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--14
			xPos = arenaWidth / 2 + arenaWidth / 6,
			yPos = arenaHeight / 2,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--15
			xPos = arenaWidth - arenaWidth / 16,
			yPos = love.math.random(arenaHeight / 10, arenaHeight - arenaHeight /10),
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--16
			xPos = arenaWidth - arenaWidth / 16,
			yPos = love.math.random(arenaHeight / 10, arenaHeight - arenaHeight /10),
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--17
			xPos = arenaWidth - arenaWidth / 16,
			yPos = love.math.random(arenaHeight / 10, arenaHeight - arenaHeight /10),
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--18
			xPos = arenaWidth / 16,
			yPos = love.math.random(arenaHeight / 10, arenaHeight - arenaHeight /10),
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--19
			xPos = arenaWidth / 16,
			yPos = love.math.random(arenaHeight / 10, arenaHeight - arenaHeight /10),
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--20
			xPos = arenaWidth / 16,
			yPos = love.math.random(arenaHeight / 10, arenaHeight - arenaHeight /10),
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--21
			xPos = love.math.random(arenaWidth / 10, arenaWidth - arenaWidth /10),
			yPos = arenaHeight / 16,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--22
			xPos = love.math.random(arenaWidth / 10, arenaWidth - arenaWidth /10),
			yPos = arenaHeight - arenaHeight / 16,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--23
			xPos = love.math.random(arenaWidth / 10, arenaWidth - arenaWidth /10),
			yPos = arenaHeight - arenaHeight / 16,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--24
			xPos = love.math.random(arenaWidth / 10, arenaWidth - arenaWidth /10),
			yPos = arenaHeight - arenaHeight / 16,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		}
	}
end

function HCstartGame()

	player = {xPos = arenaWidth / 2, yPos = arenaHeight / 2, width = 32, height = 32,
				speed = playerSpeed, img = playerImage}

	firewalls = {
		{--top
			xPos = arenaWidth / 2,
			yPos = 0,
			width = wallSize * 2,
			height = arenaWidth / 10,
		},
		{--bottom
			xPos = arenaWidth / 2,
			yPos = arenaHeight - arenaHeight / 8,
			width = wallSize * 2,
			height = arenaWidth / 10
		}
	}

	walls = {
		{--top
			xPos = 0,
			yPos = 0,
			width = arenaWidth,
			height = wallSize,
		},
		{--bottom
			xPos = 0,
			yPos = arenaHeight - wallSize,
			width = arenaWidth,
			height = wallSize,
		},
		{--left
			xPos = 0,
			yPos = 0,
			width = wallSize,
			height = arenaHeight,
		},
		{--right
			xPos = arenaWidth - wallSize,
			yPos = 0,
			width = wallSize,
			height = arenaHeight,
		},

		--vertical walls
		{--first from left
			xPos = arenaWidth / 9,
			yPos = arenaHeight / 6,
			width = wallSize,
			height = arenaHeight - (arenaHeight / 3) + wallSize,
		},
		{--first from right
			xPos = arenaWidth - arenaWidth / 9 - wallSize,
			yPos = arenaHeight / 6,
			width = wallSize,
			height = arenaHeight - (arenaHeight / 3) + wallSize,
		},
		{--top second from left
			xPos = arenaWidth / 9 + arenaWidth / 6,
			yPos = arenaHeight / 6,
			width = wallSize,
			height = arenaWidth / 6,
		},
		{--top second from right
			xPos = arenaWidth - (arenaWidth / 9 + arenaWidth / 6),
			yPos = arenaHeight / 6,
			width = wallSize,
			height = arenaWidth / 6 - wallSize,
		},
		{--bottom second from left
			xPos = arenaWidth / 9 + arenaWidth / 6,
			yPos = arenaHeight / 2 + arenaHeight / 8,
			width = wallSize,
			height = arenaWidth / 6,
		},
		{--bottom second from right
			xPos = arenaWidth - (arenaWidth / 9 + arenaWidth / 6),
			yPos = arenaHeight / 2 + arenaHeight / 8,
			width = wallSize,
			height = arenaWidth / 6,
		},
		{--third from left
			xPos = arenaWidth / 2 - arenaWidth / 12,
			yPos = arenaHeight / 8,
			width = wallSize,
			height = 4 * arenaHeight / 7 + wallSize,
		},
		{--third from right
			xPos = arenaWidth / 2 + arenaWidth / 12 - wallSize,
			yPos = arenaHeight - (arenaHeight / 8 + 4 * arenaHeight / 7),
			width = wallSize,
			height = 4 * arenaHeight / 7,
		},

		--horizontal walls
		{--top left
			xPos = arenaWidth / 9,
			yPos = arenaHeight / 6,
			width = arenaWidth / 6,
			height = wallSize,
		},
		{--top right
			xPos = arenaWidth - (arenaWidth / 9 + arenaWidth / 6),
			yPos = arenaHeight / 6,
			width = arenaWidth / 6,
			height = wallSize,
		},
		{--top center
			xPos = arenaWidth / 2 - arenaWidth / 12,
			yPos = arenaHeight / 8,
			width = arenaWidth / 6,
			height = wallSize,
		},
		{--bottom center
			xPos = arenaWidth / 2 - arenaWidth / 12,
			yPos = arenaHeight - arenaHeight / 8 - wallSize,
			width = arenaWidth / 6,
			height = wallSize,
		},
		{--bottom left
			xPos = arenaWidth / 9,
			yPos = arenaHeight - arenaHeight / 6 + wallSize,
			width = arenaWidth / 6 + wallSize,
			height = wallSize,
		},
		{--bottom right
			xPos = arenaWidth - (arenaWidth / 9 + arenaWidth / 6),
			yPos = arenaHeight - (arenaHeight / 6) + wallSize,
			width = arenaWidth / 6,
			height = wallSize,
		},
		{--blocker left
			xPos = arenaWidth / 9 + arenaWidth / 6,
			yPos = arenaHeight / 2 + arenaHeight / 8,
			width = arenaWidth / 7,
			height = wallSize,
		},
		{--blocker right
			xPos = arenaWidth - (5 * arenaWidth / 12) - wallSize,
			yPos = 6 * arenaHeight / 16,
			width = arenaWidth / 7 + 1.5 * wallSize,
			height = wallSize,
		}
	}

	zombies = {
		{
			xPos = arenaWidth - arenaWidth / 16,
			yPos = arenaHeight / 2,
			width = 32,
			height = 32,
			img = zombieImage,
			angle = 1.5 * math.pi,
		},
		{
			xPos =arenaWidth / 16,
			yPos =arenaHeight / 2,
			width = 32,
			height = 32,
			img = zombieImage,
			angle = 0.5 * math.pi,
		}
	}

	persons = {
		{--1
			xPos = arenaWidth / 10,
			yPos = arenaHeight / 10,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--2
			xPos = arenaWidth - arenaWidth / 10,
			yPos = arenaHeight / 10,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--3
			xPos = arenaWidth / 10,
			yPos = arenaHeight - arenaHeight / 10,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--4
			xPos = arenaWidth - arenaWidth / 10,
			yPos = arenaHeight - arenaHeight / 10,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--5
			xPos = arenaWidth / 2,
			yPos = arenaHeight / 16,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--6
			xPos = arenaWidth / 2,
			yPos = arenaHeight - arenaHeight / 16,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--7
			xPos = arenaWidth / 2,
			yPos = arenaHeight / 2 + arenaHeight / 16,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--8
			xPos = arenaWidth / 2,
			yPos = arenaHeight / 2 - arenaHeight / 16,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--9
			xPos = arenaWidth / 5,
			yPos = arenaHeight / 2 - arenaHeight / 5,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--10
			xPos = arenaWidth - arenaWidth / 5,
			yPos = arenaHeight / 2 - arenaHeight / 5,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--11
			xPos = arenaWidth - arenaWidth / 5,
			yPos = arenaHeight / 2 + arenaHeight / 5,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--12
			xPos = arenaWidth / 5,
			yPos = arenaHeight / 2 + arenaHeight / 5,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--13
			xPos = arenaWidth / 2 - arenaWidth / 6,
			yPos = arenaHeight / 2,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--14
			xPos = arenaWidth / 2 + arenaWidth / 6,
			yPos = arenaHeight / 2,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--15
			xPos = arenaWidth - arenaWidth / 16,
			yPos = love.math.random(arenaHeight / 10, arenaHeight - arenaHeight /10),
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--16
			xPos = arenaWidth - arenaWidth / 16,
			yPos = love.math.random(arenaHeight / 10, arenaHeight - arenaHeight /10),
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--17
			xPos = arenaWidth - arenaWidth / 16,
			yPos = love.math.random(arenaHeight / 10, arenaHeight - arenaHeight /10),
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--18
			xPos = arenaWidth / 16,
			yPos = love.math.random(arenaHeight / 10, arenaHeight - arenaHeight /10),
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--19
			xPos = arenaWidth / 16,
			yPos = love.math.random(arenaHeight / 10, arenaHeight - arenaHeight /10),
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--20
			xPos = arenaWidth / 16,
			yPos = love.math.random(arenaHeight / 10, arenaHeight - arenaHeight /10),
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--21
			xPos = love.math.random(arenaWidth / 10, arenaWidth - arenaWidth /10),
			yPos = arenaHeight / 16,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--22
			xPos = love.math.random(arenaWidth / 10, arenaWidth - arenaWidth /10),
			yPos = arenaHeight - arenaHeight / 16,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--23
			xPos = love.math.random(arenaWidth / 10, arenaWidth - arenaWidth /10),
			yPos = arenaHeight - arenaHeight / 16,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		},
		{--24
			xPos = love.math.random(arenaWidth / 10, arenaWidth - arenaWidth /10),
			yPos = arenaHeight - arenaHeight / 16,
			width = 32,
			height = 32,
			img = personImage,
			angle = love.math.random() * (2 * math.pi),
		}
	}

	zombieSpeed = 250

end

function love.draw()
	if currentScreen == 'menu' then
		menuDraw()
	elseif currentScreen == 'win' then
		winDraw()
	elseif currentScreen == 'lose' then
		loseDraw()
	elseif currentScreen == 'game' then
		gameDraw()
	elseif currentScreen == 'HCgame' then
		HCgameDraw()
	elseif currentScreen == 'error' then
		errorDraw()
	end
end

function love.update(dt)

	fireanimation.currentTime = fireanimation.currentTime + dt
	if fireanimation.currentTime >= fireanimation.duration then
		fireanimation.currentTime = fireanimation.currentTime - fireanimation.duration
	end

	Timer.update(dt)

	if currentScreen == 'menu' then
		menuUpdate(dt)
	elseif currentScreen == 'win' then
		winUpdate(dt)
	elseif currentScreen == 'lose' then
		loseUpdate(dt)
	elseif currentScreen == 'game' then
		gameUpdate(dt)
	elseif currentScreen == 'HCgame' then
		HCgameUpdate(dt)
	elseif currentScreen == 'error' then
		errorUpdate(dt)
	end
end

function menuDraw()
	love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
	love.graphics.draw(menuImage, 0, 0, 0, arenaWidth/1200, arenaHeight/900)
end

function winDraw()
	love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
	love.graphics.draw(winImage, 0, 0, 0, arenaWidth/1200, arenaHeight/900)
end

function loseDraw()
	love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
	love.graphics.draw(loseImage, 0, 0, 0, arenaWidth/1200, arenaHeight/900)
end

function errorDraw()
	love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
	love.graphics.draw(errorImage, 0, 0, 0, arenaWidth/1200, arenaHeight/900)
end

function gameDraw()

	love.graphics.setColor(love.math.colorFromBytes(160, 160, 160))
	background = love.graphics.rectangle("fill", 0, 0, arenaWidth, arenaHeight)

	love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))

	love.graphics.draw(player.img, player.xPos, player.yPos)

	for wallIndex, wall in ipairs(walls) do
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", wall.xPos, wall.yPos, wall.width, wall.height)
		love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
	end

	for personIndex, person in ipairs(persons) do
		love.graphics.draw(person.img, person.xPos, person.yPos)
	end

	for zombieIndex, zombie in ipairs(zombies) do
		love.graphics.draw(zombie.img, zombie.xPos, zombie.yPos)
	end
end
-- NORMAL MODE ABOVE

function HCgameDraw()

	local spriteNum = math.floor(fireanimation.currentTime / fireanimation.duration * #fireanimation.quads) + 1 -- FOR ANIMATION

	love.graphics.setColor(love.math.colorFromBytes(160, 160, 160))
	background = love.graphics.rectangle("fill", 0, 0, arenaWidth, arenaHeight)

	love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))

	love.graphics.draw(player.img, player.xPos, player.yPos)

	for firewallIndex, firewall in ipairs(firewalls) do
		love.graphics.setColor(love.math.colorFromBytes(160, 160, 160))
		love.graphics.rectangle("fill", firewall.xPos, firewall.yPos, firewall.width, firewall.height)
		love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
	end

	for wallIndex, wall in ipairs(walls) do
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", wall.xPos, wall.yPos, wall.width, wall.height)
		love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
	end

	for personIndex, person in ipairs(persons) do
		love.graphics.draw(person.img, person.xPos, person.yPos)
	end

	for zombieIndex, zombie in ipairs(zombies) do
		love.graphics.draw(zombie.img, zombie.xPos, zombie.yPos)
	end

	love.graphics.draw(fireanimation.spriteSheet, fireanimation.quads[spriteNum], arenaWidth / 2, 3 * (arenaHeight / 4) + arenaHeight / 10 + wallSize, 0, 2, 2, 4)
	love.graphics.draw(fireanimation.spriteSheet, fireanimation.quads[spriteNum], arenaWidth / 2, 3 * (arenaHeight / 4) + arenaHeight / 10 + wallSize + arenaHeight / 15, 0, 2, 2, 4)
	love.graphics.draw(fireanimation.spriteSheet, fireanimation.quads[spriteNum], arenaWidth / 2, 3 * (arenaHeight / 4) + arenaHeight / 10 + wallSize + arenaHeight / 23, 0, 2, 2, 4)
	love.graphics.draw(fireanimation.spriteSheet, fireanimation.quads[spriteNum], arenaWidth / 2, 3 * (arenaHeight / 4) + arenaHeight / 10 + wallSize + arenaHeight / 53, 0, 2, 2, 4)
	love.graphics.draw(fireanimation.spriteSheet, fireanimation.quads[spriteNum], arenaWidth / 2, arenaHeight - arenaHeight / 20, 0, 2, 2, 4)

	love.graphics.draw(fireanimation.spriteSheet, fireanimation.quads[spriteNum], arenaWidth / 2, 0, 0, 2, 2, 4)
	love.graphics.draw(fireanimation.spriteSheet, fireanimation.quads[spriteNum], arenaWidth / 2, arenaHeight / 53, 0, 2, 2, 4)
	love.graphics.draw(fireanimation.spriteSheet, fireanimation.quads[spriteNum], arenaWidth / 2, arenaHeight / 23, 0, 2, 2, 4)
	love.graphics.draw(fireanimation.spriteSheet, fireanimation.quads[spriteNum], arenaWidth / 2, arenaHeight / 15, 0, 2, 2, 4)
	love.graphics.draw(fireanimation.spriteSheet, fireanimation.quads[spriteNum], arenaWidth / 2, arenaHeight / 10 - wallSize, 0, 2, 2, 4)

end

-- HC MODE ABOVE

function menuUpdate(dt)
	if love.keyboard.isDown("s") then
		startGame()
		currentScreen = 'game'
	end
	if love.keyboard.isDown("h") then
		HCstartGame()
		currentScreen = 'HCgame'
	end
--	if love.keyboard.isDown("e") then
--		currentScreen = 'error'
--	end
end

function winUpdate(dt)
	if love.keyboard.isDown("q") then
		currentScreen = 'menu'
	end
end

function loseUpdate(dt)
	if love.keyboard.isDown("q") then
		currentScreen = 'menu'
	end
end

function errorUpdate(dt)
	if love.keyboard.isDown("q") then
		currentScreen = 'menu'
	end
end

function gameUpdate(dt)

	if love.keyboard.isDown("q") then
		currentScreen = 'menu'
	end

	down = love.keyboard.isDown("down")
	up = love.keyboard.isDown("up")
	left = love.keyboard.isDown("left")
	right = love.keyboard.isDown("right")

	speed = player.speed

	if((down or up) and (left or right)) then
	  speed = speed / math.sqrt(2)
	end

	if down and player.yPos + player.height < arenaHeight and #persons > 0 and #zombies > 0 then
		player.yPos = player.yPos + dt * speed
	elseif up and player.yPos > 0 and #persons > 0 and #zombies > 0  then
	  	player.yPos = player.yPos - dt * speed
	end

	if right and player.xPos + player.width < arenaWidth and #persons > 0 and #zombies > 0  then
	  player.xPos = player.xPos + dt * speed
	elseif left and player.xPos > 0 and #persons > 0 and #zombies > 0  then
	  player.xPos = player.xPos - dt * speed
	end

	for personIndex, person in ipairs(persons) do
		if person.yPos + person.height < arenaHeight and person.yPos > 0 and
			person.xPos + person.width < arenaWidth and person.xPos > 0 then
				person.xPos = (person.xPos + math.cos(person.angle)
				* personSpeed * dt)
				person.yPos = (person.yPos + math.sin(person.angle)
				* personSpeed * dt)
		end
		if person.yPos < 0 or person.yPos > arenaHeight or person.xPos < 0 or person.xPos > arenaWidth then
			currentScreen = "error"
		end
	end

	for zombieIndex, zombie in ipairs(zombies) do
		if zombie.yPos + zombie.height < arenaHeight and zombie.yPos > 0 and
			zombie.xPos + zombie.width < arenaWidth and zombie.xPos > 0 then
				zombie.xPos = (zombie.xPos + math.cos(zombie.angle)
				* zombieSpeed * dt)
				zombie.yPos = (zombie.yPos + math.sin(zombie.angle)
				* zombieSpeed * dt)
		end
		if zombie.yPos < 0 or zombie.yPos > arenaHeight or zombie.xPos < 0 or zombie.xPos > arenaWidth then
			currentScreen = "error"
		end
	end

	if #persons == 0 then
		zombieSpeed = 1
		Timer.after(3, function() currentScreen = 'lose' end)
	end
	if #zombies == 0 then
		personSpeed = 1
		Timer.after(3, function() currentScreen = 'win' end)
	end

	checkCollisions()
end

function HCgameUpdate(dt)

	if love.keyboard.isDown("q") then
		currentScreen = 'menu'
	end

	down = love.keyboard.isDown("down")
	up = love.keyboard.isDown("up")
	left = love.keyboard.isDown("left")
	right = love.keyboard.isDown("right")

	speed = player.speed

	if((down or up) and (left or right)) then
	  speed = speed / math.sqrt(2)
	end

	if down and player.yPos + player.height < arenaHeight and #persons > 0 and #zombies > 0  then
		player.yPos = player.yPos + dt * speed
	elseif up and player.yPos > 0 and #persons > 0 and #zombies > 0  then
	  	player.yPos = player.yPos - dt * speed
	end

	if right and player.xPos + player.width < arenaWidth and #persons > 0 and #zombies > 0  then
	  player.xPos = player.xPos + dt * speed
	elseif left and player.xPos > 0 and #persons > 0 and #zombies > 0  then
	  player.xPos = player.xPos - dt * speed
	end

	for personIndex, person in ipairs(persons) do
		if person.yPos + person.height < arenaHeight and person.yPos > 0 and
			person.xPos + person.width < arenaWidth and person.xPos > 0 then
				person.xPos = (person.xPos + math.cos(person.angle)
				* personSpeed * dt)
				person.yPos = (person.yPos + math.sin(person.angle)
				* personSpeed * dt)
		end
		if person.yPos < 0 or person.yPos > arenaHeight or person.xPos < 0 or person.xPos > arenaWidth then
			currentScreen = "error"
		end
	end

	for zombieIndex, zombie in ipairs(zombies) do
		if zombie.yPos + zombie.height < arenaHeight and zombie.yPos > 0 and
			zombie.xPos + zombie.width < arenaWidth and zombie.xPos > 0 then
				zombie.xPos = (zombie.xPos + math.cos(zombie.angle)
				* zombieSpeed * dt)
				zombie.yPos = (zombie.yPos + math.sin(zombie.angle)
				* zombieSpeed * dt)
		end
		if zombie.yPos < 0 or zombie.yPos > arenaHeight or zombie.xPos < 0 or zombie.xPos > arenaWidth then
			currentScreen = "error"
		end
	end

	if #persons == 0 then
		zombieSpeed = 1
		Timer.after(3, function() currentScreen = 'lose' end)
	end
	if #zombies == 0 then
		personSpeed = 1
		Timer.after(3, function() currentScreen = 'win' end)
	end

	HCcheckCollisions()
end

--HC MODE ABOVE

function checkCollisions()

	local angle1 = love.math.random() * (2 * math.pi)
	local angle2 = (angle1 - math.pi) % (2 * math.pi)

	for personIndex = #persons, 1, -1 do
		local person = persons[personIndex]

		for zombieIndex = #zombies, 1, -1 do
			local zombie = zombies[zombieIndex]

			if (intersectsLeft(person, zombie) and (intersectsTop(person, zombie)
			or intersectsBottom(person, zombie))) or (intersectsRight(person, zombie) and
			(intersectsTop(person, zombie) or intersectsBottom(person, zombie))) or
			(intersectsTop(person, zombie) and (intersectsLeft(person, zombie) or
			intersectsRight(person, zombie))) or (intersectsBottom(person, zombie) and
			(intersectsLeft(person, zombie) or intersectsRight(person, zombie))) then

				table.remove(persons, personIndex)

				table.insert(zombies, {
					xPos = person.xPos,
					yPos = person.yPos,
					angle = angle1,
					width = 32,
					height = 32,
					img = zombieImage,
				})
				table.insert(zombies, {
					xPos = person.xPos,
					yPos = person.yPos,
					angle = angle2,
					width = 32,
					height = 32,
					img = zombieImage,
				})
				table.remove(zombies, zombieIndex)
				break
			end
		end
	end

	for personIndex = #persons, 1, -1 do
		local person = persons[personIndex]

		for zombieIndex = #zombies, 1, -1 do
			local zombie = zombies[zombieIndex]

			if (intersectsLeft(player, zombie) and (intersectsTop(player, zombie) or
			intersectsBottom(player, zombie))) or (intersectsRight(player, zombie) and
			(intersectsTop(player, zombie) or intersectsBottom(player, zombie))) or
			(intersectsTop(player, zombie) and (intersectsLeft(player, zombie) or
			intersectsRight(player, zombie))) or (intersectsBottom(player, zombie) and
			(intersectsLeft(player, zombie) or intersectsRight(player, zombie))) then

				table.insert(persons, {
					xPos = zombie.xPos,
					yPos = zombie.yPos,
					angle = love.math.random() * (2 * math.pi),
					width = 32,
					height = 32,
					img = personImage,
				})
				table.remove(zombies, zombieIndex)
				break
			end
		end
	end

	for personIndex = #persons, 1, -1 do
		local person = persons[personIndex]

		for zombieIndex = #zombies, 1, -1 do
			local zombie = zombies[zombieIndex]

			for wallIndex = #walls, 1, -1 do
				local wall = walls[wallIndex]

				if intersectsLeft(zombie, wall) and (intersectsTopAlso(zombie, wall) or
					intersectsBottomAlso(zombie, wall)) then
					zombie.xPos = zombie.xPos + 2
					zombie.angle = love.math.random(1.7 * math.pi, 2.3 * math.pi)
				end
				if intersectsRight(zombie, wall) and (intersectsTopAlso(zombie, wall) or
					intersectsBottomAlso(zombie, wall)) then
					zombie.xPos = zombie.xPos - 2
					zombie.angle = love.math.random(0.7 * math.pi, 1.3 * math.pi)
				end
				if intersectsTop(zombie, wall) and (intersectsLeftAlso(zombie, wall) or
					intersectsRightAlso(zombie, wall)) then
					zombie.yPos = zombie.yPos + 2
					zombie.angle = love.math.random(0.2 * math.pi, 0.8 * math.pi)
				end
				if intersectsBottom(zombie, wall) and (intersectsLeftAlso(zombie, wall) or
					intersectsRightAlso(zombie, wall)) then
					zombie.yPos = zombie.yPos - 2
					zombie.angle = love.math.random(1.2 * math.pi, 1.8 * math.pi)
				end


				if intersectsLeft(person, wall) and (intersectsTopAlso(person, wall) or
					intersectsBottomAlso(person, wall)) then
					person.xPos = person.xPos + 2
					person.angle = love.math.random(1.7 * math.pi, 2.3 * math.pi)
				end
				if intersectsRight(person, wall) and (intersectsTopAlso(person, wall) or
					intersectsBottomAlso(person, wall)) then
					person.xPos = person.xPos - 2
					person.angle = love.math.random(0.7 * math.pi, 1.3 * math.pi)
				end
				if intersectsTop(person, wall) and (intersectsLeftAlso(person, wall) or
					intersectsRightAlso(person, wall)) then
					person.yPos = person.yPos + 2
					person.angle = love.math.random(0.2 * math.pi, 0.8 * math.pi)
				end
				if intersectsBottom(person, wall) and (intersectsLeftAlso(person, wall) or
					intersectsRightAlso(person, wall)) then
					person.yPos = person.yPos - 2
					person.angle = love.math.random(1.2 * math.pi, 1.8 * math.pi)
				end


				if intersectsLeft(player, wall) and (intersectsTopAlso(player, wall) or
					intersectsBottomAlso(player, wall)) then
					player.xPos = player.xPos + 4
				end
				if intersectsRight(player, wall) and (intersectsTopAlso(player, wall) or
					intersectsBottomAlso(player, wall)) then
					player.xPos = player.xPos - 4
				end
				if (intersectsTop(player, wall) and intersectsLeftAlso(player, wall)) or
					(intersectsRightAlso(player, wall)) then
					player.yPos = player.yPos + 4
					player.xPos = player.xPos - 4
				end
				if intersectsBottom(player, wall) and (intersectsLeftAlso(player, wall) or
					intersectsRightAlso(player, wall)) then
					player.yPos = player.yPos - 4
					player.xPos = player.xPos - 4
				end
			end
		end
	end
end
-- normal mode above

function HCcheckCollisions()

	local angle1 = love.math.random() * (2 * math.pi)
	local angle2 = (angle1 - math.pi) % (2 * math.pi)

	for personIndex = #persons, 1, -1 do
		local person = persons[personIndex]

		for zombieIndex = #zombies, 1, -1 do
			local zombie = zombies[zombieIndex]

			if (intersectsLeft(person, zombie) and (intersectsTop(person, zombie)
			or intersectsBottom(person, zombie))) or (intersectsRight(person, zombie) and
			(intersectsTop(person, zombie) or intersectsBottom(person, zombie))) or
			(intersectsTop(person, zombie) and (intersectsLeft(person, zombie) or
			intersectsRight(person, zombie))) or (intersectsBottom(person, zombie) and
			(intersectsLeft(person, zombie) or intersectsRight(person, zombie))) then

				table.remove(persons, personIndex)

				table.insert(zombies, {
					xPos = person.xPos,
					yPos = person.yPos,
					angle = angle1,
					width = 32,
					height = 32,
					img = zombieImage,
				})
				table.insert(zombies, {
					xPos = person.xPos,
					yPos = person.yPos,
					angle = angle2,
					width = 32,
					height = 32,
					img = zombieImage,
				})
				table.remove(zombies, zombieIndex)
				break
			end
		end
	end

	for personIndex = #persons, 1, -1 do
		local person = persons[personIndex]

		for zombieIndex = #zombies, 1, -1 do
			local zombie = zombies[zombieIndex]

			if (intersectsLeft(player, zombie) and (intersectsTop(player, zombie) or
			intersectsBottom(player, zombie))) or (intersectsRight(player, zombie) and
			(intersectsTop(player, zombie) or intersectsBottom(player, zombie))) or
			(intersectsTop(player, zombie) and (intersectsLeft(player, zombie) or
			intersectsRight(player, zombie))) or (intersectsBottom(player, zombie) and
			(intersectsLeft(player, zombie) or intersectsRight(player, zombie))) then

				table.insert(persons, {
					xPos = zombie.xPos,
					yPos = zombie.yPos,
					angle = love.math.random() * (2 * math.pi),
					width = 32,
					height = 32,
					img = personImage,
				})
				table.remove(zombies, zombieIndex)
				break
			end
		end
	end

	for personIndex = #persons, 1, -1 do
		local person = persons[personIndex]

		for zombieIndex = #zombies, 1, -1 do
			local zombie = zombies[zombieIndex]

			for wallIndex = #walls, 1, -1 do
				local wall = walls[wallIndex]

				for firewallIndex = #firewalls, 1, -1 do
					local firewall = firewalls[firewallIndex]

					if intersectsLeft(zombie, wall) and (intersectsTopAlso(zombie, wall) or
						intersectsBottomAlso(zombie, wall)) then
						zombie.xPos = zombie.xPos + 2
						zombie.angle = love.math.random(1.7 * math.pi, 2.3 * math.pi)
					end
					if intersectsRight(zombie, wall) and (intersectsTopAlso(zombie, wall) or
						intersectsBottomAlso(zombie, wall)) then
						zombie.xPos = zombie.xPos - 2
						zombie.angle = love.math.random(0.7 * math.pi, 1.3 * math.pi)
					end
					if intersectsTop(zombie, wall) and (intersectsLeftAlso(zombie, wall) or
						intersectsRightAlso(zombie, wall)) then
						zombie.yPos = zombie.yPos + 2
						zombie.angle = love.math.random(0.2 * math.pi, 0.8 * math.pi)
					end
					if intersectsBottom(zombie, wall) and (intersectsLeftAlso(zombie, wall) or
						intersectsRightAlso(zombie, wall)) then
						zombie.yPos = zombie.yPos - 2
						zombie.angle = love.math.random(1.2 * math.pi, 1.8 * math.pi)
					end


					if intersectsLeft(person, wall) and (intersectsTopAlso(person, wall) or
						intersectsBottomAlso(person, wall)) then
						person.xPos = person.xPos + 2
						person.angle = love.math.random(1.7 * math.pi, 2.3 * math.pi)
					end
					if intersectsRight(person, wall) and (intersectsTopAlso(person, wall) or
						intersectsBottomAlso(person, wall)) then
						person.xPos = person.xPos - 2
						person.angle = love.math.random(0.7 * math.pi, 1.3 * math.pi)
					end
					if intersectsTop(person, wall) and (intersectsLeftAlso(person, wall) or
						intersectsRightAlso(person, wall)) then
						person.yPos = person.yPos + 2
						person.angle = love.math.random(0.2 * math.pi, 0.8 * math.pi)
					end
					if intersectsBottom(person, wall) and (intersectsLeftAlso(person, wall) or
						intersectsRightAlso(person, wall)) then
						person.yPos = person.yPos - 2
						person.angle = love.math.random(1.2 * math.pi, 1.8 * math.pi)
					end


					if intersectsLeft(person, firewall) and (intersectsTopAlso(person, firewall) or
						intersectsBottomAlso(person, firewall)) then
						person.xPos = person.xPos + 2
						person.angle = love.math.random(1.7 * math.pi, 2.3 * math.pi)
					end
					if intersectsRight(person, firewall) and (intersectsTopAlso(person, firewall) or
						intersectsBottomAlso(person, firewall)) then
						person.xPos = person.xPos - 2
						person.angle = love.math.random(0.7 * math.pi, 1.3 * math.pi)
					end
					if intersectsTop(person, firewall) and (intersectsLeftAlso(person, firewall) or
						intersectsRightAlso(person, firewall)) then
						person.yPos = person.yPos + 2
						person.angle = love.math.random(0.2 * math.pi, 0.8 * math.pi)
					end
					if intersectsBottom(person, firewall) and (intersectsLeftAlso(person, firewall) or
						intersectsRightAlso(person, firewall)) then
						person.yPos = person.yPos - 2
						person.angle = love.math.random(1.2 * math.pi, 1.8 * math.pi)
					end


					if intersectsLeft(player, wall) and (intersectsTopAlso(player, wall) or
						intersectsBottomAlso(player, wall)) then
						player.xPos = player.xPos + 4
					end
					if intersectsRight(player, wall) and (intersectsTopAlso(player, wall) or
						intersectsBottomAlso(player, wall)) then
						player.xPos = player.xPos - 4
					end
					if (intersectsTop(player, wall) and intersectsLeftAlso(player, wall)) or
						(intersectsRightAlso(player, wall)) then
						player.yPos = player.yPos + 4
						player.xPos = player.xPos - 4
					end
					if intersectsBottom(player, wall) and (intersectsLeftAlso(player, wall) or
						intersectsRightAlso(player, wall)) then
						player.yPos = player.yPos - 4
						player.xPos = player.xPos - 4
					end

					if intersectsLeft(player, firewall) and (intersectsTopAlso(player, firewall) or
					intersectsBottomAlso(player, firewall)) then
					player.xPos = player.xPos + 4
					end
					if intersectsRight(player, firewall) and (intersectsTopAlso(player, firewall) or
						intersectsBottomAlso(player, firewall)) then
						player.xPos = player.xPos - 4
					end
					if (intersectsTop(player, firewall) and intersectsLeftAlso(player, firewall)) or
						(intersectsRightAlso(player, firewall)) then
						player.yPos = player.yPos + 4
						player.xPos = player.xPos - 4
					end
					if intersectsBottom(player, firewall) and (intersectsLeftAlso(player, firewall) or
						intersectsRightAlso(player, firewall)) then
						player.yPos = player.yPos - 4
						player.xPos = player.xPos - 4
					end
				end
			end
		end
	end
end

-- HC mode above

function intersectsLeft(rect1, rect2)
	if (rect1.xPos < rect2.xPos + rect2.width and rect1.xPos > rect2.xPos) then
		return true
	else
		return false
	end
end

function intersectsRight(rect1, rect2)
	if (rect1.xPos + rect1.width > rect2.xPos and rect1.xPos < rect2.xPos) then
		return true
	else
		return false
	end
end

function intersectsTop(rect1, rect2)
	if (rect1.yPos - 2 < rect2.yPos + rect2.height and rect1.yPos > rect2.yPos) then
		return true
	else
		return false
	end
end

function intersectsBottom(rect1, rect2)
	if (rect1.yPos + rect1.height + 2 > rect2.yPos and rect1.yPos < rect2.yPos) then
		return true
	else
		return false
	end
end

function intersectsLeftAlso(rect1, rect2)
	if (rect1.xPos < rect2.xPos + rect2.width and rect1.xPos > rect2.xPos) and
		((rect1.yPos < rect2.yPos + rect2.height and rect1.yPos > rect2.yPos) or
		(rect1.yPos + rect1.height > rect2.yPos and rect1.yPos < rect2.yPos)) then
		return true
	else
		return false
	end
end

function intersectsRightAlso(rect1, rect2)
	if (rect1.xPos + rect1.width > rect2.xPos and rect1.xPos < rect2.xPos) and
	((rect1.yPos < rect2.yPos + rect2.height and rect1.yPos > rect2.yPos) or
	(rect1.yPos + rect1.height > rect2.yPos and rect1.yPos < rect2.yPos)) then
		return true
	else
		return false
	end
end

function intersectsTopAlso(rect1, rect2)
	if (rect1.yPos < rect2.yPos + rect2.height and rect1.yPos > rect2.yPos) and
	((rect1.xPos < rect2.xPos + rect2.width and rect1.xPos > rect2.xPos) or
	(rect1.xPos + rect1.width > rect2.xPos and rect1.xPos < rect2.xPos)) then
		return true
	else
		return false
	end
end

function intersectsBottomAlso(rect1, rect2)
	if (rect1.yPos + rect1.height > rect2.yPos and rect1.yPos < rect2.yPos) and
	((rect1.xPos < rect2.xPos + rect2.width and rect1.xPos > rect2.xPos) or
	(rect1.xPos + rect1.width > rect2.xPos and rect1.xPos < rect2.xPos)) then
		return true
	else
		return false
	end
end

function wait (second)
end

function newAnimation(image, width, height, duration)
	local animation = {}
	animation.spriteSheet = image;
	animation.quads = {};

	for y = 0, image:getHeight() - height, height do
		for x = 0, image:getWidth() - width, width do
			table.insert(animation.quads, love.graphics.newQuad(x, y, width, height,
			image:getDimensions()))
		end
	end

	animation.duration = duration or 1
	animation.currentTime = 0

	return animation
end

--Timer function from https://github.com/vrld/hump