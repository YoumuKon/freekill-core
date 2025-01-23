local prefix = "packages.standard.pkg.skills."
if UsingNewCore then
  prefix = "packages.freekill-core.standard.pkg.skills."
end

return {
  require(prefix .. "jianxiong"),
  require(prefix .. "hujia"),
  require(prefix .. "guicai"),
  require(prefix .. "fankui"),
  require(prefix .. "ganglie"),
  require(prefix .. "tuxi"),
  require(prefix .. "luoyi"),
  require(prefix .. "tiandu"),
  require(prefix .. "yiji"),
  require(prefix .. "luoshen"),


  require(prefix .. "guanxing"),


  require(prefix .. "tieqi"),


  require(prefix .. "jizhi"),



  require(prefix .. "jiuyuan"),


  require(prefix .. "keji"),
  require(prefix .. "kurou"),

  require(prefix .. "yingzi"),

  require(prefix .. "liuli"),

  require(prefix .. "lianying"),
  require(prefix .. "xiaoji"),

  require(prefix .. "wushuang"),


  require(prefix .. "biyue"),
}
