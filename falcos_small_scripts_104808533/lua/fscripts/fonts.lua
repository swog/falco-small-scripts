-----------------------------------------------------------------------------[[
/*---------------------------------------------------------------------------
The fonts that DarkRP uses
---------------------------------------------------------------------------*/
-----------------------------------------------------------------------------]]
local function loadFonts()
    surface.CreateFont ("DarkRPHUD1", {
        size = 16,
        weight = 600,
        antialias = true,
        shadow = true,
        font = "DejaVu Sans"})

    surface.CreateFont ("DarkRPHUD2", {
        size = 23,
        weight = 400,
        antialias = true,
        shadow = false,
        font = "coolvetica"})

    surface.CreateFont("Trebuchet18", {
        size = 18,
        weight = 500,
        antialias = true,
        shadow = false,
        font = "Trebuchet MS"})

    surface.CreateFont("Trebuchet19", {
        size = 19,
        weight = 500,
        antialias = true,
        shadow = false,
        font = "Trebuchet MS"})

    surface.CreateFont("Trebuchet20", {
        size = 20,
        weight = 500,
        antialias = true,
        shadow = false,
        font = "Trebuchet MS"})

    surface.CreateFont("Trebuchet22", {
        size = 22,
        weight = 500,
        antialias = true,
        shadow = false,
        font = "Trebuchet MS"})

    surface.CreateFont("Trebuchet24", {
        size = 24,
        weight = 500,
        antialias = true,
        shadow = false,
        font = "Trebuchet MS"})

    surface.CreateFont("TabLarge", {
        size = 17,
        weight = 700,
        antialias = true,
        shadow = false,
        font = "Trebuchet MS"})

    surface.CreateFont("UiBold", {
        size = 16,
        weight = 800,
        antialias = true,
        shadow = false,
        font = "Default"})

    surface.CreateFont("HUDNumber5", {
        size = 30,
        weight = 800,
        antialias = true,
        shadow = false,
        font = "Default"})

    surface.CreateFont("ScoreboardHeader", {
        size = 32,
        weight = 500,
        antialias = true,
        shadow = false,
        font = "coolvetica"})

    surface.CreateFont("ScoreboardSubtitle", {
        size = 22,
        weight = 500,
        antialias = true,
        shadow = false,
        font = "coolvetica"})

    surface.CreateFont("ScoreboardPlayerName", {
        size = 19,
        weight = 500,
        antialias = true,
        shadow = false,
        font = "coolvetica"})

    surface.CreateFont("ScoreboardPlayerName2", {
        size = 15,
        weight = 500,
        antialias = true,
        shadow = false,
        font = "coolvetica"})

    surface.CreateFont("ScoreboardPlayerNameBig", {
        size = 22,
        weight = 500,
        antialias = true,
        shadow = false,
        font = "coolvetica"})

    surface.CreateFont("AckBarWriting", {
        size = 20,
        weight = 500,
        antialias = true,
        shadow = false,
        font = "akbar"})

    surface.CreateFont("FALCO_FONT", {
        font = "ScoreboardText",
        size = ScrW() < 2000 and 14 or 24, -- High DPI
        weight = 500,
        antialias = 1,
        shadow = false,
        font = true})
end
loadFonts()
-- Load twice because apparently once is not enough
timer.Simple(0, loadFonts)

