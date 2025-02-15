-- criado por callmegod0013
-- Configurações da ESP Box
local espSettings = {
    BoxColor = Color3.new(1, 1, 1),  -- Cor da caixa (branca)
    TextColor = Color3.new(1, 1, 1), -- Cor do texto (branca)
    TextSize = 16,                   -- Tamanho do texto
    TextFont = Drawing.Fonts.UI,      -- Fonte do texto
    BoxThickness = 2,                 -- Espessura da caixa
    ShowDistance = false,             -- Ocultar distância
    ShowName = true,                  -- Mostrar nome
    BoxPadding = 5                    -- Espaçamento ao redor do corpo (em studs)
}

-- Criar ESP para um jogador
local function createESP(player)
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    if not rootPart or not head then return end
    
    local box = Drawing.new("Square")
    local nameText = Drawing.new("Text")
    
    -- Configurações da caixa
    box.Visible = false
    box.Color = espSettings.BoxColor
    box.Thickness = espSettings.BoxThickness
    box.Filled = false
    
    -- Configurações do nome
    nameText.Visible = false
    nameText.Color = espSettings.TextColor
    nameText.Size = espSettings.TextSize
    nameText.Font = espSettings.TextFont
    nameText.Center = true
    
    -- Atualização contínua
    game:GetService("RunService").RenderStepped:Connect(function()
        if character and rootPart and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
            local rootPosition, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
            local headPosition = game.Workspace.CurrentCamera:WorldToViewportPoint(head.Position)
            
            if onScreen then
                local height = (headPosition.Y - rootPosition.Y) * 2 + espSettings.BoxPadding * 2
                local width = height / 2  -- Proporção ajustada
                
                box.Size = Vector2.new(width, height)
                box.Position = Vector2.new(rootPosition.X - width / 2, rootPosition.Y - height / 2)
                box.Visible = true
                
                if espSettings.ShowName then
                    nameText.Text = player.Name
                    nameText.Position = Vector2.new(rootPosition.X, rootPosition.Y - height / 2 - 20)
                    nameText.Visible = true
                else
                    nameText.Visible = false
                end
            else
                box.Visible = false
                nameText.Visible = false
            end
        else
            box.Visible = false
            nameText.Visible = false
            box:Remove()
            nameText:Remove()
        end
    end)
end

-- Criar ESP para todos os jogadores
local function createESPForAllPlayers()
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            createESP(player)
        end
    end
end

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1) -- Espera para garantir que o personagem foi carregado
        createESP(player)
    end)
end)

-- Iniciar ESP para jogadores existentes
createESPForAllPlayers()
