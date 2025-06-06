import { Routes, Route, Navigate, useLocation } from "react-router-dom";
import { useState, useEffect } from "react";
import LoginPage from "./pages/LoginPage";
import RegisterPage from "./pages/RegisterPage";
import AuthNavigation from "./components/AuthNavigation";
import AdminPanel from "./components/AdminPanel";

function App() {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const token = localStorage.getItem("authToken");
    const rememberMe = localStorage.getItem("rememberMe");
    if (token && rememberMe === "true") {
      setIsAuthenticated(true);
    }
    setIsLoading(false);
  }, []);

  const handleLogout = () => {
    setIsAuthenticated(false);
    localStorage.removeItem("authToken");
    localStorage.removeItem("rememberMe");
  };

  const handleLogin = async (loginData) => {
    try {
      const response = await fetch("http://localhost:5167/api/auth/login", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          email: loginData.email,
          password: loginData.password,
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        return {
          success: false,
          message: data.message || "Невірні облікові дані",
        };
      }

      localStorage.setItem("authToken", data.token);
      setIsAuthenticated(true);

      if (loginData.rememberMe) {
        localStorage.setItem("rememberMe", "true");
      }

      return { success: true };
    } catch (error) {
      return {
        success: false,
        message: "Помилка з’єднання. Спробуйте пізніше.",
      };
    }
  };

  const handleRegister = (registerData) => {
    setIsAuthenticated(true);
    localStorage.setItem("authToken", "demo-token-" + Date.now());
    return Promise.resolve({ success: true });
  };

  const ProtectedRoute = ({ children }) => {
    if (isLoading) {
      return <div>Завантаження...</div>;
    }
    return isAuthenticated ? children : <Navigate to="/login" replace />;
  };

  const PublicRoute = ({ children }) => {
    if (isLoading) {
      return <div>Завантаження...</div>;
    }
    return isAuthenticated ? <Navigate to="/admin" replace /> : children;
  };

  const location = useLocation();

  const isAuthRoute =
    location.pathname === "/login" ||
    location.pathname === "/register" ||
    location.pathname === "/reset-password";

  return (
    <>
      {!isAuthenticated && <AuthNavigation />}
      <Routes>
        <Route
          path="/"
          element={
            <Navigate to={isAuthenticated ? "/admin" : "/login"} replace />
          }
        />

        <Route
          path="/login"
          element={
            <PublicRoute>
              <LoginPage onLogin={handleLogin} />
            </PublicRoute>
          }
        />
        <Route
          path="/register"
          element={
            <PublicRoute>
              <RegisterPage onRegister={handleRegister} />
            </PublicRoute>
          }
        />

        <Route
          path="/admin"
          element={
            <ProtectedRoute>
              <AdminPanel onLogout={handleLogout} /> {/* <-- */}
            </ProtectedRoute>
          }
        />
      </Routes>
    </>
  );
}

export default App;
