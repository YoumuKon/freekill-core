local prefix = "packages."
if UsingNewCore then prefix = "packages.freekill-core." end

return {
  require(prefix .. "standard.pkg.skills.jianxiong"),
  require(prefix .. "standard.pkg.skills.hujia"),
  require(prefix .. "standard.pkg.skills.guicai"),
  require(prefix .. "standard.pkg.skills.fankui"),
  require(prefix .. "standard.pkg.skills.ganglie"),
}
