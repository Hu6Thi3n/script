-- Cấu hình máy chủ
local WebserverSettings = {
    Port = '2024',
    Password = ''  -- Đặt mật khẩu nếu có
}

-- Chọn Request phù hợp dựa trên môi trường
local Request = (syn and syn.request) or request or (http and http.request) or http_request
local HttpService = game:GetService("HttpService")

-- Chức năng gỡ lỗi
local function debugLog(message)
    print(message)  -- Hoặc ghi vào file log nếu cần
end

-- Hàm gửi tin nhắn đến máy chủ
local function sendMessageToServer(data)
    local Url = 'http://103.176.24.132:' .. WebserverSettings.Port .. '/sendMessage'
    debugLog("Constructed URL: " .. Url)

    if WebserverSettings.Password and #WebserverSettings.Password >= 6 then
        Url = Url .. '?Password=' .. WebserverSettings.Password
        debugLog("Password added to the URL.")
    end

    local jsonData = HttpService:JSONEncode(data)  -- Chuyển đổi bảng Lua thành JSON

    local Response = Request {
        Method = 'POST',
        Url = Url,
        Headers = {
            ['Content-Type'] = 'application/json',  -- Đặt loại nội dung là JSON
        },
        Body = jsonData,  -- Gửi dữ liệu JSON
    }

    debugLog("Server Response Status: " .. Response.StatusCode)
    if Response.StatusCode ~= 200 then 
        debugLog("Failed to send the message. Server responded with: " .. Response.Body)
        return false 
    end

    debugLog("Message sent successfully!")
    return Response.Body
end

-- Đợi game và các thành phần cần thiết tải xong
repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer and game:IsLoaded()
repeat wait() until game.Players.LocalPlayer.Character
repeat wait() until game:GetService("Players").LocalPlayer:FindFirstChild("DataLoaded")
repeat wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")

-- Chọn đội
repeat wait() until game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("Main"):FindFirstChild("ChooseTeam")
local function chooseTeam()
    local v99 = game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam
    local v52 = v99.Container.Pirates.Frame.TextButton
    local v123 = v99.Container.Marines.Frame.TextButton

    if string.find(getgenv().ChooseTeam, "Pirate") then
        for _, connection in pairs(getconnections(v52.Activated)) do
            connection.Function()
        end
    elseif string.find(getgenv().ChooseTeam, "Marine") then
        for _, connection in pairs(getconnections(v123.Activated)) do
            connection.Function()
        end
    else
        for _, connection in pairs(getconnections(v52.Activated)) do
            connection.Function()
        end
    end
end

chooseTeam()

-- Hàm kiểm tra và lấy thông tin từ game
local function k123()
    local v113 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
    local v111 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "1")

    if game.Players.LocalPlayer.Character:FindFirstChild("RaceTransformed") then
        return game.Players.LocalPlayer.Data.Race.Value .. "-V4"
    end
    if v113 == -2 then
        return game.Players.LocalPlayer.Data.Race.Value .. "-V3"
    end
    if v111 == -2 then
        return game.Players.LocalPlayer.Data.Race.Value .. "-V2"
    end
    return game.Players.LocalPlayer.Data.Race.Value .. " V1"
end

local function k34()
    local v99 = {}
    local v100 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("getAwakenedAbilities")
    if v100 then
        for _, k90 in pairs(v100) do
            wait()
            if k90.Awakened then
                table.insert(v99, k90.Key)
            end
        end
    end
    return table.concat(v99, ", ")
end

local function j99()
    local v231 = {"Superhuman", "ElectricClaw", "DragonTalon", "SharkmanKarate", "DeathStep", "Godhuman", "SanguineArt"}
    local k98 = ""

    for _, v11 in pairs(v231) do
        if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Buy" .. v11, true) == 1 then
            k98 = k98 .. v11 .. ", "
        end
    end

    return k98
end

local function v908(k111)
    local a = ""
    local ddd = game.ReplicatedStorage.Remotes.CommF_
    local tuoi = ddd:InvokeServer("getInventory")
    if tuoi then
        for _, v in pairs(tuoi) do
            wait()
            if v.Rarity >= 3 and v.Type == k111 then
                a = a .. v.Name .. ", "
            end
        end
    end
    return a
end

local function v999()
    local a = ""
    local ddd = game.ReplicatedStorage.Remotes.CommF_
    local tuoi = ddd:InvokeServer("getInventory")
    if tuoi then
        for _, v in pairs(tuoi) do
            if v.Rarity >= 2 and v.Type == "Material" then
                if a ~= "" then
                    a = a .. ", "
                end
                a = a .. v.Name .. ": " .. v.Count
            end
        end
    end
    return a
