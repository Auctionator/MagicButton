local currentLocale = {}

local function FixMissingTranslations(incomplete, locale)
  if locale == "enUS" then
    return
  end

  local enUS = MAGIC_BUTTON_LOCALES["enUS"]()
  for key, val in pairs(enUS) do
    if incomplete[key] == nil then
      incomplete[key] = val
    end
  end
end

if MAGIC_BUTTON_LOCALES[GetLocale()] ~= nil then
  currentLocale = MAGIC_BUTTON_LOCALES[GetLocale()]()

  FixMissingTranslations(currentLocale, GetLocale())
else
  currentLocale = MAGIC_BUTTON_LOCALES["enUS"]()
end

-- Export constants into the global scope (for XML frames to use)
for key, value in pairs(currentLocale) do
  _G["MAGIC_BUTTON_L_"..key] = value
end
