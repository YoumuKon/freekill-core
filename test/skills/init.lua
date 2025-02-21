local prefix = "packages.test.skills."
if UsingNewCore then prefix = "packages.freekill-core.test.skills." end


return {
  require(prefix .. "cheat"),
  require(prefix .. "control"),
  require(prefix .. "damage_maker"),
  require(prefix .. "test_zhenggong"),
  require(prefix .. "change_hero"),
}
