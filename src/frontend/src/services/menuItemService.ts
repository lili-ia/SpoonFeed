import axios from "axios";
import type { MenuItem } from "../interfaces/MenuItem";

const BASE_URL = "http://localhost:5167/api/facility/menu";

axios.interceptors.request.use((config) => {
  const token = localStorage.getItem("authToken");
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export const getMenuItems = () => axios.get<MenuItem[]>(`${BASE_URL}/get/all`);

export const addMenuItem = (data: Omit<MenuItem, "id">) =>
  axios.post<string>(`${BASE_URL}/add`, data);

export const updateMenuItem = (id: string, data: Partial<MenuItem>) =>
  axios.put(`${BASE_URL}/${id}`, { ...data, id });

export const deleteMenuItem = (id: string) => axios.delete(`${BASE_URL}/${id}`);

export const getMenuItemById = (id: string) =>
  axios.get<MenuItem>(`${BASE_URL}/get/${id}`);
