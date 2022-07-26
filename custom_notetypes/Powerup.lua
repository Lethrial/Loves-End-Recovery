function onCreatePost()
    bf_x = getProperty('boyfriend.x')
    bf_y = getProperty('boyfriend.y')
    bfsmall_y = bf_y - 4
    bfsmall_x = bf_x - 4
    power = 3
    invincible = false
    addCharacterToList('bf-small', 'boyfriend')
	addCharacterToList('bf', 'boyfriend')
end

function onUpdate(elapsed)
    if power > 0 then 
        setProperty('health', 2)
    else
        setProperty('health', 0)
    end

    for i = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Powerup' then
            if power == 3 then 
                setPropertyFromGroup('unspawnNotes', i, 'texture', 'NOTE_assets')
            elseif power == 2 then
                setPropertyFromGroup('unspawnNotes', i, 'texture', 'flower')
            elseif power == 1 then
                setPropertyFromGroup('unspawnNotes', i, 'texture', 'shroom')
            end
		end
	end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    if getPropertyFromGroup('notes', id, 'rating') == 'shit' then
        doBetter()
    elseif noteType == 'Powerup' then
        if power == 2 then
            triggerEvent('Change Character', 0, 'bf-fire')
            playSound('powerup')
            power = power + 1
        elseif power == 1 then
            triggerEvent('Change Character', 0, 'bf')
            playSound('powerup')
            power = power + 1
        end
        setProperty('boyfriend.x', bf_x)
        setProperty('boyfriend.y', bf_y)
    end
end

function noteMiss(id, noteData, noteType, isSustainNote)
	doBetter()
end

function noteMissPress(direction)
    doBetter()
end

function doBetter()
    if not invincible then
        if power == 3 then
            triggerEvent('Change Character', 0, 'bf')
            playSound('powerdown')
            setProperty('boyfriend.x', bf_x)
            setProperty('boyfriend.y', bf_y)
        elseif power == 2 then
            triggerEvent('Change Character', 0, 'bf-small')
            playSound('powerdown')
            setProperty('boyfriend.x', bfsmall_x)
            setProperty('boyfriend.y', bfsmall_y)
        end
        power = power - 1
        runTimer('iframes', 0.1, 25) --iframes last for 2.5 seconds
        invincible = true
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'iframes' then
        if loopsLeft > 0 then
            if flashingLights then
                if loopsLeft % 2 == 1 then
                    setProperty('boyfriend.alpha', 0) --using alpha instead of visible so it doesn't clash with the jump
                elseif loopsLeft % 2 == 0 then
                    setProperty('boyfriend.alpha', 1)
                end
            else
                setProperty('boyfriend.alpha', 0.4) --stops bf from flashing if flashing lights is off
            end
        elseif loopsLeft == 0 then
            setProperty('boyfriend.alpha', 1)
            invincible = false
        end
    end
end