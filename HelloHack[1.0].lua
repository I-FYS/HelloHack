script_name("HelloHack")
script_author("I_FYS")

require "lib.moonloader"
local imgui = require "imgui"
local encoding = require "encoding"
local memory = require "memory"
local font_flag = require('moonloader').font_flag
local my_font = renderCreateFont('Arial', 10, font_flag.BOLD + font_flag.SHADOW)
local main_window_state = imgui.ImBool(false)
local Pressed = imgui.ImBool(false)
local InfAmmo = imgui.ImBool(false)
local spread = imgui.ImBool(false)
local noFall = imgui.ImBool(false)
local fastWalk = imgui.ImBool(false)
local fastDeagle = imgui.ImBool(false)
local InfRun = imgui.ImBool(false)
local MegaJump = imgui.ImBool(false)
local AntiStun = imgui.ImBool(false)
local objectColl = imgui.ImBool(false)
local CarGM = imgui.ImBool(false)
local CarColl = imgui.ImBool(false)
local EasyDrive = imgui.ImBool(false)
local CarShot = imgui.ImBool(false)
Anims = {'WALK_PLAYER', 'GUNCROUCHFWD', 'GUNCROUCHBWD', 'GUNMOVE_BWD', 'GUNMOVE_FWD', 'GUNMOVE_L', 'GUNMOVE_R', 'RUN_GANG1', 'JOG_FEMALEA', 'JOG_MALEA', 'RUN_CIVI', 'RUN_CSAW', 'RUN_FAT', 'RUN_FATOLD', 'RUN_OLD', 'RUN_ROCKET', 'RUN_WUZI', 'SPRINT_WUZI', 'WALK_ARMED', 'WALK_CIVI', 'WALK_CSAW', 'WALK_DRUNK', 'WALK_FAT', 'WALK_FATOLD', 'WALK_GANG1', 'WALK_GANG2', 'WALK_OLD', 'WALK_SHUFFLE', 'WALK_START', 'WALK_START_ARMED', 'WALK_START_CSAW', 'WALK_START_ROCKET', 'WALK_WUZI', 'WOMAN_WALKBUSY', 'WOMAN_WALKFATOLD', 'WOMAN_WALKNORM', 'WOMAN_WALKOLD', 'WOMAN_RUNFATOLD', 'WOMAN_WALKPRO', 'WOMAN_WALKSEXY', 'WOMAN_WALKSHOP', 'RUN_1ARMED', 'RUN_ARMED', 'RUN_PLAYER', 'WALK_ROCKET', 'CLIMB_IDLE', 'MUSCLESPRINT', 'CLIMB_PULL', 'CLIMB_STAND', 'CLIMB_STAND_FINISH', 'SWIM_BREAST', 'SWIM_CRAWL', 'SWIM_DIVE_UNDER', 'SWIM_GLIDE', 'MUSCLERUN', 'WOMAN_RUN', 'WOMAN_RUNBUSY', 'WOMAN_RUNPANIC', 'WOMAN_RUNSEXY', 'SPRINT_CIVI', 'SPRINT_PANIC', 'SWAT_RUN', 'FATSPRINT'}
GunAnims = {'PYTHON_CROUCHFIRE', 'PYTHON_FIRE', 'PYTHON_FIRE_POOR'}
encoding.default = 'CP1251'
u8 = encoding.UTF8

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    sampRegisterChatCommand("hh", hh_cmd)
    imgui.Process = false
    spreadval = memory.getfloat(0x8D2E64)

    while true do
        wait(0)
        local _, my_info = sampGetPlayerIdByCharHandle(PLAYER_PED)
        local nick = sampGetPlayerNickname(my_info)
        local model = getCharModel(PLAYER_PED)
        local hp = sampGetPlayerHealth(my_info)
        local armour = sampGetPlayerArmor(my_info)
        local score = sampGetPlayerScore(my_info)
        local ping = sampGetPlayerPing(my_info)
        local framerate = memory.getfloat(0xB7CB50, true)
        renderDrawBox(0, 300, 160, 200, 0xe2000000)
        renderFontDrawText(my_font, ' =_ [HelloHack] _=', 5, 305, 0xFFFF0000)
        renderFontDrawText(my_font, 'Nick: '.. nick .. ' [' .. my_info .. ']', 5, 325, 0xFF00FF00)
        renderFontDrawText(my_font, 'S - ['..model..'] H - ['..hp..'] A - ['..armour..']', 5, 345, 0xFF00FF00)
        renderFontDrawText(my_font, 'Score - ['..score..'] Ping - ['..ping..']', 5, 365, 0xFF00FF00)
        renderFontDrawText(my_font, 'FPS - ['..framerate..']', 5, 385, 0xFF00FF00)
        renderFontDrawText(my_font, 'Script version - 1.0', 5, 480, 0xFF00FF00)
        if main_window_state.v == false then
            imgui.Process = false
        end
    end
