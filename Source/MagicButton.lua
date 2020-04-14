local MagicFrame = nil

function MagicButton()
  if AuctionHouseFrame.displayMode == AuctionHouseFrameDisplayMode.ItemSell then
    AuctionHouseFrame.ItemSellFrame:PostItem()
  end
  if AuctionHouseFrame.displayMode == AuctionHouseFrameDisplayMode.CommoditiesSell then
    AuctionHouseFrame.CommoditiesSellFrame:PostItem()
  end
  if AuctionHouseFrame.displayMode == AuctionHouseFrameDisplayMode.Auctions then
    MagicButton_CancelAuctionMagic()
  end
end

function MagicButton_Print(message)
  print("|cc935e0ffMagicButton|r: " .. message)
end

local function CreateUndercutFrame()
  if not MagicButtonUndercutFrame then
    frame = CreateFrame(
      "FRAME",
      "MagicButtonUndercutFrame",
      nil,
      "MagicButtonUndercutFrameTemplate"
    )
  end
end

function MagicButton_CancelAuctionMagic()
  if not MagicButtonUndercutFrame then
    CreateUndercutFrame()
  end
  MagicButtonUndercutFrame:ButtonPress()
end
