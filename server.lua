local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","JK_PoliceInfraction")

Infraction = {
    [1] = {money = 100 , name = "هروب من الشرطة"},
}
vRP.registerMenuBuilder({"police", function(add, data)
    local user_id = vRP.getUserId({data.player})
    if user_id ~= nil then
        local choices = {}
        if vRP.hasPermission({ user_id , "police.pc" }) then
            choices["! قائمة المخالفات !"] = {function(player, choice)
                vRPclient.getNearestPlayer(player,{2},function(nplayer)
                    local nuser_id = vRP.getUserId({nplayer})
                    if nuser_id ~= nil then
                        for k , v in pairs(Infraction) do
                            vRP.buildMenu({"Police_Warn", {player = player}, function(menu)
                                menu.name = "قائمة المخالفات"
                                menu.css={top="75px",header_color="rgba(200,0,0,0.75)"}
                                menu.onclose = function(player) vRP.openMainMenu({player}) end
                                menu[v.name] = {function(player) 
                                    vRP.tryFullPayment({ nuser_id , v.money })
                                    vRP.closeMenu({player})
                                end , "سعر المخالفة : "..v.money..""}
                                vRP.openMenu({player,menu})
                            end})
                        end
                    else
                        vRPclient.notify(player,{"لا يوجد لاعب بالقرب منك"})
                    end
                end)
            end}
        end
        add(choices)
    end
end})