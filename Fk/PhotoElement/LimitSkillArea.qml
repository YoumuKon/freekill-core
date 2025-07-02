// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

ColumnLayout {
  id: root

  Repeater {
    id: rep
    model: ListModel {
      id: skills
    }
    LimitSkillItem {
      skillname: skillname_
      usedtimes: times
    }
  }

  function update(skill, times) {
    for (let i = 0; i < rep.count; i++) {
      const data = skills.get(i);
      if (data.skillname_ === skill) {
        data.times = times;
        if (times == -1) {
          skills.remove(i);
        }
        return;
      }
    }
    skills.append({
      skillname_: skill,
      times: times,
    });
  }

  function refresh(skill_time) {
    skills.clear();
    for (let i = 0; i < skill_time.length; i++) {
      if (skill_time[i][1] > -1) {
        skills.append({
          skillname_: skill_time[i][0],
          times: skill_time[i][1]
        });
      }
    }
  }

}
