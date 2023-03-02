-- I separated most of the code in modmain
-- And I refactored a lot of code
-- Make the code more readable
-- compatible with island adventure

-- Sets the environment to be used by the given function.
-- GLOBAL.setfenv(1, GLOBAL)

local modimport = modimport

-- Import the engine.
modimport("engine.lua")

-- Imports to keep the keyhandler from working while typing in chat.
Load "chatinputscreen"
Load "consolescreen"
Load "textedit"

modimport("main/config")
modimport("main/assets")
modimport("main/atlas_build")
modimport("main/fx")
modimport("main/tuning")
modimport("main/postinit")
modimport("main/manutsaweeskin")
modimport("main/recipes")
modimport("main/containers")
modimport("main/commands")
modimport("main/constants")
modimport("main/characters")
modimport("main/strings")
modimport("main/manutsawee_strings")
modimport("main/rpc")
