local E, L = unpack(ElvUI)
local _G = _G
local DT = E:GetModule("DataTexts")
local GetCombatRatingBonus = _G.GetCombatRatingBonus
local math = _G.math
local Constants = _G.Constants --maybe should not be
local HONOR = _G.HONOR
local ARENA= _G.ARENA
local COMBAT_HONOR_GAIN = _G.COMBAT_HONOR_GAIN
local PVP_CONQUEST = _G.PVP_CONQUEST
local CURRENCY = _G.CURRENCY
local STAT_CATEGORY_ENHANCEMENTS = _G.STAT_CATEGORY_ENHANCEMENTS
local CR_HASTE_SPELL = _G.CR_HASTE_SPELL
local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------spell haste datatext
local function EltruismSpellHasteDatatext(dt)
	local spellhaste = GetCombatRatingBonus(CR_HASTE_SPELL)
	local spellhastepc = ((math.ceil(spellhaste*100))/100)..'%'
	dt.text:SetFormattedText('%s: %s%s|r', L["Spell Haste"], E.media.hexvaluecolor, spellhastepc)
end
if E.Wrath or E.Classic then
	DT:RegisterDatatext('Eltruism Spellhaste', STAT_CATEGORY_ENHANCEMENTS, {'COMBAT_RATING_UPDATE',"UNIT_SPELL_HASTE"}, EltruismSpellHasteDatatext, nil, nil, nil, nil, L["Eltruism Spell Haste"])
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------honor datatext
local function EltruismHonorDatatext(dt)
	local arg2 = E.Retail and COMBAT_HONOR_GAIN or HONOR

	local honorCurrencyID = (E.Wrath and Constants.CurrencyConsts.CLASSIC_HONOR_CURRENCY_ID) or (E.Retail and 1792)
	local arg4 = (not E.Classic and C_CurrencyInfo_GetCurrencyInfo(honorCurrencyID).quantity) or select(2, GetPVPThisWeekStats())

	local arg5 = (E.Retail and PVP_CONQUEST) or (E.Wrath and ARENA) or RANK

	local classicRank = E.Classic and UnitPVPRank('player')-4
	if classicRank and classicRank < 0 then classicRank = 0 end
	local arenaCurrencyID = (E.Wrath and Constants.CurrencyConsts.CLASSIC_ARENA_POINTS_CURRENCY_ID) or (E.Retail and 1602)
	local arg7 = not E.Classic and C_CurrencyInfo_GetCurrencyInfo(arenaCurrencyID).quantity or classicRank

	dt.text:SetFormattedText('%s: %s%s|r %s: %s%s|r', arg2, E.media.hexvaluecolor, arg4, arg5, E.media.hexvaluecolor, arg7)
end

DT:RegisterDatatext(format('Eltruism Honor/%s Points', E.Retail and 'Conquest' or 'Arena'), CURRENCY, {'CHAT_MSG_CURRENCY', 'CURRENCY_DISPLAY_UPDATE', 'PLAYER_PVP_KILLS_CHANGED'}, EltruismHonorDatatext, nil, nil, nil, nil, E.Retail and L["Eltruism Honor/Conquest Points"] or L["Eltruism Honor/Arena Points"])
