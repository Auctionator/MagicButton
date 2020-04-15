MagicButtonUndercutFrameMixin = {}

local UNDERCUT_EVENTS = {
  "AUCTION_HOUSE_SHOW",
  "OWNED_AUCTIONS_UPDATED",
  "COMMODITY_SEARCH_RESULTS_UPDATED",
  "ITEM_SEARCH_RESULTS_UPDATED",
  "AUCTION_CANCELED",
}

MAGIC_BUTTON_L_UNDERCUT_LOADED = "Auction cancelling loaded. Click once more please :)"
MAGIC_BUTTON_L_NOT_FIRST = "You aren't first. Click again to cancel %s"
MAGIC_BUTTON_L_OWNED_TOP = "You own the top auction for %s. Skipping"
MAGIC_BUTTON_L_SEARCH_RESTART = "Click again to restart undercut search"

function MagicButtonUndercutFrameMixin:OnLoad()
  self:Reset()
  MagicButton_Print(MAGIC_BUTTON_L_UNDERCUT_LOADED)
  FrameUtil.RegisterFrameForEvents(self, UNDERCUT_EVENTS)
  C_AuctionHouse.QueryOwnedAuctions({})
end

function MagicButtonUndercutFrameMixin:OnEvent(event, ...)
  if event == "AUCTION_HOUSE_SHOW" or 
     not self:AuctionsTabShown() then
    self:Reset()

  elseif event == "OWNED_AUCTIONS_UPDATED" then
    self:UpdateCurrentAuction()

  elseif event == "AUCTION_CANCELED" then
    MagicButton_Print(MAGIC_BUTTON_L_SEARCH_RESTART)

  elseif self.currentAuction and self.currentAuction.status == 1 then
    self:SkipAuction()

  elseif self.searchWaiting then
    self:ProcessSearchResults(...)
  end
end

function MagicButtonUndercutFrameMixin:ProcessSearchResults(...)
  local resultInfo

  local itemKeyInfo = C_AuctionHouse.GetItemKeyInfo(self.currentAuction.itemKey)
  if itemKeyInfo.isCommodity then
    resultInfo = C_AuctionHouse.GetCommoditySearchResultInfo(self.currentAuction.itemKey.itemID, 1)
  else
    resultInfo = C_AuctionHouse.GetItemSearchResultInfo(self.currentAuction.itemKey, 1)
  end

  if not resultInfo then
    return
  end
  
  self.searchWaiting = false

  if resultInfo.owners[1] ~= "player" then
    self.isUndercut = true
    MagicButton_Print(MAGIC_BUTTON_L_NOT_FIRST:format(itemKeyInfo.itemName))
  else
    MagicButton_Print(MAGIC_BUTTON_L_OWNED_TOP:format(itemKeyInfo.itemName))
    self:SkipAuction()
  end
end

function MagicButtonUndercutFrameMixin:AuctionsTabShown()
  return AuctionHouseFrame.displayMode == AuctionHouseFrameDisplayMode.Auctions
end

function MagicButtonUndercutFrameMixin:ButtonPress()
  if self.currentAuction and self.isUndercut then
    MagicButton_Print("Cancelling ID " .. self.currentAuction.auctionID)
    C_AuctionHouse.CancelAuction(self.currentAuction.auctionID)
    self.toCancel = nil
    self.searchWaiting = false
  else
    self:UpdateCurrentAuction()
    self:SearchForUndercuts()
  end
end

function MagicButtonUndercutFrameMixin:SearchForUndercuts()
  self.isUndercut = false
  if self.currentAuction then
    self.searchWaiting = true
    C_AuctionHouse.SendSearchQuery(self.currentAuction.itemKey, {{sortOrder = 4, reverseSort = false}}, true)
  end
end

function MagicButtonUndercutFrameMixin:CancelNow()
  C_AuctionHouse.CancelAuction(self.currentAuction.auctionID)
  self.currentAuction = nil
end

function MagicButtonUndercutFrameMixin:UpdateCurrentAuction()
  self.isUndercut = false
  self.currentAuction = C_AuctionHouse.GetOwnedAuctionInfo(self.auctionIndex)
  if not self.currentAuction then
    MagicButton_Print("No more to cancel")
    self:Reset()
  end
end

function MagicButtonUndercutFrameMixin:SkipAuction()
  self.auctionIndex = self.auctionIndex + 1
  self:UpdateCurrentAuction()
  self:SearchForUndercuts()
end

function MagicButtonUndercutFrameMixin:Reset()
  self.searchWaiting = false
  self.isUndercut = false
  self.currentAuction = nil
  self.auctionIndex = 1
end
