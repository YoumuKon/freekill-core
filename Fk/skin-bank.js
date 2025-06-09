// SPDX-License-Identifier: GPL-3.0-or-later

// TODO 这排var都得不能让外部直接调用了 改成基于函数调用
// SkinBank.getSystemPic(PHOTO_DIR, path)之类的
// 这样美化包就可以把path拐到resource_pak/xxx/packages/freekill-core/...下面
// 由于要全改SkinBank.XXX 留给后来人
//var AppPath = "file:///home/notify/develop/FreeKill";
var PHOTO_BACK_DIR = AppPath + "/image/photo/back/";
var PHOTO_DIR = AppPath + "/image/photo/";
var GENERAL_DIR = AppPath + "/image/generals/";
var GENERALCARD_DIR = AppPath + "/image/card/general/";
var STATE_DIR = AppPath + "/image/photo/state/";
var STATUS_DIR = AppPath + "/image/photo/status/";
var ROLE_DIR = AppPath + "/image/photo/role/";
var DEATH_DIR = AppPath + "/image/photo/death/";
var MAGATAMA_DIR = AppPath + "/image/photo/magatama/";
var LIMIT_SKILL_DIR = AppPath + "/image/photo/skill/";
var CARD_DIR = AppPath + "/image/card/";
var CARD_SUIT_DIR = AppPath + "/image/card/suit/";
var DELAYED_TRICK_DIR = AppPath + "/image/card/delayedTrick/";
var EQUIP_ICON_DIR = AppPath + "/image/card/equipIcon/";
var PIXANIM_DIR = AppPath + "/image/anim/"
var TILE_ICON_DIR = AppPath + "/image/button/tileicon/"
var LOBBY_IMG_DIR = AppPath + "/image/lobby/";
var MISC_DIR = AppPath + "/image/misc/";

const searchPkgResource = function(path, name, suffix) {
  const dirs = Backend.ls(AppPath + "/packages/").filter(dir =>
    !Pacman.getDisabledPacks().includes(dir) &&
      !dir.endsWith(".disabled")
  );
  if (typeof config !== "undefined" && config.enabledResourcePacks) {
    for (const packName of config.enabledResourcePacks) {
      for (const dir of dirs) {
        const resPath = AppPath + "/resource_pak/" + packName + "/packages/" + dir + path + name + suffix;
        if (Backend.exists(resPath)) return resPath;
      }
    }
  }

  let ret;
  for (const dir of dirs) {
    ret = AppPath + "/packages/" + dir + path + name + suffix;
    if (Backend.exists(ret)) return ret;
  }
}

const searchPkgResourceWithExtension = function(extension, path, name, suffix) {
  if (typeof config !== "undefined" && config.enabledResourcePacks) {
    for (const packName of config.enabledResourcePacks) {
      const resPath = AppPath + "/resource_pak/" + packName + "/packages/" + extension + path + name + suffix;
      if (Backend.exists(resPath)) return resPath;
    }
  }

  const ret = AppPath + "/packages/" + extension + path + name + suffix;
  if (Backend.exists(ret)) return ret;
}

function getGeneralExtraPic(name, extra) {
  const data = lcall("GetGeneralData", name);
  const extension = data.extension;
  const ret = searchPkgResourceWithExtension(extension, "/image/generals/" + extra, name, ".jpg");
  return ret;
}

function getGeneralPicture(name) {
  const data = lcall("GetGeneralData", name);
  const extension = data.extension;
  const ret = searchPkgResourceWithExtension(extension, "/image/generals/", name, ".jpg");

  if (ret) return ret;
  return GENERAL_DIR + "0.jpg";
}

function getCardPicture(cidOrName) {
  let extension = "";
  let name = "unknown";
  if (typeof cidOrName === 'string') {
    name = cidOrName;
    extension = lcall("GetCardExtensionByName", cidOrName);
  } else {
    const data = lcall("GetCardData", cidOrName);
    extension = data.extension;
    name = data.name;
  }

  let ret = searchPkgResourceWithExtension(extension, "/image/card/", name, ".png");
  if (!ret) {
    ret = searchPkgResource("/image/card/", name, ".png");
  }

  if (ret) return ret;
  return CARD_DIR + "unknown.png";
}

function getDelayedTrickPicture(name) {
  const extension = lcall("GetCardExtensionByName", name);
  let ret = searchPkgResourceWithExtension(extension, "/image/card/delayedTrick/", name, ".png");
  if (!ret) {
    ret = searchPkgResource("/image/card/delayedTrick/", name, ".png");
  }

  if (ret) return ret;
  return DELAYED_TRICK_DIR + "unknown.png";
}


function getEquipIcon(cid, icon) {
  const data = lcall("GetCardData", cid);
  const extension = data.extension;
  const name = icon || data.name;
  let ret = searchPkgResourceWithExtension(extension, "/image/card/equipIcon/", name, ".png");
  if (!ret) {
    ret = searchPkgResource("/image/card/equipIcon/", name, ".png");
  }

  if (ret) return ret;
  return EQUIP_ICON_DIR + "unknown.png";
}

// TODO
function getPhotoBack(kingdom) {
  let path = PHOTO_BACK_DIR + kingdom + ".png";
  if (!Backend.exists(path)) {
    let ret = searchPkgResource("/image/kingdom/", kingdom, "-back.png");
    if (ret) return ret;
  } else {
    return path;
  }
  return PHOTO_BACK_DIR + "unknown";
}

function getGeneralCardDir(kingdom) {
  let path = GENERALCARD_DIR + kingdom + ".png";
  if (!Backend.exists(path)) {
    let ret = searchPkgResource("/image/kingdom/", kingdom, "-back.png");
    if (ret) return ret.slice(0, ret.lastIndexOf('/')) + "/";
  } else {
    return GENERALCARD_DIR;
  }
}

//身份和死亡嘛先算了吧
function getRolePic(role) {
  let path = ROLE_DIR + role + ".png";
  if (Backend.exists(path)) {
    return path;
  } else {
    let ret = searchPkgResource("/image/role/", role, ".png");
    if (ret) return ret;
  }
  return ROLE_DIR + "unknown.png";
}

function getRoleDeathPic(role) {
  let path = DEATH_DIR + role + ".png";
  if (Backend.exists(path)) {
    return path;
  } else {
    let ret = searchPkgResource("/image/role/death/", role, ".png");
    if (ret) return ret;
  }
  return DEATH_DIR + "hidden.png";
}

//mark嘛先算了吧
function getMarkPic(mark) {
  let ret = searchPkgResource("/image/mark/", mark, ".png");
  if (ret) return ret;
  return "";
}
