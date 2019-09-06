player = {}
enemies = {}
function love.conf(t)
	t.console = true

end

function love.load()
	love.window.setMode(1000,1000)
	w, h = love.graphics.getDimensions()
	flag = false
	love.keyboard.setKeyRepeat(true)
	vel = 50
	playerBundle = {}
	x = 250
	y = 250
	tam = 50
	middlex = x
	middley = y
	aux=45

	up = love.math.newBezierCurve(x-tam,y-tam, middlex, y-tam-aux, x+tam,y-tam)
	down =  love.math.newBezierCurve(x-tam,y+tam, middlex, y+tam+aux ,x+tam,y+tam)
	right =  love.math.newBezierCurve(x+tam,y+tam, x+tam+aux, middley, x+tam,y-tam)
	left =  love.math.newBezierCurve(x-tam,y+tam, x-tam-aux, middley, x-tam,y-tam)


	for i = 1 , 30 do
		addEnemie(generateEnemie(-1))
	end








	player.create('player',10)

	
end

function love.update(dt)
	-- middlex = x
	-- middley = y
	player.move()
	aux = aux + vel * 0.01
	if aux > 50 then
		vel = -vel
	end
	if aux <25 then
		vel = -vel
	end
	y = playerBundle['player'].y
	x = playerBundle['player'].x
	middlex = x
	middley = y

	up = love.math.newBezierCurve(x-tam,y-tam, middlex, y-tam-aux, x+tam,y-tam)
	down =  love.math.newBezierCurve(x-tam,y+tam, middlex, y+tam+aux ,x+tam,y+tam)
	right =  love.math.newBezierCurve(x+tam,y+tam, x+tam+aux, middley, x+tam,y-tam)
	left =  love.math.newBezierCurve(x-tam,y+tam, x-tam-aux, middley, x-tam,y-tam)

	for i, j in pairs(enemies) do
		temp =  checkEat(playerBundle['player'],j)
		if(temp == 'gameover')then
			playerBundle['player'].size = 10
		end
		if (temp) then
			table.remove(enemies,i)
			addEnemie(generateEnemie(-1))
		end
		j.x = j.x+(j.speed*math.cos(j.angle)*dt)
		j.y = j.y+(j.speed*math.sin(j.angle)*dt)
		if(j.x < -j.size or j.x> w+j.size) then
			table.remove(enemies,i)
			addEnemie(generateEnemie(-1))


		end 
	end





end


function love.draw(dt)

	-- if(flag) then
	-- 	love.graphics.circle("fill", 10,10, 10)
	-- end
	for i,j in pairs(playerBundle) do
		love.graphics.setColor(1,0, 0)
		love.graphics.circle("fill", playerBundle[i].x,playerBundle[i].y, playerBundle[i].size)
		love.graphics.reset()
	end
	for i,j in pairs(enemies) do
		love.graphics.setColor(0,0, 1,0.3)
		love.graphics.line(j.originx,j.originy,j.destx,j.desty)
		love.graphics.setColor(j.r,j.g, j.b)
		love.graphics.circle("fill", j.x,j.y,j.size)
		-- love.graphics.line(j.originx, j.originy, w,0)
		-- love.graphics.line(j.originx, j.originy, w,h)
		
		
		love.graphics.reset()
	end

	-- love.graphics.line(down:render())
	-- love.graphics.line(up:render())
	-- love.graphics.line(left:render())
	-- love.graphics.line(right:render())

end
function addEnemie(e)
	table.insert(enemies,e)
end

function player.move()


	local speed  = 10
	local keys = 0
	if love.keyboard.isDown('up') then
		keys = keys+1
	end
	if love.keyboard.isDown('down') then
		keys = keys+1
	end
	if love.keyboard.isDown('left') then
		keys = keys+1
	end
	if love.keyboard.isDown('right') then
		keys = keys+1
	end

	if love.keyboard.isDown('up') then
		playerBundle['player'].y = playerBundle['player'].y - (speed/keys)
	end
	if love.keyboard.isDown('down') then
		playerBundle['player'].y = playerBundle['player'].y + (speed/keys)

	end
	if love.keyboard.isDown('left') then
		playerBundle['player'].x = playerBundle['player'].x - (speed/keys)
		x =x - (speed/keys)
	end

	if love.keyboard.isDown('right') then
		playerBundle['player'].x = playerBundle['player'].x + (speed/keys)
		x = x + (speed/keys)
	end

	if playerBundle['player'].x < 0 then 
		playerBundle['player'].x = 0
	end 
	if playerBundle['player'].x > love.graphics.getWidth() then 
		playerBundle['player'].x = love.graphics.getWidth()
	end 


	if playerBundle['player'].y < 0 then 
		playerBundle['player'].y = 0
	end 
	if playerBundle['player'].y > love.graphics.getHeight() then 
		playerBundle['player'].y = love.graphics.getHeight()
	end 



end






function generateEnemie(r)
	if(r == -1 ) then
		r = love.math.random(1,80)
	end
	local ball = {}
	local side ={-r+1,w+r-1}
	local speed = {100,-100}
	local sorted = love.math.random(1, #side)
	local x = side[sorted]
	table.remove(side,sorted)
	local y =  love.math.random(r, h-r)
	h2 = h 
	r2 = h/2
	if(y < h/2) then
		h2 = h/2
		r2 = r
	end

	local x2 = side[1]
	local y2 = love.math.random(r2,h2)




	local coe =  getCoeficiente(x,y,x2,y2)
	ball.originx = x
	ball.r = love.math.random()
	ball.g = love.math.random()
	ball.b = love.math.random()
	ball.originy = y
	ball.destx = x2
	ball.desty = y2 
	ball.x = x
	ball.y = y
	ball.size = r
	multiplicator = 1
	if(speed[sorted] < 0) then
		multiplicator = -1
	end
	ball.speed = speed[sorted]  - (multiplicator*(math.abs(speed[sorted])*(ball.size/math.abs(speed[sorted]))))
	ball.angle = getAnguloCoe(coe)
	print(math.deg(ball.angle))

	return ball 
end

function getCoeficiente(x1,y1,x2,y2) 
	return (y2-y1)/(x2-x1)

end
function getAngulo(m1,m2)
	return math.abs(math.atan((m2-m1)/1+m2*m1))
end
function getAnguloCoe(angle)
	return math.atan(angle)
end

function colide(x1,y1,r1,x2,y2,r2)
	if(math.sqrt(math.pow(x1-x2,2)+math.pow(y1-y2,2)) < r1+r2) then
		return true
	else
		return false
	end


end

function checkEat(player,enemie)
	if(colide(player.x,player.y,player.size,enemie.x,enemie.y,enemie.size) and player.size < enemie.size )  then
		return 'gameover'
		elseif(colide(player.x,player.y,player.size,enemie.x,enemie.y,enemie.size) and player.size >= enemie.size)then
			player.size = player.size+1
			return true
		end

	end



	function player.create(name,size)
		playerBundle[name] = {}	
		playerBundle[name].size = size
		playerBundle[name].x   = love.graphics.getWidth() / 2
		playerBundle[name].y = love.graphics.getHeight() / 2

	end


