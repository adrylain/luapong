local SDL = require "SDL"
local image = require "SDL.image" 
local mixer = require "SDL.mixer"
local ttf = require "SDL.ttf" 

local running = true



local w = false
local s = false
local i = false
local k = false



    
local left = 0
local right = 0
    
local paddleA = 250
local paddleB = 250
    
    

local ballX = 395
local ballY = 290


local moveX = 2
local moveY = 2




--------INIT--------

local ret, err = SDL.init {
    SDL.flags.Video,
    SDL.flags.Audio
}

if not ret then
error(err)
end

local ret, err = mixer.openAudio(44100, SDL.audioFormat.S16, 2, 1024)

if not ret then
error(err)
end


local ret, err = ttf.init()

if not ret then
error(err)
end



--------WINDOW--------


local win, err = SDL.createWindow {
title   = "Commie Pong",
width   = 1010,
height  = 622,
--flags   = { SDL.window.Resizable },
x       = 126,
y       = 126,
}

if not win then
error(err)
end



--------INIT IMAGES--------


local function trySDL(func, ...)
    local t = { func(...) }

    if not t[1] then
        error(t[#t])
    end

    return table.unpack(t)
end

-- Initialize SDL and SDL_image
trySDL(SDL.init, { SDL.flags.Video })



local formats, ret, err = image.init { image.flags.PNG }

if not formats[image.flags.PNG] then
error(err)
end

local rdr = trySDL(SDL.createRenderer, win, -1)

rdr:setDrawColor(0xFFFFFF)



--------LOAD IMAGES--------

local noah, ret = image.load("noah.png")
if not noah then
--error(err)
print("Problem loading image.")
end

noah = rdr:createTextureFromSurface(noah)


local ball, ret = image.load("ball.png")
if not ball then
--error(err)
print("Problem loading image.")
end

ball = rdr:createTextureFromSurface(ball)


local orion, ret = image.load("orion.png")
if not orion then
--error(err)
print("Problem loading image.")
end

orion = rdr:createTextureFromSurface(orion)


local background, ret = image.load("background.png")
if not background then
--error(err)
print("Problem loading image.")
end

background = rdr:createTextureFromSurface(background)

local blackback, ret = image.load("blackback.png")
if not blackback then
--error(err)
print("Problem loading image.")
end

blackback = rdr:createTextureFromSurface(blackback)

local logo, ret = image.load("logo.png")
if not logo then
--error(err)
print("Problem loading image.")
end

logo = rdr:createTextureFromSurface(logo)

--------LOAD SOUNDS--------

local wallhit = mixer.loadWAV("wallhit.wav")

if not wallhit then 
    error (err)
end

local paddlehit = mixer.loadWAV("paddlehit.wav")

if not paddlehit then 
    error (err)
end

local goal = mixer.loadWAV("goal.wav")

if not goal then 
    error (err)
end

local ree = mixer.loadWAV("ree.wav")

if not ree then 
    error (err)
end



--------LOAD FONT--------


local arcade, err = ttf.open("arcade-i.ttf", 100)

if not arcade then
error(err)
end








--------INTRO--------

local logopos = {}
logopos.x = 550-170
logopos.y = 311-128
logopos.h = 256
logopos.w = 256


rdr:setDrawColor(0xFFFFFF)
rdr:clear()
rdr:copy(blackback)
rdr:copy(logo, nil, logopos)

rdr:present()

SDL.delay(2500)



--------EXECUTE--------





local pos = {}
local noahpos = {}
local orionpos = {}

local OrionScorePos = {}
local NoahScorePos = {}



function tick()

local NoahScoreS, err = arcade:renderUtf8(tostring(left), "solid", 0xFFFFFF)
if not NoahScoreS then
error(err)
end

local NoahScoreT = rdr:createTextureFromSurface(NoahScoreS)

local OrionScoreS, err = arcade:renderUtf8(tostring(right), "solid", 0xFFFFFF)
if not OrionScoreS then
error(err)
end

local OrionScoreT = rdr:createTextureFromSurface(OrionScoreS)





pos.x = ballX-20
pos.y = ballY-20
pos.w = 40
pos.h = 40

noahpos.x = 0
noahpos.y = paddleA
noahpos.w = 100
noahpos.h = 100

orionpos.x = 910
orionpos.y = paddleB
orionpos.w = 100
orionpos.h = 100


OrionScorePos.x = 710
OrionScorePos.y = 100
OrionScorePos.h = 75
OrionScorePos.w = 75


NoahScorePos.x = 200
NoahScorePos.y = 100
NoahScorePos.h = 75
NoahScorePos.w = 75



        ballX = ballX + moveX
        ballY = ballY + moveY
        
        
        
        if w == true then
            if paddleA - 4 >= 0 then
                paddleA = paddleA -4
            end
        end

        if s == true then
            if paddleA + 4 <= 500 then
                paddleA = paddleA + 4
            end
        end
        
        if i == true then
            if paddleB - 4 >= 0 then
                paddleB = paddleB - 4
            end
        end


        if k == true then
            if paddleB + 4 <= 500 then
                paddleB = paddleB + 4
            end
        end
        
        
        if ballY <= 0 then
            moveY = moveY*-1
            
            wallhit:playChannel(1)
            mixer.expireChannel(1,200)
        end
        
        if ballY >= 600 then
            moveY = moveY*-1

            wallhit:playChannel(1)
            mixer.expireChannel(1,200)
        end



        if ballX <= 100 and ballX >= 0 and ballY >= paddleA and ballY <= paddleA+100 then
            moveX = moveX*-1
            paddlehit:playChannel(2)
            mixer.expireChannel(2,100)


        end
        

        if ballX >= 910 and ballX <= 1010 and ballY >= paddleB and ballY <= paddleB+100 then
            moveX = moveX*-1
            paddlehit:playChannel(2)
            mixer.expireChannel(2,100)

        end

        if ballX > 1010 then

            ballX = 505
            ballY = 300


            right = right + 1
            goal:playChannel(1)
            mixer.expireChannel(1, 200)
        end
        
        if ballX < 0 then

            ballX = 505
            ballY = 300

            left = left+1
           goal:playChannel(1)
           mixer.expireChannel(1, 200)
        end



        rdr:setDrawColor(0xFFFFFF)
        rdr:clear()
        rdr:copy(background)


        rdr:copy(noah, nil, noahpos)
        rdr:copy(orion, nil, orionpos)



        rdr:copy(NoahScoreT,nil,OrionScorePos)
        rdr:copy(OrionScoreT,nil,NoahScorePos)


        rdr:copy(ball, nil, pos)

        rdr:present()

end











while running do



tick()



    for e in SDL.pollEvent() do
        if e.type == SDL.event.Quit then

            ree:playChannel(3)
            mixer.expireChannel(3,1100)

            SDL.delay(1100)

            running = false
        elseif e.type == SDL.event.KeyDown then
--            print(string.format("key down: %d -> %s", e.keysym.sym, SDL.getKeyName(e.keysym.sym)))


            if SDL.getKeyName(e.keysym.sym) == "W" then
                w = true
            elseif SDL.getKeyName(e.keysym.sym) == "S" then
                s = true
            elseif SDL.getKeyName(e.keysym.sym) == "I" then
                i = true
            elseif SDL.getKeyName(e.keysym.sym) == "K" then
                k = true
            end


        elseif e.type == SDL.event.KeyUp then


            if SDL.getKeyName(e.keysym.sym) == "W" then
                w = false
            elseif SDL.getKeyName(e.keysym.sym) == "S" then
                s = false
            elseif SDL.getKeyName(e.keysym.sym) == "I" then
                i = false
            elseif SDL.getKeyName(e.keysym.sym) == "K" then
                k = false
            end

        elseif e.type == SDL.event.MouseButtonDown then

            ree:playChannel(3)
            mixer.expireChannel(3,1100)

        end           
    end




SDL.delay(4)
end






--[[]

elseif e.type == SDL.event.MouseWheel then
                            print(string.format("mouse wheel: %d, x=%d, y=%d", e.which, e.x, e.y))
                    elseif e.type == SDL.event.MouseButtonDown then
                            print(string.format("mouse button down: %d, x=%d, y=%d", e.button, e.x, e.y))
                    elseif e.type == SDL.event.MouseMotion then
                            print(string.format("mouse motion: x=%d, y=%d", e.x, e.y))
                    end

--]]






SDL.quit()
image.quit()
mixer.quit()
ttf.quit()