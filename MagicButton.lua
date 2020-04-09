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

local auctionToCancel = nil
local function CancelAuctionMagicEvent(frame, event)
  if event == "OWNED_AUCTIONS_UPDATED" then
    auctionToCancel = C_AuctionHouse.GetOwnedAuctionInfo(1)
  end
end

function MagicButton_CancelAuctionMagic()
  if not MagicFrame then
    MagicFrame = CreateFrame("Frame",nil,UIParent)
    MagicFrame:SetScript("OnEvent", CancelAuctionMagicEvent)
    MagicFrame:RegisterEvent("OWNED_AUCTIONS_UPDATED")
    C_AuctionHouse.QueryOwnedAuctions({})
    MagicButton_Print("Auction cancelling loaded. Click once more please :)")
  end
  if auctionToCancel then
    AuctionHouseFrame.AuctionsFrame:SelectAuction(auctionToCancel)
    AuctionHouseFrame.AuctionsFrame:CancelSelectedAuction()
    StaticPopup1Button1:Click()
    auctionToCancel = nil
  end
end
