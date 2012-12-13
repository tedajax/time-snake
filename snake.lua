require "snakeconf"
require "util"

function initSnake()
	snake = {};
	
	snake.position = {};
	snake.position.x = gameBounds.center.x;
	snake.position.y = gameBounds.center.y;
	
	snake.tail = {};
	snake.tail.x = snake.position.x;
	snake.tail.y = snake.position.y;
	
	snake.direction = "right";
	
	snake.moveTime = snakeMoveTime;
	snake.moveTimer = snake.moveTime;
	
	snake.body = {};
	
	snake.length = 0;
	
	snake.dead = false;
	
	return snake;
end

function addSegments(snake, amount)
	prevLength = snake.length;
	snake.length = snake.length + amount;
	
	for i = 1, amount do
		local b = prevLength + i;
		snake.body[b] = {};
		snake.body[b].position = {};
		snake.body[b].position.x = snake.tail.x;
		snake.body[b].position.y = snake.tail.y;
	end
end

function updateSnake(snake, dt)
	if (snake.dead == false) then
		snake.moveTimer = snake.moveTimer - dt;

		if (snake.moveTimer <= 0) then
			snake.moveTimer = snake.moveTime;
			
			moveSnake(snake);
			
			snake.tail.x = snake.body[snake.length].position.x;
			snake.tail.y = snake.body[snake.length].position.y;
		end
	end
end

function moveSnake(snake)	
	local sPos = {};
	sPos.x = snake.position.x;
	sPos.y = snake.position.y;
	
	if (snake.direction == "right") then
		sPos.x = sPos.x + 1;
	elseif (snake.direction == "left") then
		sPos.x = sPos.x - 1;
	elseif (snake.direction == "up") then
		sPos.y = sPos.y - 1;
	elseif (snake.direction == "down") then
		sPos.y = sPos.y + 1;
	end
	
	if (spaceSafe(sPos.x, sPos.y) == true) then
		moveBody(snake);
		snake.position = sPos
	else
		snake.dead = true;
	end
end

function moveBody(snake)
	for i = snake.length, 1, -1 do
		if (i == 1) then
			snake.body[i].position.x = snake.position.x;
			snake.body[i].position.y = snake.position.y;
		else
			snake.body[i].position.x = snake.body[i - 1].position.x;
			snake.body[i].position.y = snake.body[i - 1].position.y;
		end
	end
end

function checkBoundary(px, py)
	if (px < gameBounds.left or 
		px > gameBounds.right or 
		py < gameBounds.top or 
		py > gameBounds.bottom) then
		return false
	else
		return true
	end
end

function checkSegmentCollision(px, py)
	for i = 1, snake.length do
		if (px == snake.body[i].position.x and py == snake.body[i].position.y) then
			return false;
		end
	end
	
	return true;
end

function spaceSafe(px, py)
	return (checkBoundary(px, py) and checkSegmentCollision(px, py));
end

function drawSnake(snake)
	love.graphics.setColor(50, 50, 50);
	
	--Draw the head
	shadowRectangle("fill", snake.position.x * tileWidth, snake.position.y * tileHeight, tileWidth, tileHeight, 8);
	
	--Draw the body segments
	for i = 1, snake.length do
		bx = snake.body[i].position.x;
		by = snake.body[i].position.y;
		shadowRectangle("fill", bx * tileWidth, by * tileHeight, tileWidth, tileHeight, 8);
	end
end


