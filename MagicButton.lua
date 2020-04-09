function MagicButton()
  if AuctionHouseFrame.displayMode == AuctionHouseFrameDisplayMode.ItemSell then
    AuctionHouseFrame.ItemSellFrame:PostItem()
  end
  if AuctionHouseFrame.displayMode == AuctionHouseFrameDisplayMode.CommoditiesSell then
    AuctionHouseFrame.CommoditiesSellFrame:PostItem()
  end
end
