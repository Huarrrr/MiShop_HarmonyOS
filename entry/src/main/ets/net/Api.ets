import http from '@ohos.net.http';
import hilog from '@ohos.hilog';
import { Banner } from './model/BannerBean';
import uri from '@ohos.uri';
import PersistentCookieJar from './cookie/PersistentCookieJar';
import CookieJar from './cookie/CookieJar';
import EntryContext from '../common/EntryContext';
import CookieUtils from './cookie/CookieUtils';
import { Response } from './model/Response';
import data from '@ohos.telephony.data';
import image from '@ohos.multimedia.image';
import { CategoryData } from './model/CategoryBean';
import { GoodData } from './model/GoodBean';

let TAG = "Api";

export const BASE_URL: string = "https://miapp.itying.com";

let cookieJar: CookieJar = new PersistentCookieJar(EntryContext.getContext() as Context);

function parseUri(url: string): uri.URI {
  return new uri.URI(url);
}

async function requestSync<T>(path: string, method: http.RequestMethod, extraData?: Object): Promise<Response<T>> {
  await cookieJar.init();
  return new Promise<Response<T>>((resolve, reject) => {
    let url = BASE_URL + path;
    let uri = parseUri(url);
    let header = {};
    console.error("=========", url)
    let cookies = cookieJar.loadForRequest(uri);
    if (cookies.length > 0) {
      header["Cookie"] = CookieUtils.cookieHeader(cookies);
    }
    if (method === http.RequestMethod.POST) {
      header["Content-Type"] = "application/x-www-form-urlencoded";
      if (!extraData) {
        // POST 必须有请求体，否则会报 Parameter error
        extraData = {};
      }
    }
    let httpRequest = http.createHttp();
    header["Cache-Control"] = "no-cache"
    header["Pragma"] = "no-cache"
    header["If-Modified-Since"] = "0"
    hilog.info(0, TAG, `start request, path: ${path}, method: ${method}, extraData: ` + JSON.stringify(extraData));
    try {
      httpRequest.request(
        url,
        {
          method: method,
          expectDataType: http.HttpDataType.OBJECT,
          header: header,
          extraData: extraData
        },
        (err, data) => {
          let res = new Response<T>()
          console.error("=========dddd",JSON.stringify(data.responseCode))
          if (!err && data.responseCode === 200) {
            cookieJar.saveFromResponse(uri, CookieUtils.parseHttpRequestCookies(data.cookies))
            if (typeof data.result === 'string') {
              Object.assign(res, JSON.parse(data.result));
            } else {
              Object.assign(res, data.result);
            }
            hilog.info(0, TAG, `request success, path: ${path}, result: ${JSON.stringify(res)}`)
            resolve(res);
          } else {
            hilog.error(0, TAG, `request error, path: ${path}, error: ${JSON.stringify(err)}`)
            reject(err)
          }
        }
      )
    } catch (e) {
      console.error("err=========", e)
    }


  })
}

export default class Api {
  private static instance: Api;

  private constructor() {
  }

  static get(): Api {
    if (Api.instance === undefined) {
      Api.instance = new Api();
    }
    return Api.instance;
  }

  clearCookie() {
    cookieJar.clear();
  }


  async getHomeBanner(): Promise<Response<Array<Banner>>> {
    return requestSync("/api/focus", http.RequestMethod.GET);
  }
  async getHotBanner(): Promise<Response<Array<Banner>>> {
    return requestSync("/api/focus?position=2", http.RequestMethod.GET);
  }

  async getHomeCategory(): Promise<Response<Array<CategoryData>>> {
    return requestSync("/api/bestCate", http.RequestMethod.GET);
  }

  async getHotGood(): Promise<Response<Array<GoodData>>> {
    return requestSync("/api/plist?is_hot=1&pageSize=3", http.RequestMethod.GET);
  }

}
