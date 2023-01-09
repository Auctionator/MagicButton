function MagicButton()
  if AuctionHouseFrame.ItemSellFrame:IsVisible() then
    AuctionHouseFrame.ItemSellFrame:PostItem()
  end
  if AuctionHouseFrame.CommoditiesSellFrame:IsVisible() then
    AuctionHouseFrame.CommoditiesSellFrame:PostItem()
  end
  if AuctionHouseFrame.ItemBuyFrame:IsVisible() then
    if AuctionHouseFrame.ItemBuyFrame.BidFrame.BidButton:IsEnabled() and
        (IsAltKeyDown() or not AuctionHouseFrame.ItemBuyFrame.BuyoutFrame.BuyoutButton:IsEnabled()) then
      AuctionHouseFrame.ItemBuyFrame.BidFrame.BidButton:Click()
    else
      AuctionHouseFrame.ItemBuyFrame.BuyoutFrame.BuyoutButton:Click()
    end
    StaticPopup1Button1:Click()
  end
  if AuctionHouseFrame.CommoditiesBuyFrame:IsVisible() then
    MagicButton_BuyCommodityMagic()
  end
  if AuctionHouseFrameAuctionsFrame:IsVisible() then
    AuctionHouseFrameAuctionsFrame.CancelAuctionButton:Click()
    StaticPopup1Button1:Click()
  end
end

function MagicButton_Print(message)
  print("|cc935e0ffMagic Button|r: " .. message)
end

local function CreateCommodityBuyFrame()
  if not MagicButtonUndercutFrame then
    frame = CreateFrame(
      "FRAME",
      "MagicButtonCommodityBuyFrame",
      nil,
      "MagicButtonCommodityBuyFrameTemplate"
    )
  end
end

function MagicButton_CancelAuctionMagic()
  if not MagicButtonUndercutFrame then
    CreateUndercutFrame()
  end
  MagicButtonUndercutFrame:ButtonPress()
end

function MagicButton_BuyCommodityMagic()
  if not MagicButtonCommodityBuyFrame then
    CreateCommodityBuyFrame()
  end
  MagicButtonCommodityBuyFrame:ButtonPress()
end
