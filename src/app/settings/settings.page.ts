import { Component } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';

import { StorageService } from '../api/storage.service';

@Component({
  selector: 'cm-settings',
  templateUrl: 'settings.page.html',
  styleUrls: ['settings.page.scss']
})
export class SettingsPage {
  constructor(
    public storage: StorageService,
    private translate: TranslateService,
  ) { }

  get language() {
    return this.storage.language
  }

  set language(language: string) {
    this.translate.use(language);
    this.storage.language = language
    console.log('language', language)
  }
}
