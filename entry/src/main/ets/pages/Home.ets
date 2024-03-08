import hilog from '@ohos.hilog'
import Api from '../net/Api'
import { Banner } from '../net/model/BannerBean'
import { LoadState, PageLoading } from '../widgets/PageLoading'
import { TitleLayout } from '../widgets/TitleLayout'
import { BannerBuilder } from '../widgets/BannerBuilder'
import { CategoryGrid } from '../widgets/CategoryGrid'
import { CategoryData } from '../net/model/CategoryBean'
import { GoodData } from '../net/model/GoodBean'

@Component
export struct Home {
  private swiperController: SwiperController = new SwiperController()
  @State data: Array<Banner> = []; //轮播图
  @State cateData: Array<CategoryData> = []; //分类
  @State hotBannerData: Array<Banner> = []; //热销banner
  @State hotGoodData: Array<GoodData> = []; //热销商品
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

    this.loadHotBanner().then((data) => {
      this.hotBannerData = data
    })

    this.loadHotGood().then((data) => {
      this.hotGoodData = data
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

  async loadHotBanner(): Promise<Array<Banner>> {
    let bannerRes = await Api.get().getHomeBanner();
    return bannerRes.result
  }

  async loadHotGood(): Promise<Array<GoodData>> {
    let goodRes = await Api.get().getHotGood();
    return goodRes.result
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

              }
            })
          }
          //small image
          Image($r("app.media.xiaomi_banner")).width("100%").height(32)
          //category
          CategoryGrid({ categoryList: this.cateData })
          //post
          Image($r("app.media.xiaomi_post"))
            .objectFit(ImageFit.Auto)
            .borderRadius(8)
            .height(120)
            .width("99%")
          //hot good title
          Row() {
            Text("热门甄选").fontSize(15).fontWeight(600)
            Text("更多手机推荐 >").fontSize(14).margin({ right: 15 })
          }.justifyContent(FlexAlign.SpaceBetween).width("100%").padding(10)
          //hot good expanded
          Row() {
            Swiper(this.swiperController) {
              ForEach(this.hotBannerData, (item) => {
                Image("https://lmg.jj20.com/up/allimg/1112/04051Z03929/1Z405003929-4-1200.jpg") //getBaseImgUrl(data.pic)
                  .borderRadius(8)
                  .objectFit(ImageFit.Cover)
                  .alt($r('app.media.icon'))
                  .width('100%')
                  .height('100%')
              })
            }
            .autoPlay(true)
            .index(this.bannerPosition)
            .loop(true)
            .indicatorStyle({
              size: 12,
              color: $r("app.color.hot_key_bg"),
              selectedColor: $r("app.color.navi_tab_unselect"),
              bottom: 0
            })
            .onChange((index) => {
              this.bannerPosition = index;
            })
            .height('100%')
            .width(0)
            .layoutWeight(1)

            Row() {

            }.width(10).height("100%")

            List({ space: 5, initialIndex: 0 }) {
              ForEach(this.hotGoodData, (item: GoodData, index) => {
                ListItem() {
                  Row() {
                    Column() {
                      Text(item.title).fontWeight(600).fontSize(14).textAlign(TextAlign.Center)
                      Text(item.sub_title).fontSize(12).textAlign(TextAlign.Center).margin({top:5,bottom:5})
                      Text("¥ " + item.price + "元").fontWeight(500).fontSize(13).textAlign(TextAlign.Center)
                    }.width(0)
                    .layoutWeight(3)
                    .height(97)
                    .justifyContent(FlexAlign.Center)

                    Image($r("app.media.icon")).width(0).height(40).layoutWeight(2)
                  }.borderRadius(10)
                  .padding({right:10})
                  .backgroundColor($r("app.color.hot_key_bg"))
                }
              }, (item, index) => item)
            }
            .listDirection(Axis.Vertical)
            .width(0)
            .layoutWeight(1)
            .height(300)
          }.height(300).justifyContent(FlexAlign.SpaceBetween).padding({ left: 10, right: 10 })
        }.alignItems(HorizontalAlign.Center).margin({ bottom: 15 })
      }.scrollBar(BarState.Off).width('100%').height('100%')
    }
  }
}
