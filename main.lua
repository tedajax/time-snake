require "snakeconf"
require "snake"
require "apple"
require "util"

function getRandomTileX()
	return math.random(gameBounds.left, gameBounds.right);
end

function getRandomTileY()
	return math.random(gameBounds.top, gameBounds.bottom);
end

function love.load()
	math.randomseed(os.time());
	
	snakeGameInit();

	love.graphics.setBackgroundColor(148, 175, 132);

	snake = initSnake();
	addSegments(snake, startingSnakeLength);
	snake.position.x = snake.position.x + 1;
	
	apples = {};
	apples.n = 5;
	for i = 1, apples.n do
		apples[i] = createApple(getRandomTileX(), getRandomTileY());
	end
	
	gameFont = love.graphics.newFont("bitwise.ttf", 48);
	love.graphics.setFont(gameFont);
	
	mainCanvas = love.graphics.newCanvas();
	shadowCanvas = love.graphics.newCanvas();
	
	textCanvas = love.graphics.newCanvas();
	
	highScore = 0;

	if (love.filesystem.exists("scores.dat") == false) then
		local newScoreFile = love.filesystem.newFile("scores.dat");
		newScoreFile:open("w");
		
		for i = 10, 1, -1 do
			newScoreFile:write("AAA,");
			newScoreFile:write(i * 10 .. ",");
		end
	end
	
	local file = love.filesystem.newFile("scores.dat");
	file:open("r");
	data = file:read();
	
	scoreData = split(data, ",");
	
	highScores = {};
	for i = 1, 10 do
		highScores[i] = {};
		highScores[i].name = scoreData[2 * i - 1];
		highScores[i].score = scoreData[2 * i];
		
		print(highScores[i].name);
		print(highScores[i].score);
	end
	
	score = 0;
	scoreTime = 10;
	scoreTimer = scoreTime;
	
	menuSelection = 0;
	mainMenuItems = {};
	mainMenuItems[0] = "PLAY";
	mainMenuItems[1] = "SCORES";
	mainMenuItems[2] = "QUIT";
end

function resetGame()
	snake = initSnake();
	addSegments(snake, startingSnakeLength);
	snake.position.x = snake.position.x + 1;
	
	if (score > highScore) then
		highScore = score;
	end
	
	scoreTime = 10;
	scoreTimer = scoreTime;
	
	score = 0;
end

function love.keypressed(key, unicode)
	if (key == "escape") then
		if (gameState == "play") then
			gameState = "mainmenu";
		else
			love.event.push("quit");
		end
	end

	if (gameState == "mainmenu") then
		mainMenuKeypressed(key, unicode);
	elseif (gameState == "play") then
		playKeypressed(key, unicode);
	end
end

function mainMenuKeypressed(key, unicode)
	if (key == "up") then
		menuSelection = menuSelection - 1;
	end
	
	if (key == "down") then
		menuSelection = menuSelection + 1;
	end
	
	if (menuSelection < 0) then
		menuSelection = 2;
	elseif (menuSelection > 2) then
		menuSelection = 0;
	end
	
	if (key == "return") then
		if (menuSelection == 0) then
			gameState = "play";
		elseif (menuSelection == 1) then
			gameState = "scoreMenu";
		else
			love.event.push("quit");
		end
	end
end

function playKeypressed(key, unicode)	
	if (key == "up") then
		snake.direction = "up";
	end
	
	if (key == "down") then
		snake.direction = "down";
	end
	
	if (key == "left") then
		snake.direction = "left";
	end
	
	if (key == "right") then
		snake.direction = "right";
	end
	
	if (key == "return") then
		if (snake.dead == true) then
			resetGame()
		end
	end
end

function mainMenuUpdate(dt)
	
end

function love.update(dt)
	if (gameState == "mainmenu") then
		mainMenuUpdate(dt);
	elseif (gameState == "play") then
		playUpdate(dt);
	end
end

