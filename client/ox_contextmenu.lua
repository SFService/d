-- client/ox_contextmenu.lua
-- Enkel adapter for at vise en ox_lib context menu fra dette resource
-- Forventet input: TriggerEvent('d:openOxMenu', menu)
-- menu = {
--   id = optional_string,
--   title = "Menu titel",
--   options = {
--     { id="unique", label="Gør noget", description="valgfri", event="d:doSomething", args={...}, icon="fa..." },
--     ...
--   }
-- }
local lib = exports.ox_lib

RegisterNetEvent('d:openOxMenu', function(menu)
    if not menu or type(menu) ~= 'table' then return end

    local options = {}
    for i, item in ipairs(menu.options or {}) do
        table.insert(options, {
            id = item.id or tostring(i),
            title = item.label or item.title or ("Option " .. i),
            description = item.description,
            event = item.event or item.action or item.callback,
            args = item.args or item.data or {},
            icon = item.icon
        })
    end

    local ctxId = menu.id or ('d_menu_' .. tostring(math.random(1000,9999)))

    -- Registrer context hvis den ikke allerede findes (safe-register)
    pcall(function()
        lib.registerContext({
            id = ctxId,
            title = menu.title or 'Menu',
            options = options
        })
    end)

    pcall(function()
        lib.showContext(ctxId)
    end)
end)

-- Hjælpefunktion (valgfri eksport)
function OpenOxMenu(menu)
    TriggerEvent('d:openOxMenu', menu)
end
