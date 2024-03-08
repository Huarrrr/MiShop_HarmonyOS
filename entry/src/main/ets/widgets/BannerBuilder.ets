import { toast } from '../common/Toast'
import { Banner } from '../net/model/BannerBean'

//轮播图组件
@Component
export struct BannerBuilder {
  private swiperController: SwiperController = new SwiperController()
  @State private bannerPosition: number = 0
  bannerList: Array<Banner>

  build() {
    Swiper(this.swiperController) {
      ForEach(this.bannerList, (item) => {
        this.BannerItemBuilder(item)
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
    .width('100%')
    .height(180)
  }

  @Builder
  BannerItemBuilder(data: Banner) {
    Stack({ alignContent: Alignment.Bottom }) {
      //TODO 模拟器无法显示png，等官方处理
      Image("https://lmg.jj20.com/up/allimg/1112/04051Z03929/1Z405003929-4-1200.jpg") //getBaseImgUrl(data.pic)
        .objectFit(ImageFit.Cover).alt($r('app.media.icon'))
        .width('100%')
        .height('100%')
    }
    .width('100%')
    .height('100%')
    .onClick(() => {
      toast(data.url)
    })
  }
}