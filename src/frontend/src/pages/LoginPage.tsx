import { Eye, EyeOff, Mail, Lock, UtensilsCrossed } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { useState } from "react";

const LoginPage = ({ onLogin }) => {
  const [loginData, setLoginData] = useState({
    email: "",
    password: "",
    rememberMe: false,
  });
  const navigate = useNavigate();
  const [errorMessage, setErrorMessage] = useState("");

  const [showPassword, setShowPassword] = useState(false);

  const handleLogin = async (e) => {
    e.preventDefault();
    setErrorMessage("");

    try {
      const result = await onLogin(loginData);
      if (result.success) {
        navigate("/admin");
      } else {
        setErrorMessage(result.message || "Помилка входу");
      }
    } catch (error) {
      setErrorMessage("Помилка з’єднання з сервером");
      console.error("Помилка входу:", error);
    }
  };
  return (
    <div className="min-h-screen bg-gradient-to-br from-orange-50 via-white to-red-50 flex items-center justify-center p-4">
      <div className="max-w-md w-full">
        <div className="bg-white rounded-2xl shadow-xl p-8 border border-gray-100">
          <div className="text-center mb-8">
            <div className="inline-flex items-center justify-center w-16 h-16 bg-gradient-to-r from-orange-500 to-red-500 rounded-full mb-4">
              <UtensilsCrossed className="w-8 h-8 text-white" />
            </div>
            <h2 className="text-3xl font-bold text-gray-900 mb-2">
              Вхід до системи
            </h2>
            <p className="text-gray-600">
              Увійдіть в панель управління закладом
            </p>
          </div>
          {/* ❗ Блок помилки */}
          {errorMessage && (
            <div className="mb-4 p-3 bg-red-100 text-red-700 rounded text-sm text-center">
              {errorMessage}
            </div>
          )}
          <div className="space-y-6">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Email адреса
              </label>
              <div className="relative">
                <Mail className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
                <input
                  type="email"
                  value={loginData.email}
                  onChange={(e) =>
                    setLoginData({ ...loginData, email: e.target.value })
                  }
                  className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-transparent transition-all"
                  placeholder="your@email.com"
                  required
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Пароль
              </label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
                <input
                  type={showPassword ? "text" : "password"}
                  value={loginData.password}
                  onChange={(e) =>
                    setLoginData({ ...loginData, password: e.target.value })
                  }
                  className="w-full pl-10 pr-12 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-transparent transition-all"
                  placeholder="Введіть пароль"
                  required
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
                >
                  {showPassword ? (
                    <EyeOff className="w-5 h-5" />
                  ) : (
                    <Eye className="w-5 h-5" />
                  )}
                </button>
              </div>
            </div>

            <div className="flex items-center justify-between">
              <div className="flex items-center">
                <input
                  type="checkbox"
                  id="remember"
                  checked={loginData.rememberMe}
                  onChange={(e) =>
                    setLoginData({ ...loginData, rememberMe: e.target.checked })
                  }
                  className="w-4 h-4 text-orange-500 border-gray-300 rounded focus:ring-orange-500"
                />
                <label
                  htmlFor="remember"
                  className="ml-2 text-sm text-gray-600"
                >
                  Запам'ятати мене
                </label>
              </div>
              <button
                type="button"
                className="text-sm text-orange-600 hover:text-orange-700 font-medium"
              >
                Забули пароль?
              </button>
            </div>

            <button
              onClick={handleLogin}
              className="w-full bg-gradient-to-r from-orange-500 to-red-500 text-white py-3 px-4 rounded-lg font-medium hover:from-orange-600 hover:to-red-600 focus:ring-4 focus:ring-orange-200 transition-all transform hover:scale-[1.02]"
            >
              Увійти
            </button>
          </div>

          <div className="mt-6 text-center">
            <p className="text-gray-600">
              Ще не маєте акаунту?{" "}
              <button className="text-orange-600 hover:text-orange-700 font-medium">
                Зареєструватися
              </button>
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LoginPage;
