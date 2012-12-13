function createApple(x, y)
	apple = {};
	apple.position = {};
	
	apple.position.x = x;
	apple.position.y = y;
	
	return apple;
end

function drawApples(apples)
	for i = 1, apples.n do
		drawApple(apples[i]);
	end
end

function drawApple(apple)
	--Draw the apple
	ax = apple.position.x;
	ay = apple.position.y;

	--Top
	shadowRectangle("fill", ax * tileWidth + tileWidth / 3, ay * tileHeight + 0, tileWidth / 3, tileHeight / 3, 3);
	--Left
	shadowRectangle("fill", ax * tileWidth + 0, ay * tileHeight + tileHeight / 3, tileWidth / 3, tileHeight / 3, 3);
	--Bottom
	shadowRectangle("fill", ax * tileWidth + 2 * tileWidth / 3, ay * tileHeight + tileHeight / 3, tileWidth / 3, tileHeight / 3, 3);
	--Right
	shadowRectangle("fill", ax * tileWidth + tileWidth / 3, ay * tileHeight + 2 * tileHeight / 3, tileWidth / 3, tileHeight / 3, 3);
end