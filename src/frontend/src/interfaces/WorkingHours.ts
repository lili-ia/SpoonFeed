export interface DayWorkingHours {
  isOpen: boolean;
  openTime: string;
  closeTime: string;
}

export type WorkingHours = {
  monday: DayWorkingHours;
  tuesday: DayWorkingHours;
  wednesday: DayWorkingHours;
  thursday: DayWorkingHours;
  friday: DayWorkingHours;
  saturday: DayWorkingHours;
  sunday: DayWorkingHours;
};
