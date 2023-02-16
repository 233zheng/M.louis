-- NOTE: debugcommands
GLOBAL.setfenv(1, GLOBAL)

function c_allkatana()
    c_give("hitokiri")
    c_give("shirasaya")
    c_give("raikiri")
    c_give("koshirae")
end

function c_allkatana2()
    c_give("hitokiri2")
    c_give("shirasaya2")
    c_give("raikiri2")
    c_give("koshirae2")
end

function c_mindpower(num)
    local player = ConsoleCommandPlayer()
    if player.prefab == "manutsawee" then
        player.mindpower = num or 30
        player.components.talker:Say("Mindpower" .. player.mindpower)
    end
end
