import { useState, useMemo } from "react";
import {
  Clock,
  User,
  Phone,
  MapPin,
  Package,
  ChevronDown,
  Search,
  Filter,
  RefreshCw,
} from "lucide-react";

interface OrderItem {
  id: string;
  name: string;
  quantity: number;
  price: number;
  specialInstructions?: string;
}

interface Customer {
  name: string;
  phone: string;
  address?: string;
}

interface Order {
  id: string;
  orderNumber: string;
  customer: Customer;
  items: OrderItem[];
  totalAmount: number;
  status: OrderStatus;
  createdAt: Date;
  estimatedDeliveryTime?: Date;
  paymentMethod: "cash" | "card" | "online";
  deliveryType: "pickup" | "delivery";
  notes?: string;
}

type OrderStatus =
  | "new"
  | "confirmed"
  | "preparing"
  | "ready"
  | "out_for_delivery"
  | "delivered"
  | "picked_up"
  | "cancelled";

const OrderManagement = () => {
  const [orders, setOrders] = useState<Order[]>([
    {
      id: "1",
      orderNumber: "ORD-001",
      customer: {
        name: "Іван Петренко",
        phone: "+380671234567",
        address: "вул. Хрещатик, 22, кв. 15",
      },
      items: [
        { id: "1", name: "Котлета по-київськи", quantity: 2, price: 320 },
        { id: "2", name: "Компот 0.5л", quantity: 2, price: 45 },
      ],
      totalAmount: 730,
      status: "new",
      createdAt: new Date(Date.now() - 10 * 60000),
      estimatedDeliveryTime: new Date(Date.now() + 30 * 60000),
      paymentMethod: "online",
      deliveryType: "delivery",
    },
    {
      id: "2",
      orderNumber: "ORD-002",
      customer: {
        name: "Марія Коваленко",
        phone: "+380509876543",
      },
      items: [
        { id: "3", name: "Картопля пюре", quantity: 1, price: 180 },
        { id: "4", name: "Котлета по-київськи", quantity: 1, price: 85 },
      ],
      totalAmount: 265,
      status: "preparing",
      createdAt: new Date(Date.now() - 25 * 60000),
      paymentMethod: "cash",
      deliveryType: "pickup",
    },
    {
      id: "3",
      orderNumber: "ORD-003",
      customer: {
        name: "Олександр Шевченко",
        phone: "+380631112233",
        address: "вул. Пушкіна, 10",
      },
      items: [
        { id: "5", name: "Салат Цезар", quantity: 1, price: 145 },
        { id: "6", name: "Суп домашній", quantity: 1, price: 95 },
      ],
      totalAmount: 240,
      status: "ready",
      createdAt: new Date(Date.now() - 40 * 60000),
      paymentMethod: "card",
      deliveryType: "delivery",
    },
  ]);

  const [searchTerm, setSearchTerm] = useState("");
  const [statusFilter, setStatusFilter] = useState<OrderStatus | "all">("all");
  const [deliveryFilter, setDeliveryFilter] = useState<
    "all" | "pickup" | "delivery"
  >("all");

  const statusConfig = {
    new: {
      label: "Нове",
      color: "bg-blue-100 text-blue-800",
      nextStatuses: ["confirmed", "cancelled"],
      priority: 1,
    },
    confirmed: {
      label: "Підтверджено",
      color: "bg-purple-100 text-purple-800",
      nextStatuses: ["preparing", "cancelled"],
      priority: 2,
    },
    preparing: {
      label: "Готується",
      color: "bg-yellow-100 text-yellow-800",
      nextStatuses: ["ready", "cancelled"],
      priority: 3,
    },
    ready: {
      label: "Готово",
      color: "bg-green-100 text-green-800",
      nextStatuses: ["out_for_delivery", "picked_up"],
      priority: 4,
    },
    out_for_delivery: {
      label: "В дорозі",
      color: "bg-indigo-100 text-indigo-800",
      nextStatuses: ["delivered"],
      priority: 5,
    },
    delivered: {
      label: "Доставлено",
      color: "bg-green-100 text-green-800",
      nextStatuses: [],
      priority: 6,
    },
    picked_up: {
      label: "Забрано",
      color: "bg-green-100 text-green-800",
      nextStatuses: [],
      priority: 6,
    },
    cancelled: {
      label: "Скасовано",
      color: "bg-red-100 text-red-800",
      nextStatuses: [],
      priority: 0,
    },
  };

  const updateOrderStatus = (orderId: string, newStatus: OrderStatus) => {
    setOrders((prev) =>
      prev.map((order) =>
        order.id === orderId ? { ...order, status: newStatus } : order
      )
    );
  };

  const filteredOrders = useMemo(() => {
    return orders
      .filter((order) => {
        const matchesSearch =
          order.orderNumber.toLowerCase().includes(searchTerm.toLowerCase()) ||
          order.customer.name
            .toLowerCase()
            .includes(searchTerm.toLowerCase()) ||
          order.customer.phone.includes(searchTerm);

        const matchesStatus =
          statusFilter === "all" || order.status === statusFilter;
        const matchesDelivery =
          deliveryFilter === "all" || order.deliveryType === deliveryFilter;

        return matchesSearch && matchesStatus && matchesDelivery;
      })
      .sort((a, b) => {
        const priorityDiff =
          statusConfig[b.status].priority - statusConfig[a.status].priority;
        if (priorityDiff !== 0) return priorityDiff;
        return b.createdAt.getTime() - a.createdAt.getTime();
      });
  }, [orders, searchTerm, statusFilter, deliveryFilter]);

  const formatTime = (date: Date) => {
    return date.toLocaleTimeString("uk-UA", {
      hour: "2-digit",
      minute: "2-digit",
    });
  };

  const getTimeSince = (date: Date) => {
    const minutes = Math.floor((Date.now() - date.getTime()) / 60000);
    if (minutes < 1) return "щойно";
    if (minutes < 60) return `${minutes} хв тому`;
    const hours = Math.floor(minutes / 60);
    return `${hours} год ${minutes % 60} хв тому`;
  };

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h2 className="text-2xl font-semibold text-gray-900">
            Управління замовленнями
          </h2>
          <p className="text-gray-600 mt-1">
            Всього замовлень: {filteredOrders.length}
          </p>
        </div>
        <button className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition-colors flex items-center">
          <RefreshCw className="w-4 h-4 mr-2" />
          Оновити
        </button>
      </div>

      <div className="bg-white rounded-lg shadow-sm border p-4">
        <div className="flex flex-wrap gap-4 items-center">
          <div className="flex items-center space-x-2">
            <Search className="w-4 h-4 text-gray-400" />
            <input
              type="text"
              placeholder="Пошук за номером, ім'ям або телефоном..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent min-w-80"
            />
          </div>

          <div className="flex items-center space-x-2">
            <Filter className="w-4 h-4 text-gray-400" />
            <select
              value={statusFilter}
              onChange={(e) =>
                setStatusFilter(e.target.value as OrderStatus | "all")
              }
              className="border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="all">Всі статуси</option>
              {Object.entries(statusConfig).map(([status, config]) => (
                <option key={status} value={status}>
                  {config.label}
                </option>
              ))}
            </select>
          </div>

          <select
            value={deliveryFilter}
            onChange={(e) =>
              setDeliveryFilter(e.target.value as "all" | "pickup" | "delivery")
            }
            className="border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="all">Всі типи</option>
            <option value="delivery">Доставка</option>
            <option value="pickup">Самовивіз</option>
          </select>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-6">
        {filteredOrders.map((order) => (
          <div
            key={order.id}
            className="bg-white rounded-lg shadow-md border overflow-hidden"
          >
            <div className="bg-gray-50 px-4 py-3 border-b">
              <div className="flex justify-between items-start">
                <div>
                  <h3 className="font-semibold text-gray-900">
                    {order.orderNumber}
                  </h3>
                  <div className="flex items-center text-sm text-gray-600 mt-1">
                    <Clock className="w-4 h-4 mr-1" />
                    {getTimeSince(order.createdAt)}
                  </div>
                </div>
                <div className="text-right">
                  <div className="text-lg font-bold text-gray-900">
                    {order.totalAmount} ₴
                  </div>
                  <div className="text-sm text-gray-600">
                    {order.deliveryType === "delivery"
                      ? "Доставка"
                      : "Самовивіз"}
                  </div>
                </div>
              </div>
            </div>

            <div className="px-4 py-3 border-b">
              <div className="flex items-center mb-2">
                <User className="w-4 h-4 text-gray-400 mr-2" />
                <span className="font-medium">{order.customer.name}</span>
              </div>
              <div className="flex items-center mb-2">
                <Phone className="w-4 h-4 text-gray-400 mr-2" />
                <span className="text-sm text-gray-600">
                  {order.customer.phone}
                </span>
              </div>
              {order.customer.address && (
                <div className="flex items-start">
                  <MapPin className="w-4 h-4 text-gray-400 mr-2 mt-0.5" />
                  <span className="text-sm text-gray-600">
                    {order.customer.address}
                  </span>
                </div>
              )}
            </div>

            <div className="px-4 py-3 border-b">
              <div className="flex items-center mb-2">
                <Package className="w-4 h-4 text-gray-400 mr-2" />
                <span className="font-medium text-sm">Товари:</span>
              </div>
              <div className="space-y-1">
                {order.items.map((item) => (
                  <div
                    key={item.id}
                    className="flex justify-between items-center text-sm"
                  >
                    <span>
                      {item.name} x{item.quantity}
                    </span>
                    <span className="text-gray-600">
                      {item.price * item.quantity} ₴
                    </span>
                  </div>
                ))}
              </div>
            </div>

            <div className="px-4 py-3">
              <div className="flex items-center justify-between mb-3">
                <span className="text-sm font-medium text-gray-700">
                  Статус:
                </span>
                <span
                  className={`px-2 py-1 rounded-full text-xs font-medium ${statusConfig[order.status].color}`}
                >
                  {statusConfig[order.status].label}
                </span>
              </div>

              {statusConfig[order.status].nextStatuses.length > 0 && (
                <div className="space-y-2">
                  <span className="text-sm font-medium text-gray-700">
                    Змінити на:
                  </span>
                  <div className="flex flex-wrap gap-2">
                    {statusConfig[order.status].nextStatuses.map(
                      (nextStatus) => (
                        <button
                          key={nextStatus}
                          onClick={() =>
                            updateOrderStatus(order.id, nextStatus)
                          }
                          className="px-3 py-1 bg-blue-600 text-white text-sm rounded-md hover:bg-blue-700 transition-colors"
                        >
                          {statusConfig[nextStatus].label}
                        </button>
                      )
                    )}
                  </div>
                </div>
              )}
            </div>
          </div>
        ))}
      </div>

      {filteredOrders.length === 0 && (
        <div className="text-center py-12">
          <Package className="w-12 h-12 text-gray-400 mx-auto mb-4" />
          <p className="text-gray-500 text-lg">Замовлення не знайдено</p>
        </div>
      )}
    </div>
  );
};

export default OrderManagement;
