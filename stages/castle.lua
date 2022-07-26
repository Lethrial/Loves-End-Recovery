luaDebugMode = true
function onCreate()
	if downscroll then --ik this could be done better but when trying a better method the sprites just kinda died lol
		makeLuaSprite('bricks', 'castle/bricks', -412, 84-106)
		makeAnimatedLuaSprite('lava', 'castle/lava', -700, 498-106)
	else
		makeLuaSprite('bricks', 'castle/bricks', -412, 84)
		makeAnimatedLuaSprite('lava', 'castle/lava', -700, 498)
	end

	addAnimationByPrefix('lava', 'flow', 'flow', 12, true)

	setProperty('bricks.antialiasing', false)
	setProperty('lava.antialiasing', false)
	scaleObject('bricks', 6, 6)
	scaleObject('lava', 6, 6)

	addLuaSprite('bricks', false)
	addLuaSprite('lava', true)
	objectPlayAnimation('lava', 'flow', true)
end

function onCreatePost()
	if downscroll then
		setProperty('boyfriend.y', getProperty('boyfriend.y') - 106)
		setProperty('dad.y', getProperty('dad.y') - 106)
	end

	setProperty('gf.visible', false)
end