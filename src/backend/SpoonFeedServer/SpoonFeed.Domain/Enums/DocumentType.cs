namespace SpoonFeed.Domain.Enums;

/// <summary>
/// Represents the type of user's document.
/// </summary>
public enum DocumentType
{
    /// <summary>
    /// Who user is?
    /// </summary>
    IdentityCard,
    /// <summary>
    /// Is the user allowed to drive?
    /// </summary>
    DriverLicense,
    /// <summary>
    /// Is the user allowed to have business?
    /// </summary>
    BusinessLicense,
    /// <summary>
    /// Is the user registered as a company?
    /// </summary>
    CompanyRegistrationDocument,
    /// <summary>
    /// Is the user's food safe?
    /// </summary>
    FoodSafetyCertificate
}