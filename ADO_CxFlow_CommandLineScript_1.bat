rem ADO: Run this as a 'Command Line Script' Task version 2.*
rem This will download the CxFlow JAR into the 'temp' directory (which should be $(Agent.TempDirectory)) and unzip it...
rem Version: v1.0115

rem - - - - - Set various CxCLI Variables - - - - -     

set CX_URL=http://jwebsoftware.ngrok.io
set CX_USER=dcox
set CX_PSWD=C0rky9#2016

set CX_TEAM=/CxServer/SP/Company/Users
set CX_PROJECT=ADO-15-CxFlow-MyFirstProject
set CX_APP=ADO-15

rem set CX_ADO_OWNER=cxdcox, CX_ADO_REPO=MyFirstProject , CX_ADO_BRANCH=master

echo " = = = = = CxCLI Variables = = = = = "
echo "CX_URL=%CX_URL%"
echo "CX_USER=%CX_USER%"
echo "CX_PSWD=%CX_PSWD%"
echo " - - - - - "
echo "CX_TEAM=%CX_TEAM%"
echo "CX_PROJECT=%CX_PROJECT%"
echo "CX_APP=%CX_APP%"

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
curl --output cx-flow-1.6.26.jar -L "https://github.com/checkmarx-ltd/cx-flow/releases/download/1.6.26/cx-flow-1.6.26.jar"
echo "Using 'curl' to download the CxFlow YAML file..."
curl --output application-azure_v9.4.0.yml "https://raw.githubusercontent.com/cxdcox/ADO-CxFlow-Control/main/application-azure_v9.4.0.yml"
echo "Directory of . (should be $(Agent.TempDirectory)) after 'curl' download:"
dir .
echo "Display of the downloaded 'application-azure_v9.4.0.yml' file..."
type application-azure_v9.4.0.yml

echo "Invoking: java -jar cx-flow-1.6.26.jar --scan --f="$(Build.Repository.LocalPath)" --spring.config.location="application-azure_v9.4.0.yml" --cx-team="%CX_TEAM%" --cx-project="%CX_PROJECT%" --app="%CX_APP%" --namespace="cx-drc" --repo-name="$(Build.Repository.Name)" --branch="$(Build.SourceBranchName)" "
java -jar cx-flow-1.6.26.jar --scan --f="$(Build.Repository.LocalPath)" --spring.config.location="application-azure_v9.4.0.yml" --cx-team="%CX_TEAM%" --cx-project="%CX_PROJECT%" --app="%CX_APP%" --namespace="cx-drc" --repo-name="$(Build.Repository.Name)" --branch="$(Build.SourceBranchName)"

echo "Switching back to the 'source' directory..."
popd
echo "Directory of . (should be $(Build.Repository.LocalPath)):"
dir .

echo " = = = = = End of Build Task = = = = = "
rem ===== Output of ADO_CxFlow_CommandLineScript_1.bat =====
