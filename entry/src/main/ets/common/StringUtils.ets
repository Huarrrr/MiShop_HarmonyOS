import { BASE_URL } from '../net/Api'

export function getBaseImgUrl(pic: string) :string {
  console.error("pic========",BASE_URL + '/' + pic)
  return BASE_URL + '/' + pic
}