function playUpdate(dt)
	updateSnake(snake, dt);
	
	scoreTime = scoreTime + (dt / 10);
	if (scoreTime > 10) then
		scoreTimer = 100;
	end
	
	for i = 1, apples.n do
		if (apples[i].position.x == snake.position.x and apples[i].position.y == snake.position.y) then
			addSegments(snake, 5);
			apples[i].position.x = getRandomTileX();
			apples[i].position.y = getRandomTileY();
			--score = score + 20
			scoreTime = 0;
			scoreTimer = 0;
		end
	end
	
	if (snake.dead == false) then
		scoreTimer = scoreTimer - dt;
		
		if (scoreTimer <= 0) then
			scoreTimer = scoreTime;
			score = score + 1;
		end
	end
end

function love.draw()
	if (gameState == "mainmenu") then
		mainMenuDraw();
	elseif (gameState == "play") then
		playDraw();
	end
end

function playDraw()
	drawSnake(snake);
	drawApples(apples);
	
	shadowRectangle("fill", 0, (gameBounds.top * tileHeight) - (tileHeight / 3), (gameBounds.right - gameBounds.left + 1) * tileWidth, tileHeight / 3, 2);
	shadowRectangle("fill", 0, (gameBounds.bottom + 1) * tileHeight, (gameBounds.right - gameBounds.left + 1) * tileWidth, tileHeight / 3, 2);
	shadowRectangle("fill", (gameBounds.left * tileWidth) - (tileWidth / 3), (gameBounds.top * tileHeight) - (tileHeight / 3), tileWidth / 3, (gameBounds.bottom - gameBounds.top + 1) * tileHeight + (2 * tileHeight / 3));
	shadowRectangle("fill", ((gameBounds.right + 1) * tileWidth), (gameBounds.top * tileHeight) - (tileHeight / 3), tileWidth / 3, (gameBounds.bottom - gameBounds.top + 1) * tileHeight + (2 * tileHeight / 3));
	
	love.graphics.draw(shadowCanvas);
	love.graphics.draw(mainCanvas);
	
	drawHUD();
	
	mainCanvas:clear();
	shadowCanvas:clear();
end

function mainMenuDraw()
	love.graphics.setColor(50, 50, 50);
	
	textCanvas:renderTo(
		function()
			love.graphics.print(mainMenuItems[0], love.graphics.getWidth() / 2, 200, 0, 1, 1, gameFont:getWidth(mainMenuItems[0]) / 2, 0);
			love.graphics.print(mainMenuItems[1], love.graphics.getWidth() / 2, 300, 0, 1, 1, gameFont:getWidth(mainMenuItems[1]) / 2, 0);
			love.graphics.print(mainMenuItems[2], love.graphics.getWidth() / 2, 400, 0, 1, 1, gameFont:getWidth(mainMenuItems[2]) / 2, 0);
			
			love.graphics.rectangle("line", (love.graphics.getWidth() / 2) - gameFont:getWidth(mainMenuItems[menuSelection]) / 2, (menuSelection + 2) * 100, gameFont:getWidth(mainMenuItems[menuSelection]), 42);
		end
	);
	
	love.graphics.draw(textCanvas);
	
	textCanvas:clear();
end

function drawHUD()
	love.graphics.setColor(50, 50, 50);
	
	textCanvas:renderTo(
		function()
			love.graphics.print("SCORE : " .. score, 5, 10);
			love.graphics.print("HIGH : " .. highScore, love.graphics.getWidth() - 5, 10, 0, 1, 1, gameFont:getWidth("HIGH : " .. highScore), 0);
		end
	);
							
	if (snake.dead) then
		textCanvas:renderTo(
			function() 
				love.graphics.print("GAME OVER", 640, 300, 0, 1, 1, gameFont:getWidth("GAME OVER") / 2, 0) 
			end
		);
	end
	
	love.graphics.draw(textCanvas);
	textCanvas:clear();
end