import { Home } from './Home'
import { Category } from './Category'
import { Service } from './Service'
import { CartView } from './CartView'
import { Mine } from './Mine'
import OHPermission from '../common/OHPermission'

@Entry
@Component
struct Index {
  private tabsController = new TabsController()
  @State currentIndex: number = 0
  @State isPermissionGrant: boolean = false

  build() {
      Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
        TabContent() {
          Home()
        }.tabBar(this.TabBuilder("首页", 0, $r("app.media.ic_tab_home_fill"), $r("app.media.ic_tab_home")))

        TabContent() {
          Category()
        }.tabBar(this.TabBuilder("分类", 1, $r("app.media.ic_tab_discover_fill"), $r("app.media.ic_tab_discover")))

        TabContent() {
          Service()
        }.tabBar(this.TabBuilder("服务", 2, $r("app.media.ic_tab_tree_fill"), $r("app.media.ic_tab_tree")))

        TabContent() {
          CartView()
        }.tabBar(this.TabBuilder("购物车", 3, $r("app.media.ic_tab_wechat_fill"), $r("app.media.ic_tab_wechat")))

        TabContent() {
          Mine()
        }.tabBar(this.TabBuilder("我的", 4, $r("app.media.ic_tab_my_fill"), $r("app.media.ic_tab_my")))
      }
      .scrollable(false)
      .onChange((index) => {
        this.currentIndex = index
      })
      .backgroundColor($r("app.color.start_window_background"))

  }

  aboutToAppear() {
    OHPermission.requestPermission(getContext(this), ['ohos.permission.INTERNET'])
      .then((v) => {
        this.isPermissionGrant = true;
      })
      .catch((err) => {
        this.isPermissionGrant = false;
      })
  }

  @Builder
  TabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 24, height: 24 })
        .fillColor(this.currentIndex === targetIndex ? $r("app.color.main") : $r("app.color.navi_tab_unselect"))
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? $r("app.color.main") : $r("app.color.navi_tab_unselect"))
        .fontSize(11)
    }
    .width("100%")
    .height("100%")
    .backgroundColor($r("app.color.navi_bar_bg"))
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex
      this.tabsController.changeIndex(targetIndex)
    })
  }
}
