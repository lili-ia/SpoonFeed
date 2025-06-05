using AutoMapper;
using SpoonFeed.Application.DTOs.Order;
using SpoonFeed.Application.DTOs.Shared;
using SpoonFeed.Domain.Models;
using SpoonFeed.Domain.Owned;

namespace SpoonFeed.Application.Mappings;

public class AutoMapperProfile : Profile
{
    public AutoMapperProfile()
    {
        CreateMap<CreateOrderDto, Order>();
        CreateMap<CreateOrderPositionDto, OrderPosition>();
        CreateMap<AddressDto, Address>();
    }
}