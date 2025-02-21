-- Подключаем OrionLib
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()

-- Получаем сервисы
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local plr = game.Players.LocalPlayer.Name
-- Создаем окно GUI
local Window = OrionLib:MakeWindow({
    Name = "14 y.o Talent",
    IntroEnabled = true,
    IntroText = "by @LostAllFriends",
    IntroIcon = "rbxassetid://7229442422",
    SaveConfig = true,
    ConfigFolder = "OrionTest"
})

-- Создаем вкладку "Main"
local mainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://7229442422"
})

-- Переменная для хранения состояния тоггла
local enabled = false
local enabled2 = false

mainTab:AddToggle({
    Name = "Auto Sprout",
    Default = false,
    Callback = function(value)
        enabled = value
        while enabled do
            local playerPosition1 = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            
            local tokenF = game.Workspace.ServerTokens
            local token2 = tokenF:GetChildren()
            for _, tokena in ipairs(token2) do
                if tokena:IsA("Part") then
                    if not enabled then break end-- Останавливаем цикл, если переключатель выключен
                    tokena.CFrame = playerPosition1 -- Перемещаем токен к игроку
                    wait(0.00001)  -- Небольшая задержка между перемещениями
                end
            end
            wait(0.00001)  -- Небольшая задержка перед повторным циклом
        end
    end
})

mainTab:AddToggle({
    Name = "Auto Tokens",
    Default = false,
    Callback = function(value)
        enabled2 = value
        while enabled2 do
            local playerPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            
            local tokenp = game.Workspace.Tokens:FindFirstChild(plr)
            local tokenp2 = tokenp:GetChildren()
            for _, token in ipairs(tokenp2) do
                if not enabled2 then break end -- Останавливаем цикл, если переключатель выключен
                token.CFrame = playerPosition -- Перемещаем токен к игроку
                wait(0.00001)  -- Небольшая задержка между перемещениями
            end
            wait(0.00001)  -- Небольшая задержка перед повторным циклом
        end
    end
})
local safetyenabled = false
local plr = game.Players.LocalPlayer.Name
mainTab:AddToggle({
    Name = "Safety from monsters",
    Default = false,
    Callback = function(value)
        safetyenabled = value
        while safetyenabled do
            local playerMonsters = game.Workspace.PlayerMonsters:FindFirstChild(plr)
            local serverEffects = game.Workspace.ServerEffects
            
            if playerMonsters then
                for _, monster in ipairs(playerMonsters:GetChildren()) do
                    if monster:IsA("Model") then
                        monster:Destroy()
                    end
                end
            end
            
            if serverEffects then
                for _, poison in ipairs(serverEffects:GetChildren()) do
                    poison:Destroy()
                end
            end
            
            wait(0.001)  -- Увеличиваем интервал для снижения нагрузки
        end
    end
})
local currentSpeed = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed
local speedLockEnabled = false
mainTab:AddToggle({
    Name = "Lock Speed",
    Default = false,
    Callback = function(value)
        speedLockEnabled = value
        if speedLockEnabled then
            currentSpeed = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed
            while speedLockEnabled do
                local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.WalkSpeed ~= currentSpeed then
                    humanoid.WalkSpeed = currentSpeed
                end
                wait(0.1)  -- Проверяем и корректируем скорость каждые 0.1 секунды
            end
        end
    end
})
mainTab:AddTextbox({
    Name = "Set Player Speed",
    Default = "16",  -- Значение по умолчанию (стандартная скорость в Roblox)
    TextDisappear = true,
    Callback = function(value)
        local speed = tonumber(value)
        if speed and speed >= 0 then
            local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = speed
            end
        else
            OrionLib:MakeNotification({
                Name = "Ошибка",
                Content = "Введите корректное число (скорость не может быть отрицательной).",
                Time = 5
            })
        end
    end
})

local fields = game.Workspace.FieldZones:GetChildren()
local fieldNames = {}

for _, field in ipairs(fields) do
    table.insert(fieldNames, field.Name)
end


local fieldTP = mainTab:AddDropdown({
    Name = "Select Field",
    Default = "Choose a field",
    Options = fieldNames,
    Callback = function(selectedField)
        local field = game.Workspace.FieldZones:FindFirstChild(selectedField)
        fieldBox = field
    end    
})

mainTab:AddBind({
    Name = "Tp to Field",
    Default = Enum.KeyCode.X,
    Hold = false,
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = fieldBox.CFrame
    end
})
OrionLib:Init()
