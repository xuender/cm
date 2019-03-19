import { Injectable } from '@angular/core';

import { chain, findIndex, some, includes } from 'lodash';

import { Context } from './context';
import { Menu } from './menu';

@Injectable({
  providedIn: 'root'
})
export class ContextService {
  contexts: Context[] = [
    { name: 'page', open: true, icon: 'menu' },
    { name: 'selection', open: false, icon: 'crop' },
    { name: 'image', open: false, icon: 'image' },
    { name: 'link', open: false, icon: 'link' },
  ]
  tags = new Set<string>()
  constructor() { }

  icon(c: string) {
    return chain<Context[]>(this.contexts)
      .filter(t => t.name == c)
      .first()
      .value()
      .icon
  }

  sort(m: Menu) {
    return `${findIndex(this.contexts, t => includes(m.contexts, t.name))}${m.name}${m.id}`
  }

  isOpen(m: Menu) {
    return some<Context>(this.contexts, c => c.open && includes(m.contexts, c.name))
  }
}
