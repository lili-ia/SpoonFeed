using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;


namespace SpoonFeedServer.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class OrderController : ControllerBase
{
    
}