MagicButtonCommodityBuyFrameMixin = {}

local THROTTLE_EVENTS = {
  "AUCTION_HOUSE_THROTTLED_SYSTEM_READY",
}

function MagicButtonCommodityBuyFrameMixin:OnEvent(event, ...)
  if event == "AUCTION_HOUSE_THROTTLED_SYSTEM_READY" then 
    local newAmount = AuctionHouseFrame.BuyDialog.PriceFrame:GetAmount()
    local oldAmount = AuctionHouseFrame.CommoditiesBuyFrame.BuyDisplay.TotalPrice:GetAmount()
    if newAmount <= oldAmount then
      AuctionHouseFrame.BuyDialog.BuyNowButton:Click()
    else
      MagicButton_Print(MAGIC_BUTTON_L_COMMODITY_PRICE_INCREASED)
      AuctionHouseFrame.BuyDialog.CancelButton:Click()
    end
    FrameUtil.UnregisterFrameForEvents(self, THROTTLE_EVENTS)
  end
end

function MagicButtonCommodityBuyFrameMixin:ButtonPress()
  AuctionHouseFrame.CommoditiesBuyFrame.BuyDisplay.BuyButton:Click()

  FrameUtil.RegisterFrameForEvents(self, THROTTLE_EVENTS)
end
