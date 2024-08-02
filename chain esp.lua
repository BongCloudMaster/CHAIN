--[[
	English: I have this open sourced because i dont wanna be that guy that gatekeeps esp source codes like its unpatchable
	-- these translation are from ChatGPT, just to make people understand from other countries
	Spanish: Tengo esto en código abierto porque no quiero ser ese tipo que acapara los códigos de fuente de ESP como si no pudieran ser parcheados
	Russia: Я сделал это открытым исходным кодом, потому что не хочу быть тем человеком, который монополизирует исходные коды ESP, как будто их нельзя исправить
	Vietnam: Tôi đã mở mã nguồn này ra vì tôi không muốn trở thành người giữ thông tin mã nguồn ESP như thể nó không thể được vá lỗi
	Filipino (Tagalog): "Binuksan ko ang source code na ito dahil ayaw kong maging 'yong taong nagmamay-ari ng mga ESP source codes na parang hindi ito maaring ma-patch."
	Cebuano: "Gibukas ko kini nga open-source tungod kay dili ko gusto nga mahimong tawo nga nagtago sa mga ESP source codes nga daw dili mahimong ma-patch."
	Ilokano: "Inbuklatak daytoy a taudan ti kodigo gapu ta saanak nga kaykayatan nga agballigi iti mga ESP nga source codes a kasla saan a mabalin nga ma-patch."
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
--[[
	* The libraries isnt mine, like Bin
	* It tracks connections, instances, functions, threads, and objects to be later destroyed.
]]
local Bin
do
	Bin = setmetatable({}, {
		__tostring = function()
			return "Bin"
		end,
	})
	Bin.__index = Bin
	function Bin.new(...)
		local self = setmetatable({}, Bin)
		return self:constructor(...) or self
	end
	function Bin:constructor()
	end
	function Bin:add(item)
		local node = {
			item = item,
		}
		if self.head == nil then
			self.head = node
		end
		if self.tail then
			self.tail.next = node
		end
		self.tail = node
		return self
	end
	function Bin:destroy()
		local head = self.head
		while head do
			local _binding = head
			local item = _binding.item
			if type(item) == "function" then
				item()
			elseif typeof(item) == "RBXScriptConnection" then
				item:Disconnect()
			elseif type(item) == "thread" then
				task.cancel(item)
			elseif item.destroy ~= nil then
				item:destroy()
			elseif item.Destroy ~= nil then
				item:Destroy()
			end
			head = head.next
			self.head = head
		end
	end
	function Bin:isEmpty()
		return self.head == nil
	end
end

--[[
    ----------------------
    Variables & References
    ----------------------
]]

local AIFolder : Folder = Workspace.Misc.AI
local LocalPlayer : Player = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera
local ScreenGui = Instance.new("ScreenGui")

--[[
    --------------------
    Function Declaration
    --------------------
    All the functions that are used throughout the code
]]

function format(num)
    local formatted = string.format("%.2f", math.floor(num*100)/100)
    if string.find(formatted, ".00") then
        return string.sub(formatted, 1, -4)
    end
    return formatted
end

--[[
    ---------------------
    Component Declaration
    ---------------------
]]
local ESP
do
    ESP = setmetatable({}, {
        __tostring = function()
            return "ESP"
        end,
    })
    ESP.__index = ESP
    function ESP.new(...)
        local self = setmetatable({}, ESP)
        return self:constructor(...) or self
    end

    function ESP:constructor(entity : Model)
        self.bin = Bin.new()
        self.labels = {
            container = Instance.new("Frame"),
            name = Instance.new("TextLabel"),
            data = Instance.new("TextLabel"),
            listlayout = Instance.new('UIListLayout'),
        }
        -- Set up:
        self.instance = entity
        local attributes = entity:GetAttributes()
        self.attributes = attributes
        -- Interface:
        self:setLabels()
        -- Initialize:
        local bin = self.bin
        local instances = ESP.instances
        local _entity = entity
        local _self = self
        instances[_entity] = _self
        bin:add(function()
            local _entity_1 = entity
            -- ▼ Map.delete ▼ -- cleanup marked
            local _valueExisted = instances[_entity_1] ~= nil
            instances[_entity_1] = nil
            -- ▲ Map.delete ▲
            return _valueExisted
        end)
        entity.AncestryChanged:Connect(function(_, parent)
            return parent == nil and self:destroy()
        end)
        -- Manual update:
        self:update()
    end
   
    function ESP:setLabels()
        local _binding = self
        local labels = _binding.labels
        local instance = _binding.instance
        local bin = _binding.bin
        local _binding_1 = labels
        local container = _binding_1.container
        local name = _binding_1.name
        local data = _binding_1.data
        local listlayout = _binding_1.listlayout
        container.Visible = false
        container.AnchorPoint = Vector2.new(0.5, 0)
        container.BackgroundTransparency = 1
        name.BackgroundTransparency = 1
        name.Font = Enum.Font.Nunito
        name.Size = UDim2.new(1, 0, 0, 14)
        name.Text = instance.Name 
        name.TextSize = 14
        name.TextStrokeTransparency = 0.5
        data.BackgroundTransparency = 1
        data.Font = Enum.Font.Nunito
        data.Size = UDim2.new(1, 0, 0, 14)
        data.Text = "[0] [Anger : 0%] [Burst: 0%] [Choke: 100%] [Deflect: 0%]"
        data.TextSize = 12
        data.TextStrokeTransparency = 0.5
        listlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        listlayout.SortOrder = Enum.SortOrder.LayoutOrder
        name.Parent = container
        data.Parent = container
        listlayout.Parent = container
        container.Parent = ScreenGui
        bin:add(container)
    end
    function ESP:update()
        local _binding_1 = self
        local labels = _binding_1.labels
        local _binding_2 = labels
        local container = _binding_2.container
        local name = _binding_2.name
        local data = _binding_2.data
        local listlayout = _binding_2.listlayout
        name.TextColor3 = Color3.new(1, 0, 0)
        data.TextColor3 = Color3.new(1, 1, 1)
        listlayout.Padding = UDim.new(0, -4)
        container.Size = UDim2.new(0, 300, 0, listlayout.AbsoluteContentSize.Y)
    end
    function ESP:destroy()
        return self.bin:destroy()
    end
    function ESP:render()
        local camera = CurrentCamera
        local instance = self.instance
        local attributes = self.attributes
        local labels = self.labels
        local _binding = labels
        local container = _binding.container
        local name = _binding.name
        local data = _binding.data
    
        if camera and instance and instance.HumanoidRootPart then
            local position, visible = camera:WorldToViewportPoint(instance.HumanoidRootPart.Position)
            
            if visible then
                local scale = 1 / (position.Z * math.tan(math.rad(camera.FieldOfView * 0.5)) * 2) * 1000
                local width, height = math.floor(4.5 * scale), math.floor(6 * scale)
                local x, y = math.floor(position.X), math.floor(position.Y)
                local xPosition, yPosition = math.floor(x - width * 0.5), math.floor((y - height * 0.5) + (0.5 * scale))
                local vector2 = Vector2.new(xPosition, yPosition)
                if instance.GetAttributes then
                    attributes = instance:GetAttributes()
                end
    
                local _valueExisted = container.Visible == false
                container.Visible = true
                name.Text = instance.Name
                
                local positionDiff = LocalPlayer.Character.HumanoidRootPart.Position - instance.HumanoidRootPart.Position
                data.Text = `[{format(positionDiff.Magnitude)}] [Anger: {format(attributes.Anger)}] [Choke : {format(attributes.ChokeMeter)}%] [Deflect : {format(attributes.DeflectChance)}]`
    
                container.Position = UDim2.new(0, vector2.X, 0, vector2.Y + 3)
            else
                local _valueExisted_1 = container.Visible == true
                container.Visible = false
            end
        end
    end
end

ESP.instances = {}
ESP.inAi = {}
ESP.connections = Bin.new()

ESP.connections:add(AIFolder.ChildAdded:Connect(function(instance)
    if instance:IsA("Model") and instance:FindFirstChild("Humanoid") then
        local esp = ESP.new(instance)
        ESP.inAi[instance] = esp
    end
end))


ESP.connections:add(AIFolder.ChildRemoved:Connect(function(instance)
    if ESP.inAi[instance] then
        ESP.inAi[instance]:destroy()
        ESP.inAi[instance] = nil
    end
end))

ESP.connections:add(RunService.RenderStepped:Connect(function()
    for _, esp in pairs(ESP.instances) do
        esp:render()
    end
end))

for _, _n in pairs(AIFolder:GetChildren()) do
    if _n:FindFirstChild("Humanoid") then
        local suc, res = pcall(function()
            local esp = ESP.new(_n)
            ESP.inAi[_n] = esp
        end)
        if not suc then
            warn(res)
        end
    end
end

ScreenGui.DisplayOrder = 10
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game.CoreGui
