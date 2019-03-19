export interface Menu {
  /**
   * id
   */
  id: string
  /**
   * tags: all, chrome...
   */
  tags?: string[]
  /**
   * name
   */
  name?: string
  /**
   * title
   */
  title?: string
  /**
   * back
   */
  back?: boolean
  /**
   * incognito
   */
  incognito?: boolean
  /**
   * contexts: "all", "page", "frame", "selection", "link", "editable", "image", "video", "audio"
   * old:TXT, MEN, PIC, LIN
   */
  contexts: string[]
  /**
   * language
   */
  language: string
  /**
   * URL
   */
  url: string
  /**
   * value
   */
  value?: number
  /**
   * select
   */
  select?: boolean
  /**
   * order
   */
  order?: number
  // h: m.h
  // k: m.k
}
