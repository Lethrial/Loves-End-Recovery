function onCreate()
    setPropertyFromClass('GameOverSubstate', 'characterName', 'over')
    setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'shush')
    setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'shush')
    setPropertyFromClass('GameOverSubstate', 'endSoundName', 'shush')
end

function onCreatePost()
    bf_x = getProperty('boyfriend.x')
	bf_y = getProperty('boyfriend.y') --using defaultBoyfriendX/Y didn't work for some reason

    --shock effect (thank you SAKK for making the sprite)
	makeLuaSprite('shock', 'shock', bf_x - 130, bf_y - 120)
	setProperty('shock.antialiasing', false)
	scaleObject('shock', 6, 6)
	addLuaSprite('shock', true)
	setProperty('shock.visible', false)

    --jumping sprites
	makeAnimatedLuaSprite('jump', 'jump', getProperty('boyfriend.x') - 66, getProperty('boyfriend.y') - 66)
	addAnimationByPrefix('jump', 'fire_jump', 'fire_jump', 1, true)
	addAnimationByPrefix('jump', 'normal_jump', 'normal_jump', 1, true)
	setProperty('jump.antialiasing', false)
	scaleObject('jump', 6, 6)
	addLuaSprite('jump', false)
	setProperty('jump.visible', false)
    characterPlayAnim('boyfriend', 'skid', false)
end

function onCountdownTick(counter)
	characterPlayAnim('boyfriend', 'skid', false)
end

function onUpdate(elapsed)
	--why did you flip the skid animation funk mix team ):
	if getProperty('boyfriend.animation.curAnim.name') == 'skid' then
		setProperty('boyfriend.flipX', true)
		setProperty('boyfriend.x', bf_x + 18)
	else
		setProperty('boyfriend.flipX', false)
		setProperty('boyfriend.x', bf_x)
	end

	if curBeat < 340 then setProperty('dad.x', getProperty('dad.x') + (3 * elapsed)) end --moves imario every frame. multiplying by elapsed so the speed is constant on any frame rate   
end

function onEvent(name, value1, value2)
	if name == 'Shock' then
		setProperty('shock.visible', not getProperty('shock.visible'))
	end
end

function onBeatHit()
	--suicide time!
	if curBeat == 336 then characterDance('boyfriend') end
	if curBeat > 337 then
		if getProperty('boyfriend.curCharacter') == 'bf-fire' then
			objectPlayAnimation('jump', 'fire_jump', true)
		else
			objectPlayAnimation('jump', 'normal_jump', true)
		end
	end
	if curBeat == 338 then
		setProperty('boyfriend.visible', false)
		setProperty('jump.visible', true)
		doTweenX('jumpX', 'jump', bf_x - 270, 0.8, 'linear')
		doTweenY('jumpYup', 'jump', bf_y - 220, 0.3, 'circOut')
	end
end

function onTweenCompleted(tag)
	if tag == 'jumpYup' then
		doTweenY('jumpYdown', 'jump', bf_y + 340, 0.5, 'circIn')
	end
end

function onGameOverStart()
	setPropertyFromClass('flixel.FlxG', 'camera.x', 0)
	setPropertyFromClass('flixel.FlxG', 'camera.y', 0)
    screenCenter('boyfriend')
    setProperty('boyfriend.x', getProperty('boyfriend.x') + 30)
    setProperty('boyfriend.y', getProperty('boyfriend.y') - 10)
    playSound('death')
    return Function_Continue
end

function onGameOverConfirm(retry)
    pauseSound('death') --this doesn't work for some reason lol
    if retry then playSound('game_over_confirm') end
	return Function_Continue
end