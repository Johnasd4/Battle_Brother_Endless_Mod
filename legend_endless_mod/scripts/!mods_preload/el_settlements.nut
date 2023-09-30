local gt = getroottable();

::mods_registerMod("el_settlements", 1, "el_settlements");
::mods_queue(null, "el_world", function ()
{
    ::mods_hookNewObject("entity/world/settlements/buildings/arena_building", function(o)
    {
        o.refreshCooldown = function()
        {
            this.m.CooldownUntil = 0;
        }
    });

});
