function DropItem( unit )
  local DropInfo = GameRules.DropTable[unit:GetUnitName()]
  if DropInfo then
    local total = 0
    for item_name,stack in pairs(DropInfo) do
        total = total + stack
    end
    local item_index = RandomInt(1, total)
    print(item_index)
    local index = 0
    for item_name,stack in pairs(DropInfo) do
      index = index + stack
      if item_index <= index then
          -- Create the item
          local item = CreateItem(item_name, nil, nil)
          local pos = unit:GetAbsOrigin()
          CreateItemOnPositionSync( pos, item )
          local pos_launch = pos+RandomVector(RandomFloat(150,200))
          item:LaunchLoot(false, 200, 0.75, pos_launch)
          break
      end
    end
end
end