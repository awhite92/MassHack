
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
		stateNext = 0
		
		lineSpace = 18
		charToWall = 77 -- the ammount of chars to the right side of the game
		termLines = {}
		showInput = false
		
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
		
		mapText = {
			{ caption = "", content = ""},
			{ caption = "", content = ""}
			}
		
		-- setup the fonts
		termFont = gfx.newFont("res/dosvga.ttf",16)
		
		-- lets get things started :D
		audio.play(startSound)
		pushLine("Initializing Hardware...")
	end
	
	function printLines()
		for id = 1, #termLines, 1 do
			gfx.print(termLines[id], 10, 10 + (id-1) * lineSpace)
		end
		if showInput then gfx.print("root@MassHack#:_", 10, 10 + (#termLines) * lineSpace) end
	end
	
	function pushLine(lineText)
		table.insert(termLines, lineText)
	end
	function clearLines()
		termLines = {}
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
				
				if stateID == 1 then
					stateNext = 2  -- dont show anything for 1 second
				elseif stateID == 2 then 
					stateNext = 6  -- 6 -- the time it takes the sound file to go BEEP -- probably going to be shortened
					clearLines()
				elseif stateID == 3 then 
					stateNext = 1
					pushLine("loading Linux Kernel v3.6r7...")
				elseif stateID == 4 then 
					stateNext = .5
					termLines[1] = "loading Linux Kernel v3.6r7........................................... [Done]"
					pushLine("Connecting to external IP...")
				elseif stateID == 5 then 
					stateNext = .4
					termLines[2] = "Connecting to external IP............................................. [Done]"
					pushLine("Masking IP and rerouting...")
				elseif stateID == 6 then 
					stateNext = .7
					termLines[3] = "Masking IP and rerouting.............................................. [Done]"
					pushLine("Auto Logging In...")
				elseif stateID == 7 then 
					setupMainMenu() -- meh..
				end -- move on to the main menu
			end
			
		elseif gameState == "mainMenu" then
			
			
			
		end
		
		gfx.setCaption("Mass Hack - Current FPS: "..tostring(love.timer.getFPS()))
	end
	
	function setupMainMenu()
		gameState = "mainMenu"
		showInput = true
		clearLines()
		pushLine("Welcom To MASS Hack v 0.3a")
		pushLine("This version is still under heavy development, and is subject to change.")
		pushLine("type help for a list of commands.")
		pushLine("-------------------------------------")
		addHelpLines()
	end
	
	function addHelpLines()
		pushLine("Help - these are not avalible as of yet.")
		pushLine("help      levels      options")
		pushLine("exit      clear")
		pushLine("-------------------------------------")
	end
	
	function love.draw()
		gfx.setColor(255,255,255,255)
		gfx.setFont(termFont)
		
		if gameState == "startup" then
		
			if stateID == 0 then
			
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
			
			printLines()
				
		elseif gameState == "mainMenu" then
			
			--gfx.draw(logo_s, winW - logo_s:getWidth() - 10, 10) -- mite not keep the small logo, i just don't know. -- wasnt really digging it
			printLines()
			
		elseif gameState == "mapTest" then
		
			gfx.draw(maps[1],0,0,0,23,23)
			
		end
		
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
		
			gameState = "mapTest" -- accepts an 'any key'
			
			
			
		elseif gameState == "startup" then
			
			if key == " " then
				setupMainMenu()
			end
			
		end
	end
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	