end

function hh_cmd()
    main_window_state.v = not main_window_state.v
	imgui.Process = main_window_state.v
end

function imgui.OnDrawFrame()
	imgui.SetNextWindowSize(imgui.ImVec2(200, 300), imgui.Cond.FirstUseEver)
    imgui.Begin("HelloHack || 1.0", main_window_state)
    if imgui.CollapsingHeader("Player cheats") then
        if imgui.Checkbox("GM", Pressed) then
            if Pressed.v then
                setCharProofs(PLAYER_PED, true, true, true, true, true)
            elseif not Pressed.v then
                setCharProofs(PLAYER_PED, false, false, false, false, false)
            end
        end
        if imgui.Checkbox("Infinite Ammo", InfAmmo) then
            if InfAmmo.v then
                memory.write(0x969178, 1, 1, true)
            elseif not InfAmmo.v then
                memory.write(0x969178, 0, 1, true)
            end
        end
        if imgui.Checkbox("No Spread", spread) then
            if spread.v then
                memory.setfloat(0x8D2E64, 0)
            elseif not spread.v then
                memory.setfloat(0x8D2E64, spreadval)
            end
        end
        if imgui.Checkbox("No Fall", noFall) then
            if noFall.v then
                lua_thread.create(function()
                    while true do
                        wait(0)
                        if isCharPlayingAnim(PLAYER_PED, 'KO_SKID_BACK') or isCharPlayingAnim(playerPed, 'FALL_COLLAPSE') then
                            local x, y, z = getCharCoordinates(PLAYER_PED)
                            setCharCoordinates(PLAYER_PED, x, y, z - 1)
                        end
                    end
                end)
            end
        end
        if imgui.Checkbox("FastWalk", fastWalk) then
            if fastWalk.v then
                lua_thread.create(function()
                    while true do
                        wait(0)
                        for k,v in pairs(Anims) do
                            setCharAnimSpeed(PLAYER_PED, v, 5.0)
                            setPlayerNeverGetsTired(playerHandle, 0)
                        end
                    end
                end)
				setPlayerNeverGetsTired(playerHandle, 1)
            elseif not fastWalk.v then
                lua_thread.create(function()
                    while true do
                        wait(0)
                        for k,v in pairs(Anims) do setCharAnimSpeed(PLAYER_PED, v, 1.0) end
                        setPlayerNeverGetsTired(playerHandle, 1)
                    end
                end)
            end
        end
        if imgui.Checkbox("Fast Deagle", fastDeagle) then
            if fastDeagle.v then
                lua_thread.create(function()
                    while true do
                        wait(0)
                        for k,g in pairs(GunAnims) do
                            setCharAnimSpeed(PLAYER_PED, g, 3.0)
                        end
                    end
                end)
            elseif not fastDeagle.v then
                lua_thread.create(function()
                    while true do
                        wait(0)
                        for k,g in pairs(GunAnims) do
                            setCharAnimSpeed(PLAYER_PED, g, 1.0)
                        end
                    end
                end)
            end
        end
        if imgui.Checkbox("Mega Jump", MegaJump) then
            if MegaJump.v then
                memory.setint8(0x96916C, 1)
            elseif not MegaJump.v then
                memory.setint8(0x96916C, 0)
            end
        end
        if imgui.Checkbox("Infinite Run", InfRun) then
            if InfRun.v then
                setPlayerNeverGetsTired(playerHandle, 0)
            elseif not InfRun.v then
                setPlayerNeverGetsTired(playerHandle, 1)
            end
        end
        if imgui.Checkbox("Anti Stun", AntiStun) then
            if AntiStun.v then
                setCharUsesUpperbodyDamageAnimsOnly(PLAYER_PED, 1)
            elseif not AntiStun.v then
                setCharUsesUpperbodyDamageAnimsOnly(PLAYER_PED, 0)
            end
        end
        if imgui.Checkbox("Object collision", objectColl) then
            if objectColl.v then
                lua_thread.create(function()
                    while true do
                        wait(0)
                        local meposX, meposY, meposZ = getCharCoordinates(PLAYER_PED)
                        local _, find_obj = findAllRandomObjectsInSphere(meposX, meposY, meposZ, 100, 1)
                        setObjectCollision(find_obj, 0)
                    end
                end)
            elseif not objectColl.v then
            end
        end
        if imgui.Button("Save player position") then
            posX, posY, posZ = getCharCoordinates(PLAYER_PED)
            sampAddChatMessage("Player position saved", -1)
            sampAddChatMessage("posX - " .. posX .. " posY - " .. posY .. " posZ - " .. posZ, -1)
        end
        imgui.SameLine()
        if imgui.Button("Teleport to save position") then
            sampAddChatMessage("Teleported!", -1)
            setCharCoordinates(PLAYER_PED, posX, posY, posZ)
        end
    end
    if imgui.CollapsingHeader("Vehicle cheats") then
        if imgui.Checkbox("GM Car", CarGM) then
            if CarGM.v then
                if isCharInAnyCar(PLAYER_PED) then
                    local vehi = storeCarCharIsInNoSave(PLAYER_PED)
                    setCarProofs(vehi, true, true, true, true, true)
                else
                    sampAddChatMessage("First, enter to vehicle", -1)
                    CarGM.v = not CarGM.v
                end
            elseif not CarGM.v then
                if isCharInAnyCar(PLAYER_PED) then
                    local vehi = storeCarCharIsInNoSave(PLAYER_PED)
                    setCarProofs(vehi, false, false, false, false, false)
                else
                    sampAddChatMessage("WTF, ENTER TO VEHICLE!", -1)
                    CarGM.v = not CarGM.v
                end
            end
        end
        if imgui.Checkbox("Collision car", CarColl) then
            if isCharInAnyCar(PLAYER_PED) then
                local carhandle = storeCarCharIsInNoSave(PLAYER_PED)
                if CarColl.v then
                    setCarCollision(carhandle, true)
                elseif CarColl.v then
                    setCarCollision(carhandle, false)
                end
            else
                sampAddChatMessage("Enter to vehicle", -1)
                CarColl.v = false
            end
        end
        if imgui.Checkbox("Easy Drive", EasyDrive) then
            if EasyDrive.v then
                memory.setint8(0x96914C, 1)
            elseif not EasyDrive.v then
                memory.setint8(0x96914C, 0)
            end
        end
        if imgui.Checkbox("CarShot", CarShot) then
            if isCharInAnyCar(PLAYER_PED) then
                if CarShot.v then
                    lua_thread.create(function()
                        while true do
                            wait(0)
                            local camCoordX, camCoordY, camCoordZ = getActiveCameraCoordinates()
                            local targetCamX, targetCamY, targetCamZ = getActiveCameraPointAt()
                            setCarHeading(storeCarCharIsInNoSave(PLAYER_PED), getHeadingFromVector2d(targetCamX - camCoordX, targetCamY - camCoordY))
                            if isKeyDown(VK_W) then setCarForwardSpeed(storeCarCharIsInNoSave(PLAYER_PED), 100.0)
                            elseif isKeyDown(VK_S) then setCarForwardSpeed(storeCarCharIsInNoSave(playerPed), 0.0) end
                        end
                    end)
                elseif not CarShot.v then
                    setCarForwardSpeed(storeCarCharIsInNoSave(playerPed), 0.0)
                end
            else
                sampAddChatMessage("Enter to vehicle!", -1)
                CarShot.v = not CarShot.v
            end
        end
    end
    imgui.End()
end

function apply_custom_style()
    
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    style.WindowPadding = ImVec2(15, 15)
    style.WindowRounding = 5.0
    style.FramePadding = ImVec2(5, 5)
    style.FrameRounding = 4.0
    style.ItemSpacing = ImVec2(12, 8)
    style.ItemInnerSpacing = ImVec2(8, 6)
    style.IndentSpacing = 25.0
    style.ScrollbarSize = 15.0
    style.ScrollbarRounding = 9.0
    style.GrabMinSize = 5.0
    style.GrabRounding = 3.0

    colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
    colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
    colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
    colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
    colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
    colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.TitleBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
    colors[clr.TitleBgActive] = ImVec4(0.07, 0.07, 0.09, 1.00)
    colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
    colors[clr.CheckMark] = ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.SliderGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.SliderGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
    colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
    colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
    colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
    colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
    colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
    colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
    colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
    colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end
apply_custom_style()