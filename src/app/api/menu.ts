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
   * "normal", "checkbox", "radio", "separator"
   */
  type?: string
  /**
   * back
   */
  back?: boolean
  /**
   * incognito
   */
  incognito?: boolean
  /**
   * contexts: "all", "page", "frame", "selection", "link", "editable", "image", "video", "audio", "launcher", "browser_action", "page_action"
   * old:TXT, MEN, PIC, LIN
   */
  contexts: string[]
  /**
   * language
   */
  language?: string
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
