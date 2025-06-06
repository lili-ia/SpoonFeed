import { Save } from "lucide-react";
import { useEffect, useState } from "react";
import type { FacilityInfo } from "../interfaces/FacilityInfo";

const apiBase =
  import.meta.env.VITE_API_URL ?? "http://localhost:5167/api/facility/info";

export default function FacilityInformation() {
  const [facilityInfo, setFacilityInfo] = useState<FacilityInfo | null>(null);
  const defaultFacilityInfo: FacilityInfo = {
    facilityName: "",
    phoneNumber: "",
    firstName: "",
    lastName: "",
    addressDto: {
      street: "",
      city: "",
      postalCode: "",
      latitude: 0,
      longitude: 0,
    },
    picUrl: "",
  };

  const [localInfo, setLocalInfo] = useState<FacilityInfo | null>(
    defaultFacilityInfo
  );

  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");
  const [savedOk, setSavedOk] = useState(false);

  useEffect(() => {
    const fetchFacility = async () => {
      try {
        const res = await fetch(`${apiBase}/get`, {
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${localStorage.getItem("authToken") ?? ""}`,
          },
        });

        if (!res.ok) throw new Error("Не вдалося завантажити дані");

        const data: FacilityInfo = await res.json();
        setFacilityInfo(data);
        setLocalInfo(data);
      } catch (e: any) {
        setError(e.message);
      } finally {
        setLoading(false);
      }
    };

    fetchFacility();
  }, []);

  if (loading)
    return <p className="text-center py-10 text-gray-500">Завантаження…</p>;

  if (error)
    return (
      <p className="text-center py-10 text-red-600">
        Помилка: {error}. Спробуйте пізніше.
      </p>
    );

  if (!localInfo) return null;

  const hasChanges = JSON.stringify(facilityInfo) !== JSON.stringify(localInfo);

  const handleSave = async () => {
    console.log("localInfo перед відправкою:", localInfo);

    setSaving(true);
    setError("");
    try {
      const res = await fetch(`${apiBase}/update`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${localStorage.getItem("authToken") ?? ""}`,
        },
        body: JSON.stringify(localInfo),
      });

      if (!res.ok) throw new Error("Не вдалося зберегти зміни");

      const getRes = await fetch(`${apiBase}/get-info`, {
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${localStorage.getItem("authToken") ?? ""}`,
        },
      });

      if (!getRes.ok) throw new Error("Не вдалося завантажити оновлені дані");

      const updated = await getRes.json();
      setFacilityInfo(updated);
      setLocalInfo(updated);

      setSavedOk(true);
      setTimeout(() => setSavedOk(false), 2500);
    } catch (e: any) {
      setError(e.message);
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-semibold">Facility Information</h2>

      {error && (
        <div className="p-3 bg-red-100 text-red-700 rounded">{error}</div>
      )}

      <div className="bg-white p-6 rounded-lg shadow space-y-6">
        <InputRow
          label="Facility Name"
          value={localInfo.facilityName}
          onChange={(v) => setLocalInfo({ ...localInfo, facilityName: v })}
        />

        <InputRow
          label="Phone"
          value={localInfo.phoneNumber}
          onChange={(v) => setLocalInfo({ ...localInfo, phoneNumber: v })}
        />

        <InputRow
          label="Street"
          value={localInfo.addressDto.street}
          onChange={(v) =>
            setLocalInfo({
              ...localInfo,
              addressDto: { ...localInfo.addressDto, street: v },
            })
          }
        />

        <InputRow
          label="City"
          value={localInfo.addressDto.city}
          onChange={(v) =>
            setLocalInfo({
              ...localInfo,
              addressDto: { ...localInfo.addressDto, city: v },
            })
          }
        />

        <InputRow
          label="Postal Code"
          value={localInfo.addressDto.postalCode}
          onChange={(v) =>
            setLocalInfo({
              ...localInfo,
              addressDto: { ...localInfo.addressDto, postalCode: v },
            })
          }
        />

        <InputRow
          label="Profile Image URL"
          value={localInfo.picUrl || ""}
          onChange={(v) =>
            setLocalInfo({
              ...localInfo,
              picUrl: v,
            })
          }
        />

        {localInfo.picUrl && (
          <img
            src={localInfo.picUrl}
            alt="Profile"
            className="w-32 h-32 rounded-full object-cover mt-2"
          />
        )}

        <div className="flex items-center space-x-4">
          <button
            onClick={handleSave}
            disabled={!hasChanges || saving}
            className={`px-6 py-2 rounded flex items-center transition-colors ${
              !hasChanges || saving
                ? "bg-gray-300 text-gray-500 cursor-not-allowed"
                : "bg-blue-600 text-white hover:bg-blue-700"
            }`}
          >
            <Save className="w-4 h-4 mr-2" />
            {saving ? "Saving…" : "Save Changes"}
          </button>

          {savedOk && (
            <span className="text-green-600 text-sm">Saved successfully!</span>
          )}
        </div>
      </div>
    </div>
  );
}

interface InputRowProps {
  label: string;
  value: string;
  onChange: (v: string) => void;
  type?: string;
}
const InputRow = ({ label, value, onChange, type = "text" }: InputRowProps) => (
  <div>
    <label className="block mb-1 text-sm font-medium">{label}</label>
    <input
      type={type}
      className="w-full border px-3 py-2 rounded"
      value={value}
      onChange={(e) => onChange(e.target.value)}
    />
  </div>
);
