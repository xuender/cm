import { Injectable } from '@angular/core';
import { Type } from './type';
import { chain, findIndex, some } from 'lodash';
import { Menu } from './menu';

@Injectable({
  providedIn: 'root'
})
export class TypeService {
  types: Type[] = [
    { name: 'page', open: true, icon: 'menu' },
    { name: 'selection', open: false, icon: 'crop' },
    { name: 'image', open: false, icon: 'image' },
    { name: 'link', open: false, icon: 'link' },
  ]
  tags = new Set<string>()
  constructor() { }
  icon(type: string) {
    return chain<Type[]>(this.types)
      .filter(t => t.name == type)
      .first()
      .value()
      .icon
  }
  sort(m: Menu) {
    return `${findIndex(this.types, t => t.name == m.m)}${m.n}${m.c}`
  }
  inTypes(m: Menu) {
    return some<Type>(this.types, { name: m.m, open: true })
  }
}
