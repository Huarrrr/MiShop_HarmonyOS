import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import EntryContext from '../common/EntryContext';
import WindowUtils from '../common/WindowUtils';

export default class EntryAbility extends UIAbility {
  tag: string = "EntryAbility"

  onCreate(want, launchParam) {
    hilog.info(0x0000, this.tag, '%{public}s', 'Ability onCreate');
    EntryContext.setContext(this.context)
  }

  async onWindowStageCreate(windowStage) {

    // 1.获取应用主窗口。
    let windowClass = null;
    windowStage.getMainWindow((err, data) => {
      if (err.code) {
        console.error('Failed to obtain the main window. Cause: ' + JSON.stringify(err));
        return;
      }
      windowClass = data;
      console.info('Succeeded in obtaining the main window. Data: ' + JSON.stringify(data));

      // // 2.实现沉浸式效果：设置导航栏、状态栏不显示。
      // let names = ['navigation|status'];
      // windowClass.setWindowSystemBarEnable(names, (err) => {
      //   if (err.code) {
      //     console.error('Failed to set the system bar to be visible. Cause:' + JSON.stringify(err));
      //     return;
      //   }
      //   console.info('Succeeded in setting the system bar to be visible.');
      // });
    })
    // 3.为沉浸式窗口加载对应的目标页面。
    windowStage.loadContent("pages/Index", (err) => {
      if (err.code) {
        console.error('Failed to load the content. Cause:' + JSON.stringify(err));
        return;
      }
      console.info('Succeeded in loading the content.');
    });
  }
}
