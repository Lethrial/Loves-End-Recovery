luaDebugMode = true
arrow_move = 80
acc = 0
small_acc = 0
ds_y = 0
us_y = 655
font_size = 48

function onCreate()
    makeLuaSprite('hud', 'hud/hud', 0, 0)
	setObjectCamera('hud', 'camHUD')
	addLuaSprite('hud', true)
    if downscroll then setProperty('hud.flipY', true) end
end

function onCreatePost()
    for i = 0, 3 do
		if not middlescroll then --pushes arrows into the "4:3" bounds
			setPropertyFromGroup('playerStrums', i, 'x', getPropertyFromGroup('playerStrums', i, 'x') - arrow_move)
			setPropertyFromGroup('opponentStrums', i, 'x', getPropertyFromGroup('opponentStrums', i, 'x') + arrow_move)
		else --removes opponent strums as it's done in funk mix
			setPropertyFromGroup('opponentStrums', i, 'x', -10000)
		end
	end

    --bye bye old ui o/
    setProperty('iconP2.visible', false)
    setProperty('iconP1.visible', false)
	setProperty('healthBar.visible', false)
    setProperty('healthBarBG.visible', false)
	setProperty('scoreTxt.visible', false)
	setProperty('timeBarBG.visible', false)
	setProperty('timeBar.visible', false)
	setProperty('timeTxt.visible', false)
	setProperty('showComboNum', false)
	setProperty('showRating', false)

    --hello new ui \o
    --countdown stuff
    makeAnimatedLuaSprite('countdown', 'hud/countdown', 0, 0)
    setObjectCamera('countdown', 'camHUD')
    screenCenter('countdown')
    addAnimationByPrefix('countdown', 'three', 'three', 1, true)
    addAnimationByPrefix('countdown', 'two', 'two', 1, true)
    addAnimationByPrefix('countdown', 'one', 'one', 1, true)
    addAnimationByPrefix('countdown', 'go', 'go', 1, true)
    setProperty('countdown.visible', false)
    setProperty('countdown.antialiasing', false)
    addLuaSprite('countdown', true)

    if not hideHud then
        --text stuff (score and ratings)
        if not downscroll then
            makeLuaText('score_text', '', 500, 60, us_y)
            makeLuaText('acc_text', '', 500, 720, us_y)
            makeLuaText('small_acc_text', '', 500, 830, us_y + 23)
        else
            makeLuaText('score_text', '', 500, 60, ds_y)
            makeLuaText('acc_text', '', 500, 720, ds_y)
            makeLuaText('small_acc_text', '', 500, 830, ds_y + 23)
        end
        setTextFont('score_text', 'normal.ttf')
        setTextFont('acc_text', 'normal.ttf')
        setTextFont('small_acc_text', 'small.ttf')
        setTextSize('score_text', font_size)
        setTextSize('acc_text', font_size)
        setTextSize('small_acc_text', 25)
        setTextBorder('score_text', '1', getColorFromHex('FFFFFF'))
        setTextBorder('acc_text', '1', getColorFromHex('FFFFFF'))
        setTextBorder('small_acc_text', '1', getColorFromHex('FFFFFF'))
        setObjectOrder('score_text', getObjectOrder('hud') + 1)
        setObjectOrder('acc_text', getObjectOrder('hud') + 1)
        setObjectOrder('small_acc_text', getObjectOrder('hud') + 1)
        addLuaText('score_text')
        addLuaText('acc_text')
        addLuaText('small_acc_text')

        --image stuff (flags, icons and points)
        if not downscroll then
            makeAnimatedLuaSprite('flags', 'hud/flags', 795, us_y + 7)
            makeAnimatedLuaSprite('rankings', 'hud/rankings', 840, us_y + 7)
        else
            makeAnimatedLuaSprite('flags', 'hud/flags', 795, ds_y + 7)
            makeAnimatedLuaSprite('rankings', 'hud/rankings', 845, ds_y + 7)
        end
        makeAnimatedLuaSprite('points', 'hud/judgements', getProperty('boyfriend.x') - 110, 10000) --y will be calculated later

        addAnimationByPrefix('flags', 'sfc', 'sfc', 1, true)
        addAnimationByPrefix('flags', 'gfc', 'gfc', 1, true)
        addAnimationByPrefix('flags', 'fc', 'fc', 1, true)
        addAnimationByPrefix('flags', 'none', 'none', 1, true)
        setProperty('flags.antialiasing', false)
        setObjectCamera('flags', 'camHUD')
        setObjectOrder('flags', getObjectOrder('hud') + 1)
        scaleObject('flags', 0.9, 0.9)
        addLuaSprite('flags', true)

        addAnimationByPrefix('rankings', 'cross', 'cross', 1, true)
        addAnimationByPrefix('rankings', 'bowser', 'bowser', 1, true)
        addAnimationByPrefix('rankings', 'poison', 'poison', 1, true)
        addAnimationByPrefix('rankings', 'coin', 'coin', 1, true)
        addAnimationByPrefix('rankings', 'mushroom', 'mushroom', 1, true)
        addAnimationByPrefix('rankings', 'flower', 'flower', 1, true)
        addAnimationByPrefix('rankings', 'star', 'star', 1, true)
        addAnimationByPrefix('rankings', 'crown', 'you dropped this', 1, true)
        setProperty('rankings.antialiasing', false)
        setObjectCamera('rankings', 'camHUD')
        setObjectOrder('rankings', getObjectOrder('hud') + 1)
        scaleObject('rankings', 0.9, 0.9)
        addLuaSprite('rankings', true)

        addAnimationByPrefix('points', 'perfect', 'perfect', 1, true)
        addAnimationByPrefix('points', 'sick', 'sick', 1, true)
        addAnimationByPrefix('points', 'good', 'good', 1, true)
        addAnimationByPrefix('points', 'bad', 'bad', 1, true)
        addAnimationByPrefix('points', 'shit', 'shit', 1, true)
        addAnimationByPrefix('points', 'miss', 'miss', 1, true)
        setProperty('points.antialiasing', false)
        addLuaSprite('points', true)

        for i = 0, getProperty('unspawnNotes.length') - 1 do
            if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') == true then
                setPropertyFromGroup('unspawnNotes', i, 'alpha', 1)
            end
        end
    end
