require "gyroscope"

local W				= application:getContentWidth()
local H				= application:getContentHeight()

local tolerance		= 0.02
local kRad2Deg		= 180.0 / math.pi

local gyroButton	= Button.new(Bitmap.new(Texture.new("CompassOff.png")), Bitmap.new(Texture.new("CompassOver.png")), Bitmap.new(Texture.new("CompassOn.png")))
local circleTex		= Texture.new("Circle.png")

local rotx = 0
local roty = 0
local rotz = 0

local spriteRotX
local spriteRotY
local spriteRotZ

local function onEnterFrame(event)
    local x, y, z = gyroscope:getRotationRate()
	
	if (math.abs(x) > tolerance) then
		rotx = rotx + x * event.deltaTime
		spriteRotX:setRotation(rotx * kRad2Deg)
	end
	
	if (math.abs(y) > tolerance) then
		roty = roty + y * event.deltaTime
		spriteRotY:setRotation(roty * kRad2Deg)
	end
	
	if (math.abs(z) > tolerance) then
		rotz = rotz + z * event.deltaTime
		spriteRotZ:setRotation(rotz * kRad2Deg)
	end
	
end

gyroButton:setScale(0.5)
gyroButton:setPosition((W - gyroButton:getWidth()) / 2.0, H - (gyroButton:getHeight() + 10))
gyroButton:setToggle(false)
gyroButton:addEventListener("click",
	function()
		if (gyroButton.toggle) then
			if (gyroscope:isAvailable()) then
				gyroscope:start()
				
				stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)
				print("Gyroscope started")
			else
				print("Start: No gyroscope available!")
			end
		else
			rotx = 0
			roty = 0
			rotz = 0
			spriteRotX:setRotation(0)
			spriteRotY:setRotation(0)
			spriteRotZ:setRotation(0)
			if (gyroscope:isAvailable()) then
				gyroscope:stop()
				
				stage:removeEventListener(Event.ENTER_FRAME, onEnterFrame)
				print("Gyroscope stopped")
			else
				print("Stop: No gyroscope available!")
			end
		end
	end)

stage:addChild(gyroButton)

function makeCircleSprite()
	local	circleBitmap	= Bitmap.new(circleTex)
	local	circleSprite	= Sprite.new()

	circleBitmap:setScale(0.5)
	circleBitmap:setPosition(-(circleBitmap:getWidth() / 2.0), -(circleBitmap:getHeight() / 2.0))
	circleSprite:addChild(circleBitmap)
	
	return circleSprite
end

function addRefLinesFor(aSprite, aColor)
	local	vertLine		= Shape.new()
	local	horLine			= Shape.new()
	local	posX			= aSprite:getX()
	local	posY			= aSprite:getY()
	
	vertLine:setLineStyle(3, aColor)
	vertLine:moveTo(posX, posY - (aSprite:getHeight() / 2.0 + 10.0))
	vertLine:lineTo(posX, posY + aSprite:getHeight() / 2.0 + 10.0)
	vertLine:endPath()
	
	horLine:setLineStyle(3, aColor)
	horLine:moveTo(posX - (aSprite:getWidth() / 2.0 + 10.0), posY)
	horLine:lineTo(posX + aSprite:getWidth() / 2.0 + 10.0, posY)
	horLine:endPath()
	
	stage:addChild(vertLine)
	stage:addChild(horLine)
end

spriteRotX	= makeCircleSprite()
spriteRotX:setPosition(W * 0.25, H / 4.0)
addRefLinesFor(spriteRotX, 0xFF7777)
stage:addChild(spriteRotX)

spriteRotY	= makeCircleSprite()
spriteRotY:setPosition(W * 0.75, H / 4.0)
addRefLinesFor(spriteRotY, 0x77FF77)
stage:addChild(spriteRotY)

spriteRotZ	= makeCircleSprite()
spriteRotZ:setPosition(W / 2.0, (H + spriteRotZ:getHeight()) / 2.0)
addRefLinesFor(spriteRotZ, 0x7777FF)
stage:addChild(spriteRotZ)

