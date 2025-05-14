using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Domain.Models;

public class Currency : BaseEntity
{
    [Required(ErrorMessage = "Name is required.")]
    [StringLength(100, ErrorMessage = "Name cannot exceed 100 characters.")]
    public string Name { get; set; }
    
    [StringLength(10, ErrorMessage = "Code cannot exceed 10 characters.")]
    public string Code { get; set; }
    
    [StringLength(5, ErrorMessage = "Symbol cannot exceed 5 characters.")]
    public string Symbol { get; set; }
}