end

local function CheckTrainSS()
    local InvokeServer_ret1_9, InvokeServer_ret2_9 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("UpgradeRace", "Check")
    if InvokeServer_ret1_9 == 8 then
        return tostring(10 - InvokeServer_ret2_9)
    else
        return "0"
    end
end

local function CheckPullLever()
    return game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CheckTempleDoor") and "yes" or "no"
end

local function CheckGears2()
    local gay = 0
    for i, v in pairs(game.Players.LocalPlayer.Data.Race:GetChildren()) do
        pcall(function()
            if v.Value > gay then
                gay = v.Value
            end
        end)
    end
    return tostring(gay)
end

local function CheckGear()
    if not game.Players.LocalPlayer.Character:FindFirstChild("RaceTransformed") then
        return "No Gear"
    end
    local InvokeServer_ret1_9, InvokeServer_ret2_9, InvokeServer_ret3_3 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("UpgradeRace", "Check")
    local gay = {
        "Required Train More",
        InvokeServer_ret3_3 and "Can Buy Gear With " .. InvokeServer_ret3_3 .. " Fragments" or "gay",
        "Required Train More",
        InvokeServer_ret3_3 and "Can Buy Gear With " .. InvokeServer_ret3_3 .. " Fragments" or "gay",
        "Full Gear, Full 5 Training Sessions (Full Update)",
        InvokeServer_ret2_9 and "Gear 3, Upgrade completed: " .. InvokeServer_ret2_9 - 2 .. "/3, Need Trains More" or "gay",
        InvokeServer_ret3_3 and "Can Buy Gear With " .. InvokeServer_ret3_3 .. " Fragments" or "gay",
        InvokeServer_ret2_9 and "Full Gear, Remaining: " .. 10 - InvokeServer_ret2_9 .. "/3, Training Sessions" or "gay",
    }
    if gay[InvokeServer_ret1_9] then
        return gay[InvokeServer_ret1_9]
    else
        if InvokeServer_ret1_9 == 0 then
            return "Ready For Trial"
        else
            return "No Gear"
        end
    end
    return gay[8]
end

local function tuoiiiii()
    local data1 = {}
    local data2 = {}
    local data3 = {}
    local data4 = {}

    local LocalPlayer = game.Players.LocalPlayer

    -- Dữ liệu cơ bản
    data1["Player Name"] = LocalPlayer.Name
    data1["Level"] = tostring(LocalPlayer.Data.Level.Value):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
    data1["Beli"] = tostring(LocalPlayer.Data.Beli.Value):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
    data1["Frag"] = tostring(LocalPlayer.Data.Fragments.Value):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
    data1["Race"] = k123()
    data1["Devil FRUIT"] = tostring(LocalPlayer.Data.DevilFruit.Value)
    data1["Bounty/Honor"] = tostring(LocalPlayer.leaderstats["Bounty/Honor"].Value):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")

    -- Dữ liệu về khả năng và gear
    data2["Awakened Skills"] = k34()
    data2["Melee(s)"] = j99()
    data2["Sword(s)"] = v908("Sword")
    data2["Gun(s)"] = v908("Gun")
    data2["Accessory(s)"] = v908("Wear")

    -- Dữ liệu về vật phẩm và kiểm tra
    data3["Fruit(s)"] = v908("Blox Fruit")
    data3["Materials(s)"] = v999()
    data3["TrainSS"] = CheckTrainSS()
    data3["PullLever"] = CheckPullLever()
    data3["Trial"] = CheckGear()
    local placeId = game.PlaceId
    if placeId == 2753915549 then
        data4["Sea"] = "Sea 1"
    elseif placeId == 4442272183 then
        data4["Sea"] = "Sea 2"
    elseif placeId == 7449423635 then
        data4["Sea"] = "Sea 3"
    else
        data4["Sea"] = "Unknown"
    end
    -- New fields using getgenv()
    data4["Key"] = getgenv().Key or ""
    data4["Note"] = getgenv().Note or ""

    -- Gửi thông tin người chơi

    return data
end
while true do
	local LocalPlayer = game.Players.LocalPlayer
	local playerData = {
	    Username = LocalPlayer.Name,
	    PlayerInfo = tuoiiiii()  -- hoặc dữ liệu khác bạn muốn gửi
	}
	debugLog("Sending player data to the server.")
    sendMessageToServer({
        data1 = data1,
        data2 = data2,
        data3 = data3,
        data4 = data4
    })
    wait(15)
end