local gt = getroottable();

::mods_registerMod("endless_mod", "1.0.1", "Endless Mod");
::mods_queue(null, "mod_legends,mod_legends_PTR", function ()
{

	::mods_registerJS("el_hiring_screen.js");

});
