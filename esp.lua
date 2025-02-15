-- criado por CallmeGod0013
-- Configurações básicas
local espSettings = {
    BoxColor = Color3.new(1, 0, 0),  -- Cor da caixa (vermelho)
    TextColor = Color3.new(1, 1, 1), -- Cor do texto (branco)
    TextSize = 14,                   -- Tamanho do texto
    TextFont = Drawing.Fonts.Plex,   -- Fonte do texto
    BoxThickness = 1,                -- Espessura da caixa
    ShowDistance = true,             -- Mostrar distância
    ShowName = true,                 -- Mostrar nome
    BoxPadding = 10                  -- Espaçamento extra ao redor do corpo (em studs)
}

-- Função para criar um ESP para um jogador
local function createESP(player)
    local character = player.Character
    if not character then return end

    local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
    local head = character:FindFirstChild("Head")
    if not rootPart or not head then return end

    -- Cria os objetos de desenho
    local box = Drawing.new("Square")
    local nameText = Drawing.new("Text")
    local distanceText = Drawing.new("Text")

    -- Configura os objetos de desenho
    box.Visible = false
    box.Color = espSettings.BoxColor
    box.Thickness = espSettings.BoxThickness
    box.Filled = false

    nameText.Visible = false
    nameText.Color = espSettings.TextColor
    nameText.Size = espSettings.TextSize
    nameText.Font = espSettings.TextFont
    nameText.Center = true

    distanceText.Visible = false
    distanceText.Color = espSettings.TextColor
    distanceText.Size = espSettings.TextSize
    distanceText.Font = espSettings.TextFont
    distanceText.Center = true

    -- Loop de atualização
    game:GetService("RunService").RenderStepped:Connect(function()
        if character and rootPart and head and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
            -- Obtém a posição da cabeça e do rootPart (corpo)
            local headPosition, headOnScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(head.Position)
            local rootPosition = game.Workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)

            if headOnScreen then
                -- Calcula a distância do jogador
                local distance = (game.Workspace.CurrentCamera.CFrame.Position - rootPart.Position).Magnitude
                local scaleFactor = 1 / (distance * 0.1) -- Ajuste o fator de escala conforme necessário

                -- Calcula o tamanho da caixa com um espaçamento extra
                local width = (50 + espSettings.BoxPadding * 2) * scaleFactor -- Largura da caixa com padding
                local height = (headPosition.Y - rootPosition.Y) * 2 + espSettings.BoxPadding * 2 -- Altura da caixa com padding

                -- Ajusta a posição da caixa para ficar fora do corpo
                local boxPosition = Vector2.new(rootPosition.X - width / 2 - espSettings.BoxPadding, rootPosition.Y - height / 2 - espSettings.BoxPadding)

                -- Atualiza a posição e tamanho da caixa
                box.Size = Vector2.new(width, height)
                box.Position = boxPosition
                box.Visible = true

                -- Atualiza o texto do nome
                if espSettings.ShowName then
                    nameText.Text = player.Name
                    nameText.Position = Vector2.new(rootPosition.X, rootPosition.Y - height / 2 - 20)
                    nameText.Visible = true
                else
                    nameText.Visible = false
                end

                -- Atualiza o texto da distância
                if espSettings.ShowDistance then
                    distanceText.Text = string.format("%.1f studs", distance)
                    distanceText.Position = Vector2.new(rootPosition.X, rootPosition.Y + height / 2 + 10)
                    distanceText.Visible = true
                else
                    distanceText.Visible = false
                end
            else
                box.Visible = false
                nameText.Visible = false
                distanceText.Visible = false
            end
        else
            box.Visible = false
            nameText.Visible = false
            distanceText.Visible = false

            -- Remove os objetos de desenho se o jogador não existir mais
            if not player or not player.Parent then
                box:Remove()
                nameText:Remove()
                distanceText:Remove()
            end
        end
    end)
end

-- Cria ESP para todos os jogadores
local function createESPForAllPlayers()
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            createESP(player)
        end
    end
end

-- Conecta a função para criar ESP quando um novo jogador entra no jogo
game.Players.PlayerAdded:Connect(createESP)

-- Inicia o ESP para todos os jogadores existentes
createESPForAllPlayers()
