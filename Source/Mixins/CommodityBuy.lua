MagicButtonCommodityBuyFrameMixin = {}

local THROTTLE_EVENTS = {
  "AUCTION_HOUSE_THROTTLED_SYSTEM_READY",
}

function MagicButtonCommodityBuyFrameMixin:OnEvent(event, ...)
  if event == "AUCTION_HOUSE_THROTTLED_SYSTEM_READY" then 
    AuctionHouseFrame.BuyDialog.BuyNowButton:Click()
    FrameUtil.UnregisterFrameForEvents(self, THROTTLE_EVENTS)
  end
end

function MagicButtonCommodityBuyFrameMixin:ButtonPress()
  AuctionHouseFrame.CommoditiesBuyFrame.BuyDisplay.BuyButton:Click()

  FrameUtil.RegisterFrameForEvents(self, THROTTLE_EVENTS)
end
