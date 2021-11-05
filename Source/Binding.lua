CreateFrame("Button", "MagicButtonActualButton", nil, nil, nil)

MagicButtonActualButton:SetScript("OnClick", function()
  if AuctionHouseFrame ~= nil then
    MagicButton()
  end
end)

_G["BINDING_NAME_" .. "CLICK MagicButtonActualButton:LeftButton"] = "Magic Button"
