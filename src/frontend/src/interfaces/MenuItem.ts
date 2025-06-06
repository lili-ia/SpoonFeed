import type { MenuItemStatus } from "../enums/MenuItemStatus";

export interface MenuItem {
  id: string;
  name: string;
  ingredients: string;
  status: MenuItemStatus;
  price: number;
  currencyCode: "uah";
  menuItemCategoryId: string;
  weight: number;
  image: string;
}
