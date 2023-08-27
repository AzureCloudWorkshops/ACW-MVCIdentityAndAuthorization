# Customizing ASP.NET Identity and adding third-party signins

This is the default repo for working with identity and third-party sign ins.

## Architecture

To Work with this solution, you need an Azure App Service and an Azure SQL Database.  You can create these in the Azure Portal, or you can use the templates in the `iac` folder to deploy them using the Azure CLI.

## Web Solution

The web solution is a standard ASP.NET Core MVC application.  It uses the default ASP.NET Core Identity implementation, with a few customizations.  Use the starter project to build the solution from the ground up.  To review the final solution, the final project shows the outcome of adding customizations and third-party sign ins to the starter project.

## Slides:

Download a [copy of the slides](https://talkimages.blob.core.windows.net/mvcidentityandthirdparty/ASPNetIdentityAndThirdPartySignIns.pptx)
## Part 1: Customizing ASP.NET Identity

In the first part of this solution, you'll override and customize the ASP.NET default identity.

[Customizing ASP.NET Identity](/Part1-CustomizingASPNETIdentityUser.md)    

## Part 2: Adding Third-Party Sign Ins

In the second part of this solution, you'll add third-party sign ins to the application.

[Utilizing Third-Party Sign Ins](/Part2-ThirdPartySignIns.md)