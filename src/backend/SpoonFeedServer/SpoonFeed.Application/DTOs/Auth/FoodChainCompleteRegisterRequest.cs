using System.ComponentModel.DataAnnotations;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Application.DTOs.Auth;

public class FoodChainCompleteRegisterRequest
{
    [Required(ErrorMessage = "FoodChainCategory is required")]
    public FoodChainCategory FoodChainCategory { get; set; }
}