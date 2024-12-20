-- SPDX-License-Identifier: GPL-3.0-or-later

local pkgprefix = "packages/"
if UsingNewCore then pkgprefix = "packages/freekill-core/" end
dofile(pkgprefix .. "standard/game_rule.lua")
dofile(pkgprefix .. "standard/aux_skills.lua")
dofile(pkgprefix .. "standard/aux_poxi.lua")
Fk:appendKingdomMap("god", {"wei", "shu", "wu", "qun"})

require(pkgprefix .. "standard/i18n")

local extension = require(pkgprefix .. "standard/pkg")
return extension
