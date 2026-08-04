-- Fonctions utilitaires partagées (client/server)
local Utils = {}

-- Affiche les clé/valeur d'une table (utile pour le debug)
function Utils.printTable(t, indent)
    indent = indent or ""
    for k, v in pairs(t) do
        if type(v) == "table" then
            print(indent .. tostring(k) .. " = {")
            Utils.printTable(v, indent .. "  ")
            print(indent .. "}")
        else
            print(indent .. tostring(k) .. " = " .. tostring(v))
        end
    end
end

return Utils
