import hilog from '@ohos.hilog'
import Api from '../net/Api'
import { Banner } from '../net/model/BannerBean'
import { LoadState, PageLoading } from '../widgets/PageLoading'
import router from '@ohos.router'
import { TitleLayout } from '../widgets/TitleLayout'
import { BannerBuilder } from '../widgets/BannerBuilder'
import { CategoryGrid } from '../widgets/CategoryGrid'
import { CategoryData } from '../net/model/CategoryBean'

@Component
export struct Home {
  @State data: Array<Banner> = [];
  @State cateData: Array<CategoryData> = [];
  @State loadState: LoadState = LoadState.LOADING;
  @State showLoading: boolean = false;
  @State bannerPosition: number = 0;
  @State title: string = "首页";
  private tag = "Home";
  scroller: Scroller = new Scroller()

  async aboutToAppear() {
    hilog.info(0, this.tag, "aboutToAppear")
    this.loadData();
  }

  async loadData() {
    this.loadState = LoadState.LOADING
    this.loadBannerData().then(
      (data) => {
        this.data = data;
        if (this.data.length === 0) {
          this.loadState = LoadState.EMPTY;
        } else {
          this.loadState = LoadState.SUCCESS;
        }
      },
      () => {
        this.loadState = LoadState.FAIL;
      })

    this.loadCategoryData().then(
      (cateData) => {
        this.cateData = cateData;
      })
  }

  async loadBannerData(): Promise<Array<Banner>> {
    let bannerRes = await Api.get().getHomeBanner();
    return bannerRes.result
  }

  async loadCategoryData(): Promise<Array<CategoryData>> {
    let cateRes = await Api.get().getHomeCategory();
    return cateRes.result
  }

  build() {

    PageLoading({
      loadState: $loadState,
      showLoading: $showLoading,
      onReload: () => {
        hilog.debug(0, this.tag, "onReload");
        this.loadData();
      }
    }) {
      Scroll(this.scroller) {
        Column() {
          //banner
          Stack({ alignContent: Alignment.Top }) {
            BannerBuilder({
              bannerList: this.data
            })
            TitleLayout({
              title: $title,
              showBack: false,
              menuIcon: $r("app.media.ic_search"),
              onMenuClick: () => {
                router.pushUrl({
                  url: 'pages/SearchEntry'
                });
              }
            })
          }
          //small image
          Image($r("app.media.xiaomi_banner")).width("100%").height(32)
          //category
          CategoryGrid({ categoryList: this.cateData })
          //post
          Image($r("app.media.xiaomi_post")).objectFit(ImageFit.Auto).borderRadius(8).height(120).width("98%")
        }
        .width('100%')
        .height('100%')
        .alignItems(HorizontalAlign.Center)
      }
    }
  }
}
