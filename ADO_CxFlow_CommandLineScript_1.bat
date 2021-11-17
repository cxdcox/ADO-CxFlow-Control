rem
rem ADO: Run this as a 'Command Line Script' Task version 2.*
rem This will download the CxFlow JAR into the 'temp' directory (which should be $(Agent.TempDirectory)) and unzip it...
rem Version: v1.0106

rem - - - - - Set various CxCLI Variables - - - - -     

rem set CX_URL=http://DARYLCOXE36C
set CX_URL=http://jwebsoftware.ngrok.io
set CX_USER=dcox
set CX_PSWD=C0rky9#2016

set CX_TEAM=/CxServer/SP/Company/Users
set CX_PROJECT=ADO-3-CxFlow-MyFirstProject
set CX_APP=ADO-3

set CX_ADO_OWNER=cxdcox
set CX_ADO_REPO=MyFirstProject
set CX_ADO_BRANCH=master

echo " = = = = = CxCLI Variables = = = = = "
echo "CX_URL=%CX_URL%"
echo "CX_USER=%CX_USER%"
echo "CX_PSWD=%CX_PSWD%"
echo " - - - - - "
echo "CX_TEAM=%CX_TEAM%"
echo "CX_PROJECT=%CX_PROJECT%"

echo " = = = = = Directories and Workspaces = = = = = "
echo "Directory of 'Agent.BuildDirectory' (should be $(Agent.BuildDirectory))..."
echo "Directory of 'Pipeline.Workspace' (should be $(Pipeline.Workspace))..."
echo "Directory of 'Build.Repository.LocalPath' (Source directory #1): $(Build.Repository.LocalPath)..."
echo "Directory of 'Build.SourcesDirectory' (Source directory #2): $(Build.SourcesDirectory)..."
echo "Directory of 'System.DefaultWorkingDirectory' (Source directory #3): $(System.DefaultWorkingDirectory)..."
echo "Directory of 'Build.StagingDirectory' (Staging directory - Artifacts output): $(Build.StagingDirectory)..."
echo "Directory of 'Common.TestResultsDirectory' (Test results): $(Common.TestResultsDirectory)..."
echo "Directory of 'Agent.ToolsDirectory': $(Agent.ToolsDirectory)..."
echo "- - - - - - - - - - - - - - - - - - - - - - - - "
echo "Current temp directory 'Agent.TempDirectory': $(Agent.TempDirectory)..."
echo "Current directory: %cd%..."

echo " = = = = = Start of Build Task = = = = = "

rem curl --help

echo "Switching to the 'temp' directory..."
pushd .
cd $(Agent.TempDirectory)

echo "Using 'curl' to download the CxFlow JAR file..."
curl --output cx-flow-1.6.22.jar -L "https://github.com/checkmarx-ltd/cx-flow/releases/download/1.6.22/cx-flow-1.6.22.jar"

echo "Using 'curl' to download the CxFlow YAML file..."
curl --output application-azure_v9.4.0.yml "https://raw.githubusercontent.com/cxdcox/ADO-CxFlow-Control/main/application-azure_v9.4.0.yml"

echo "Directory of . (should be $(Agent.TempDirectory)) after 'curl' download:"
dir .

echo "Display of the downloaded 'application-azure_v9.4.0.yml' file..."
type application-azure_v9.4.0.yml

rem echo "Running the downloaded CxFlow JAR in '--help' mode..."
rem java -jar cx-flow-1.6.22.jar --help
rem runCxConsole.cmd OsaScan -v -Projectname %CX_TEAM%%CX_PROJECT% -CxServer %CX_URL% -CxUser %CX_USER% -CxPassword %CX_PSWD% -LocationType folder -LocationPath "$(Build.Repository.LocalPath)" -OsaJson "$(Build.StagingDirectory)" -executepackagedependency

echo "Running the downloaded CxFlow JAR in '--scan' mode..."
echo "Invoking: java -jar cx-flow-1.6.22.jar --scan --f="$(Build.Repository.LocalPath)" --spring.config.location="application-azure_v9.4.0.yml" --cx-team="%CX_TEAM%" --cx-project="%CX_PROJECT%" --app="%CX_APP%" --azure.owner-tag-prefix="%CX_ADO_OWNER%" --azure.repo-tag-prefix="CX_ADO_REPO%" --azure.branch-label-prefix="CX_ADO_BRANCH%" "
java -jar cx-flow-1.6.22.jar --scan --f="$(Build.Repository.LocalPath)" --spring.config.location="application-azure_v9.4.0.yml" --cx-team="%CX_TEAM%" --cx-project="%CX_PROJECT%" --app="%CX_APP%" --azure.owner-tag-prefix="%CX_ADO_OWNER%" --azure.repo-tag-prefix="CX_ADO_REPO%" --azure.branch-label-prefix="CX_ADO_BRANCH%"

echo "Switching back to the 'source' directory..."
popd

echo "Directory of . (should be $(Build.Repository.LocalPath)):"
dir .

echo " = = = = = End of Build Task = = = = = "

rem ===== Output of ADO_CxFlow_CommandLineScript_1.bat =====
