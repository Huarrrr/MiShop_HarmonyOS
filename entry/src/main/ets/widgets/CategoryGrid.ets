import { getBaseImgUrl } from '../common/StringUtils'
import { CategoryData } from '../net/model/CategoryBean'
//swiper + grid 翻页的宫格   分类
@Component
export struct CategoryGrid {
  private swiperController: SwiperController = new SwiperController()
  @State private gridPosition: number = 0
  categoryList: Array<CategoryData>
  categoryPage: Array<string>

  aboutToAppear(): void {
    let list = []
    let page = Math.ceil(this.categoryList.length / 10)
    for (var i = 1; i <= page; i++) {
      list.push(i.toString());
    }
    this.categoryPage = list
  }

  build() {
    Swiper(this.swiperController) {
      ForEach(this.categoryPage, (_, index) => {
        this.SwiperItem(index)
      })
    }
    .autoPlay(false)
    .index(this.gridPosition)
    .indicatorStyle({
      size: 12,
      color: $r("app.color.hot_key_bg"),
      selectedColor: $r("app.color.navi_tab_unselect"),
      bottom: 0
    })
    .onChange((index) => {
      this.gridPosition = index;
    })
    .width('100%')
    .padding(15)
  }

  @Builder
  SwiperItem(pageNum: number) {
    Grid() {
      ForEach(getPageCategory(this.categoryList, pageNum), (item: CategoryData) => {
        GridItem() {
          Column() {
            Image(getBaseImgUrl(item.pic)).alt($r('app.media.icon')).width(20).height(20)
            Text(item.title).fontSize(12).margin(5)
          }.width("100%").alignItems(HorizontalAlign.Center)
        }
      })
    }
    .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
    .rowsTemplate('1fr 1fr')
    .columnsGap(5)
    .rowsGap(5)
    .height(100)
    .width('100%')

  }
}

export function getPageCategory(categoryList: Array<CategoryData>, pageNum: number): Array<CategoryData> {
  let result: Array<CategoryData> = []
  if (pageNum === 0) {
    let end = categoryList.length > 10 ? 10 : categoryList.length
    result = categoryList.slice(0, end)
  } else {
    let start = pageNum * 10
    let end = categoryList.length < ((pageNum + 1) * 10 - 1) ? categoryList.length : (pageNum + 1) * 10
    result = categoryList.slice(start, end + 1)
  }
  return result
}