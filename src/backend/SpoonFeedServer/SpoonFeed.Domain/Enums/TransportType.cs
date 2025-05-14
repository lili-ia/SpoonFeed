namespace SpoonFeed.Domain.Enums;

/// <summary>
/// Represents the transport courier is using. 
/// </summary>
public enum TransportType
{
    /// <summary>
    /// Represents lack of any transport (walking, public transportation, etc.).
    /// </summary>
    None,
    /// <summary>
    /// Represents any type of bicycle, with better carry weight and travel distance.
    /// </summary>
    Bicycle,
    /// <summary>
    /// Represents any type of motorcycle, assuming good carry weight and travel distance.
    /// </summary>
    Motorcycle,
    /// <summary>
    /// Represents any type of car, assuming the greatest carry weight and travel distance.
    /// </summary>
    Car
}