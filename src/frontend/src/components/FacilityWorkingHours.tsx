import { useState } from "react";
import { Save } from "lucide-react";
import type { WorkingHours } from "../interfaces/WorkingHours";

const FacilityWorkingHours = () => {
  const [workingHours, setWorkingHours] = useState<WorkingHours>({
    monday: { isOpen: true, openTime: "09:00", closeTime: "22:00" },
    tuesday: { isOpen: true, openTime: "09:00", closeTime: "22:00" },
    wednesday: { isOpen: true, openTime: "09:00", closeTime: "22:00" },
    thursday: { isOpen: true, openTime: "09:00", closeTime: "22:00" },
    friday: { isOpen: true, openTime: "09:00", closeTime: "23:00" },
    saturday: { isOpen: true, openTime: "10:00", closeTime: "23:00" },
    sunday: { isOpen: false, openTime: "10:00", closeTime: "21:00" },
  });

  const updateWorkingHours = (
    day: string,
    field: string,
    value: string | boolean
  ) => {
    setWorkingHours((prev) => ({
      ...prev,
      [day]: {
        ...prev[day],
        [field]: value,
      },
    }));
  };
  return (
    <>
      <div className="space-y-6">
        <h2 className="text-2xl font-semibold text-gray-900">Working Hours</h2>
        <div className="bg-white rounded-lg shadow-md p-6">
          <div className="space-y-4">
            {Object.entries(workingHours).map(([day, hours]) => (
              <div
                key={day}
                className="flex items-center space-x-4 p-4 border rounded-lg"
              >
                <div className="w-24">
                  <span className="text-sm font-medium text-gray-700 capitalize">
                    {day}
                  </span>
                </div>
                <div className="flex items-center space-x-2">
                  <input
                    type="checkbox"
                    checked={hours.isOpen}
                    onChange={(e) =>
                      updateWorkingHours(day, "isOpen", e.target.checked)
                    }
                    className="h-4 w-4 text-blue-600 rounded focus:ring-blue-500"
                  />
                  <span className="text-sm text-gray-700">Open</span>
                </div>
                {hours.isOpen && (
                  <>
                    <div className="flex items-center space-x-2">
                      <label className="text-sm text-gray-700">From:</label>
                      <input
                        type="time"
                        value={hours.openTime}
                        onChange={(e) =>
                          updateWorkingHours(day, "openTime", e.target.value)
                        }
                        className="px-2 py-1 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      />
                    </div>
                    <div className="flex items-center space-x-2">
                      <label className="text-sm text-gray-700">To:</label>
                      <input
                        type="time"
                        value={hours.closeTime}
                        onChange={(e) =>
                          updateWorkingHours(day, "closeTime", e.target.value)
                        }
                        className="px-2 py-1 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      />
                    </div>
                  </>
                )}
              </div>
            ))}
          </div>
          <div className="mt-6">
            <button className="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition-colors flex items-center">
              <Save className="w-4 h-4 mr-2" />
              Save Working Hours
            </button>
          </div>
        </div>
      </div>
    </>
  );
};

export default FacilityWorkingHours;
