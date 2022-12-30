MagicButtonCommodityBuyFrameMixin = {}

local BUY_EVENTS = {
  "COMMODITY_PRICE_UPDATED",
}

function MagicButtonCommodityBuyFrameMixin:OnEvent(event, ...)
  if event == "COMMODITY_PRICE_UPDATED" then
    local _, newAmount = ...
    local oldAmount = AuctionHouseFrame.CommoditiesBuyFrame.BuyDisplay.TotalPrice:GetAmount()
    if newAmount <= oldAmount then
      AuctionHouseFrame.BuyDialog.BuyNowButton:Click()
    else
      MagicButton_Print(MAGIC_BUTTON_L_COMMODITY_PRICE_INCREASED)
      AuctionHouseFrame.BuyDialog.CancelButton:Click()
    end
    FrameUtil.UnregisterFrameForEvents(self, BUY_EVENTS)
  end
end

function MagicButtonCommodityBuyFrameMixin:ButtonPress()
  AuctionHouseFrame.CommoditiesBuyFrame.BuyDisplay.BuyButton:Click()

  FrameUtil.RegisterFrameForEvents(self, BUY_EVENTS)
end
