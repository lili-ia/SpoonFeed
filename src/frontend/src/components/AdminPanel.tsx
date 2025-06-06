import { useState, useEffect } from "react";
import FacilityInformation from "./FacilityInformation";
import FacilityWorkingHours from "./FacilityWorkingHours";
import MenuItemList from "./MenuItemList";
import OrderManagement from "./OrderManagement";
import {
  getMenuItems,
  addMenuItem,
  updateMenuItem,
  deleteMenuItem,
  getMenuItemById,
} from "../services/menuItemService";
import {
  Clock,
  Info,
  UtensilsCrossed,
  ShoppingBag,
  LogOut,
} from "lucide-react";
import type { MenuItem } from "../interfaces/MenuItem";
import { useNavigate } from "react-router-dom";

const AdminPanel = ({ onLogout }) => {
  const [activeTab, setActiveTab] = useState("orders");
  const [menuItems, setMenuItems] = useState<MenuItem[]>([]);
  const navigate = useNavigate();

  const updateMenuItemHandler = async (updatedItem: MenuItem) => {
    try {
      const response = await updateMenuItem(updatedItem.id, updatedItem);
      setMenuItems((prev) =>
        prev.map((item) => (item.id === updatedItem.id ? response.data : item))
      );
    } catch (err) {
      console.error("Failed to update item:", err);
    }
  };

  const deleteMenuItemHandler = async (id: string) => {
    try {
      await deleteMenuItem(id);
      setMenuItems((prev) => prev.filter((item) => item.id !== id));
    } catch (err) {
      console.error("Failed to delete item:", err);
    }
  };

  const handleAddMenuItem = async (newItem: Omit<MenuItem, "id">) => {
    try {
      const response = await addMenuItem(newItem);
      const id = response.data; // GUID
      const fullItem = await getMenuItemById(id);
      setMenuItems((prev) => [...prev, fullItem.data]);
    } catch (err) {
      console.error("Failed to add menu item:", err);
    }
  };

  useEffect(() => {
    const fetchMenuItems = async () => {
      try {
        const response = await getMenuItems();
        setMenuItems(response.data);
      } catch (err) {
        console.error("Failed to fetch menu items:", err);
      }
    };

    fetchMenuItems();
  }, []);

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center py-6">
            <div>
              <h1 className="text-3xl font-bold text-gray-900">
                SpoonFeed Admin
              </h1>
              <p className="text-lg text-gray-600 mt-1">{}</p>
            </div>
            <div className="flex space-x-1 bg-gray-100 p-1 rounded-lg">
              <button
                onClick={() => setActiveTab("orders")}
                className={`px-4 py-2 rounded-md text-sm font-medium transition-colors flex items-center ${
                  activeTab === "orders"
                    ? "bg-white text-blue-600 shadow-sm"
                    : "text-gray-600 hover:text-gray-900"
                }`}
              >
                <ShoppingBag className="w-4 h-4 mr-2" />
                Orders
              </button>
              <button
                onClick={() => setActiveTab("menu")}
                className={`px-4 py-2 rounded-md text-sm font-medium transition-colors flex items-center ${
                  activeTab === "menu"
                    ? "bg-white text-blue-600 shadow-sm"
                    : "text-gray-600 hover:text-gray-900"
                }`}
              >
                <UtensilsCrossed className="w-4 h-4 mr-2" />
                Menu Items
              </button>
              <button
                onClick={() => setActiveTab("facility")}
                className={`px-4 py-2 rounded-md text-sm font-medium transition-colors flex items-center ${
                  activeTab === "facility"
                    ? "bg-white text-blue-600 shadow-sm"
                    : "text-gray-600 hover:text-gray-900"
                }`}
              >
                <Info className="w-4 h-4 mr-2" />
                Facility Info
              </button>
              <button
                onClick={() => setActiveTab("hours")}
                className={`px-4 py-2 rounded-md text-sm font-medium transition-colors flex items-center ${
                  activeTab === "hours"
                    ? "bg-white text-blue-600 shadow-sm"
                    : "text-gray-600 hover:text-gray-900"
                }`}
              >
                <Clock className="w-4 h-4 mr-2" />
                Working Hours
              </button>
              <button
                onClick={onLogout}
                className="px-4 py-2 rounded-md text-sm font-medium flex items-center bg-red-600 text-white hover:bg-red-700 transition-colors"
              >
                <LogOut className="w-4 h-4 mr-2" />
                Logout
              </button>
            </div>
          </div>
        </div>
      </div>
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {activeTab === "orders" && <OrderManagement />}
        {activeTab === "menu" && (
          <MenuItemList
            items={menuItems}
            onDelete={deleteMenuItemHandler}
            onEdit={updateMenuItemHandler}
            onAdd={handleAddMenuItem}
          />
        )}
        {activeTab === "facility" && <FacilityInformation />}
        {activeTab === "hours" && <FacilityWorkingHours />}
      </div>
    </div>
  );
};

export default AdminPanel;
