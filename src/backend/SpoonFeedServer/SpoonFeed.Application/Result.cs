namespace SpoonFeed.Application;

public class Result<T>
{
    public T? Value { get; }
    
    public bool Success { get; }
    
    public string? ErrorMessage { get; }
    
    public ErrorType? ErrorType { get; }

    private Result(T value)
    {
        Value = value;
        Success = true;
    }

    private Result(string errorMessage, ErrorType errorType)
    {
        ErrorMessage = errorMessage;
        ErrorType = errorType;
        Success = false;
    }
    
    public static Result<T> SuccessResult(T value) => new(value);
    public static Result<T> FailureResult(string errorMessage, ErrorType errorType = Application.ErrorType.Unknown)
        => new(errorMessage, errorType);
    
    public static Result<T> NoContentResult() => new Result<T>(default!); 
}

public enum ErrorType
{
    NotFound,
    Validation,
    ServerError,
    Unknown, 
    Unauthorized, 
    Forbidden,
}