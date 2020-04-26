function ScriptedAbility( event )
  local caster = event.caster
  local target = event.target
  local ability = event.ability

  local healthPercentage = ability:GetLevelSpecialValueFor("health_percentage", (ability:GetLevel() - 1))

  if target:GetHealthPercent() < healthPercentage then
    target:Kill(nil, caster)
  end
end