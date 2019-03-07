import { IonicModule } from '@ionic/angular';
import { RouterModule } from '@angular/router';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { TranslateModule } from '@ngx-translate/core';
import { NgPipesModule } from 'ngx-pipes';

import { MenuPage } from './menu.page';
import { ListComponent } from './list/list.component';
import { EditComponent } from './edit/edit.component';

@NgModule({
  imports: [
    IonicModule,
    CommonModule,
    FormsModule,
    TranslateModule,
    NgPipesModule,
    RouterModule.forChild([
      {
        path: '',
        component: MenuPage,
        children: [
          {
            path: ':id',
            component: ListComponent,
          },
          {
            path: '',
            redirectTo: 'page',
            pathMatch: "full"
          }
        ]
      }
    ])
  ],
  declarations: [
    MenuPage,
    ListComponent,
  ]
})
export class MenuPageModule { }