end

function onCountdownTick(counter)
	if counter == 0 then
        setProperty('countdown.visible', true)
        objectPlayAnimation('countdown', 'three')
    elseif counter == 1 then
        objectPlayAnimation('countdown', 'two')
    elseif counter == 2 then
        objectPlayAnimation('countdown', 'one')
    elseif counter == 3 then
        objectPlayAnimation('countdown', 'go')
    elseif counter == 4 then
        setProperty('countdown.visible', false)
    end
end

function onSongStart()
	setProperty('isCameraOnForcedPos', true)
end

function onUpdate(elapsed)
    --general ui handling (removing cam zoom and correcting note splashes)
    setProperty('camZooming', false)
	for i = 0, getProperty('grpNoteSplashes.length') - 1 do
        setPropertyFromGroup('grpNoteSplashes', i, 'offset.x', -95)
        setPropertyFromGroup('grpNoteSplashes', i, 'offset.y', -100)
    end

    if not hideHud then
        --text stuff
        setTextString('score_text', fillText(tostring(math.abs(score)), 6))
        if score < 0 then setTextColor('score_text', 'b53120') else setTextColor('score_text', 'FFFFFF') end

        acc = math.floor(rating * 100)
        setTextString('acc_text', fillText(tostring(acc), 3))

        small_acc = math.floor(rating * 10000) - (acc * 100)
        setTextString('small_acc_text', '.' .. fillText(tostring(small_acc), 2) .. '%')

        --flags
        if getProperty('ratingFC') == 'SFC' then objectPlayAnimation('flags', 'sfc')
        elseif getProperty('ratingFC') == 'GFC' then objectPlayAnimation('flags', 'gfc')
        elseif getProperty('ratingFC') == 'FC' then objectPlayAnimation('flags', 'fc')
        else objectPlayAnimation('flags', 'none')
        end

        --rankings
        if acc >= 100 then objectPlayAnimation('rankings', 'crown')
        elseif acc >= 95 then objectPlayAnimation('rankings', 'star')
        elseif acc >= 80 then objectPlayAnimation('rankings', 'flower')
        elseif acc >= 75 then objectPlayAnimation('rankings', 'mushroom')
        elseif acc >= 70 then objectPlayAnimation('rankings', 'coin')
        elseif acc >= 65 then objectPlayAnimation('rankings', 'poison')
        elseif acc >= 60 then objectPlayAnimation('rankings', 'bowser')
        else objectPlayAnimation('rankings', 'cross')
        end

        --points, check goodNoteHit noteMiss and noteMissPress for the rest
        setProperty('points.y', getProperty('points.y') - (200 * elapsed))
    end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    if not hideHud then
        if not isSustainNote then setProperty('points.y', getProperty('boyfriend.y') - 20) end

        if getPropertyFromGroup('notes', id, 'rating') == 'sick' and getProperty('ratingFC') == 'SFC' then objectPlayAnimation('points', 'perfect')
        elseif getPropertyFromGroup('notes', id, 'rating') == 'sick' then objectPlayAnimation('points', 'sick')
        elseif getPropertyFromGroup('notes', id, 'rating') == 'good' then objectPlayAnimation('points', 'good')
        elseif getPropertyFromGroup('notes', id, 'rating') == 'bad' then objectPlayAnimation('points', 'bad')
        elseif getPropertyFromGroup('notes', id, 'rating') == 'shit' then objectPlayAnimation('points', 'shit')
        end
    end
end

function noteMiss(id, noteData, noteType, isSustainNote)
    if not hideHud then
        setProperty('points.y', getProperty('boyfriend.y') - 15)
        objectPlayAnimation('points', 'miss')
    end
end

function noteMissPress(direction)
    if not hideHud then
        setProperty('points.y', getProperty('boyfriend.y') - 15)
        objectPlayAnimation('points', 'miss')
    end
end

function fillText(text, limit)
    while string.len(text) < limit do
        text = '0' .. text
    end
    return text
end