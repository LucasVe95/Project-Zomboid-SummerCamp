Teams = {}

Teams.list = {
    Alpha = {"Alice", "Bob", "Charlie", "Diana", "Ethan"},
    Bravo = {"Fiona", "George", "Hannah", "Ian", "Julia"},
    Charlie = {"Kevin", "Laura", "Mike", "Nina", "Oscar"}
}

Teams.playerTeams = {}

function Teams.getTeamForCharacter(characterName)
    for teamName, characters in pairs(Teams.list) do
        for _, char in ipairs(characters) do
            if char == characterName then return teamName end
        end
    end
    return nil
end

function Teams.assignPlayer(playerName, characterName)
    local teamName = Teams.getTeamForCharacter(characterName)
    if not teamName then return end

    if not Teams.playerTeams[teamName] then
        Teams.playerTeams[teamName] = {}
    end

    table.insert(Teams.playerTeams[teamName], playerName)
end

function Teams.printTeams()
    for teamName, players in pairs(Teams.playerTeams) do
        print("Équipe " .. teamName .. " :")
        for _, p in ipairs(players) do
            print(" - " .. p)
        end
    end
end

return Teams
