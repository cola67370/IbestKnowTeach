// import { router } from '@kit.ArkUI'
// import { RouterConstant } from '../../contants/RouterConstant'
// import { CommonConstant } from '../../contants/CommonConstant'
// import { ArticleComponent } from '../../components/ArticleComponent'
// import articleContentApi from '../../api/ArticleContentApi'
// import { LoadingComponent } from '../../components/LoadingComponent'
// import { ArticleContentData } from '../../api/ArticleContentApi.type'
// import { showToast } from '../../utils/Toast'
//
// @Entry
// @Component
// export struct Home {
//   // 是否展示最新标题的下划线
//   @State newDividerShow: boolean = true
//   // 是否展示热门标题的下划线
//   @State hotDividerShow: boolean = false
//   // 搜索词
//   @State keyword: string = ''
//   // 标题
//   @State title: string = ''
//   // 文章数据数组
//   @State articleContentList: ArticleContentData[] = []
//   // 学习打卡总记录数
//   @State total: number = 0
//   // 当前页
//   @State page: number = 1
//   // 每一页大小
//   @State pageSize: number = 7
//   // 控制当前页面展示
//   @State isShow: boolean = false
//   // 定义一个状态属性，用来和Refresh组件进行双向数据绑定
//   @State isRefreshing: boolean = false
//   // 节流, false表示未请求, true表示正在请求
//   isLoad: boolean = false
//   // 是否展示文本，列表到底
//   @State textShow: boolean = false
//
//   /**
//    * 生命周期函数
//    */
//   async aboutToAppear() {
//     // 默认获取首页最新文章内容
//     this.getArticleNewDataList(true, false)
//   }
//
//   /**
//    * 分页查询最新文章数据
//    */
//   async getArticleNewDataList(isFlushed: boolean, isUpdate: boolean) {
//     // 分页查询最新文章数据
//     const articleDataList =
//       await articleContentApi.getNewArticle({ page: this.page, pageSize: this.pageSize, title: this.title })
//     isFlushed ? this.articleContentList = articleDataList.records :
//     this.articleContentList.push(...articleDataList.records)
//     this.total = articleDataList.total
//     // 判断总数据
//     if (this.total > this.page * this.pageSize) {
//       this.textShow = false
//     } else {
//       this.textShow = true
//     }
//     // 页面展示
//     this.isShow = true
//     // 节流，防止用户重复下拉
//     this.isLoad = false
//     this.isRefreshing = false
//     // 是否刷新
//     if (isUpdate) {
//       showToast("已更新")
//     }
//   }
//
//   /**
//    * 分页查询最热门文章数据
//    */
//   async getArticleHotDataList(isFlushed: boolean, isUpdate: boolean) {
//     // 分页查询最热门文章数据
//     const articleDataList =
//       await articleContentApi.getHotArticle({ page: this.page, pageSize: this.pageSize, title: this.title })
//     isFlushed ? this.articleContentList = articleDataList.records :
//     this.articleContentList.push(...articleDataList.records)
//     this.total = articleDataList.total
//     // 判断总数据
//     if (this.total > this.page * this.pageSize) {
//       this.textShow = false
//     } else {
//       this.textShow = true
//     }
//     // 页面展示
//     this.isShow = true
//     // 节流，防止用户重复下拉
//     this.isLoad = false
//     this.isRefreshing = false
//     // 是否刷新
//     if (isUpdate) {
//       showToast("已更新")
//     }
//   }
//
//   /**
//    * 分页查询文章数据
//    */
//   async getArticleDataList(isFlushed: boolean) {
//     // 分页查询文章数据
//     if (this.newDividerShow) {
//       this.getArticleNewDataList(isFlushed, true)
//     }
//     if (this.hotDividerShow) {
//       this.getArticleHotDataList(isFlushed, true)
//     }
//   }
//
//   build() {
//     Column() {
//       // 标题栏
//       Row({ space: 10 }) {
//         Column() {
//           Text($r('app.string.article_best_new'))
//             .textStyles()
//           // 选中标题会出现下划线
//           if (this.newDividerShow) {
//             Divider().dividerStyles()
//           }
//         }
//         .onClick(() => {
//           // 展示下划线
//           this.hotDividerShow = false
//           this.newDividerShow = true
//           // 查询最新文章数据
//           this.isShow = false
//           this.page = 1
//           this.getArticleNewDataList(true, true)
//         })
//
//         Column() {
//           Text($r('app.string.article_best_hot'))
//             .textStyles()
//           // 选中标题会出现下划线
//           if (this.hotDividerShow) {
//             Divider().dividerStyles()
//           }
//         }
//         .onClick(() => {
//           this.newDividerShow = false
//           this.hotDividerShow = true
//           // 查询最热门文章数据
//           this.isShow = false
//           this.page = 1
//           this.getArticleHotDataList(true, true)
//         })
//
//       }.justifyContent(FlexAlign.Start)
//       .margin({ top: 10, bottom: 20 })
//       .width(CommonConstant.WIDTH_FULL)
//
//       // 搜索
//       Search({ placeholder: '请输入关键字', value: $$this.keyword })
//         .placeholderFont({ size: 14 })
//         .textFont({ size: 14 })
//         .onSubmit(() => {
//           // 处理标题
//           this.title = encodeURIComponent(this.keyword)
//           // 分页查询文章内容
//           this.isShow = false
//           this.page = 1
//           this.getArticleDataList(true)
//         })
//         .width(CommonConstant.WIDTH_FULL)
//         .height(30)
//
//       if (this.isShow) {
//         Refresh({ refreshing: $$this.isRefreshing }) {
//           // 内容组件
//           List() {
//             ForEach(this.articleContentList, (item: ArticleContentData) => {
//               ListItem() {
//                 ArticleComponent({ articleContentData: item })
//                   .onClick(() => {
//                     // 路由到内容详情页
//                     router.pushUrl({
//                       url: RouterConstant.VIEWS_HOME_ARTICLE_INFO, params: {
//                         "articleId": item.id
//                       }
//                     })
//                   })
//               }
//             })
//             if (this.textShow) {
//               ListItem() {
//                 Text($r('app.string.no_have_article'))
//                   .fontColor($r('app.color.common_gray'))
//                   .fontSize($r('app.float.common_font_size_small'))
//                   .width(CommonConstant.WIDTH_FULL)
//                   .textAlign(TextAlign.Center)
//                   .margin({ top: 80 })
//               }
//             }
//           }
//           .width(CommonConstant.WIDTH_FULL)
//           .height(CommonConstant.HEIGHT_FULL)
//           .scrollBar(BarState.Off)
//           .onReachEnd(() => {
//             if (!this.isLoad) {
//               if (this.total > this.page * this.pageSize) {
//                 this.isLoad = true
//                 this.page++
//                 if (this.newDividerShow) {
//                   // 分页查询最新文章数据
//                   this.getArticleNewDataList(false, false)
//                 }
//                 if (this.hotDividerShow) {
//                   // 分页查询最热门文章数据
//                   this.getArticleHotDataList(false, false)
//                 }
//               } else {
//                 this.textShow = true
//               }
//
//             }
//           })
//         }
//         .onRefreshing(() => {
//           if (!this.isLoad) {
//             this.isLoad = true
//             this.textShow = false
//             // 页面恢复到1
//             this.page = 1
//             if (this.newDividerShow) {
//               // 分页查询最新文章数据
//               this.getArticleNewDataList(true, true)
//             }
//             if (this.hotDividerShow) {
//               // 分页查询最热门文章数据
//               this.getArticleHotDataList(true, true)
//             }
//
//           }
//         })
//       } else {
//         // 加载组件
//         LoadingComponent()
//       }
//
//     }.padding($r('app.float.common_padding'))
//     .height(CommonConstant.HEIGHT_FULL)
//     .width(CommonConstant.WIDTH_FULL)
//
//   }
// }
//
// @Extend(Text)
// function textStyles() {
//   .fontSize($r('app.float.common_font_size_huge'))
//   .fontWeight(FontWeight.Medium)
// }
//
// @Extend(Divider)
// function dividerStyles() {
//   .color(Color.Black)
//   .width($r('app.float.common_width_tiny'))
//   .strokeWidth(3)
// }


