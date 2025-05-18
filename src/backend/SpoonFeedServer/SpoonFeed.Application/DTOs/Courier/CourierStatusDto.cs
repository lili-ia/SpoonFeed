using System.ComponentModel.DataAnnotations;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Application.DTOs.Courier;

public record CourierStatusDto([Required] CourierStatus CourierStatus);
