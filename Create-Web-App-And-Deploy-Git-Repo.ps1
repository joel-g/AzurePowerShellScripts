$gitRepo = "<Path to local git repo>"
$webAppName = "<name your web app>"
$location = "westus2"
$resourceGroup = "<rg name goes here>"

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
    scmType="LocalGit";
}
Set-AzureRmResource -PropertyObject $PropertiesObject `
                    -ResourceGroupName $resourceGroup `
                    -ResourceType Microsoft.Web/sites/config `
                    -ResourceName $webAppName/web `
                    -ApiVersion 2015-08-01 `
                    -Force

# Get app-level deployment credentials
$xml = [xml](Get-AzureRmWebAppPublishingProfile -Name $webAppName `
                                                -ResourceGroupName $resourceGroup `
                                                -OutputFile null
)
$username = $xml.SelectNodes("//publishProfile[@publishMethod=`"MSDeploy`"]/@userName").value
$password = $xml.SelectNodes("//publishProfile[@publishMethod=`"MSDeploy`"]/@userPWD").value

# Add the Azure remote to you local Git repo and push your code
#### This method saves your password in the git remote. You can use Git credential manager to secure your password instead.
git remote add azure "https://${username}:$password@$webappName.scm.azurewebsites.net"
git push azure master