import prompt from '@ohos.prompt';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
export struct Home {
  @State isBlocking: boolean = false

  build() {
    Column() {
      Text("🏠 首页 - 主线程阻塞演示")
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      Button(this.isBlocking ? "正在阻塞..." : "点击模拟主线程卡顿")
        .backgroundColor(this.isBlocking ? '#FF6B6B' : '#1698CE')
        .fontColor('#FFFFFF')
        .onClick(() => {
          if (this.isBlocking) {
            prompt.showToast({ message: '正在阻塞中，请稍候…' })
            return
          }
          this.simulateMainThreadBlock()
        })
        .margin({ bottom: 40 })

      Text("点击上方按钮后，界面将冻结约3秒。")
        .fontSize(16)
        .fontColor('#555')
        .textAlign(TextAlign.Center)
        .width('90%')
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .height('100%')
    .width('100%')
  }

  // 模拟主线程阻塞函数
  simulateMainThreadBlock() {
    this.isBlocking = true
    prompt.showToast({ message: '开始阻塞主线程 3 秒...' })
    hilog.info(0x0001, 'BLOCK', 'UI blocking started')

    // 同步忙循环3秒，阻塞主线程
    const start = Date.now()
    while (Date.now() - start < 3000) {
      // 模拟复杂计算任务
      Math.sqrt(Math.random() * 1000000)
    }

    hilog.info(0x0001, 'BLOCK', 'UI blocking ended')
    prompt.showToast({ message: '阻塞结束！' })
    this.isBlocking = false
  }
}
