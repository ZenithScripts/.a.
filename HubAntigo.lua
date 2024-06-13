local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Zenith Hub | BETA",
    SubTitle = "by Guizx.7",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

local Tabs = {
    Home = Window:AddTab({ Title = "Home", Icon = "home" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "moon" }),
    Mods = Window:AddTab({ Title = "Gun Mods", Icon = "wrench" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "hammer" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}


local Options = Fluent.Options

    Tabs.Home:AddParagraph({
        Title = "ChangeLog",
        Content = "\n+ Adicionado Novo HUB!"
    })

    --// Aimbot TAB: Combat

    local RandomCool = false
local r = "Head"

local Aimbot = {
    Enabled = false,
    On = false,
    PredictionVelocity = 100,
    Random = false,
    Height = 0,
    AimlockToggleKey = Enum.KeyCode.E,
    HitPart = "Head",
    Hits = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "RightUpperLeg", "LeftUpperLeg"}
}

local ToggleAimbot = Tabs.Combat:AddToggle("AimbotToggle", {Title = "Aimbot", Default = Aimbot.Enabled})

ToggleAimbot:OnChanged(function()
    Aimbot.Enabled = ToggleAimbot.Value

    if Aimbot.Enabled then
        RAim = game:GetService("RunService").RenderStepped:Connect(function()
            pcall(function()
                if Aimbot.Enabled and Aimbot.On and AimlockTarget and AimlockTarget.Character and AimlockTarget.Character:FindFirstChild(Aimbot.HitPart) then
                    if Aimbot.PredictionVelocity == 100 then
                        game:GetService("Workspace").CurrentCamera.CFrame = CFrame.new(
                            game:GetService("Workspace").CurrentCamera.CFrame.p, 
                            AimlockTarget.Character[Aimbot.HitPart].Position + Vector3.new(0, Aimbot.Height, 0)
                        )
                    elseif not Aimbot.Random then
                        game:GetService("Workspace").CurrentCamera.CFrame = CFrame.new(
                            game:GetService("Workspace").CurrentCamera.CFrame.p, 
                            AimlockTarget.Character[Aimbot.HitPart].Position + Vector3.new(0, Aimbot.Height, 0) + 
                            AimlockTarget.Character[Aimbot.HitPart].Velocity / Aimbot.PredictionVelocity
                        )
                    elseif not RandomCool then
                        r = Aimbot.Hits[math.random(1, #Aimbot.Hits)]
                        if AimlockTarget.Character:FindFirstChild(r) then
                            RandomCool = true
                            wait(0.5)
                            RandomCool = false
                        end
                    else
                        game:GetService("Workspace").CurrentCamera.CFrame = CFrame.new(
                            game:GetService("Workspace").CurrentCamera.CFrame.p, 
                            AimlockTarget.Character[r].Position + Vector3.new(0, Aimbot.Height, 0) + 
                            AimlockTarget.Character[Aimbot.HitPart].Velocity / Aimbot.PredictionVelocity
                        )
                    end
                end
            end)
        end)
    elseif not Aimbot.Enabled and RAim then
        RAim:Disconnect()
        RAim = nil
    end
end)

ToggleAimbot:SetValue(Aimbot.Enabled)

local SliderPrediction = Tabs.Combat:AddSlider("AimbotPredictionSlider", {
    Title = "Aimbot Prediction [100 = No Prediction]",
    Description = "Adjust the aimbot prediction velocity",
    Default = Aimbot.PredictionVelocity,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Callback = function(value)
        Aimbot.PredictionVelocity = value
    end
})

SliderPrediction:OnChanged(function(value)
    Aimbot.PredictionVelocity = value
end)

SliderPrediction:SetValue(Aimbot.PredictionVelocity)

local ToggleRandomize = Tabs.Combat:AddToggle("AimbotRandomizeToggle", {Title = "Aimbot Randomize", Default = Aimbot.Random})

ToggleRandomize:OnChanged(function()
    Aimbot.Random = ToggleRandomize.Value
end)

ToggleRandomize:SetValue(Aimbot.Random)

local SliderHeight = Tabs.Combat:AddSlider("AimbotHeightSlider", {
    Title = "Aimbot Height [Adjust Target Height, Useful For Distance]",
    Description = "Adjust the aimbot target height",
    Default = Aimbot.Height * 10,
    Min = 0,
    Max = 20,
    Rounding = 1,
    Callback = function(value)
        Aimbot.Height = value / 10
    end
})

SliderHeight:OnChanged(function(value)
    Aimbot.Height = value / 10
end)

SliderHeight:SetValue(Aimbot.Height * 10)

local DropdownToggleKey = Tabs.Combat:AddDropdown("AimbotToggleKeyDropdown", {
    Title = "Toggle Key [E Is Default Trigger]",
    Values = {"X", "C", "F", "E", "G", "Q", "LeftControl"},
    Multi = false,
    Default = "E",
    Callback = function(value)
        local keyMap = {
            X = Enum.KeyCode.X,
            C = Enum.KeyCode.C,
            F = Enum.KeyCode.F,
            E = Enum.KeyCode.E,
            G = Enum.KeyCode.G,
            Q = Enum.KeyCode.Q,
            LeftControl = Enum.KeyCode.LeftControl
        }
        Aimbot.AimlockToggleKey = keyMap[value]
    end
})

DropdownToggleKey:OnChanged(function(value)
    local keyMap = {
        X = Enum.KeyCode.X,
        C = Enum.KeyCode.C,
        F = Enum.KeyCode.F,
        E = Enum.KeyCode.E,
        G = Enum.KeyCode.G,
        Q = Enum.KeyCode.Q,
        LeftControl = Enum.KeyCode.LeftControl
    }
    Aimbot.AimlockToggleKey = keyMap[value]
end)

DropdownToggleKey:SetValue("E")

local DropdownAimPart = Tabs.Combat:AddDropdown("AimbotAimPartDropdown", {
    Title = "Aim Part",
    Values = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "RightUpperLeg", "LeftUpperLeg"},
    Multi = false,
    Default = "Head",
    Callback = function(value)
        local partMap = {
            Head = "Head",
            HumanoidRootPart = "HumanoidRootPart",
            UpperTorso = "UpperTorso",
            LowerTorso = "LowerTorso",
            RightUpperLeg = "RightUpperLeg",
            LeftUpperLeg = "LeftUpperLeg"
        }
        Aimbot.HitPart = partMap[value]
    end
})

DropdownAimPart:OnChanged(function(value)
    local partMap = {
        Head = "Head",
        HumanoidRootPart = "HumanoidRootPart",
        UpperTorso = "UpperTorso",
        LowerTorso = "LowerTorso",
        RightUpperLeg = "RightUpperLeg",
        LeftUpperLeg = "LeftUpperLeg"
    }
    Aimbot.HitPart = partMap[value]
end)

DropdownAimPart:SetValue("Head")

--// HitboxExpander TAB: Combat

--// detected


--// ESP TAB: Visuals

local ESP = {
    Enabled = true,
    Boxes = true,
    Tracers = true,
    BoxShift = CFrame.new(0, -1.5, 0),
    BoxSize = Vector3.new(4, 6, 0),
    Color = Color3.fromRGB(255,255,255),
    FaceCamera = true,
    Names = true,
    DistanceESP = true,
    TeamColor = true,
    Thickness = 2,
    AttachShift = 1,
    TeamMates = true,
    Players = true,
    Friends = true,
    DistanceSize = 14,
    NameSize = 13,
    Objects = setmetatable({}, { __mode = "kv" }),
    Overrides = {}
}

local cam = workspace.CurrentCamera
local plrs = game:GetService("Players")
local plr = plrs.LocalPlayer
local mouse = plr:GetMouse()

local V3new = Vector3.new
local WorldToViewportPoint = cam.WorldToViewportPoint

-- Functions
local function Draw(obj, props)
    local new = Drawing.new(obj)
    props = props or {}
    for i, v in pairs(props) do
        new[i] = v
    end
    return new
end

function ESP:GetTeam(p)
    local ov = self.Overrides.GetTeam
    if ov then
        return ov(p)
    end
    return p and p.Team
end

function ESP:IsTeamMate(p)
    local ov = self.Overrides.IsTeamMate
    if ov then
        return ov(p)
    end
    return self:GetTeam(p) == self:GetTeam(plr)
end

function ESP:GetColor(obj)
    local ov = self.Overrides.GetColor
    if ov then
        return ov(obj)
    end
    local p = self:GetPlrFromChar(obj)
    return p and self.TeamColor and p.Team and p.Team.TeamColor.Color or self.Color
end

function ESP:GetPlrFromChar(char)
    local ov = self.Overrides.GetPlrFromChar
    if ov then
        return ov(char)
    end
    return plrs:GetPlayerFromCharacter(char)
end

function ESP:Toggle(bool)
    self.Enabled = bool
    if not bool then
        for i, v in pairs(self.Objects) do
            if v.Type == "Box" then -- fov circle etc
                if v.Temporary then
                    v:Remove()
                else
                    for i, v in pairs(v.Components) do
                        v.Visible = false
                    end
                end
            end
        end
    end
end

function ESP:GetBox(obj)
    return self.Objects[obj]
end

function ESP:AddObjectListener(parent, options)
    local function NewListener(c)
        if type(options.Type) == "string" and c:IsA(options.Type) or options.Type == nil then
            if type(options.Name) == "string" and c.Name == options.Name or options.Name == nil then
                if not options.Validator or options.Validator(c) then
                    local box = ESP:Add(c, {
                        PrimaryPart = type(options.PrimaryPart) == "string" and c:WaitForChild(options.PrimaryPart) or type(options.PrimaryPart) == "function" and options.PrimaryPart(c),
                        Color = type(options.Color) == "function" and options.Color(c) or options.Color,
                        ColorDynamic = options.ColorDynamic,
                        Name = type(options.CustomName) == "function" and options.CustomName(c) or options.CustomName,
                        IsEnabled = options.IsEnabled,
                        RenderInNil = options.RenderInNil
                    })
                    -- TODO: add a better way of passing options
                    if options.OnAdded then
                        coroutine.wrap(options.OnAdded)(box)
                    end
                end
            end
        end
    end

    if options.Recursive then
        parent.DescendantAdded:Connect(NewListener)
        for i, v in pairs(parent:GetDescendants()) do
            coroutine.wrap(NewListener)(v)
        end
    else
        parent.ChildAdded:Connect(NewListener)
        for i, v in pairs(parent:GetChildren()) do
            coroutine.wrap(NewListener)(v)
        end
    end
end

local boxBase = {}
boxBase.__index = boxBase

function boxBase:Remove()
    ESP.Objects[self.Object] = nil
    for i, v in pairs(self.Components) do
        v.Visible = false
        v:Remove()
        self.Components[i] = nil
    end
end

function boxBase:Update()
    if not self.PrimaryPart then
        -- warn("not supposed to print", self.Object)
        return self:Remove()
    end

    local FriendCheck = game.Players.LocalPlayer:IsFriendsWith(game.Players:FindFirstChild(self.Name).UserId)

    local color
    if ESP.Highlighted == self.Object then
        color = ESP.HighlightColor
    else
        color = self.Color or self.ColorDynamic and self:ColorDynamic() or ESP:GetColor(self.Object) or ESP.Color
    end

    local allow = true
    if ESP.Overrides.UpdateAllow and not ESP.Overrides.UpdateAllow(self) then
        allow = false
    end
    if self.Player and not ESP.TeamMates and ESP:IsTeamMate(self.Player) then
        allow = false
    end
    if self.Player and not ESP.Players then
        allow = false
    end
    if self.IsEnabled and (type(self.IsEnabled) == "string" and not ESP[self.IsEnabled] or type(self.IsEnabled) == "function" and not self:IsEnabled()) then
        allow = false
    end
    if not workspace:IsAncestorOf(self.PrimaryPart) and not self.RenderInNil then
        allow = false
    end

    if not allow then
        for i, v in pairs(self.Components) do
            v.Visible = false
        end
        return
    end

    if ESP.Highlighted == self.Object then
        color = ESP.HighlightColor
    end

    -- calculations --
    local cf = self.PrimaryPart.CFrame
    if ESP.FaceCamera then
        cf = CFrame.new(cf.p, cam.CFrame.p)
    end
    local size = self.Size
    local locs = {
        TopLeft = cf * ESP.BoxShift * CFrame.new(size.X / 2, size.Y / 2, 0),
        TopRight = cf * ESP.BoxShift * CFrame.new(-size.X / 2, size.Y / 2, 0),
        BottomLeft = cf * ESP.BoxShift * CFrame.new(size.X / 2, -size.Y / 2, 0),
        BottomRight = cf * ESP.BoxShift * CFrame.new(-size.X / 2, -size.Y / 2, 0),
        TagPos = cf * ESP.BoxShift * CFrame.new(0, size.Y / 2, 0) + Vector3.new(0, 2.5, 0),
        Torso = cf * ESP.BoxShift
    }

    if ESP.Boxes then
        local TopLeft, Vis1 = WorldToViewportPoint(cam, locs.TopLeft.p)
        local TopRight, Vis2 = WorldToViewportPoint(cam, locs.TopRight.p)
        local BottomLeft, Vis3 = WorldToViewportPoint(cam, locs.BottomLeft.p)
        local BottomRight, Vis4 = WorldToViewportPoint(cam, locs.BottomRight.p)

        if self.Components.Quad then
            if Vis1 or Vis2 or Vis3 or Vis4 then
                self.Components.Quad.Visible = true
                self.Components.Quad.PointA = Vector2.new(TopRight.X, TopRight.Y)
                self.Components.Quad.PointB = Vector2.new(TopLeft.X, TopLeft.Y)
                self.Components.Quad.PointC = Vector2.new(BottomLeft.X, BottomLeft.Y)
                self.Components.Quad.PointD = Vector2.new(BottomRight.X, BottomRight.Y)

                if ESP.Friends and FriendCheck then
                    self.Components.Quad.Color = Color3.fromRGB(111, 227, 142)
                else
                    self.Components.Quad.Color = color
                end
            else
                self.Components.Quad.Visible = false
            end
        end
    else
        self.Components.Quad.Visible = false
    end

    if ESP.Names then
        local TagPos, Vis5 = WorldToViewportPoint(cam, locs.TagPos.p)

        if Vis5 then
            self.Components.Name.Visible = true
            self.Components.Name.Position = Vector2.new(TagPos.X, TagPos.Y + 2)
            self.Components.Name.Text = self.Name
            self.Components.Name.Size = ESP.NameSize or 14

            if ESP.DistanceESP then
                self.Components.Distance.Visible = true
                self.Components.Distance.Position = Vector2.new(TagPos.X, TagPos.Y + 14)
                self.Components.Distance.Text = math.floor((cam.CFrame.p - cf.p).magnitude) .. "m away"
                self.Components.Distance.Size = ESP.DistanceSize or 19
                if ESP.Friends and FriendCheck then
                    self.Components.Distance.Color = Color3.fromRGB(111, 227, 142)
                else
                    self.Components.Distance.Color = color
                end
            end

            if ESP.Friends and FriendCheck then
                self.Components.Name.Color = Color3.fromRGB(111, 227, 142)
            else
                self.Components.Name.Color = color
            end
        else
            self.Components.Name.Visible = false
            self.Components.Distance.Visible = false
        end
    else
        self.Components.Name.Visible = false
        self.Components.Distance.Visible = false
    end

    if ESP.Tracers then
        local TorsoPos, Vis6 = WorldToViewportPoint(cam, locs.Torso.p)
        local mouse = game.Players.LocalPlayer:GetMouse()
        local distance = (locs.Torso.Position - game.Players.LocalPlayer.Character.PrimaryPart.Position).magnitude

        if Vis6 and distance < 600 then
            self.Components.Tracer.Visible = true
            self.Components.Tracer.From = Vector2.new(TorsoPos.X, TorsoPos.Y)
            self.Components.Tracer.To = Vector2.new(mouse.X, mouse.Y + 38)

            if ESP.Friends and FriendCheck then
                self.Components.Tracer.Color = Color3.fromRGB(111, 227, 142)
            else
                self.Components.Tracer.Color = color
            end
        else
            self.Components.Tracer.Visible = false
        end
    else
        self.Components.Tracer.Visible = false
    end
end

function ESP:Add(obj, options)
    if not obj.Parent and not options.RenderInNil then
        return warn(obj, "has no parent")
    end

    local box = setmetatable({
        Name = options.Name or obj.Name,
        Type = "Box",
        Color = options.Color --[[or self:GetColor(obj)]],
        Size = options.Size or self.BoxSize,
        Object = obj,
        Player = options.Player or plrs:GetPlayerFromCharacter(obj),
        PrimaryPart = options.PrimaryPart or obj.ClassName == "Model" and (obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")) or obj:IsA("BasePart") and obj,
        Components = {},
        IsEnabled = options.IsEnabled,
        Temporary = options.Temporary,
        ColorDynamic = options.ColorDynamic,
        RenderInNil = options.RenderInNil
    }, boxBase)

    if self:GetBox(obj) then
        self:GetBox(obj):Remove()
    end

    box.Components["Quad"] = Draw("Quad", {
        Thickness = self.Thickness,
        Color = color,
        Transparency = 1,
        Filled = false,
        Visible = self.Enabled and self.Boxes
    })
    box.Components["Name"] = Draw("Text", {
        Text = box.Name,
        Color = box.Color,
        Center = true,
        Outline = true,
        Size = 14,
        Visible = self.Enabled and self.Names
    })
    box.Components["Distance"] = Draw("Text", {
        Color = box.Color,
        Center = true,
        Outline = true,
        Size = 19,
        Visible = self.Enabled and self.Names
    })

    box.Components["Tracer"] = Draw("Line", {
        Thickness = ESP.Thickness,
        Color = box.Color,
        Transparency = 1,
        Visible = self.Enabled
    })
    self.Objects[obj] = box

    obj.AncestryChanged:Connect(function(_, parent)
        if parent == nil and ESP.AutoRemove ~= false then
            box:Remove()
        end
    end)
    obj:GetPropertyChangedSignal("Parent"):Connect(function()
        if obj.Parent == nil and ESP.AutoRemove ~= false then
            box:Remove()
        end
    end)

    local hum = obj:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Died:Connect(function()
            if ESP.AutoRemove ~= false then
                box:Remove()
            end
        end)
    end

    return box
end

local function CharAdded(char)
    local p = plrs:GetPlayerFromCharacter(char)
    if not char:FindFirstChild("HumanoidRootPart") then
        local ev
        ev = char.ChildAdded:Connect(function(c)
            if c.Name == "HumanoidRootPart" then
                ev:Disconnect()
                ESP:Add(char, {
                    Name = p.Name,
                    Player = p,
                    PrimaryPart = c
                })
            end
        end)
    else
        ESP:Add(char, {
            Name = p.Name,
            Player = p,
            PrimaryPart = char.HumanoidRootPart
        })
    end
end
local function PlayerAdded(p)
    p.CharacterAdded:Connect(CharAdded)
    if p.Character then
        coroutine.wrap(CharAdded)(p.Character)
    end
end
plrs.PlayerAdded:Connect(PlayerAdded)
for i, v in pairs(plrs:GetPlayers()) do
    if v ~= plr then
        PlayerAdded(v)
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    cam = workspace.CurrentCamera
    for i, v in (ESP.Enabled and pairs or ipairs)(ESP.Objects) do
        if v.Update then
            local s, e = pcall(v.Update, v)
            if not s then warn("[EU]", e, v.Object:GetFullName()) end
        end
    end
end)

-- ESP Toggles and Sliders
local ESPEnabledToggle = Tabs.Visuals:AddToggle("ESPEnabled", {Title = "ESP Enabled", Default = ESP.Enabled})
ESPEnabledToggle:OnChanged(function()
    ESP:Toggle(Options.ESPEnabled.Value)
end)

local BoxesToggle = Tabs.Visuals:AddToggle("ShowBoxes", {Title = "Show Boxes", Default = ESP.Boxes})
BoxesToggle:OnChanged(function()
    ESP.Boxes = Options.ShowBoxes.Value
end)

local TracersToggle = Tabs.Visuals:AddToggle("ShowTracers", {Title = "Show Tracers", Default = ESP.Tracers})
TracersToggle:OnChanged(function()
    ESP.Tracers = Options.ShowTracers.Value
end)

local NamesToggle = Tabs.Visuals:AddToggle("ShowNames", {Title = "Show Names", Default = ESP.Names})
NamesToggle:OnChanged(function()
    ESP.Names = Options.ShowNames.Value
end)

local DistanceToggle = Tabs.Visuals:AddToggle("ShowDistance", {Title = "Show Distance", Default = ESP.DistanceESP})
DistanceToggle:OnChanged(function()
    ESP.DistanceESP = Options.ShowDistance.Value
end)

local TeamColorToggle = Tabs.Visuals:AddToggle("UseTeamColors", {Title = "Use Team Colors", Default = ESP.TeamColor})
TeamColorToggle:OnChanged(function()
    ESP.TeamColor = Options.UseTeamColors.Value
end)

local ThicknessSlider = Tabs.Visuals:AddSlider("BoxThickness", {
    Title = "Box Thickness",
    Description = "Adjust the thickness of the ESP box",
    Default = ESP.Thickness,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        ESP.Thickness = Value
    end
})
ThicknessSlider:OnChanged(function(Value)
    ESP.Thickness = Value
end)

local NameSizeSlider = Tabs.Visuals:AddSlider("NameSize", {
    Title = "Name Size",
    Description = "Adjust the size of the name text",
    Default = ESP.NameSize,
    Min = 10,
    Max = 20,
    Rounding = 1,
    Callback = function(Value)
        ESP.NameSize = Value
    end
})
NameSizeSlider:OnChanged(function(Value)
    ESP.NameSize = Value
end)

local DistanceSizeSlider = Tabs.Visuals:AddSlider("DistanceTextSize", {
    Title = "Distance Text Size",
    Description = "Adjust the size of the distance text",
    Default = ESP.DistanceSize,
    Min = 10,
    Max = 20,
    Rounding = 1,
    Callback = function(Value)
        ESP.DistanceSize = Value
    end
})
DistanceSizeSlider:OnChanged(function(Value)
    ESP.DistanceSize = Value
end)


--// FullBright TAB: Visuals

local ClockTime = 14
local RTime


local function ToggleClockTime(v)
    if v then
        RTime = game:GetService("Lighting"):GetPropertyChangedSignal("ClockTime"):Connect(function()
            if game:GetService("Lighting").ClockTime ~= ClockTime then
                game:GetService("Lighting").ClockTime = ClockTime
            end
        end)
    elseif not v and RTime then
        RTime:Disconnect()
        RTime = nil
    end
end


local function ToggleFullbright(v)
    if v then

    else

    end
end


local FullbrightToggle = Tabs.Visuals:AddToggle("FullbrightToggle", {Title = "Fullbright", Default = false})


FullbrightToggle:OnChanged(function(value)
    ToggleFullbright(value)
   
    ToggleClockTime(value)
end)


FullbrightToggle:SetValue(false)


--// No Recoil TAB: MODS//GunMODS


local NoRecoilToggle = Tabs.Mods:AddToggle("No Recoil", {Title = "No Recoil", Default = false})

NoRecoilToggle:OnChanged(function(value)
    if value then
        local str = 'KickUpCameraInfluence'
        local str2 = 'ShiftGunInfluence'
        local str3 = 'ShiftCameraInfluence'
        local str4 = 'RaiseInfluence'
        local str5 = 'KickUpSpeed'
        
        for i, v in pairs(getgc(true)) do
            if type(v) == 'table' and rawget(v, str) then
                setreadonly(v, false)
                v[str] = 0
                v[str2] = 0
                v[str3] = 0
                v[str4] = 0
                v[str5] = 10000000
            end
        end
    else

    end
end)

NoRecoilToggle:SetValue(false)


--// FastFireRate TAB: MODS//GunMODS

local FastFireRate = false

local ToggleFastFireRate = Tabs.Mods:AddToggle("MyToggle", {Title = "Fast Fire Rate", Default = false})

ToggleFastFireRate:OnChanged(function(value)
    FastFireRate = value
    if FastFireRate then
        local str = 'FireRate'
        
        for i, v in pairs(getgc(true)) do
            if type(v) == 'table' and rawget(v, str) then
                setreadonly(v, false)
                v[str] = 1500
            end
        end
    else
    end
end)

local NoSpreadToggle = Tabs.Mods:AddToggle("NoSpread", {
    Title = "NoSpread",
    Default = false, -- Initial state
    OnToggle = function(enabled)
        NoSpreadEnabled = enabled
        ToggleNoSpread(enabled)
    end
})

-- Function to toggle NoSpread
local function ToggleNoSpread(enabled)
    local str2 = 'SpreadAddTPSHip'
    local str3 = 'SpreadAddTPSZoom'
    local str4 = 'SpreadAddFPSHip'
    local str5 = 'RollRightBias'
    local str6 = 'RollLeftBias'
    local str7 = 'ShiftRoll'
    local str8 = 'ShiftForce'
    local str9 = 'SlideForce'

    for i, v in pairs(getgc(true)) do
        if type(v) == 'table' and rawget(v, 'Spread') then
            v[str2] = enabled and 0 or nil
            v[str3] = enabled and 0 or nil
            v[str4] = enabled and 0 or nil
            v[str5] = enabled and 0 or nil
            v[str6] = enabled and 0 or nil
            v[str7] = enabled and 0 or nil
            v[str8] = enabled and 0 or nil
            v[str9] = enabled and 0 or nil
        end
    end
end


--// Speed TAB: MISC


local Speed = 1
local HbTP

local ToggleTPWalk = Tabs.Misc:AddToggle("SpeedToggle", {Title = "Speed", Default = false})

ToggleTPWalk:OnChanged(function(value)
    if value == true then
        HbTP = game:GetService("RunService").Heartbeat:Connect(function()
            local player = game:GetService("Players").LocalPlayer
            if player.Character and player.Character.Humanoid and player.Character.Humanoid.Parent then
                if player.Character.Humanoid.MoveDirection.Magnitude > 0 then
                    player.Character:TranslateBy(player.Character.Humanoid.MoveDirection * Speed / 10)
                end
            end
        end)
    elseif value == false and HbTP then
        HbTP:Disconnect()
        HbTP = nil
    end
end)

local SliderTPSpeed = Tabs.Misc:AddSlider("Slider", {
    Title = "Speed",
    Description = "Adjust speed",
    Default = 1,
    Min = 0.5,
    Max = 200,
    Rounding = 0,
    Callback = function(value)
        Speed = value
    end
})


--// Infinite Jump TAB: MISC


local InfiniteJump = false

local Toggle = Tabs.Misc:AddToggle("InfToggle", {Title = "Infinite Jump", Default = false})

Toggle:OnChanged(function(value)
    InfiniteJump = value
end)

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if InfiniteJump and input.KeyCode == Enum.KeyCode.Space then
        local player = game:GetService("Players").LocalPlayer
        if player and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState("Jumping")
            end
        end
    end
end)


--// Noclip TAB: MISC

local NoClipToggle = Tabs.Misc:AddToggle("NoClip", {Title = "Toggle NoClip", Default = false})

local NoClipEvent
local NoClipObjects = {}

NoClipToggle:OnChanged(function()
    if Options.NoClip.Value then
        -- Enable NoClip
        NoClipEvent = game:GetService("RunService").Stepped:Connect(function()
            local LocalPlayer = game:GetService("Players").LocalPlayer
            if not LocalPlayer.Character then return end

            for _, Object in pairs(LocalPlayer.Character:GetDescendants()) do
                if Object:IsA("BasePart") then
                    if NoClipObjects[Object] == nil then
                        NoClipObjects[Object] = Object.CanCollide
                    end
                    Object.CanCollide = false
                end
            end
        end)
    else
        -- Disable NoClip
        if NoClipEvent then
            NoClipEvent:Disconnect()
            NoClipEvent = nil

            wait(0.1)
            for Object, CanCollide in pairs(NoClipObjects) do
                Object.CanCollide = CanCollide
            end
            table.clear(NoClipObjects)
        end
    end
end)

Options.NoClip:SetValue(false)

--// Staff detector TAB: MISC


local function CheckStaff(Player)
    pcall(function()
        if Player:GetRankInGroup(1066925) > 1 or Player:GetRankInGroup(9630142) > 0 then
            Fluent:Notify({
                Title = "Zenith Hub",
                Content = "Staff: " .. Player.Name,
                Duration = 120 -- Set to nil to make the notification not disappear
            })
        end
    end)
end

game:GetService("Players").PlayerAdded:Connect(function(Player)
    CheckStaff(Player)
end)

local ToggleStaffDetector = Tabs.Misc:AddToggle("StaffDetectorToggle", {Title = "Staff Detector", Default = false})

ToggleStaffDetector:OnChanged(function()
    if Options.StaffDetectorToggle.Value == true then
        -- Check staff for all current players
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            CheckStaff(player)
        end
    end
end)

Options.StaffDetectorToggle:SetValue(false)
