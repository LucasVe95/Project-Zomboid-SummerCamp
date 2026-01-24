-- Gestion des équipes
Teams = {}

Teams.list = {
    Alpha = {},
    Bravo = {},
    Charlie = {}
}

function Teams.addPlayerToTeam(playerName, teamName)
    if Teams.list[teamName] then
        table.insert(Teams.list[teamName], playerName)
        print(playerName .. " a été ajouté à l'équipe " .. teamName)
    end
end

return Teams
