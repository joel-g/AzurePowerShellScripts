﻿$gitRepo = "<repo url goes here>"
$webAppName = "<web app name goes here>"
$location = "<location goes here>"
$resourceGroup = "<resource name goes here>"

# Login
Login-AzureRmAccount

# Make a new resource group.
New-AzureRmResourceGroup -Name $resourceGroup -Location $location

# Create the 'Free' tier App Service plan.
New-AzureRmAppServicePlan -Name $webAppName `
                          -Location $location `
                          -ResourceGroupName $resourceGroup `
                          -Tier Free

# Create the web app.
New-AzureRmWebApp -Name $webAppName `
                  -Location $location `
                  -AppServicePlan $webAppName `
                  -ResourceGroupName $resourceGroup

# Configure GitHub deployment from your GitHub repo and deploy once.
$PropertiesObject = @{
    repoUrl = "$gitRepo";
    branch = "master";
    isManualIntegration = "true";
}
Set-AzureRmResource -PropertyObject $PropertiesObject `
                    -ResourceGroupName $resourceGroup `
                    -ResourceType Microsoft.Web/sites/sourcecontrols  `
                    -ResourceName $webAppName/web `
                    -ApiVersion 2015-08-01 `
                    -Force