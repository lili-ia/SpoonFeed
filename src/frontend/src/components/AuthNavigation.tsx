import { useLocation, useNavigate } from "react-router-dom";

const AuthNavigation = () => {
  const navigate = useNavigate();
  const { pathname } = useLocation();

  return (
    <div className="fixed top-4 right-4 bg-white rounded-lg shadow-lg p-2 flex gap-2 z-50">
      <button
        onClick={() => navigate("/login")}
        className={`px-3 py-2 rounded text-sm font-medium transition-all ${
          pathname === "/auth/login"
            ? "bg-orange-500 text-white"
            : "text-gray-600 hover:bg-gray-100"
        }`}
      >
        Вхід
      </button>
      <button
        onClick={() => navigate("/register")}
        className={`px-3 py-2 rounded text-sm font-medium transition-all ${
          pathname === "/auth/register"
            ? "bg-orange-500 text-white"
            : "text-gray-600 hover:bg-gray-100"
        }`}
      >
        Реєстрація
      </button>
    </div>
  );
};

export default AuthNavigation;
