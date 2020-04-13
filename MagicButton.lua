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
local cancel = false
local auctionCancelIndex = 1
local MAGIC_BUTTON_CANCEL_EVENTS = {
  "AUCTION_HOUSE_SHOW",
  "OWNED_AUCTIONS_UPDATED",
  "COMMODITY_SEARCH_RESULTS_UPDATED",
  "ITEM_SEARCH_RESULTS_UPDATED",
  "AUCTION_CANCELED",
}
local function cancelSearch()
  if auctionToCancel then
    C_AuctionHouse.SendSearchQuery(auctionToCancel.itemKey, {}, true)
  end
end
local function setCancelAuction()
  local wasAuction = auctionToCancel
  auctionToCancel = C_AuctionHouse.GetOwnedAuctionInfo(auctionCancelIndex)
  if not auctionToCancel and wasAuction then
    MagicButton_Print("No more to cancel")
    auctionCancelIndex = 1
  end
  if auctionToCancel and auctionToCancel.status == 1 then
    auctionCancelIndex = auctionCancelIndex + 1
    setCancelAuction()
  end
  cancel = false
end
local function CancelAuctionMagicEvent(frame, event, itemKey)
  if event == "AUCTION_HOUSE_SHOW" then
    cancel = false
    auctionCancelIndex = 1
    return
  end

  if AuctionHouseFrame.displayMode ~= AuctionHouseFrameDisplayMode.Auctions then
    auctionToCancel = nil
    cancel = false
    return
  end

  if event == "OWNED_AUCTIONS_UPDATED" then
    setCancelAuction()
    return
  end

  if event == "AUCTION_CANCELED" then
    MagicButton_Print("Click again to restart undercut search")
    return
  end

  if (not auctionToCancel) or cancel then
    return
  end

  local resultInfo
  local itemKeyInfo = C_AuctionHouse.GetItemKeyInfo(auctionToCancel.itemKey)
  if itemKeyInfo.isCommodity then
    resultInfo = C_AuctionHouse.GetCommoditySearchResultInfo(auctionToCancel.itemKey.itemID, 1)
  else
    resultInfo = C_AuctionHouse.GetItemSearchResultInfo(auctionToCancel.itemKey, 1)
  end

  if not resultInfo then
    return
  end

  if resultInfo.owners[1] ~= "player" then
    cancel = true
    MagicButton_Print("You aren't first. Click again to cancel ".. itemKeyInfo.itemName)
  else
    cancel = false
    MagicButton_Print("You own the top auction for ".. itemKeyInfo.itemName ..". Looking at next one")
    auctionCancelIndex = auctionCancelIndex + 1
    setCancelAuction()
    cancelSearch()
  end
end

function MagicButton_CancelAuctionMagic()
  if not MagicFrame then
    MagicFrame = CreateFrame("Frame",nil,UIParent)
    MagicFrame:SetScript("OnEvent", CancelAuctionMagicEvent)
    FrameUtil.RegisterFrameForEvents(MagicFrame, MAGIC_BUTTON_CANCEL_EVENTS)
    C_AuctionHouse.QueryOwnedAuctions({})
    MagicButton_Print("Auction cancelling loaded. Click once more please :)")
  end
  if cancel then
    MagicButton_Print("Cancelling ID " .. auctionToCancel.auctionID)
    C_AuctionHouse.CancelAuction(auctionToCancel.auctionID)
    auctionToCancel = nil
  else
    setCancelAuction()
    cancelSearch()
  end
end
