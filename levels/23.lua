return {
	{1,6,6,6,6,6,6,6,6,1},
	{1,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,2},
	{1,0,0,0,0,0,0,0,0,2},
	{1,0,0,0,0,0,0,1,1,1},
	{1,0,0,0,0,0,0,0,1,1},
	{1,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,1},
	{1,2,2,2,2,2,2,2,2,1},
	settings = 	{
				up = 0,		 	-- the room link to the north
				right = 24,		-- the room link to the east
				down = 50,		-- the room link to the south
				left = 0,		-- the room link to the west
				art = 0		-- special art object, 0 for none ( like the tree )
				}
	}

	-- level data types: --
	-- 0 for empty space
	-- 1 for wall
	-- 2 for level transition
	-- 3 for locked door
	-- 4 for button
	-- 5 for special art object position
