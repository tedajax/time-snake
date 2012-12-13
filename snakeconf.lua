function snakeGameInit()
	tileWidth = 24;
	tileHeight = 24;
	
	gameBounds = {};
	gameBounds.left = 0;
	gameBounds.right = math.floor(love.graphics.getWidth() / tileWidth) - 1;
	gameBounds.top = math.ceil(72 / tileHeight);
	gameBounds.bottom = math.floor(love.graphics.getHeight() / tileHeight) - 1;
	
	gameBounds.center = {};
	gameBounds.center.x = math.floor((gameBounds.right - gameBounds.left) / 2) + gameBounds.left;
	gameBounds.center.y = math.floor((gameBounds.bottom - gameBounds.top) / 2) + gameBounds.top;
	
	snakeMoveTime = 0.05;
	
	startingSnakeLength = 3;
	
	gameState = "mainmenu"
end