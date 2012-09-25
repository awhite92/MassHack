
	--require "mt_class"

	function love.load()
		
		-- make some shortcuts and vars
		audio = love.audio
		gfx = love.graphics
		fLineY = -60
		fLineShow = true
		gameState = "startup"
		stateID = 0
		stateTimer = 0
		stateNext = 2
		lineSpace = 18
		
		-- load all the sounds
		startSound = audio.newSource("res/startup.ogg", stream)
		
		-- load some images
		gfx.setDefaultImageFilter("nearest","nearest")
		screen_over = gfx.newImage("res/screen_over.png")
		logo_l = gfx.newImage("res/logo_l.png")
		logo_s = gfx.newImage("res/logo_s.png")
		
		maps = {
			gfx.newImage("maps/1.png")
			}
		
		-- setup the fonts
		termFont = gfx.newFont("res/dosvga.ttf",16)
		
		-- lets get things started :D
		audio.play(startSound)
		
	end
	
	function love.update(dt)
		
		fLineY = fLineY + 200 * dt -- fancy line people spent years removing from old screens, and now im putting it back. problem? ;D
		
		if fLineY > winH then
			fLineY = winH*3*-1
		end
		
		if gameState == "startup" then
		
			stateTimer = stateTimer + 1 * dt
			
			if stateTimer > stateNext then
				stateTimer = 0 -- reset the timer
				stateID = stateID +1 -- increment the, well you know.
				if stateID == 1 then stateNext = 1 end -- dont show anything for 1 second
				if stateID == 2 then stateNext = 5 end -- the time it takes the sound file to go BEEP -- probably going to be shortened
				if stateID == 3 then gameState = "mainMenu" end -- move on to the main menu
			end
			
		elseif gameState == "mainMenu" then
			
			
			
		end
		
		gfx.setCaption("Mass Hack - Current FPS: "..tostring(love.timer.getFPS()))
	end
	
	function love.draw()
		gfx.setColor(255,255,255,255)
		gfx.setFont(termFont)
		
		if gameState == "startup" then
		
			if stateID == 0 then
				gfx.print("Please Wait...",10,10)
			elseif stateID == 2 then -- skip 1 -- thanks captin
				local imgW = logo_l:getWidth()
				local imgH = logo_l:getHeight()
				local x = winW/2 - imgW/2
				local y = winH/2 - imgH/2 - 20
				gfx.draw(logo_l, x, y)
				-- drawa the amazing progress bar :D
				gfx.rectangle("fill", x, y + imgH +10, imgW, 18)
				gfx.setColor(0,0,0)
				gfx.rectangle("fill", x + 2, y + imgH +12, imgW-4, 14)
				gfx.setColor(255,255,255)
				gfx.rectangle("fill", x + 4, y + imgH +14, stateTimer/stateNext*imgW-8, 10)
			end
			
		elseif gameState == "mainMenu" then
			
			--gfx.draw(logo_s, winW - logo_s:getWidth() - 10, 10) -- mite not keep the small logo, i just don't know. -- wasnt really digging it
			
				gfx.print("Welcome to Mass Computer Systems",10,10) 
				gfx.print("Press Any Key to start the map test...",10, 10 + lineSpace * 1)
				gfx.print("And watch the FPS drop..",10, 10 + lineSpace * 2)
			
		elseif gameState == "mapTest" then
			gfx.draw(maps[1],0,0,0,23,23)
		end
		
		
		
		-- draw test map
		--gfx.draw(maps[1],0,0,0,23,23)
		
		-- draw screen line
		if fLineY > 0 then
			gfx.setColor(255,255,255,100)
			gfx.line(0,fLineY,winW,fLineY)
		end
		
		-- last thing to be drawn
		gfx.setColor(255,255,255,255)
		gfx.draw(screen_over,0,0)
		
	end
	
	function love.keypressed(key)
		if gameState == "mainMenu" then
			gameState = "mapTest"
		end
	end
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	