export interface FacilityInfo {
  facilityName: string;
  phoneNumber: string;
  firstName: string;
  lastName: string;
  addressDto: AddressDto;
  picUrl?: string;
}

export interface AddressDto {
  street: string;
  city: string;
  postalCode: string;
  latitude: number;
  longitude: number;
}
