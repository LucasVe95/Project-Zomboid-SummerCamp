require "ISUI/ISPanel"
require "ISUI/ISButton"
require "ISUI/ISLabel"

local PS = require "core/player_selection"
local Teams = require "core/teams"
UISelection = {}

UISelection.panel = nil
UISelection.selectedCharacter = nil
UISelection.currentPlayer = nil

function UISelection.show(playerObj)
    UISelection.currentPlayer = playerObj

    if UISelection.panel then
        UISelection.panel:removeFromUIManager()
        UISelection.panel = nil
    end

    local available = PS.getAvailableCharacters()
    local width, height = 400, 300
    local x = (getCore():getScreenWidth() - width) / 2
    local y = (getCore():getScreenHeight() - height) / 2

    UISelection.panel = ISPanel:new(x, y, width, height)
    UISelection.panel.backgroundColor = { r=0, g=0, b=0, a=0.8 }

    local title = ISLabel:new(10, 10, 20, "Choisissez votre personnage :", 1,1,1,1,UIFont.Big)
    UISelection.panel:addChild(title)

    local btnY = 40
    for _, char in ipairs(available) do
        local btn = ISButton:new(10, btnY, 180, 30, char, UISelection.panel, UISelection.onCharacterClick)
        btn.characterName = char
        UISelection.panel:addChild(btn)
        btnY = btnY + 35
    end

    local randomBtn = ISButton:new(200, 40, 180, 30, "Aléatoire", UISelection.panel, UISelection.onRandomClick)
    UISelection.panel:addChild(randomBtn)

    UISelection.panel:addToUIManager()
end

function UISelection.onCharacterClick(button)
    UISelection.selectedCharacter = button.characterName
    UISelection.showConfirmDialog()
end

function UISelection.onRandomClick(button)
    local available = PS.getAvailableCharacters()
    if #available > 0 then
        UISelection.selectedCharacter = available[ZombRand(#available) + 1]
        UISelection.showConfirmDialog()
    end
end

function UISelection.showConfirmDialog()
    local msg = "Confirmez le choix : " .. UISelection.selectedCharacter .. " ?"
    local result = getTextManager():DoModal("Selection", msg, true)
    if result == "YES" then
        UISelection.confirmSelection()
    else
        UISelection.selectedCharacter = nil
        UISelection.show(UISelection.currentPlayer)
    end
end

function UISelection.confirmSelection()
    local playerName = UISelection.currentPlayer:getUsername()
    if not UISelection.selectedCharacter then return end

    local chosen = PS.chooseCharacter(playerName, UISelection.selectedCharacter)
    if chosen then
        Teams.assignPlayer(playerName, chosen)
        getPlayerData(playerName):setMetadata("chosenCharacter", chosen)
    end

    UISelection.panel:removeFromUIManager()
    UISelection.panel = nil
    UISelection.selectedCharacter = nil
end

return UISelection
