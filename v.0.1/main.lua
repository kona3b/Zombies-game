function love.load()
	arenaWidth = love.graphics.getWidth( )
	arenaHeight = love.graphics.getHeight( )

	shipRadius = arenaHeight / 60
	personRadius = arenaHeight / 60
	zombieRadius = arenaHeight / 60
	personSpeed = 100
	zombieSpeed = 200

	function reset()
		shipX = arenaWidth / 2
		shipY = arenaHeight / 2
		shipAngle = 0
		shipSpeedX = 0
		shipSpeedY = 0

		zombies = {
			{
				x = arenaWidth - (arenaWidth / 8),
				y = arenaHeight - (arenaHeight / 6),
			}
		}

		persons = {
			{
				x = arenaWidth / 8,
				y = arenaHeight / 6,
			},
			{
				x = arenaWidth - (arenaWidth / 8),
				y = arenaHeight / 6,
			},
			{
				x = arenaWidth / 8,
				y = arenaHeight - (arenaHeight / 6),
			},
			{
				x = arenaWidth - (arenaWidth / 8),
				y = arenaHeight - (arenaHeight / 6),
			},
			{
				x = arenaWidth / 2,
				y = arenaHeight - (love.math.random((arenaWidth / 12), (arenaWidth / 8))),
			},
			{
				x = love.math.random(arenaHeight, (arenaHeight - arenaHeight)),
				y = love.math.random(arenaWidth, (arenaWidth - arenaWidth)),
			},
			{
				x = love.math.random(arenaHeight, (arenaHeight - arenaHeight)),
				y = love.math.random(arenaWidth, (arenaWidth - arenaWidth)),
			},
			{
				x = love.math.random(arenaHeight, (arenaHeight - arenaHeight)),
				y = love.math.random(arenaWidth, (arenaWidth - arenaWidth)),
			},
			{
				x = love.math.random(arenaHeight, (arenaHeight - arenaHeight)),
				y = love.math.random(arenaWidth, (arenaWidth - arenaWidth)),
			},
			{
				x = love.math.random(arenaHeight, (arenaHeight - arenaHeight)),
				y = love.math.random(arenaWidth, (arenaWidth - arenaWidth)),
			},
			{
				x = love.math.random(arenaHeight, (arenaHeight - arenaHeight)),
				y = love.math.random(arenaWidth, (arenaWidth - arenaWidth)),
			},
			{
				x = love.math.random(arenaHeight, (arenaHeight - arenaHeight)),
				y = love.math.random(arenaWidth, (arenaWidth - arenaWidth)),
			},
			{
				x = love.math.random(arenaHeight, (arenaHeight - arenaHeight)),
				y = love.math.random(arenaWidth, (arenaWidth - arenaWidth)),
			},
			{
				x = arenaWidth / 2,
				y = love.math.random((arenaWidth / 12), (arenaWidth / 8)),
			}
		}

		for personIndex, person in ipairs(persons) do
			person.angle = love.math.random() * (2 * math.pi)
		end

		for zombieIndex, zombie in ipairs(zombies) do
			zombie.angle = love.math.random() * (2 * math.pi)
		end
	end
	reset()
end

function love.update(dt)
	local turnSpeed = 8

	local angle1 = love.math.random() * (2 * math.pi)
	local angle2 = (angle1 - math.pi) % (2 * math.pi)

	if love.keyboard.isDown('right') then
		shipAngle = shipAngle + turnSpeed * dt
	end

	if love.keyboard.isDown('left') then
		shipAngle = shipAngle - turnSpeed * dt
	end
	shipAngle = shipAngle % (2 * math.pi)

	if love.keyboard.isDown('up') then
		local shipSpeed = 200
		shipSpeedX = shipSpeedX + math.cos(shipAngle) * shipSpeed * dt
		shipSpeedY = shipSpeedY + math.sin(shipAngle) * shipSpeed * dt
	end

	if love.keyboard.isDown('down') then
		local shipSpeed = -200
		shipSpeedX = shipSpeedX + math.cos(shipAngle) * shipSpeed * dt
		shipSpeedY = shipSpeedY + math.sin(shipAngle) * shipSpeed * dt
	end

	shipX = (shipX + shipSpeedX * dt) % arenaWidth
	shipY = (shipY + shipSpeedY * dt) % arenaHeight

	local function areCirclesIntersecting(aX, aY, aRadius, bX, bY, bRadius)
		return (aX - bX)^2 + (aY - bY)^2 <= (aRadius + bRadius)^2
	end

	for personIndex = #persons, 1, -1 do
		local person = persons[personIndex]

		for zombieIndex = #zombies, 1, -1 do
			local zombie = zombies[zombieIndex]

			if areCirclesIntersecting(
				person.x, person.y, personRadius,
				zombie.x, zombie.y, zombieRadius
			) then
				table.remove(persons, personIndex)

				table.insert(zombies, {
					x = person.x,
					y = person.y,
					angle = angle1,
				})
				table.insert(zombies, {
					x = person.x,
					y = person.y,
					angle = angle2,
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

			if areCirclesIntersecting(
				shipX, shipY, shipRadius,
				zombie.x, zombie.y, zombieRadius
			) then
				table.insert(persons, {
					x = zombie.x,
					y = zombie.y,
					angle = angle1,
				})
				table.remove(zombies, zombieIndex)
				break
			end
		end
	end


	for personIndex, person in ipairs(persons) do
		person.x = (person.x + math.cos(person.angle)
			* personSpeed * dt) % arenaWidth
		person.y = (person.y + math.sin(person.angle)
			* personSpeed * dt) % arenaHeight
	end

	for zombieIndex, zombie in ipairs(zombies) do
		zombie.x = (zombie.x + math.cos(zombie.angle)
			* zombieSpeed * dt) % arenaWidth
		zombie.y = (zombie.y + math.sin(zombie.angle)
			* zombieSpeed * dt) % arenaHeight
	end

	if #persons == 0 then
		reset()
	end
	if #zombies == 0 then
		reset()
	end
end

function love.draw()
	for y = -1, 1 do
		for x = -1, 1 do
			love.graphics.origin()
			love.graphics.translate(x * arenaWidth, y * arenaHeight)

			love.graphics.setColor(0, 0, 1)
			love.graphics.circle('fill', shipX, shipY, shipRadius)

			local shipCircleDistance = shipRadius - (shipRadius / 5)
			love.graphics.setColor(1, 1, 0)
			love.graphics.circle(
			'fill',
			shipX + math.cos(shipAngle) * shipCircleDistance,
			shipY + math.sin(shipAngle) * shipCircleDistance,
			shipRadius / 5
			)

			for personIndex, person in ipairs(persons) do
				love.graphics.setColor(0, 1, 0)
				love.graphics.circle('fill', person.x, person.y, personRadius)
			end

			for zombieIndex, zombie in ipairs(zombies) do
				love.graphics.setColor(1, 0, 0)
				love.graphics.circle('fill', zombie.x, zombie.y, zombieRadius)
			end
		end
	end
end
