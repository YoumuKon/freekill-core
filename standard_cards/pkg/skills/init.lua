local prefix = "packages.standard_cards.pkg.skills."
if UsingNewCore then
  prefix = "packages.freekill-core.standard_cards.pkg.skills."
end

return {
  require(prefix .. "slash"),
  require(prefix .. "jink"),
}
