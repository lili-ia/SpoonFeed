using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Application.DTOs.Menu;

public record CreateItemCategoryRequest(
    [Required(ErrorMessage = "Name is required.")]
    [MinLength(2, ErrorMessage = "The name of category should be at least 2 characters long.")]
    [StringLength(100, ErrorMessage = "Name cannot exceed 100 characters.")]
    string Name);