export interface Menu {
  /**
   * tag: all, chrome...
   */
  t?: string[]
  /**
   * name
   */
  n?: string
  /**
   * title
   */
  e?: string
  /**
   * back
   */
  b?: boolean
  /**
   * code
   */
  c: string
  /**
   * incognito
   */
  i?: boolean
  /**
   * menu type: now: page, selection, image, link
   * old:TXT, MEN, PIC, LIN
   */
  m: string
  /**
   * language
   */
  l: string
  /**
   * URL
   */
  u: string
  /**
   * value
   */
  v?: number
  /**
   * select
   */
  s?: boolean
  /**
   * order
   */
  o?: number
  // h: m.h
  // k: m.k
}
