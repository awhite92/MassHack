
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
		
		userInput = ""
		placementKey = "_"
		keyTimer = 0
		
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
			{ title = "", content = ""},
			{ title = "", content = ""}
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
		if showInput then gfx.print("root@MassHack#:" .. userInput..placementKey, 10, 10 + (#termLines) * lineSpace) end
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
		
		-- flash placement key -- this is also temp, it needs to be an image and the user should be able to move arround with the arrow keys
		keyTimer = keyTimer + 1 * dt
		if keyTimer >= .5 then
			keyTimer = 0
			if placementKey == "_" then
				placementKey = ""
			else placementKey = "_" end
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
					stateNext = .2
					termLines[2] = "Connecting to external IP............................................. [Done]"
					pushLine("Masking IP and rerouting...")
				elseif stateID == 6 then 
					stateNext = 1
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
		pushLine("Welcom To MASS Hack v 0.4a")
		pushLine("This version is still under heavy development, and is subject to change.")
		pushLine("type help for a list of commands.")
		addHelpLines()
	end
	
	function addHelpLines()
		pushLine("-------------------------------------")
		pushLine("List of commands.")
		pushLine("help      start      options")
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
		
			-- accepting users input
			if key == "backspace" then
				if userInput:len() > 0 then -- well, you cant get rid of nothing, but this is going to have to be much more dynamic later..
					userInput = string.sub(userInput, 0,userInput:len()-1)
				end
			elseif key == "return" then -- trying to do something!
				-- add the line and the users input
				pushLine("root@MassHack#:" .. userInput)
				
				-- find the "space" 
				com = userInput
				if com:find(" ") ~= nil then
					com = com:sub(0,(com:find(" ")-1))
				end
				-- check for commands -- and later check for pramaters
				if com == "clear" then
					clearLines()
				elseif com == "help" then
					addHelpLines()
				elseif com == "start" then
					gameState = "mapTest"
					
				elseif com == "echo" then -- just for kicks..
					pushLine(userInput:sub(6))
				elseif com == "exit" then
					-- do some awesome exiting stuff :D
					love.event.quit()
				else
					pushLine(com.." is not a valid command.")
				end
				userInput = ""
			elseif key == "escape" then
				-- idk yet
			elseif key:len() == 1 then -- make sure to cover al' the other 'special' keys
				userInput = userInput .. key
			end
			
			
		elseif gameState == "startup" then
			
			if key == " " then
				setupMainMenu()
			end
			
		end
	end
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
