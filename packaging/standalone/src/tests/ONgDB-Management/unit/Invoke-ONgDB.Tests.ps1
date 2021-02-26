$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
$common = Join-Path (Split-Path -Parent $here) 'Common.ps1'
. $common

Import-Module "$src\ONgDB-Management.psm1"

InModuleScope ONgDB-Management {
  Describe "Invoke-ONgDB" {

    # Setup mocking environment
    #  Mock Java environment
    $javaHome = global:New-MockJavaHome
    Mock Get-ONgDBEnv { $javaHome } -ParameterFilter { $Name -eq 'JAVA_HOME' }
    Mock Set-ONgDBEnv { }
    Mock Test-Path { $false } -ParameterFilter {
      $Path -like 'Registry::*\JavaSoft\Java Runtime Environment'
    }
    Mock Get-ItemProperty { $null } -ParameterFilter {
      $Path -like 'Registry::*\JavaSoft\Java Runtime Environment*'
    }
    # Mock ONgDB environment
    $mockONgDBHome = global:New-MockONgDBInstall
    Mock Get-ONgDBEnv { $global:mockONgDBHome } -ParameterFilter { $Name -eq 'ONGDB_HOME' }
    Mock Start-Process { throw "Should not call Start-Process mock" }
    # Mock helper functions
    Mock Start-ONgDBServer { 2 } -ParameterFilter { $Console -eq $true }
    Mock Start-ONgDBServer { 3 } -ParameterFilter { $Service -eq $true }
    Mock Stop-ONgDBServer { 4 }
    Mock Get-ONgDBStatus { 6 }
    Mock Install-ONgDBServer { 7 }
    Mock Uninstall-ONgDBServer { 8 }

    Context "No arguments" {
      $result = Invoke-ONgDB

      It "returns 1 if no arguments" {
        $result | Should Be 1
      }
    }

    # Helper functions - error
    Context "Helper function throws an error" {
      Mock Get-ONgDBStatus { throw "error" }

      It "returns non zero exit code on error" {
        Invoke-ONgDB 'status' -ErrorAction SilentlyContinue | Should Be 1
      }

      It "throws error when terminating error" {
        { Invoke-ONgDB 'status' -ErrorAction Stop } | Should Throw
      }
    }


    # Helper functions
    Context "Helper functions" {
      It "returns exitcode from console command" {
        Invoke-ONgDB 'console' | Should Be 2
      }

      It "returns exitcode from start command" {
        Invoke-ONgDB 'start' | Should Be 3
      }

      It "returns exitcode from stop command" {
        Invoke-ONgDB 'stop' | Should Be 4
      }

      It "returns exitcode from restart command" {
        Mock Start-ONgDBServer { 5 } -ParameterFilter { $Service -eq $true }
        Mock Stop-ONgDBServer { 0 }

        Invoke-ONgDB 'restart' | Should Be 5
      }

      It "returns exitcode from status command" {
        Invoke-ONgDB 'status' | Should Be 6
      }

      It "returns exitcode from install-service command" {
        Invoke-ONgDB 'install-service' | Should Be 7
      }

      It "returns exitcode from uninstall-service command" {
        Invoke-ONgDB 'uninstall-service' | Should Be 8
      }
    }

  }
}