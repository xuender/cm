import { IonicModule } from '@ionic/angular';
import { RouterModule } from '@angular/router';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { TranslateModule } from '@ngx-translate/core';

import { MenuPage } from './menu.page';

@NgModule({
  imports: [
    IonicModule,
    CommonModule,
    FormsModule,
    TranslateModule,
    RouterModule.forChild([{ path: '', component: MenuPage }])
    // RouterModule.forChild([
    //   {
    //     path: '',
    //     component: MenuPage,
    //     children: [
    //       {
    //         path: ':id',
    //         component: ListComponent,
    //       },
    //       {
    //         path: '',
    //         redirectTo: 'page',
    //         pathMatch: "full"
    //       }
    //     ]
    //   }
    // ])
  ],
  declarations: [
    MenuPage,
  ]
})
export class MenuPageModule { }
